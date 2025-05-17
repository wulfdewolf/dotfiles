#!/bin/bash
# Install nvim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
rm -rf ~/.config/nvim
ln -s ~/dotfiles/nvim/ ~/.config/nvim
echo -e '\n# Set Neovim as default editor\nexport EDITOR=nvim\nexport VISUAL=nvim' >> ~/.bashrc
git config --global core.editor "nvim"
rm nvim-linux-x86_64.tar.gz

# Download and install nerdfont
wget -qO nerd-font.zip "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/0xProto.zip" && unzip -j nerd-font.zip "0xProtoNerdFont-Regular.ttf" -d ~/.local/share/fonts && rm nerd-font.zip
fc-cache -fv

# Install rust
curl https://sh.rustup.rs -sSf | sh
source $HOME/.cargo/env

# Install node and tree-sitter
cd ~
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt update
sudo apt install nodejs luarocks xclip libfontconfig1-dev libevent-dev bison fzf
sudo apt autoclean
sudo apt autoremove
npm install tree-sitter-cli
rm package.json package-lock.json
cd ~/dotfiles

# Alacritty
git clone https://github.com/alacritty/alacritty.git alacritty_
cd alacritty_
rustup override set stable
rustup update stable
cargo build --release
mv target/release/alacritty ~/.local/bin/alacritty
cd ~/dotfiles
rm -rf alacritty_
rm -rf ~/.config/alacritty/
ln -s ~/dotfiles/alacritty/ ~/.config/alacritty

# Tmux
git clone https://github.com/tmux/tmux.git
cd tmux
sh autogen.sh
./configure
make && sudo make install
cd ~/dotfiles
rm -rf tmux/
chmod +x tmux-sessionizer.sh
ln -s ~/dotfiles/tmux-sessionizer.sh ~/.local/bin/tmux-sessionizer.sh
echo bind -x '"\C-f":tmux-sessionizer.sh' >> ~/.bashrc

# Keybindings
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name 'Alacritty AltT'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command 'alacritty'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding '<Alt>t'

echo "PS1='[\A \W] \$ '" >> ~/.bashrc
source ~/.bashrc
