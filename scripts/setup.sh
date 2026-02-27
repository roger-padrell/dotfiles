#!/bin/bash
echo "Starting setup (5 seconds to cancel)..."
sleep 5

echo "Installing dependencies..."
yay -S --noconfirm yazi zen-browser-bin visual-studio-code-bin oh-my-posh stow ox fish

mkdir ../.config/omarchy/themes/dark
tar -xJf assets/theme.tar.xz -C ../.config/omarchy/themes/dark --strip-components=1
