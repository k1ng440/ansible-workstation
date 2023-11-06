#!/usr/bin/env bash

# fail early
set -e -o pipefail

LOGIN_USER=$1
LOGIN_PASS=$2

if getent passwd "$LOGIN_USER" >/dev/null; then
  echo "Login User '$LOGIN_USER' already created..."
  exit 0
fi

adduser "$LOGIN_USER" --gecos "" --home "/home/$LOGIN_USER" --disabled-password
echo "$LOGIN_USER:$LOGIN_PASS" | chpasswd
usermod -a -G adm,cdrom,sudo,dip,plugdev "$LOGIN_USER"
echo "$LOGIN_USER ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/"$LOGIN_USER"

if [[ $(which gnome-session) ]]; then
    mv /usr/share/xsessions/gnome-xorg.desktop{,.bak}
    mv /usr/share/xsessions/gnome.desktop{,.bak}
fi

mkdir -p /etc/gdm3
{
  echo "[daemon]"
  echo "AutomaticLoginEnable = true"
  echo "AutomaticLogin = $LOGIN_USER"
} > /etc/gdm3/custom.conf

if [[ $(which gnome-session) ]]; then
  systemctl restart display-manager
fi
