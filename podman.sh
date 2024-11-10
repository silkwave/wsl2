# Podman 설치
sudo apt install -y podman
sudo apt install -y podman-compose             
sudo groupadd podman 
sudo usermod -aG podman $USER
sudo newgrp podman 

id -u

# Podman Compose 설정 파일
# /etc/containers/registries.conf 파일에서 레지스트리 설정을 변경합니다.
echo 'unqualified-search-registries = ["docker.io"]' | sudo tee -a /etc/containers/registries.conf  # Podman에서 사용할 기본 레지스트리를 설정합니다.

/etc/containers/registries.conf
unqualified-search-registries = ["docker.io"]
podman-compose up -d

# Podman Compose 실행
# Podman Compose를 이용해 서비스를 실행합니다.
podman-compose up -d   # Podman Compose를 이용해 백그라운드에서 서비스를 실행합니다.
podman-compose logs   # 실행된 서비스의 로그를 확인합니다.

# Docker와 호환되도록 설정 (alias 사용)
alias docker="podman"  # Docker 명령어 대신 Podman을 사용하도록 alias를 설정합니다.
alias docker-compose="podman-compose"  # Docker Compose 명령어 대신 Podman Compose를 사용하도록 alias를 설정합니다.

##############################################
sudo docker stop `docker ps -a -q`
sudo docker rm   `docker ps -a -q`
sudo docker rmi  `docker images -q`
sudo docker commit ts silkwave/tensorflow-notebook

##############################################

도커 엔진🔗 제거
sudo apt-get purge docker-ce docker-ce-cli containerd.io docker-compose-plugin

sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd
##############################################
vscode docker Docker v1.22.0 podman 정상

  "dev.containers.dockerComposePath": "podman-compose",
  "dev.containers.dockerPath": "podman",
  "docker.debug": true
  
##############################################

