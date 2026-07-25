# 0. config 파일 존재 여부 먼저 확인
ls /boot/config-$(uname -r) 2>/dev/null && echo "존재함" || echo "없음 - defconfig로 진행 필요"

# 1. 필요 패키지 설치
sudo apt update && sudo apt install -y build-essential libncurses-dev bison flex libssl-dev libelf-dev dwarves bc rsync fakeroot

# 2. 소스 다운로드
mkdir -p ~/kernel && cd ~/kernel
wget https://cdn.kernel.org/pub/linux/kernel/v7.x/linux-7.1.4.tar.xz
tar -xf linux-7.1.4.tar.xz
cd linux-7.1.4

# 3. config 생성 (0번 결과에 따라 분기)
cp /boot/config-$(uname -r) .config 2>/dev/null || make defconfig
make olddefconfig

# 4. 빌드
make -j$(nproc)

# 5. 백업 후 WSL용 커널 이미지 복사
cp /mnt/c/wsl-kernel/vmlinux-7.1.4 /mnt/c/wsl-kernel/vmlinux-7.1.4.bak 2>/dev/null
mkdir -p /mnt/c/wsl-kernel
cp arch/x86/boot/bzImage /mnt/c/wsl-kernel/vmlinux-7.1.4

echo "빌드 완료. wsl --shutdown 실행 후 uname -r로 확인하세요."

[wsl2]
memory=14GB
processors=10
swap=4GB
localhostForwarding=true
kernel=C:\\wsl-kernel\\vmlinux-7.1.4