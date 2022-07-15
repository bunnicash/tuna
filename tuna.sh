#!/bin/bash
## Copyright (C) 2022 bunnicash "@bunnicash" and licensed under GPL-2.0
version="v1.0-028"
source ~/tuna/config.tuna

## Initialize Tuna
mkdir -p ~/AUR
array_main="$(echo $*)"

## Functions 
aur_upgrade () {  # Upgrade shared core for U,A
    cd ~/AUR/$p && echo -e "\e[93m==>\e[39m Old PKGBUILD for $p:\n"
    echo -e "\e[95m " && cat PKGBUILD && echo -e "\e[39m " && echo -e "$(sleep $wait_tuna)\n"
    mv PKGBUILD ~/tuna && cd ~/AUR
    rm -rf $p && git clone https://aur.archlinux.org/$p.git
    cd ~/AUR/$p && echo -e "\n\e[93m==>\e[39m New PKGBUILD for $p\n:"
    echo -e "\e[95m " && cat PKGBUILD && echo -e "\e[39m " && echo -e "$(sleep $wait_tuna)\n"
    makepkg -csir --noconfirm --skippgpcheck
    echo -e "\n\e[93m==>\e[39m Upgraded $p from version $(awk -n -F"pkgver=" '/pkgver=/{print $2}' ~/tuna/PKGBUILD) to version $(awk -n -F"pkgver=" '/pkgver=/{print $2}' PKGBUILD)" && sleep $wait_tuna
    rm -rf ~/tuna/PKGBUILD && cd ~/AUR && echo -e "\n\e[92m===============================================================\e[39m\n"
}

