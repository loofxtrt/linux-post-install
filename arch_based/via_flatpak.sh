#!/bin/bash

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