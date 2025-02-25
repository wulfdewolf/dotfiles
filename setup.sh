#!/bin/bash

# Install nvim
sudo apt install nvim

# Move all config to the right place
mv -r lua/ init.lua ~/.config/nvim
