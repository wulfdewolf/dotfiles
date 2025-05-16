#!/bin/bash
# Install nvim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
ln -s ~/dotfiles/nvim/ ~/.config/nvim
echo -e '\n# Set Neovim as default editor\nexport EDITOR=nvim\nexport VISUAL=nvim' >> ~/.bashrc
git config --global core.editor "nvim"
# Download and install nerdfont
wget -qO nerd-font.zip "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/0xProto.zip" && unzip -j nerd-font.zip "0xProtoNerdFont-Regular.ttf" -d ~/.local/share/fonts && rm nerd-font.zip
fc-cache -fv

# Install required packages
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt update
sudo apt install nodejs luarocks xclip
npm install tree-sitter-cli

# Alacritty
git clone https://github.com/alacritty/alacritty.git
cd alacritty
rustup override set stable
rustup update stable
cargo build --release
mv target/release/alacritty ~/local/bin/alacritty
ln -s ~/dotfiles/alacritty/ ~/.config/alacritty

# Tmux
git clone https://github.com/tmux/tmux.git
cd tmux
sh autogen.sh
./configure
make && sudo make install
rm -rf tmux/
