#!/bin/bash
# Puts the newest app code into the copy already on this Mac, for when the normal update can't be built yet.
# It works on a copy and only swaps it in once that's ready, and it puts the old one back if the new one won't open.
VERSION='0.15.0'
SHA='111879d6fbbdc54769d282eab265500cd78cc73308aeb0614c6c2e0c4dd1bf57'
SITE='https://noahs-ark.starktech.workers.dev'
BUNDLE='com.yahya613.browser'

main() {
  local app='' name dir candidate
  for dir in "/Applications" "$HOME/Applications"; do
    for name in "Noah’s Ark" "Arc"; do
      candidate="$dir/$name.app"
      # The real Arc lives at /Applications/Arc.app too, so the name isn't enough.
      if [ "$(/usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' "$candidate/Contents/Info.plist" 2>/dev/null)" = "$BUNDLE" ]; then
        if [ -z "$app" ] || pgrep -f "$candidate/Contents/MacOS/" > /dev/null; then app="$candidate"; fi
      fi
    done
  done
  if [ -z "$app" ]; then
    echo "Noah's Ark isn't installed on this Mac, so there's nothing to update."
    return 1
  fi
  echo "Updating $app to $VERSION"

  local work
  work="$(mktemp -d)"
  trap 'rm -rf "$work"' EXIT

  echo "Downloading..."
  if ! curl -fsSL "$SITE/quick-update/app.asar" -o "$work/app.asar"; then
    echo "The download failed, and nothing has changed. Check your internet and run this again."
    return 1
  fi
  if [ "$(shasum -a 256 "$work/app.asar" | cut -d' ' -f1)" != "$SHA" ]; then
    echo "The download came through wrong, and nothing has changed. Run this again."
    return 1
  fi

  echo "Preparing it..."
  local new="$work/new.app"
  if ! ditto "$app" "$new"; then
    echo "It couldn't be copied, and nothing has changed."
    return 1
  fi
  cp "$work/app.asar" "$new/Contents/Resources/app.asar"
  local plist="$new/Contents/Info.plist"
  set_info() {
    /usr/libexec/PlistBuddy -c "Set :$1 '$2'" "$plist" 2>/dev/null || /usr/libexec/PlistBuddy -c "Add :$1 string '$2'" "$plist"
  }
  set_info NSMicrophoneUsageDescription 'Websites you allow can use your microphone.'
  set_info NSCameraUsageDescription 'Websites you allow can use your camera.'
  set_info CFBundleShortVersionString "$VERSION"
  xattr -cr "$new" 2>/dev/null
  if ! codesign --force --deep --sign - "$new" 2> "$work/sign.txt" || ! codesign --verify --deep "$new" 2>> "$work/sign.txt"; then
    cat "$work/sign.txt"
    echo "It couldn't be prepared, and nothing has changed."
    return 1
  fi

  # Closed properly first, so your tabs are saved.
  if pgrep -f "$app/Contents/MacOS/" > /dev/null; then
    echo "Closing it..."
    osascript -e "tell application id \"$BUNDLE\" to quit" 2>/dev/null
    local i
    for i in $(seq 1 40); do
      pgrep -f "$app/Contents/MacOS/" > /dev/null || break
      sleep 0.5
    done
    pkill -f "$app/Contents/MacOS/" 2>/dev/null
    sleep 1
  fi

  if ! mv "$app" "$app.old" 2> "$work/move.txt"; then
    cat "$work/move.txt"
    echo
    echo "Your Mac stopped Terminal from changing the app, and nothing has changed."
    echo "Go to System Settings, Privacy & Security, App Management, turn on Terminal, and run this again."
    open "$app"
    return 1
  fi
  if ! mv "$new" "$app"; then
    mv "$app.old" "$app"
    echo "It couldn't be swapped in, and nothing has changed."
    open "$app"
    return 1
  fi

  open "$app"
  for i in $(seq 1 40); do
    pgrep -f "$app/Contents/MacOS/" > /dev/null && break
    sleep 0.5
  done
  sleep 3
  if ! pgrep -f "$app/Contents/MacOS/" > /dev/null; then
    rm -rf "$app"
    mv "$app.old" "$app"
    open "$app"
    echo "The new version wouldn't open, so your old one is back and nothing has changed."
    return 1
  fi
  rm -rf "$app.old"
  echo "Done. It's now version $VERSION."
}

main
