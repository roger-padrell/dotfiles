#!/bin/bash
sudo pacman --noconfirm -S stow
stow . --ignore .stow-local-ignore
echo "Updated config from dotfiles"
