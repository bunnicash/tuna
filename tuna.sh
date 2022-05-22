#!/bin/bash
## Copyright (C) 2022 bunnicash "@bunnicash" and licensed under GPL-2.0
version="v1.0-023"
source ~/tuna/config.tuna

## Get flags/args
while getopts "S: P: U A R: X J I H L: D E G K" flag; do # "A" = no arguments, "A:" needs arguments, flag is one letter ("bc" in "Abc" would be args for "A")
    case "$flag" in 
        S) ;; # needs targets
        P) ;; # needs targets
        U) ;;
        A) ;;
        R) ;; # needs targets
        X) ;;
        J) ;;
        I) ;;
        H) ;;
        L) ;; # needs targets
        D) ;;
        E) ;;
        G) ;;
        K) ;;
        \?) echo -e "e[93m==>\e[39m Error: Incorrect command syntax\n" && exit 0;;
    esac
done

## Functions
aur_upgrade () {
    cd ~/AUR/$p && echo -e "\e[93m==>\e[39m Old PKGBUILD for $p:\n"
    echo -e "\e[95m " && cat PKGBUILD && echo -e "\e[39m " && echo -e "$(sleep $wait_tuna)\n"
    mv PKGBUILD ~/tuna && cd ~/AUR
    rm -rf $p && git clone https://aur.archlinux.org/$p.git && cd ~/AUR/$p && echo -e "\n\e[93m==>\e[39m New PKGBUILD for $p\n:"
    echo -e "\e[95m " && cat PKGBUILD && echo -e "\e[39m " && echo -e "$(sleep $wait_tuna)\n"
    makepkg -csir --noconfirm --skippgpcheck
    echo -e "\n\e[93m==>\e[39m Upgraded $p from version $(awk -n -F"pkgver=" '/pkgver=/{print $2}' ~/tuna/PKGBUILD) to version $(awk -n -F"pkgver=" '/pkgver=/{print $2}' PKGBUILD)"
    rm -rf ~/tuna/PKGBUILD && cd ~/AUR && echo -e "\n\e[92m===============================================================\e[39m\n"
}

## Input array, repository creation
mkdir -p ~/AUR && echo " "
array_main="$(echo $*)"

