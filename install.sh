#!/bin/sh
#script de instalação do meu setup voidlinux.

#entar no modo super usuário
su root
#descriptografar e montar os volumes lvm
cryptsetup luksOpen /dev/sda2 lvm
vgchange -ay
#formatar as partições
wipefs -a /dev/sda1
wipefs -a /dev/lvm/root
wipefs -a /dev/lvm/swap
#criar as partições
mkfs.vfat -F32 /dev/sda1
mkfs.ext4 -L VoidLinux /dev/lvm/root
mkswap /dev/lvm/swap
#montar as partições
mount /dev/lvm/root /mnt
for dir in dev proc sys run; do mkdir -p /mnt/$dir ; mount --rbind /$dir /mnt/$dir ; mount --make-rslave /mnt/$dir ; done
mkdir -p /mnt/home
mount /dev/lvm/home /mnt/home
mkdir -p /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi
#copiar as chaves do xbps
mkdir -p /mnt/var/db/xbps/keys
cp /var/db/xbps/keys/* /mnt/var/db/xbps/keys/
#instalar o sistema base e afins.
xbps-install -Sy -R https://repo-default.voidlinux.org/current -r /mnt base-system base-devel lvm2 cryptsetup grub-x86_64-efi vim
#remover arquivos e instalar os pré-configurados.
cd config
rm /mnt/etc/crypttab
rm /mnt/etc/fstab
rm /mnt/etc/hostname
rm /mnt/etc/locale.conf
cp cryptab fstab hostname locale.conf /mnt/etc/
cp 10-key.conf /etc/dracut.conf.d/
cp grub /etc/default/
cd /
#configurações da raiz e root
chroot /mnt
chown root:root /
chmod 755 /
cp /home/void.bk/key /
chmod 000 /key
passwd root
#instalando o boot
grub-install --target="x86_64" --efi-directory=:"/boot/efi" --bootloarder-id="VoidLinux" /dev/sda
#reconfigurar tudo
xbps-reconfigure -fa
#sair e reiniciar
exit
umount -R /mnt
reboot
