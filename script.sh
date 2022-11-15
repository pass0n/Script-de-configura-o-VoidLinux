#!/bin/bash
#Script de configuração do meu setup VoidLinux

#Baixar e atualizar os repositórios void
sudo xbps-install -Sy void-repo-nonfree void-repo-multilib void-repo-multilib-nonfree
sudo xbps-install -Sy
#criar a pasta para instalação do nvidia DKMS
sudo mkdir -p /var/lib/dkms
#baixar os meus pacotes padrões
sudo xbps-install -Sy xorg-minimal vim xdg-user-dirs zsh picom dex scrot awesome alacritty git vscode firefox Thunar tumbler thunar-archive-plugin file-roller unrar unzip p7zip thunar-media-tags-plugin setxkbmap  nitrogen lxappearance gvfs gvfs-mtp polkit elogind dbus rtkit pavucontrol pipewire alsa-pipewire ssr webp-pixbuf-loader ristretto geany mpv mesa-dri mesa-dri-32bit steam numlockx gnome-keyring seahorse nvidia470 nvidia470-libs-32bit 
#baixar e instalar o Oh My Zsh!
xdg-user-dirs-update
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
#configurar o pipewire
sudo ln -s /usr/share/applications/pipewire.desktop /etc/xdg/autostart/pipewire.desktop
sudo ln -s /usr/share/applications/pipewire-pulse.desktop /etc/xdg/autostart/pipewire-pulse.desktop
sudo mkdir -p /etc/alsa/conf.d
sudo ln -s /usr/share/alsa/alsa.conf.d/50-pipewire.conf /etc/alsa/conf.d
sudo ln -s /usr/share/alsa/alsa.conf.d/99-pipewire-default.conf /etc/alsa/conf.d
#ativar serviços runit
sudo ln -s /etc/sv/dbus/ /var/service/
sudo ln -s /etc/sv/dhcpcd/ /var/service/
sudo ln -s /etc/sv/rtkit/ /var/service/
sudo ln -s /etc/sv/polkitd/ /var/service/
