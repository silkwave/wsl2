# --- Podman 설치 및 사용자 설정 ---
# Podman 및 Podman Compose 패키지 설치
sudo apt install -y podman podman-compose

# Podman 그룹 생성 및 현재 사용자 추가
sudo groupadd podman
sudo usermod -aG podman "$USER"
newgrp podman # 새 그룹 적용 (재로그인 필요할 수 있음)

# 현재 사용자의 UID(User ID) 확인
id -u

# --- Podman Compose 설정 및 실행 ---
# /etc/containers/registries.conf 파일에 기본 레지스트리 "docker.io" 추가
echo 'unqualified-search-registries = ["docker.io"]' | sudo tee -a /etc/containers/registries.conf

# Podman Compose를 이용하여 서비스 실행 및 로그 확인
podman-compose up -d   # 백그라운드에서 서비스 실행
podman-compose logs    # 실행된 서비스의 로그 확인

# --- Docker 호환성 설정 (alias 사용) ---
# 'docker' 명령어를 'podman'으로, 'docker-compose'를 'podman-compose'로 alias 설정
alias docker="podman"
alias docker-compose="podman-compose"

# --- Docker/Podman 컨테이너 및 이미지 관리 ---
# 모든 실행 중인 컨테이너 중지, 모든 컨테이너 제거, 모든 이미지 제거
docker stop "$(docker ps -a -q)"
docker rm   "$(docker ps -a -q)"
docker rmi  "$(docker images -q)"

# 'ts' 컨테이너를 'silkwave/tensorflow-notebook' 이름으로 이미지 커밋
docker commit ts silkwave/tensorflow-notebook

# --- 도커 엔진 제거 ---
# Docker 관련 패키지 및 데이터 완전 삭제
sudo apt-get purge -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo rm -rf /var/lib/docker /var/lib/containerd

# --- VS Code Docker 확장 Podman 설정 가이드 ---
# VS Code의 settings.json에 다음 내용을 추가하여 Podman을 Docker 대신 사용하도록 설정합니다.
echo "
  \"dev.containers.dockerComposePath\": \"podman-compose\",
  \"dev.containers.dockerPath\": \"podman\",
  \"docker.debug\": true
"
