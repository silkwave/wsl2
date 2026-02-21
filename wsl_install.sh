#!/bin/bash

################################################################################
# Part 1: Windows PowerShell Commands
# - WSL2 설치 및 Ubuntu 22.04 배포판 설정
# - 이 부분은 Windows PowerShell에서 실행해야 합니다.
################################################################################

# --- WSL2 및 필수 기능 활성화 ---
# DISM 도구를 사용하여 Microsoft-Windows-Subsystem-Linux 기능 활성화
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
# DISM 도구를 사용하여 VirtualMachinePlatform 기능 활성화 (WSL2 필수)
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart


# --- Ubuntu 22.04 수동 설치 ---
# Ubuntu 22.04 배포판 zip 파일 다운로드
# curl.exe -L -o ubuntu-22.04.zip https://aka.ms/wslubuntu2204
# 또는 Invoke-WebRequest 사용
# Invoke-WebRequest -Uri https://aka.ms/wslubuntu2204 -OutFile .\ubuntu.zip

# 다운로드 후 압축 해제 및 설치는 수동으로 진행하는 것을 권장합니다.
# New-Item -Type Container -Path "$env:SYSTEMDRIVE\Distro\Ubuntu2204"
# Expand-Archive -Path .\ubuntu.zip -DestinationPath "$env:SYSTEMDRIVE\Distro\Ubuntu2204"
# cd "$env:SYSTEMDRIVE\Distro\Ubuntu2204"
# .\ubuntu2204.exe


# --- WSL 기본 설정 ---
# 설치된 WSL 배포판 목록 및 버전 확인
wsl -l -v
# WSL 기본 버전을 2로 설정
wsl --set-default-version 2
# WSL 기본 배포판을 Ubuntu-22.04로 설정
wsl --set-default Ubuntu-22.04


# --- .wslconfig 파일 설정 ---
# WSL2가 사용할 자원(메모리, 프로세서 등)을 설정하는 .wslconfig 파일 생성
# notepad $env:USERPROFILE\.wslconfig
# 아래 내용 추가:
# [wsl2]
# memory=4GB
# processors=2
# swap=1GB
# localhostForwarding=true


################################################################################
# Part 2: Ubuntu (WSL2) Shell Commands
# - 이 부분은 WSL2 Ubuntu 터미널에서 실행해야 합니다.
################################################################################

# --- APT 저장소 미러 변경 및 시스템 업그레이드 ---
# 카카오 미러 서버로 변경
sudo sed -i -re 's/([a-z]{2}.)?archive.ubuntu.com|security.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list
sudo sed -i -E 's#http://[a-zA-Z0-9.-]+/ubuntu/#http://mirror.kakao.com/ubuntu/#g' /etc/apt/sources.list.d/ubuntu.sources

# 패키지 목록 업데이트 및 전체 업그레이드
sudo apt update && sudo apt upgrade -y && sudo apt dist-upgrade -y && sudo apt autoremove -y


# --- 필수 패키지 및 GUI 애플리케이션 설치 ---
# 빌드 도구, 개발 유틸리티, GUI 앱 등 필수 패키지 설치
sudo apt install -y build-essential vim git wget curl \
                    font-manager gedit nautilus x11-apps firefox \
                    language-selector-gnome update-manager-core \
                    bridge-utils net-tools


# --- wsl.conf 및 resolv.conf 설정 ---
# /etc/wsl.conf 파일 설정 (systemd 활성화 및 네트워크 설정)
sudo tee /etc/wsl.conf > /dev/null <<EOF
[boot]
systemd=true
command = "mount --make-rshared /"

[network]
generateResolvConf=false
EOF

# Google DNS를 사용하도록 /etc/resolv.conf 파일 설정
sudo tee /etc/resolv.conf > /dev/null <<EOF
nameserver 8.8.8.8
nameserver 8.8.4.4
EOF

# resolv.conf 파일이 자동으로 변경되지 않도록 불변(immutable) 속성 설정
sudo chattr +i /etc/resolv.conf


# --- iptables 레거시 모드 설정 ---
# iptables를 레거시 모드로 설정
sudo update-alternatives --set iptables /usr/sbin/iptables-legacy
sudo update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy

# iptables 기본 정책 설정 (모두 허용)
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -F

echo "WSL2 설치 및 기본 설정 스크립트입니다."
echo "Part 1은 Windows PowerShell에서, Part 2는 WSL2 Ubuntu 터미널에서 실행하세요."
