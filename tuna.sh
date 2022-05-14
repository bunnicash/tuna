#!/bin/bash
## GPL-2.0 - @bunnicash, 2022
version="v1.0-019"

# Upgrade -Syu, -Sya
aur_upgrade () {
  cd ~/AUR/$p && echo " " && echo -e "\e[93m==>\e[39m Old PKGBUILD for $p:" && echo " "
  echo -e "\e[95m " && cat PKGBUILD && echo -e "\e[39m " && sleep $wait_upgrade && echo " "
  mv PKGBUILD ~/tuna && cd ~/AUR
  rm -rf $p && git clone https://aur.archlinux.org/$p.git && cd ~/AUR/$p
  echo " " && echo -e "\e[93m==>\e[39m New PKGBUILD for $p:" && echo " "
  echo -e "\e[95m " && cat PKGBUILD && echo -e "\e[39m " && sleep $wait_upgrade && echo " "
  makepkg -csir --noconfirm --skippgpcheck
  echo " " && echo -e "\e[93m==>\e[39m Upgraded $p from version $(awk -n -F"pkgver=" '/pkgver=/{print $2}' ~/tuna/PKGBUILD) to version $(awk -n -F"pkgver=" '/pkgver=/{print $2}' PKGBUILD)"
  rm -rf ~/tuna/PKGBUILD && cd ~/AUR  && sleep 2 && echo " " && echo -e "\e[92m===============================================================\e[39m"
}

# Tuna return
tur () {
  . tuna.sh
}

# Input array and repository creation
mkdir -p ~/AUR
read -p "tuna " -a array_main
echo " "

