#!/bin/bash

# Install nvim
sudo apt install neovim

# Move all config to the right place
mkdir ~/.config/nvim
cp -r lua/ init.lua ~/.config/nvim

# Download and install nerdfont
wget -qO nerd-font.zip "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/0xProto.zip" && unzip -j nerd-font.zip "0xProtoNerdFont-Regular.ttf" -d ~/.local/share/fonts && rm nerd-font.zip
fc-cache -fv

# Install required packages
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt update
sudo apt install nodejs luarocks xclip
npm install tree-sitter-cli
