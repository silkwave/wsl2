# 1. 패키지 목록 업데이트 및 XFCE4 데스크탑 환경 설치
sudo apt update
sudo apt install xfce4 xfce4-goodies dbus-x11 -y

# 2. 필수 기본 유틸리티 (터미널, 파일관리자, 메모장)
xfce4-terminal
thunar
mousepad

# 3. XFCE4 데스크탑 실행 (GUI 세션 시작)
# ※ WSL2나 원격 환경인 경우 DISPLAY 설정이 필요할 수 있습니다.
startxfce4

# 4. 한글 입력기(iBus) 및 한글 엔진 설치
sudo apt install ibus ibus-hangul -y

# 5. 시스템 기본 입력기를 iBus로 설정
im-config -n ibus

# 6. GUI 애플리케이션에서 iBus를 인식하도록 환경 변수 설정
# GTK/QT 라이브러리를 사용하는 앱들이 한글 입력기를 찾을 수 있게 합니다.
echo '
export GTK_IM_MODULE=ibus
export QT_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
' >> ~/.bashrc

# 7. 변경된 환경 변수 즉시 적용
source ~/.bashrc

# 8. iBus 데몬 실행 (배경에서 실행, 기존 프로세스 교체)
ibus-daemon -drx

# 9. 화면 스케일 설정 (고해상도 모니터 대응)
# 글자가 너무 작으면 GDK_SCALE=2 로 변경하세요.
echo '
export GDK_SCALE=1
export GDK_DPI_SCALE=1
' >> ~/.bashrc

sudo apt install fonts-nanum -y
