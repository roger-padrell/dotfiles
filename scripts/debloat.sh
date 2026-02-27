#!/bin/bash
sudo pacman --noconfirm -Rns snapper limine-snapper-sync 
sudo pacman --noconfirm -Rns chromium electron39 obsidian signal-desktop spotify typora localsend claude-code 1password-beta 1password-cli
sudo pacman --noconfirm -Rns kirigami kwallet kio kdenlive qqc2-desktop-style solid sonnet syndication purpose
sudo pacman --noconfirm -Rns docker containerd runc docker-buildx docker-compose lazydocker ufw-docker

sudo rm -rf .local/share/omarchy/applications/* 
sudo rm -rf .local/share/applications/*  

sudo pacman -Rns --noconfirm libreoffice-fresh pinta obs-studio xournalpp neovim omarchy-nvim lazygit opencode starship gnome-calculator evince sushi 
sudo omarchy-remove-preinstalls
echo "Omarchy setup debloated"
