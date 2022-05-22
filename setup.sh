#!/bin/bash
## Copyright (C) 2022 bunnicash "@bunnicash" and licensed under GPL-2.0

## Initial Setup
sudo pacman -Sy git base-devel --noconfirm --needed
sudo rm -rf /usr/bin/tuna
cd ~/tuna && chmod +x *.sh
sudo cp -f tuna.sh /usr/bin/tuna
ls /usr/bin/tuna* && cd ~
