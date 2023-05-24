#!/bin/bash
#Script de configuração do meu setup VoidLinux

#Baixar e atualizar os repositórios void
xbps-install -Sy void-repo-nonfree void-repo-multilib void-repo-multilib-nonfree
xbps-install -Sy

#criar a pasta para instalação do nvidia DKMS
mkdir -p /var/lib/dkms

#baixar os meus pacotes padrões

BSPWM="bspwm sxhkd polybar rofi picom dex scrot setxkbmap xsetroot xprop nitrogen lxappearance ristretto"

PKGS="xorg-minimal zathura zathura-pdf-mupdf neovim xdg-user-dirs git vscode firefox unrar unzip p7zip numlockx mpv mesa-dri mesa-dri-32bit gvfs elogind rtkit pavucontrol pipewire alsa-pipewire webp-pixbuf-loader nvidia470 nvidia470-libs-32bit"

THUNAR="Thunar tumbler thunar-archive-plugin file-roller thunar-media-tags-plugin"

XFCE="$THUNAR xfce4 ristretto"

echo -n "XFCE4 = 1 / BSPWM = 2: "
read -r n

if [ "$n" = "1" ]; then
    xbps-install -Syu $XFCE $PKGS
else
    xbps-install -Syu $BSPWM $THUNAR $PKGS
fi

# horário de São Paulo
ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime

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