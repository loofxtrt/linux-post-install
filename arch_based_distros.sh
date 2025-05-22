#!/bin/bash

set -e # parar o script caso algum erro aconteça

echo "Atualizando o sistema antes de instalar packages"
sudo pacman -Syu --noconfirm # atualizar o sistema e as packages pela primeira vez

install_basics() {
    # base-devel: grupo de pacotes com ferramentas básicas para compilar programas (inclui make, gcc, binutils, pkgconf, etc.) muitas aur packages exigem isso
    # git: controle de versão
    # wget: ferramenta de linha de comando para baixar arquivos da internet
    # unzip: utilitário para descompactar arquivos .zip
    # ripgrep: ferramenta de busca baseada em grep, ex: procurar pela string "lorem_ipsum" em todos os arquivos recursivamente a partir do diretório atual
    # make:
    # make: ferramenta de automação de compilação (já vem no base-devel, mas só pra garantir)
    # gcc: compilador C/C++ (também parte do base-devel)
    # fakeroot: utilitário pra empacotar software com segurança sem precisar de privilégios de root
    # --needed faz com o que pacman instale apenas os softwares que ainda NÃO existem no sistema, evitando reinstalações desnecessárias
    echo "Instalando software básico"
    sudo pacman -S --needed base-devel git wget unzip ripgrep make gcc fakeroot
}

# essa função deve ser rodada antes de qualquer outra que instale algum software por um manager
# que não seja o pacman, ou seja, que não venha por padrão na maioria das distros baseadas no arch
install_managers() {
    install_flatpak() {
        echo "Instalando o manager flatpak"
        sudo pacman -S --needed flatpak
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo # adicionar o repositório do flatpak ao sistema
    }
    
    # o yay é um helper pra facilitar a instalação de packages do aur
    # ele busca, compila e instala os arquivos vindos do repositório
    install_yay() {
        # testar se o comando yay já existe ou não
        # se não exsitr, clona o repositório do yay, entra no diretório novo, compila e depois volta
        if ! command -v yay &> /dev/null; then
            echo "Instalando o manager yay"
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
    echo "Instalando software via flatpak"
    flatpak install -y flathub \
        org.kde.kdenlive \
        com.kristianduske.TrenchBroom \
        org.sqlitebrowser.sqlitebrowser \
        net.blockbench.Blockbench \
        net.lutris.Lutris \
        com.github.tchx84.Flatseal \
        com.usebottles.bottles
}

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

install_software_via_yay() {
    echo "Instalando software via yay"
    yay -S --needed \
        vscodium-bin \
        libresprite \
        sklauncher-bin \
        fspy \
        beeref
}

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

# função opcional que não é chamada por padrão no script
install_secondary_software() {
    echo "Instando software secundário via qualquer manager"
    
    sudo pacman -S \
        firefox-developer-edition \
        kvantum
    
    yay -S \
        firefox-nightly-bin
}

main() {
    install_basics
    install_managers
    install_software_via_flatpak
    install_software_via_pacman
    install_software_via_yay
    setup_steam_installation
}

main "$@"