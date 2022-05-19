#!/bin/bash
## Copyright (C) 2022 bunnicash "@bunnicash" and licensed under GPL-2.0, Module: tuna > aur-advanced-dependency-management (aurdepmgmt)

## Comments/Info
# Packages with AUR deps: https://aur.archlinux.org/packages/octopi-dev, ...
# search if package exists (lots of output):  pacman -Ss $dep
# search for package info: pacman -Si $dep
# echo -n to a file (>> or >) keeps everything in one line!

## pkbuild excerpt: doesn't matter if ' or " in array (optdepends exists, but optional, ignore)
depends=('python' 'ffmpeg' 'python-sentry_sdk' 'python-colorama'
         'yt-dlp' 'python-certifi' 'python-html2text'
         'python-requests' 'python-aioxmpp')
makedepends=('python-build' 'python-installer' 'python-wheel')

## AUR dep-check function
aurdeps () {
  if [[ $(pacman -Si $dep | wc -c) -ge 1 ]]; then
    echo -e "\e[93m==>\e[39m $dep exists in pacman repositories"
  else echo -e "\e[91m==>\e[39m $dep: nonexistent or AUR package" && echo -n "$dep " >> ~/Desktop/aur-depmgmt/aurdeps
  fi
}

## Run dep-check
for dep in ${makedepends[@]}; do
  aurdeps
done

for dep in ${depends[@]}; do
  aurdeps
done
echo " "

## Fetch aurdeps, insert to command
fetchdeps=$(cat ~/Desktop/aur-depmgmt/aurdeps)
if [[ $(echo $fetchdeps | wc -c) -ge 1 ]]; then
  echo "tuna -S ${fetchdeps}package1 package2"
else echo "tuna -S package1 package2"
fi
