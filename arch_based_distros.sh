#!/bin/bash

set -e # parar caso algum erro aconteça
sudo pacman -Syu --noconfirm # atualizar o sistema e as packages pela primeira vez

install_basics() {
    echo "Now installing basic software"

    # base-devel: grupo de pacotes com ferramentas básicas para compilar programas (inclui make, gcc, binutils, pkgconf, etc.) muitas aur packages exigem isso
    # git: controle de versão
    # wget: ferramenta de linha de comando para baixar arquivos da internet
    # unzip: utilitário para descompactar arquivos .zip
    # ripgrep: ferramenta de busca baseada em grep, ex: procurar pela string "lorem_ipsum" em todos os arquivos recursivamente a partir do diretório atual
    # make:
    # make: ferramenta de automação de compilação (já vem no base-devel, mas só pra garantir)
    # gcc: compilador C/C++ (também parte do base-devel)
    # --needed faz com o que pacman instale apenas os softwares que ainda NÃO existem no sistema, evitando reinstalações desnecessárias
    sudo pacman -S --needed base-devel git wget unzip ripgrep make gcc
}

install_managers() {
    install_flatpak() {
        echo "Now installing packman"

        sudo pacman -S --needed flatpak
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo # adicionar o repositório do flatpak ao sistema
    }
    
    install_yay() {
        # testar se o comando yay já existe ou não
        # se não exsitr, clona o repositório do yay, entra no diretório novo, compila e depois volta
        if ! command -v yay &> /dev/null; then
            echo "Now installing yay"

            git clone https://aur.archlinux.org/yay.git
            cd yay
            makepkg -si
            cd ..
            rm -rf yay
        fi
    }

    install_flatpak
    install_yay
}

install_software_via_flatpak() {
    echo "Now installing software via flatpak"

    flatpak install -y flathub \
        org.kde.kdenlive \
        com.kristianduske.TrenchBroom \
        org.sqlitebrowser.sqlitebrowser \
        net.blockbench.Blockbench \
        net.lutris.Lutris \
        com.github.tchx84.Flatseal \
        com.valvesoftware.Steam \
        com.usebottles.bottles \
        com.github.beeRef.BeeRef
}

install_software_via_pacman() {
    echo "Now installing software via pacman"

    sudo pacman -S --needed \
        firefox \
        audacity \
        krita \
        inkscape \
        qt5-tools \
        neovim \
        kvantum \
        blender \
        godot \
        gimp \
        obsidian \
        discord \
        spotify-launcher \
        obs-studio \
        wine \
        openjdk21 \
        python \
        lua
}

install_software_via_yay() {
    echo "Now installing software via yay"

    yay -S --needed \
        btop \
        vscodium-bin \
        libresprite
}

install_basics
install_managers
install_software_via_flatpak
install_software_via_pacman
install_software_via_yay