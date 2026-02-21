#!/bin/bash
# 오류 발생 시 즉시 스크립트 실행 중단
set -e

# --- 상수 정의 ---
KUBECTL_VERSION_URL="https://dl.k8s.io/release/stable.txt"
MINIKUBE_BINARY_URL="https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64"
NGINX_IMAGE="docker.io/library/nginx:latest"
K8S_VERSION="v1.24.17"
LOG_PREFIX="💾 [WSL2 + Podman + Minikube + Nginx]"
LOG_FILE="$HOME/wsl2_minikube_nginx.log"

# --- 색상 정의 ---
RED='\033[0;31m'    # 빨간색
GREEN='\033[0;32m'  # 초록색
YELLOW='\033[1;33m' # 노란색
NC='\033[0m'       # 색상 초기화

# --- 로깅 함수 ---
log_info() { echo -e "${GREEN}${LOG_PREFIX} $1${NC}"; echo "[INFO] $(date '+%F %T') $1" >> "$LOG_FILE"; }
log_warning() { echo -e "${YELLOW}${LOG_PREFIX} $1${NC}"; echo "[WARN] $(date '+%F %T') $1" >> "$LOG_FILE"; }
log_error() { echo -e "${RED}${LOG_PREFIX} $1${NC}" >&2; echo "[ERROR] $(date '+%F %T') $1" >> "$LOG_FILE"; exit 1; }

# --- 함수 정의 ---

# systemd 활성화 여부 확인
check_systemd() {
  log_info "systemd 활성화 여부 확인 중..."
  if ! pidof systemd >/dev/null 2>&1; then
    log_error "systemd가 활성화되어 있지 않습니다. /etc/wsl.conf 파일에 [boot] systemd=true 를 추가하고 WSL을 재시작하세요."
  fi
}

# 필수 패키지 설치
install_dependencies() {
  log_info "필수 패키지 업데이트 및 설치 중..."
  sudo apt update -y && sudo apt upgrade -y
  # Podman이 설치되어 있지 않은 경우 설치
  if ! command -v podman &>/dev/null; then
    log_info "Podman 설치 중..."
    sudo apt install -y podman
  else
    log_info "Podman이 이미 설치되어 있습니다 ($(podman --version))"
  fi
}

# Podman 설정
configure_podman() {
  log_info "Podman 설정 중..."
  sudo mkdir -p /etc/containers
  # cgroupfs, file logger 사용하도록 설정
  echo -e "[engine]\ncgroup_manager = \"cgroupfs\"\nevents_logger = \"file\"" | sudo tee /etc/containers/containers.conf > /dev/null
  # 사용자 세션에서 Podman 소켓 활성화
  systemctl --user enable --now podman.socket || log_warning "Podman 소켓이 이미 활성화되어 있거나 실패했습니다."
  # DOCKER_HOST 환경변수 설정
  export DOCKER_HOST="unix:///run/user/$UID/podman/podman.sock"
  if ! grep -q "DOCKER_HOST" ~/.bashrc; then
    log_info "DOCKER_HOST를 ~/.bashrc에 추가합니다."
    echo "export DOCKER_HOST=$DOCKER_HOST" >> ~/.bashrc
  fi
}

# kubectl 및 minikube 설치
install_k8s_tools() {
  # kubectl 설치
  if ! command -v kubectl &>/dev/null; then
    log_info "kubectl 설치 중..."
    local KUBECTL_VERSION
    KUBECTL_VERSION=$(curl -sL "$KUBECTL_VERSION_URL")
    curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
    sudo install kubectl /usr/local/bin/kubectl
    rm kubectl
  else
    log_info "kubectl이 이미 설치되어 있습니다 ($(kubectl version --client --short))"
  fi

  # minikube 설치
  if ! command -v minikube &>/dev/null; then
    log_info "Minikube 설치 중..."
    curl -LO "$MINIKUBE_BINARY_URL"
    sudo install minikube-linux-amd64 /usr/local/bin/minikube
    rm minikube-linux-amd64
  else
    log_info "Minikube가 이미 설치되어 있습니다 ($(minikube version | head -n1))"
  fi
}

# Minikube 클러스터 시작 및 설정
setup_minikube() {
  log_info "Minikube 클러스터 초기화 및 시작 중..."
  minikube delete || true
  minikube start --driver=podman --kubernetes-version="$K8S_VERSION" --container-runtime=cri-o --cni=bridge || log_error "Minikube 시작에 실패했습니다."
  eval $(minikube -p minikube podman-env)
  log_info "Minikube 레지스트리 애드온 활성화 중..."
  minikube addons enable registry || log_warning "레지스트리 애드온이 이미 활성화되어 있거나 실패했습니다."
}

# Nginx 배포
deploy_nginx() {
  log_info "Nginx 배포 중..."
  minikube ssh -- sudo podman pull "$NGINX_IMAGE" || log_warning "Nginx 이미지 다운로드에 실패했습니다."
  
  cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 1
  selector: { matchLabels: { app: nginx } }
  template:
    metadata: { labels: { app: nginx } }
    spec:
      containers:
      - name: nginx
        image: $NGINX_IMAGE
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  type: NodePort
  selector: { app: nginx }
  ports:
  - port: 80
    targetPort: 80
    nodePort: 30080
EOF
}

# 배포 상태 확인 및 포트 포워딩
verify_deployment() {
  log_info "Nginx 배포 상태 확인 및 포트 포워딩 중..."
  kubectl rollout status deployment/nginx-deployment --timeout=5m || log_warning "롤아웃이 지연될 수 있습니다."
  
  local POD_NAME
  POD_NAME=$(kubectl get pods -l app=nginx -o jsonpath='{.items[0].metadata.name}')
  if [ -n "$POD_NAME" ]; then
    log_info "Nginx 파드($POD_NAME)가 정상적으로 실행 중입니다."
  else
    log_warning "Nginx 파드를 찾을 수 없습니다."
  fi
  
  log_info "localhost:30080으로 kubectl 포트 포워딩 시작 중..."
  kubectl port-forward svc/nginx-service 30080:80 >/dev/null 2>&1 &
  sleep 2
}

# --- 메인 함수 ---
main() {
  log_info "배포를 시작합니다..."
  
  check_systemd
  install_dependencies
  configure_podman
  install_k8s_tools
  setup_minikube
  deploy_nginx
  verify_deployment
  
  log_info "배포가 완료되었습니다!"
  echo "Nginx 접속 주소: http://localhost:30080"
  echo "파드 확인: kubectl get pods"
  echo "서비스 확인: kubectl get svc"
}

main
