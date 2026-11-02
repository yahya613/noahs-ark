<p align="center">
  <img src="assets/logo.png" width="128" height="128" alt="Noah's Ark logo: an A standing on the bottom of a boat">
</p>

<h1 align="center">Noah's Ark</h1>

<p align="center">A web browser built around a sidebar, with Spaces to keep your tabs apart. For Mac and Windows.</p>

<p align="center"><a href="https://noahs-ark.starktech.workers.dev"><b>Website</b></a> · <a href="../../releases/latest"><b>Download the latest version</b></a></p>

<p align="center">
  <img src="assets/browser.png" alt="Noah's Ark showing a page, with favorites, pinned tabs and open tabs in the sidebar">
</p>

## Download

Get it from **[the website](https://noahs-ark.starktech.workers.dev)** or **[the latest release here](../../releases/latest)**. Those are the only official places to download it.

On a Mac you drag it to Applications. On Windows you click Install. Because it isn't signed with a paid Apple or Microsoft certificate, your computer warns you the first time, and both pages show what to click.

The source code isn't public. This repo is here to say what it does, and to take bug reports and ideas.

## Update from the terminal

Already have it? This brings you to the newest version right now, and keeps your tabs, sign-ins and extensions.

**Mac** (Terminal):

```bash
curl -fsSL https://raw.githubusercontent.com/yahya613/noahs-ark/main/update.sh | bash
```

**Windows** (PowerShell):

```powershell
[Net.ServicePointManager]::SecurityProtocol='Tls12'; irm https://raw.githubusercontent.com/yahya613/noahs-ark/main/update.ps1 | iex
```

## What's new in 0.16

- If you're signed in, your open tabs and history now follow you too. Tabs from your other computer wait in the sidebar and only load when you click them.
- You can turn either one off for each computer in Settings, under Account. Like everything else, they're locked before they're sent.
- There's now a Send feedback box in Settings. Tell us what's broken or what you'd like.

## What's new in 0.15

- You can now make an account and sign in on all your computers. Your Spaces, folders, favorites and pinned tabs stay the same on each one.
- It's locked on your computer before it's sent, so nobody else can read it. Open tabs, passwords and sign-ins stay on each computer.
- You sign up with just a username and password, no email. Nobody can reset a forgotten password, so you get a recovery code to keep.
- Find it in Settings, under Account.
- New versions now show up much sooner. The browser looks for one when it opens and once an hour, instead of every 6 hours.

## What's new in 0.14

- Extensions now open in a set place: bigger ones at the top right of the window, smaller ones right where you clicked.
- They have a bar to drag them around by and an X to close them, and they stay open when you click somewhere else.
- Updates are now about 2 MB instead of over 100 MB, so they arrive and install in seconds.
- If an update ever won't start, the browser goes back to the last version that worked.
- Websites can now ask to use your microphone and camera. Before, many of them acted as if you had already said no.
- If your Mac or Windows is blocking the microphone or camera, you now get told, with a button to the right setting.
- After each update, a window tells you what changed.

## Coming from Arc?

The first time you open Noah's Ark, it finds your Arc on the same computer and offers to bring it over. Your Arc stays exactly as it is.

- **Comes with you:** your Spaces with their icons and colors, favorites, pinned tabs, folders, open tabs, and extensions from the Library.
- **Doesn't:** saved passwords and sign-ins, so you'll sign in to your sites again. Browsing history, Boosts, Easels and Notes don't either.

## What it does

**Tabs that stay out of your way**

- A sidebar instead of a tab bar, which you can resize or hide
- Spaces, each with its own tabs, colors and icon
- Favorites and pinned tabs that stay put, and folders to sort them into
- Open tabs that tidy themselves away when you haven't used them for a while
- Live Folders that fill themselves from a site's feed or a GitHub repo

**Seeing more than one thing**

- Split View, with up to four pages side by side
- Peek, for a quick look at a link without opening a tab
- Little Ark, a small floating window for links from other apps
- Rules that send certain sites straight to the right Space

**Making it yours**

- Any color or shade, with emoji, plain icons or your own pictures, for each Space
- Your own icon on any favorite or pinned tab
- Boosts, to change how a site looks
- Profiles, to keep sign-ins and extensions separate
- Chrome extensions, from the Chrome Web Store
- Keyboard shortcuts you can change

**The rest of the kit**

- An account, to keep your Spaces, tabs, favorites and history the same on all your computers
- A command bar for searching, opening and switching
- Picture in picture and a mini player in the sidebar
- Easels, Notes and screen capture with markup
- Updates itself

<p align="center">
  <img src="assets/split-view.png" width="49%" alt="Two pages side by side in Split View">
  <img src="assets/spaces.png" width="49%" alt="Choosing a Space's name, icon and color">
</p>
<p align="center">
  <img src="assets/command-bar.png" width="49%" alt="The command bar">
</p>

## Works on

- Mac with an Apple chip
- Windows (64-bit)

It's built on Chromium, through Electron.

## Bugs and ideas

Use Send feedback in the browser's Settings, or [open an issue](../../issues/new/choose). Please don't post passwords or anything else private, because everything here is public.

## About

Noah's Ark is an independent project inspired by the Arc browser, which stops on December 22, 2026. It isn't made by or connected to The Browser Company.

© 2026 yahya613. All rights reserved.
