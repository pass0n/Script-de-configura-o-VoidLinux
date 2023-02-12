#!/bin/sh
#script de instalação do meu setup voidlinux.

#descriptografar e montar os volumes lvm
cryptsetup luksOpen /dev/sda2 lv
vgchange -ay
#formatar as partições
wipefs -a /dev/sda1
wipefs -a /dev/mapper/lv-root
wipefs -a /dev/mapper/lv-swap

#criar as partições
mkfs.vfat -F32 /dev/sda1
mkfs.ext4 -L root /dev/mapper/lv-root
mkswap /dev/mapper/lv-swap

#montar as partições
mount /dev/mapper/lv-root /mnt
for dir in dev proc sys run; do mkdir -p /mnt/$dir ; mount --rbind /$dir /mnt/$dir ; mount --make-rslave /mnt/$dir ; done
mount --mkdir /dev/mapper/lv-home /mnt/home
mount --mkdir /dev/sda1 /mnt/boot/efi

#copiar as chaves do xbps
mkdir -p /mnt/var/db/xbps/keys
cp /var/db/xbps/keys/* /mnt/var/db/xbps/keys/

#instalar o sistema base e afins.
xbps-install -Sy -R https://repo-default.voidlinux.org/current -r /mnt base-system base-devel lvm2 cryptsetup grub-x86_64-efi neovim

#remover arquivos e instalar os pré-configurados.

cp config/10-key.conf /mnt/etc/dracut.conf.d/
cp config/grub /mnt/etc/default/grub
cp config/libc-locales /mnt/etc/default/libc-locales
cp config/locale.conf /mnt/etc/locale.conf
cp config/fstab /mnt/etc/fstab
cp config/crypttab /mnt/etc/crypttab
cp config/hostname /mnt/etc/hostname

#configurações da raiz
chroot /mnt
chown root:root /
chmod 755 /
cp /home/void.bk/key.bin /
chmod 000 /key.bin
passwd root

#instalando o boot
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloarder-id="void_grub" /dev/sda

#reconfigurar tudo
xbps-reconfigure -fa

#sair e reiniciar
exit
umount -R /mnt
reboot
