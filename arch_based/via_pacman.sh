#!/bin/bash

install_software_via_pacman() {
    echo "Instalando software via pacman"
    
    echo "pacman --- Instalando software geral"
    sudo pacman -S --needed \
        firefox \
        obsidian \
        discord \
        spicetify-cli \
        bitwarden \
        wine
    
    creation_related() {
        echo "pacman --- Instalando software relacionado à criação"
        sudo pacman -S --needed \
            audacity \
            krita \
            blender \
            gimp \
            obs-studio \
            reaper
    }

    programming_related() {
        echo "pacman --- Instalando software relacionado à programação"
        sudo pacman -S --needed \
            qt5-tools \
            godot \
            neovim \
            openjdk21 \
            python \
            lua
    }
    
    command_line() {
        echo "pacman --- Instalando software de linha de comando"
        sudo pacman -S --needed \
            xtrlock \
            btop \
            hyfetch
    }

    creation_related
    programming_related
    command_line
}