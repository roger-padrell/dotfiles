#!/usr/bin/env sh

# Check if stow is installed
if pacman -Q stow >/dev/null 2>&1; then
    echo "stow is already installed."
else
    echo "stow is not installed. Installing..."
    sudo pacman -S --needed --noconfirm stow
fi

stow . --ignore .stow-local-ignore
echo "Updated config from dotfiles"
