sudo apt  purge fcitx fcitx-hangul 
sudo apt autoremove
sudo apt install -y fcitx fcitx-hangul  dbus-x11 
im-config -n fcitx
im-config


sudo vi /etc/default/im-config
IM_CONFIG_DEFAULT_MODE=fcitx # auto를 fcitx
##############################################
sudo vi /etc/profile.d/fcitx.sh

#!/bin/bash
export QT_IM_MODULE=fcitx
export GTK_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export DefaultIMModule=fcitx
 
#optional
fcitx-autostart &>/dev/null

wsl --shutdown
fcitx-config-gtk3

##############################################
crontab -e
@reboot /usr/bin/fcitx-autostart
##############################################