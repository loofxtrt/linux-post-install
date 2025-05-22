#!/bin/bash

# a steam precisa de alguns ajustes pra ser instalada pelo pacman
# essa função faz esses ajustes nas configurações do pacman e instala mais utils pra steam
setup_steam_installation() {
    enable_multilib_repository() {
        echo "Habilitando o repositório multilib no pacman.conf"

        # fazer backup do arquivo original
        sudo cp /etc/pacman.conf /etc/pacman.conf.bak

        # remover o '#' da linha [multilib] e da linha Include logo abaixo, descomentando elas
        sudo sed -i '/^\s*#\[multilib\]/s/^#//' /etc/pacman.conf
        sudo sed -i '/^\s*#Include = \/etc\/pacman.d\/mirrorlist/s/^#//' /etc/pacman.conf

        echo "Repositório multilib habilitado"
    }

    install_steam() {
        echo "Instalando a Steam e bibliotecas de 32 bits"

        sudo pacman -S --needed steam lib32-mesa lib32-alsa-plugins lib32-libpulse

        # se o hardware for da nvidia, instala a lib32 dos drivers também (opcional)
        if lspci | grep -i nvidia &> /dev/null; then
            echo "Instalando lib32-nvidia-utils pra hardware da NVIDIA"
            sudo pacman -S --needed lib32-nvidia-utils
        fi
    }

    enable_multilib_repository
    install_steam
}

# comente essa linha caso o script vá rodar automaticamente
setup_steam_installation