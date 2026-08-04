#!/bin/bash
set -e

# ==========================================
# 1. 필요 패키지 설치
# ==========================================
echo "▶ 1단계: 필수 빌드 패키지 설치 중..."
sudo apt update
sudo apt install -y build-essential libncurses-dev bison flex libssl-dev libelf-dev dwarves bc rsync fakeroot git wget

# ==========================================
# 2. 커널 다운로드
# ==========================================
echo "▶ 2단계: 커널 소스코드 다운로드 및 압축 해제..."
mkdir -p ~/kernel
cd ~/kernel

# 실제 릴리스 여부 확인 후 다운로드
wget https://cdn.kernel.org/pub/linux/kernel/v7.x/linux-7.1.4.tar.xz
tar -xf linux-7.1.4.tar.xz
cd linux-7.1.4

# ==========================================
# 3. Config 생성 (WSL2 맞춤형 추출)
# ==========================================
echo "▶ 3단계: 커널 설정(.config) 구성 중..."
if [ -f /proc/config.gz ]; then
    zcat /proc/config.gz > .config
    echo "기존 WSL2 커널 설정(/proc/config.gz)을 추출하여 적용했습니다."
elif [ -f /boot/config-$(uname -r) ]; then
    cp /boot/config-$(uname -r) .config
else
    make defconfig
    echo "기본 설정(defconfig)으로 진행합니다."
fi

# 새로운 커널 버전에 맞게 설정 업데이트
make olddefconfig

# 인증키 오류 방지
./scripts/config --set-str SYSTEM_TRUSTED_KEYS ""
./scripts/config --set-str SYSTEM_REVOCATION_KEYS ""
make olddefconfig

# ==========================================
# 4. 커널 빌드
# ==========================================
echo "▶ 4단계: 커널 컴파일 시작 (시간이 다소 소요됩니다)..."
make -j$(nproc)

# ==========================================
# 5. Windows로 복사
# ==========================================
echo "▶ 5단계: 빌드된 bzImage를 윈도우 C드라이브로 복사 중..."
mkdir -p /mnt/c/wsl-kernel

cp /mnt/c/wsl-kernel/vmlinux-7.1.4 \
   /mnt/c/wsl-kernel/vmlinux-7.1.4.bak 2>/dev/null || true

cp arch/x86/boot/bzImage /mnt/c/wsl-kernel/vmlinux-7.1.4

echo
echo "=========================================="
echo " 빌드 및 복사 완료! "
echo "=========================================="
echo "1. Windows PowerShell을 열고 아래 명령 실행:"
echo "   wsl --shutdown"
echo
echo "2. 다시 Ubuntu 터미널을 실행한 뒤 버전 확인:"
echo "   uname -r"
echo "=========================================="


[wsl2]
memory=14GB
processors=10
swap=4GB
localhostForwarding=true
kernel=C:\\wsl-kernel\\vmlinux-7.1.4

