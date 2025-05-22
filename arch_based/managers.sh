#!/bin/bash

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