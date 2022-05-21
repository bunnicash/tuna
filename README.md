# tuna
Tuna - An AUR helper written in Bash<br>

<p>
</a>
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
    <img src="https://i.imgur.com/OjIFLXc.png" />
</p>
<br>

### Features:
- Initial setup including dependency resolving for tuna/AUR
- Automated AUR package installation for as many packages as needed in one command
- Full system upgrade (Pacman Repositories and AUR)
- Partial system upgrade (AUR only)
- Colorful PKGBUILD viewer/comparison pre-install/pre-upgrade
- Detailed information about installed AUR packages
- Clean unused leftover dependencies after the build process
- Local AUR repository management: backup and restore
- Package search function including alternatives
- Remove certain or all AUR packages in one command
- Easy AUR-helper update process in a single command
- Automatically remove empty/failed packages
<br><br>

### Syntax:
<b>tuna -Operation Targets</b><br>
- Examples: <br>
tuna -S xiccd duckstation-git librewolf-bin <br>
tuna -L xiccd librewolf duckstation <br>
tuna -Re <br><br>
- Note: <br>
Not every operation needs targets, e.g packages specified <br>
You can see which operations need "Targets" specified below <br><br>

<pre><b>Operations</b>
• Install AUR packages             -S      Targets
• Install pacman packages          -O      Targets
• Upgrade system (pacman/AUR)      -Syu
• Upgrade system (AUR)             -Sya
• Uninstall certain AUR packages   -R      Targets
• Uninstall all AUR packages       -Ra
• Remove empty/failed packages     -Re
• Detailed information             -Pa
• Show helpful information         -H
• Search for packages              -L      Targets
• Create local AUR backup          -Bu
• Restore local AUR from backup    -Br
• Update tuna                      -Tu
• Remove tuna                      -Tr
</pre><br>

### Using tuna
Start the setup process:
```
sudo pacman -Sy git --noconfirm
```
```
cd ~ && git clone https://github.com/bunnicash/tuna.git && cd tuna && chmod +x *.sh && . setup.sh
```
<br>

To use tuna:
```
tuna
```
<br><br>

### FAQ:
- Is there an unstable branch for testing? Yes, you can use the testing branch: `git clone -b testing https://github.com/bunnicash/tuna.git` <br>

- A package / certain packages I am trying to install won't install, what's happening? - Before opening an issue, please make sure the packages you want do not have any reported issues on https://aur.archlinux.org/, not all AUR packages are functional, that's not a tuna-problem.
<br><br>
