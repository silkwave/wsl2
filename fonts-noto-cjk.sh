##############################################

sudo apt update
sudo apt install -y tasksel
sudo apt install -y screenfetch 
sudo apt install -y neofetch 

sudo apt update
sudo apt install -y  fonts-noto-cjk 

Ubuntu에 Locale변경하기
locale
sudo apt install -y language-pack-ko
sudo apt install -y language-pack-gnome-ko
sudo locale-gen ko_KR.UTF-8
sudo dpkg-reconfigure locales
sudo update-locale LANG=ko_KR.UTF-8 LC_MESSAGES=POSIX

/etc/default/locale 파일을 수정하는 것인데요, nano나 vim등으로 아래와 같이 내용을 수정해주시면 됩니다.
wsl --user root

sudo vi  /etc/default/locale
LANG=ko_KR.UTF-8
LC_MESSAGES=POSIX
