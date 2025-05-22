#!/bin/bash

install_secondary_software() {
    echo "Instando software secundário via qualquer manager"
    
    sudo pacman -S \
        firefox-developer-edition \
        kvantum
    
    yay -S \
        firefox-nightly-bin
}