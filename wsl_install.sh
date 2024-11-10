curl.exe -L -o ubuntu-2204.zip https://aka.ms/wslubuntu2204

Set-Location -Path $env:USERPROFILE\Downloads
$TargetUri = "https://aka.ms/wslubuntu2204"
Invoke-WebRequest -Uri $TargetUri -OutFile .\ubuntu.zip
New-Item -Type Container -Path $env:SYSTEMDRIVE\Distro\Ubuntu2204
Expand-Archive -Path .\ubuntu.zip -DestinationPath $env:SYSTEMDRIVE\Distro\Ubuntu2204
Remove-Item -Path .\ubuntu.zip
Set-Location -Path $env:SYSTEMDRIVE\Distro\Ubuntu2204
.\ubuntu2204.exe

ubuntu2204.exe install --ui=none

wsl -l -v

wsl --set-default-version 2
wsl --set-default Ubuntu-22.04
wsl --unregister Ubuntu-18.04
explorer.exe .

###########################################
카카오서버로 변경 
sudo sed -i -re 's/([a-z]{2}.)?archive.ubuntu.com|security.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list
sudo apt update
sudo apt upgrade -y

###########################################
sudo apt install build-essential -y
sudo apt install vim git wget curl -y

##############################################
sudo apt update 
sudo apt upgrade
sudo apt dist-upgrade
sudo apt autoremove
sudo apt install update-manager-core
sudo do-release-upgrade or sudo do-release-upgrade -d

##############################################
sudo apt install -y font-manager 
sudo apt install -y gedit 
sudo apt install -y nautilus 
sudo apt install -y x11-apps 
sudo apt install -y firefox
##############################################

curl -O http://ports.ubuntu.com/pool/main/f/firefox/firefox_75.0+build3-0ubuntu1_arm64.deb
##############################################
sudo apt install language-selector-gnome
sudo gnome-language-selector

C:/Users/<user name>/.wslconfig 파일을 생성하여 WSL2가 사용하는 자원을 한정 한다.
notepad $env:USERPROFILE\.wslconfig

[wsl2]
memory=4GB
processors=2
swap=1GB
localhostForwarding=true
##############################################

notepad $env:USERPROFILE/.wslconfig


Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux

dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

Invoke-WebRequest -Uri https://aka.ms/wslubuntu2004 -OutFile Ubuntu.appx -UseBasicParsing
Add-AppxPackage .\app_name.appx

==================================
/etc/wsl.conf
[boot]
systemd=true

==================================

sudo rm /etc/resolv.conf
sudo bash -c 'echo "nameserver 8.8.8.8" >  /etc/resolv.conf'
sudo bash -c 'echo "nameserver 8.8.4.4" >> /etc/resolv.conf'
sudo bash -c 'echo "[boot]"       > /etc/wsl.conf'
sudo bash -c 'echo "systemd=true" >> /etc/wsl.conf'
sudo bash -c 'echo "[network]"    >> /etc/wsl.conf'
sudo bash -c 'echo "generateResolvConf=false" >> /etc/wsl.conf'

sudo chattr -f +i /etc/resolv.conf
sudo chattr -i /etc/resolv.conf

sudo apt-get install bridge-utils
sudo apt-get install net-tools    

ip link
hostname -I
ip addr

sudo update-alternatives --set iptables /usr/sbin/iptables-legacy
sudo update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
sudo iptables -F FORWARD
sudo iptables -P FORWARD ACCEPT
sudo iptables -P INPUT ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -S -t nat         
sudo iptables -t nat -nL
sudo iptables -I OUTPUT -p tcp --sport 80
sudo iptables -nxvL OUTPUT

##############################################