# -S (Install packages)
if [ ${array_main[0]} == "-S" ]; then
  cd ~/AUR
  read -p "==> Show PKGBUILD for [0-10] seconds? " wait_s
  for str in ${array_main[@]:1}; do
    if [ ${#str} -ge 2 ]; then
      rm -rf $str && git clone https://aur.archlinux.org/$str.git && cd ~/AUR/$str
      echo " " && echo -e "\e[93m==>\e[39m PKGBUILD for $str:" && echo " "
      echo -e "\e[95m " && cat PKGBUILD && echo -e "\e[39m " && sleep $wait_s && echo " "
      makepkg -csir --noconfirm --skippgpcheck
      echo " " && echo -e "\e[93m==>\e[39m Installed $str version $(awk -n -F"pkgver=" '/pkgver=/{print $2}' PKGBUILD)" && sleep 2
      cd ~/AUR && echo " " && echo -e "\e[92m===============================================================\e[39m" && echo " "
    fi
  done
  cd ~

# -Bu (Backup local AUR)
elif [ ${array_main[0]} == "-Bu" ]; then
  cd ~
  today=$(date +"%d-%m-%Y")
  tar -zcvf aur-backup-$today.tar.gz ./AUR
  echo " " && echo -e "\e[93m==>\e[39m Created tar.gz for local AUR repository backup" && echo " "

# -Br (Restore local AUR backup)
elif [ ${array_main[0]} == "-Br" ]; then
  aur_backup="/home/$USER/aur-backup-*.tar.gz"
  if test -f $aur_backup; then
    rm -rf ~/AUR
    tar -xvf ~/aur-backup-*.tar.gz
    rm -rf ~/aur-backup-*.tar.gz
    echo " " && echo -e "\e[93m==>\e[39m Restored local backup, deleted leftover tar.gz"
  else echo " " && echo -e "\e[93m==>\e[39m Backup .tar.gz not found, aborting..."
  fi
  echo " " && cd ~

# -H (Helpful information)
elif [ ${array_main[0]} == "-H" ]; then
  echo -ne "\e[93m==>\e[39m Syntax: tuna <-Operation> <Targets>
\e[92m===============================================================\e[39m
\e[93m==>\e[39m -S      Install AUR packages
\e[93m==>\e[39m -O      Install pacman packages
\e[93m==>\e[39m -Syu    Full system upgrade (Pacman Repositories, AUR)
\e[93m==>\e[39m -Sya    Partial system upgrade (AUR only)
\e[93m==>\e[39m -R      Uninstall certain AUR/pacman packages
\e[93m==>\e[39m -Ra     Uninstall all AUR packages
\e[93m==>\e[39m -Re     Remove empty/failed packages
\e[93m==>\e[39m -Pa     Display AUR program information
\e[93m==>\e[39m -L      Package search including alternatives
\e[93m==>\e[39m -Bu     Create local AUR backup
\e[93m==>\e[39m -Br     Restore local AUR from backup
\e[93m==>\e[39m -Tu     Update tuna
\e[93m==>\e[39m -Tr     Remove tuna

"
  tur

# -Syu (Sync and upgrade all repository/AUR packages)
elif [ ${array_main[0]} == "-Syu" ]; then
  sudo pacman -Syu --noconfirm
  echo " " && read -p "==> Show PKGBUILD for [0-10] seconds? " wait_upgrade
  echo " " && cd ~/AUR && echo -ne "\e[93m==> AUR: \e[39m" && ls && sleep 2
  ls > ~/tuna/pkg.txt
  while read p; do
    if [ ${#p} -ge 2 ]; then
      aur_upgrade
    fi
  done <~/tuna/pkg.txt
  rm -rf ~/tuna/pkg.txt && cd ~ && echo " "

# -Sya (Sync and upgrade all AUR packages)
elif [ ${array_main[0]} == "-Sya" ]; then
  sudo pacman -Sy --noconfirm
  echo " " && read -p "==> Show PKGBUILD for [0-10] seconds? " wait_upgrade
  echo " " && cd ~/AUR && echo -ne "\e[93m==> AUR: \e[39m" && ls && sleep 2
  ls > ~/tuna/pkg.txt
  while read p; do
    if [ ${#p} -ge 2 ]; then
      aur_upgrade
    fi
  done <~/tuna/pkg.txt
  rm -rf ~/tuna/pkg.txt && cd ~ && echo " "

# -Pa (Package info all)
elif [ ${array_main[0]} == "-Pa" ]; then
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
  echo " " && cd ~

# -L (Package Search)
elif [ ${array_main[0]} == "-L" ]; then
  echo -e "\e[93m==>\e[39m Matches and suggestions:"
  echo -e "\e[92m===============================================================\e[39m"
  array_look=(".git" "-bin.git" "-git.git" "-base.git" "-dkms.git" "-beta.git" "-cli.git")
  for str in ${array_main[@]:1}; do
    if [[ $(pacman -Ss $str | wc -c) -ge 1 ]]; then
      echo -e "\e[93m==>\e[39m Found packages named $str in pacman repositories"
    fi
    if [ ${#str} -ge 2 ]; then
      for l in ${array_look[@]}; do
        if [[ $(git ls-remote https://aur.archlinux.org/$str$l | wc -c) -ge 1 ]]; then
          echo -e "\e[93m==>\e[39m Found package $str as $l version"
        fi
      done
    fi
  done
  echo " " && tur

# -R (Uninstall packages)
elif [ ${array_main[0]} == "-R" ]; then
  cd ~/AUR && echo -ne "\e[93m==> AUR: \e[39m" && ls && echo " "
  for str in ${array_main[@]:1}; do
    if [ ${#str} -ge 2 ]; then
      sudo pacman -Rs $str --noconfirm
      rm -rf ~/AUR/$str
    fi
  done
  echo " " && cd ~

# -Ra (Uninstall all AUR packages)
elif [ ${array_main[0]} == "-Ra" ]; then
  cd ~/AUR && echo -ne "\e[93m==> AUR: \e[39m" && ls && sleep 2
  ls > ~/tuna/pkg.txt
  while read p; do
    if [ ${#p} -ge 2 ]; then
      sudo pacman -Rs $p --noconfirm
      rm -rf ~/AUR/$p
    fi
  done <~/tuna/pkg.txt
  rm -rf ~/tuna/pkg.txt && cd ~ && echo " "

# -Tu (Update tuna)
elif [ ${array_main[0]} == "-Tu" ]; then
  sudo rm -rf /usr/bin/tuna.sh ~/tuna && cd ~
  git clone https://github.com/bunnicash/tuna.git && cd tuna && chmod +x *.sh && . setup.sh

# -Tr (Remove tuna)
elif [ ${array_main[0]} == "-Tr" ]; then
  sudo rm -rf /usr/bin/tuna.sh ~/tuna && cd ~

# -Re (Remove empty/failed packages)
elif [ ${array_main[0]} == "-Re" ]; then
  cd ~/AUR && ls > ~/tuna/broken.txt
  while read p; do
    if [ ${#p} -ge 2 ]; then
      cd ~/AUR/$p
      if test -f PKGBUILD && test -f *.pkg.tar.zst; then
        echo -e "\e[93m==>\e[39m Package $p is functional, skipping..."
      else rm -rf ~/AUR/$p && echo -e "\e[93m==>\e[39m Deleted empty/failed package $p"
      fi
    fi
    cd ~
  done <~/tuna/broken.txt
  rm -rf ~/tuna/broken.txt && cd ~ && echo " "

# -O (Pacman installing)
elif [ ${array_main[0]} == "-O" ]; then
  sudo pacman -Sy ${array_main[@]:1} --noconfirm --needed
fi

