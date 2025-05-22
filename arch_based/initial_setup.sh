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

# importar funções de outros arquivos
source ./managers.sh
source ./secondary.sh
source ./setup_steam.sh
source ./via_flatpak.sh
source ./via_pacman.sh
source ./via_yay.sh

# descomente as linhas com '#' pra que elas sejam rodadas automaticamente
# elas podem ser rodadas individualmente por terem uma hashbang (#!/bin/bash) no topo do arquivo
# o que é útil pra ter mais controle sobre quais comandos estão sendo executados e quando
main() {
    install_basics
    install_managers
    #install_software_via_flatpak
    #install_software_via_pacman
    #install_software_via_yay
    #setup_steam_installation
    #install_secondary_software
}

main "$@"