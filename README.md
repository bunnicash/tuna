# tuna
Tuna - An AUR helper written in Bash <br>

<p>
    <a href="https://github.com/bunnicash/tuna">
        <img src="https://img.shields.io/github/stars/bunnicash/tuna?style=flat-square">
    </a>
    <a href="https://github.com/bunnicash/tuna/blob/main/LICENSE">
        <img src="https://img.shields.io/github/license/bunnicash/tuna?style=flat-square">
    </a>
    <a href="https://github.com/bunnicash/tuna/issues">
        <img src="https://img.shields.io/github/issues/bunnicash/tuna?style=flat-square">
    </a>
    <a href="https://github.com/bunnicash/tuna">
        <img src="https://img.shields.io/tokei/lines/github/bunnicash/tuna?style=flat-square">
    </a>
    <a href="https://github.com/bunnicash/tuna">
        <img src="https://img.shields.io/github/last-commit/bunnicash/tuna?style=flat-square">
    </a>
</p>
<br>

<p float="left">
    <img src="https://i.imgur.com/syYXtE2.png" />
    <img src="https://i.imgur.com/YiNVjVJ.png" />
</p>
<br>

### Features:
- Initial setup including dependency resolving for tuna/AUR
- Automated AUR package installation for as many packages as desired in one command
- Full system upgrade (Pacman Repositories and AUR)
- Partial system upgrade (AUR only)
- Colorful PKGBUILD viewer/comparison pre-install/pre-upgrade
- Detailed information about installed AUR packages
- Clean unused leftover dependencies after the build process
- Local AUR repository management: backup and restore
- Package search function including alternatives
- Remove certain or all AUR packages in one command
- Automatically remove empty/failed packages
<br><br>

### Usage and syntax:
<b>tuna -Operation Targets</b><br>
- Examples: <br>
tuna -S xiccd duckstation-git librewolf-bin <br>
tuna -L xiccd librewolf duckstation <br>
tuna -J <br>
tuna -U <br><br>
- Notes: <br>
Not every operation needs targets, e.g packages specified <br>
You can see which operations need "Targets" specified below <br>
Just calling the program by typing "tuna" will display the help menu <br><br>

<pre><b>Operations</b>
• Install AUR packages             -S      Targets
• Install pacman packages          -P      Targets
• Upgrade system (pacman/AUR)      -U
• Upgrade system (AUR)             -A
• Uninstall certain AUR packages   -R      Targets
• Uninstall all AUR packages       -X
• Remove empty/failed packages     -J
• Detailed information             -I
• Show helpful information         -H
• Search for packages              -L      Targets
• Create local AUR backup          -D
• Restore local AUR from backup    -E
</pre><br>

### Installing tuna
To install the latest version:
```
sudo pacman -Sy git --noconfirm --needed
```
```
cd ~ && git clone https://github.com/bunnicash/tuna.git && cd tuna && chmod +x *.sh && sudo cp -f tuna.sh /usr/bin/tuna
```
<br>

### FAQ:
- Is there an unstable branch for testing? Yes, you can use the testing branch: `git clone -b testing https://github.com/bunnicash/tuna.git`. <br>

- A package / certain packages I am trying to install won't install, what's happening? - Before opening an issue, please make sure the packages you want do not have any reported issues on https://aur.archlinux.org/, not all AUR packages are functional, that's not an issue related to the AUR helper itself. <br>

- Why does my package with AUR dependencies fail? - As of now, tuna does not have AUR-dependency management, simply add them to the command, e.g `tuna -S AUR-dep1 AUR-dep2 AUR-program`. <br>

- I want to delete tuna entirely! - To do so, enter: `sudo rm -rf /usr/bin/tuna ~/tuna` <br><br>
