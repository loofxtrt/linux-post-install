#!/bin/bash

install_software_via_yay() {
    echo "Instalando software via yay"
    yay -S --needed \
        vscodium-bin \
        libresprite \
        sklauncher-bin \
        fspy \
        beeref \
        spicetify-cli
}

# comente essa linha caso o script vá rodar automaticamente
install_software_via_yay