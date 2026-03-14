#!/bin/bash
echo "Starting setup (5 seconds to cancel)..."
sleep 5

echo "Installing dependencies..."
# TODO: install dependencies
yay -S --noconfirm zsh ze
chsh -s /usr/bin/zsh
sudo chsh -s /usr/bin/zsh

echo "All finished! You may need to reboot to finish some config"
