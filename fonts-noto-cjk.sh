#!/bin/bash

# 시스템 패키지 목록 업데이트
sudo apt update

# Noto CJK 폰트 및 관련 유틸리티 설치
# - fonts-noto-cjk: Noto CJK 폰트 (중국어, 일본어, 한국어 글꼴 지원)
# - tasksel: 특정 작업을 위한 패키지 그룹 설치 도구
# - screenfetch, neofetch: 터미널에 시스템 정보와 배포판 로고 표시
# - language-pack-ko, language-pack-gnome-ko: 한국어 언어 팩
sudo apt install -y fonts-noto-cjk tasksel screenfetch neofetch language-pack-ko language-pack-gnome-ko

# Ubuntu에 Locale 변경하기
# 현재 시스템의 로케일 설정 확인
locale

# ko_KR.UTF-8 로케일 생성 (UTF-8 인코딩의 한국어 로케일)
sudo locale-gen ko_KR.UTF-8

# 시스템 로케일 재설정 대화형 프롬프트 실행
sudo dpkg-reconfigure locales

# 시스템 기본 로케일을 한국어로, 메시지 로케일을 POSIX로 업데이트
sudo update-locale LANG=ko_KR.UTF-8 LC_MESSAGES=POSIX

# /etc/default/locale 파일을 직접 수정하여 로케일 설정
echo "################################################################"
echo "# 아래 명령어를 사용하여 /etc/default/locale 파일을 직접 수정할 수 있습니다."
echo "# wsl --user root"
echo "# sudo vi /etc/default/locale"
echo "################################################################"
echo "LANG=ko_KR.UTF-8"
echo "LC_MESSAGES=POSIX"
