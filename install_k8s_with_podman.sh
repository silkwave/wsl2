#!/bin/bash
set -e

echo "🔹 패키지 업데이트"
sudo apt update -y && sudo apt upgrade -y

# -------------------------------
# Podman 설치
# -------------------------------
if ! command -v podman &> /dev/null; then
    echo "🔹 Podman 설치"
    sudo apt install -y podman
else
    echo "✅ Podman 이미 설치됨, 설치 건너뜀"
fi

# Podman socket 활성화
echo "🔹 Podman socket 활성화"
if ! systemctl --user is-active --quiet podman.socket; then
    systemctl --user enable podman.socket
    systemctl --user start podman.socket
else
    echo "✅ podman.socket 이미 활성화됨"
fi
export DOCKER_HOST=unix:///run/user/$UID/podman/podman.sock

# -------------------------------
# kubectl 설치
# -------------------------------
if ! command -v kubectl &> /dev/null; then
    echo "🔹 kubectl 설치"
    curl -LO "https://dl.k8s.io/release/$(curl -L -s \
https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl
    sudo mv kubectl /usr/local/bin/kubectl
else
    echo "✅ kubectl 이미 설치됨, 설치 건너뜀"
fi

# -------------------------------
# Minikube 설치
# -------------------------------
if ! command -v minikube &> /dev/null; then
    echo "🔹 Minikube 설치"
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube
else
    echo "✅ Minikube 이미 설치됨, 설치 건너뜀"
fi

# -------------------------------
# Minikube 클러스터 시작
# -------------------------------
echo "🔹 Minikube 클러스터 시작 (Podman 드라이버)"
minikube start --driver=podman || echo "⚠️ Minikube 시작 실패. 이미 클러스터가 실행 중일 수 있음"

# -------------------------------
# Kubernetes 상태 확인
# -------------------------------
echo "🔹 Kubernetes 노드 상태 확인"
kubectl get nodes

echo "🔹 전체 Pod 확인"
kubectl get pods -A


# chmod +x install_k8s_with_podman.sh
# ./install_k8s_with_podman.sh