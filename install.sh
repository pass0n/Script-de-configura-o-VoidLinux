#!/bin/sh
#script de instalação do meu setup voidlinux.

#descriptografar e montar os volumes lvm
cryptsetup luksOpen /dev/sda2 lvm
vgchange -ay
#formatar as partições
wipefs -a /dev/sda1
wipefs -a /dev/mapper/lvm-volRoot
wipefs -a /dev/mapper/lvm-volSwap

#criar as partições
mkfs.vfat -F32 /dev/sda1
mkfs.ext4 -L root /dev/mapper/lvm-volRoot
mkswap /dev/mapper/lvm-volSwap

#montar as partições
mount /dev/mapper/lvm-volRoot /mnt
for dir in dev proc sys run; do mkdir -p /mnt/$dir ; mount --rbind /$dir /mnt/$dir ; mount --make-rslave /mnt/$dir ; done
mount --mkdir /dev/mapper/lvm-volHome /mnt/home
mount --mkdir /dev/sda1 /mnt/boot/efi

#copiar as chaves do xbps
mkdir -p /mnt/var/db/xbps/keys
cp /var/db/xbps/keys/* /mnt/var/db/xbps/keys/

#instalar o sistema base e afins.
xbps-install -Sy -R https://voidlinux.com.br/repo/current -r /mnt base-system base-devel lvm2 cryptsetup grub-x86_64-efi neovim

#remover arquivos e instalar os pré-configurados.

cp /etc /mnt/etc

#configurações da raiz
chroot /mnt
chown root:root /
chmod 755 /
cp /home/void.bk/key.bin /
chmod 000 /key.bin
passwd root

#instalando o boot
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id="void_grub" /dev/sda

#reconfigurar tudo
xbps-reconfigure -fa

#sair e reiniciar
exit
umount -R /mnt
reboot
