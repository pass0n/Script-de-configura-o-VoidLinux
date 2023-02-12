#!/bin/bash
#Script de configuração do meu setup VoidLinux

#Baixar e atualizar os repositórios void
xbps-install -Sy void-repo-nonfree void-repo-multilib void-repo-multilib-nonfree
xbps-install -Sy

#criar a pasta para instalação do nvidia DKMS
mkdir -p /var/lib/dkms

#baixar os meus pacotes padrões
xbps-install -Sy xorg-minimal bspwm sxhkd polybar rofi terminator zathura zathura-pdf-mupdf neovim xdg-user-dirs picom dex scrot git vscode eclipse firefox Thunar tumbler thunar-archive-plugin file-roller unrar unzip p7zip thunar-media-tags-plugin setxkbmap xsetroot xprop nitrogen lxappearance gvfs elogind rtkit pavucontrol pipewire alsa-pipewire webp-pixbuf-loader ristretto mpv mesa-dri mesa-dri-32bit numlockx nvidia470 nvidia470-libs-32bit

#configurar o pipewire
ln -s /usr/share/applications/pipewire.desktop /etc/xdg/autostart/pipewire.desktop
ln -s /usr/share/applications/pipewire-pulse.desktop /etc/xdg/autostart/pipewire-pulse.desktop
mkdir -p /etc/pipewire
sed '/path.*=.*pipewire-media-session/s/{/#{/' \
    /usr/share/pipewire/pipewire.conf > /etc/pipewire/pipewire.conf
mkdir -p /etc/pipewire/pipewire.conf.d
echo 'context.exec = [ { path = "/usr/bin/wireplumber" args = "" } ]' \
    > /etc/pipewire/pipewire.conf.d/10-wireplumber.conf
mkdir -p /etc/alsa/conf.d
ln -s /usr/share/alsa/alsa.conf.d/50-pipewire.conf /etc/alsa/conf.d
ln -s /usr/share/alsa/alsa.conf.d/99-pipewire-default.conf /etc/alsa/conf.d

#ativar serviços runit
ln -s /etc/sv/dbus/ /var/service/
ln -s /etc/sv/dhcpcd/ /var/service/
ln -s /etc/sv/rtkit/ /var/service/
ln -s /etc/sv/polkitd/ /var/service/