tuna_U () {  # Complete system upgrade
    sudo pacman -Syu --noconfirm
    cd ~/AUR
    pkg_upgrade=$(ls)
    for p in $pkg_upgrade; do
        if [ ${#p} -ge 2 ]; then
            aur_upgrade
        fi
    done
    cd ~ && echo -e "\e[93m==>\e[39m Upgraded the system entirely\n"
}

tuna_A () {  # Complete AUR upgrade
    sudo pacman -Sy --noconfirm
    cd ~/AUR
    pkg_upgrade=$(ls)
    for p in $pkg_upgrade; do
        if [ ${#p} -ge 2 ]; then
            aur_upgrade
        fi
    done
    cd ~ && echo -e "\e[93m==>\e[39m Upgraded all AUR packages\n"
}

tuna_S () {  # Install AUR packages
    cd ~/AUR
    for str in ${array_main[@]:2}; do
        if [ ${#str} -ge 2 ]; then
            rm -rf $str && git clone https://aur.archlinux.org/$str.git
            cd ~/AUR/$str && echo -e "\n\e[93m==>\e[39m PKGBUILD for $str:\n"
            echo -e "\e[95m " && cat PKGBUILD && echo -e "\e[39m " && echo -e "$(sleep $wait_tuna)\n"
            makepkg -csir --noconfirm --skippgpcheck
            echo -e "\n\e[93m==>\e[39m Installed $str version $(awk -n -F"pkgver=" '/pkgver=/{print $2}' PKGBUILD)" && sleep $wait_tuna
            cd ~/AUR && echo -e "\n\e[92m===============================================================\e[39m\n"
        fi
    done
    cd ~
}

tuna_D () {  # Create AUR repository backup 
    cd ~
    today=$(date +"%d-%m-%Y")
    tar -zcvf aur-backup-$today.tar.gz ./AUR
    echo -e "\n\e[93m==>\e[39m Created local AUR repository backup\n"
}

tuna_E () {  # Restore AUR repository backup 
    aur_backup="/home/$USER/aur-backup-*.tar.gz"
    if test -f $aur_backup; then
        rm -rf ~/AUR
        tar -xvf ~/aur-backup-*.tar.gz
        rm -rf ~/aur-backup-*.tar.gz
        echo -e "\n\e[93m==>\e[39m Restored local backup"
    else echo -e "\n\e[93m==>\e[39m Error: Backup archive not found"
    fi
    cd ~ && echo " "
}

tuna_I () {  # AUR repository information 
    cd ~/AUR
    echo -e "\e[93m==>\e[39m tuna $version"
    echo -e "\e[92m===============================================================\e[39m"
    echo -ne "\e[93m==>\e[39m Total installed packages: " && pacman -Q | wc -l
    echo -ne "\e[93m==>\e[39m Total installed AUR packages: " && find */ -maxdepth 0 -type d | wc -l
    echo -ne "\e[93m==>\e[39m Total size occupied by AUR: " && du -sh | cut -f1
    echo -e "\e[92m===============================================================\e[39m"
    echo -e "\e[93m==>\e[39m AUR Packages by size:"
    du -sh -- * | sort -rh
    echo -e "\e[92m===============================================================\e[39m"
    echo -e "\e[93m==>\e[39m AUR Package versions:"
    pkg_version=$(ls)
    for p in $pkg_version; do
        if [ ${#p} -ge 2 ]; then
            cd ~/AUR/$p
            echo -e "$p, version $(awk -n -F"pkgver=" '/pkgver=/{print $2}' PKGBUILD)"
        fi
    done
    cd ~ && echo " "
}

tuna_L () {  # Package lookup / query
    echo -e "\e[93m==>\e[39m Matches and suggestions:"
    echo -e "\e[92m===============================================================\e[39m"
    array_look=(".git" "-bin.git" "-git.git" "-base.git" "-dkms.git" "-beta.git" "-cli.git")
    for str in ${array_main[@]:2}; do
        if [[ $(pacman -Ss $str | wc -c) -ge 1 ]]; then
            echo -e "\e[93m==>\e[39m Found packages named $str in pacman repositories"
        fi
        if [ ${#str} -ge 2 ]; then
            for l in ${array_look[@]}; do
                if [[ $(git ls-remote https://aur.archlinux.org/$str$l | wc -c) -ge 1 ]]; then
                    echo -e "\e[93m==>\e[39m Found package $str$l"
                fi
            done
        fi
    done
    echo -e "\e[93m==>\e[39m Finished querying the AUR\n"
}

tuna_R () {  # Remove selected AUR packages
    cd ~/AUR
    for str in ${array_main[@]:2}; do
        if [ ${#str} -ge 2 ]; then
            sudo pacman -Rs $str --noconfirm
            rm -rf ~/AUR/$str
        fi
    done
    cd ~ && echo -e "\e[93m==>\e[39m Removed packages\n"
}

tuna_J () {  # Remove broken packages
    pkg_broken=$(ls ~/AUR)
    for p in $pkg_broken; do
        if [ ${#p} -ge 2 ]; then
            cd ~/AUR/$p
            if test -f PKGBUILD && test -f *.pkg.tar.zst; then
                echo -e "\e[93m==>\e[39m Package $p is functional"
            else rm -rf ~/AUR/$p && echo -e "\e[93m==>\e[39m Deleted empty/failed package $p"
            fi
        fi
        cd ~
    done
    echo -e "\e[93m==>\e[39m Finished cleaning broken packages\n"
}

tuna_X () {  # Remove all AUR packages
    pkg_wipeall=$(ls ~/AUR)
    sudo pacman -Rs $pkg_wipeall --noconfirm
    rm -rf ~/AUR
    echo -e "\e[93m==>\e[39m Removed all packages\n"
}

tuna_P () {  # Pacman installation
    sudo pacman -Sy ${array_main[@]:2} --noconfirm --needed
}

tuna_H () {  # Help menu
    echo -ne "\e[93m==>\e[39m Syntax: tuna <-Operation> <Targets>
\e[92m===============================================================\e[39m
\e[93m==>\e[39m -S      Install AUR packages
\e[93m==>\e[39m -P      Install pacman packages
\e[93m==>\e[39m -U      Full system upgrade (Pacman Repositories, AUR)
\e[93m==>\e[39m -A      Partial system upgrade (AUR only)
\e[93m==>\e[39m -R      Uninstall certain AUR/pacman packages
\e[93m==>\e[39m -X      Uninstall all AUR packages
\e[93m==>\e[39m -J      Remove empty/failed packages
\e[93m==>\e[39m -I      Display AUR program information
\e[93m==>\e[39m -L      Package search including alternatives
\e[93m==>\e[39m -D      Create local AUR backup
\e[93m==>\e[39m -E      Restore local AUR from backup

"
}

tuna_syntaxerr () {
    echo -e "\e[93m==>\e[39m Error: Incorrect command syntax\n"
    exit 1
}

## CLI: Flags, Targets/Args
while getopts "S: P: U A R: X J I H L: D E" flag; do  # "A" = no args, "A:" needs args
    case "$flag" in  
        S) tuna_S ;;  # needs targets
        P) tuna_P ;;  # needs targets
        U) tuna_U ;;
        A) tuna_A ;;
        R) tuna_R ;;  # needs targets
        X) tuna_X ;;
        J) tuna_J ;;
        I) tuna_I ;;
        H) tuna_H ;;
        L) tuna_L ;;  # needs targets
        D) tuna_D ;;
        E) tuna_E ;;
        \?) tuna_syntaxerr ;;
    esac
done
if [ -z "$*" ]; then
    tuna_H
fi
