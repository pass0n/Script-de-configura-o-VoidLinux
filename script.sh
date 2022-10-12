#!/bin/bash
#Script de configuração do meu setup VoidLinux

#Baixar e atualizar os repositórios Void
sudo xbps-install -Su void-repo-nonfree void-repo-multilib void-repo-multilib-nonfree
sudo xbps-install -Su
#Criar a pasta para instalação do nvidia DKMS
sudo mkdir -p /var/lib/dkms
#Baixar os meus aplicativos padrões
sudo xbps-install -S xorg-minimal vim xdg-user-dirs fish-shell awesome alacritty git vscode firefox Thunar thunar-archive-plugin file-roller unrar unzip p7zip thunar-media-tags-plugin setxkbmap  nitrogen lxappearance gvfs gvfs-mtp polkit elogind dbus rtkit pavucontrol pipewire alsa-pipewire webp-pixbuf-loader ristretto mousepad mpv mesa-dri mesa-dri-32bit steam numlockx gnome-keyring seahorse nvidia470 nvidia470-libs-32bit 
#Configurar o pipewire
sudo ln -s /usr/share/applications/pipewire.desktop /etc/xdg/autostart/pipewire.desktop
sudo ln -s /usr/share/applications/pipewire-pulse.desktop /etc/xdg/autostart/pipewire-pulse.desktop
sudo mkdir -p /etc/alsa/conf.d
sudo ln -s /usr/share/alsa/alsa.conf.d/50-pipewire.conf /etc/alsa/conf.d
sudo ln -s /usr/share/alsa/alsa.conf.d/99-pipewire-default.conf /etc/alsa/conf.d
#Ativar serviços ln -s /etc/sv/<service> /var/service/
sudo ln -s /etc/sv/dbus/ /var/services/
sudo ln -s /etc/sv/dhcpcd/ /var/services/
sudo ln -s /etc/sv/rtkit/ /var/services/
sudo ln -s /etc/sv/polkitd/ /var/services/
#Criar meu Usuário
sudo useradd -m -s /bin/fish -U -G wheel,audio,video,xbuilder void