## Operations
if [ ${array_main[@]:0:3} == "-S" ]; then # Install packages
        cd ~/AUR
        for str in ${array_main[@]:3}; do
            if [ ${#str} -ge 2 ]; then
                rm -rf $str && git clone https://aur.archlinux.org/$str.git && cd ~/AUR/$str && echo -e "\n\e[93m==>\e[39m PKGBUILD for $str:\n"
                echo -e "\e[95m " && cat PKGBUILD && echo -e "\e[39m " && echo -e "$(sleep $wait_tuna)\n"
                makepkg -csir --noconfirm --skippgpcheck
                echo -e "\n\e[93m==>\e[39m Installed $str version $(awk -n -F"pkgver=" '/pkgver=/{print $2}' PKGBUILD)"
                cd ~/AUR && echo -e "\n\e[92m===============================================================\e[39m\n"
            fi
        done
        cd ~

elif [ ${array_main[@]:0:3} == "-D" ]; then # Backup local AUR
    cd ~
    today=$(date +"%d-%m-%Y")
    tar -zcvf aur-backup-$today.tar.gz ./AUR
    echo -e "\n\e[93m==>\e[39m Created local AUR repository backup\n"

elif [ ${array_main[@]:0:3} == "-E" ]; then # Restore local AUR backup
    aur_backup="/home/$USER/aur-backup-*.tar.gz"
    if test -f $aur_backup; then
        rm -rf ~/AUR
        tar -xvf ~/aur-backup-*.tar.gz
        rm -rf ~/aur-backup-*.tar.gz
        echo -e "\n\e[93m==>\e[39m Restored local backup"
    else echo -e "\n\e[93m==>\e[39m Error: Backup archive not found"
    fi
    cd ~ && echo " "

elif [ ${array_main[@]:0:3} == "-I" ]; then # Package info all
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
    ls > ~/tuna/vers.txt
    while read p; do
        if [ ${#p} -ge 2 ]; then
            cd ~/AUR/$p
            echo -e "$p, version $(awk -n -F"pkgver=" '/pkgver=/{print $2}' PKGBUILD)"
        fi
    done <~/tuna/vers.txt
    rm -rf ~/tuna/vers.txt
    cd ~ && echo " "

elif [ ${array_main[@]:0:3} == "-L" ]; then # Package Search
    echo -e "\e[93m==>\e[39m Matches and suggestions:"
    echo -e "\e[92m===============================================================\e[39m"
    array_look=(".git" "-bin.git" "-git.git" "-base.git" "-dkms.git" "-beta.git" "-cli.git")
    for str in ${array_main[@]:3}; do
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

elif [ ${array_main[@]:0:3} == "-R" ]; then # Uninstall packages
    cd ~/AUR
    for str in ${array_main[@]:3}; do
        if [ ${#str} -ge 2 ]; then
            sudo pacman -Rs $str --noconfirm
            rm -rf ~/AUR/$str
        fi
    done
    cd ~ && echo -e "\e[93m==>\e[39m Removed packages\n"

elif [ ${array_main[@]:0:3} == "-J" ]; then # Remove empty/failed packages
    cd ~/AUR && ls > ~/tuna/broken.txt
    while read p; do
        if [ ${#p} -ge 2 ]; then
            cd ~/AUR/$p
            if test -f PKGBUILD && test -f *.pkg.tar.zst; then
                echo -e "\e[93m==>\e[39m Package $p is functional"
            else rm -rf ~/AUR/$p && echo -e "\e[93m==>\e[39m Deleted empty/failed package $p"
            fi
        fi
        cd ~
    done <~/tuna/broken.txt
    rm -rf ~/tuna/broken.txt && cd ~ && echo -e "\e[93m==>\e[39m Cleaned broken packages\n"

elif [ ${array_main[@]:0:3} == "-X" ]; then # Uninstall all AUR packages
    cd ~/AUR && ls > ~/tuna/pkg.txt
    while read p; do
        if [ ${#p} -ge 2 ]; then
            sudo pacman -Rs $p --noconfirm
            rm -rf ~/AUR/$p
        fi
    done <~/tuna/pkg.txt
    rm -rf ~/tuna/pkg.txt && cd ~ && echo -e "\e[93m==>\e[39m Removed all packages\n"

elif [ ${array_main[@]:0:3} == "-P" ]; then # Pacman installing
    sudo pacman -Sy ${array_main[@]:3} --noconfirm --needed

elif [ ${array_main[@]:0:3} == "-G" ]; then # Update tuna
    sudo rm -rf /usr/bin/tuna ~/tuna && cd ~
    git clone https://github.com/bunnicash/tuna.git && cd tuna && chmod +x *.sh && . setup.sh

elif [ ${array_main[@]:0:3} == "-K" ]; then # Remove tuna
    sudo rm -rf /usr/bin/tuna ~/tuna && cd ~

elif [ ${array_main[@]:0:3} == "-H" ]; then # Helpful information
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
\e[93m==>\e[39m -G      Update tuna
\e[93m==>\e[39m -K      Remove tuna

"

elif [ ${array_main[@]:0:3} == "-U" ]; then # Sync and upgrade all repository/AUR packages
    sudo pacman -Syu --noconfirm
    cd ~/AUR && ls > ~/tuna/pkg.txt
    while read p; do
        if [ ${#p} -ge 2 ]; then
            aur_upgrade
        fi
    done <~/tuna/pkg.txt
    rm -rf ~/tuna/pkg.txt && cd ~ && echo -e "\e[93m==>\e[39m Upgraded the system entirely\n"

elif [ ${array_main[@]:0:3} == "-A" ]; then # Sync and upgrade all AUR packages
    sudo pacman -Sy --noconfirm
    cd ~/AUR && ls > ~/tuna/pkg.txt
    while read p; do
        if [ ${#p} -ge 2 ]; then
            aur_upgrade
        fi
    done <~/tuna/pkg.txt
    rm -rf ~/tuna/pkg.txt && cd ~ && echo -e "\e[93m==>\e[39m Upgraded all AUR packages\n"
fi
