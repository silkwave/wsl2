#!/bin/bash
set -e

# -------------------------------
# Constants
# -------------------------------
KUBECTL_VERSION_URL="https://dl.k8s.io/release/stable.txt"
MINIKUBE_BINARY_URL="https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64"
NGINX_IMAGE="docker.io/library/nginx:latest"
K8S_VERSION="v1.24.17"
LOG_PREFIX="💾 [WSL2 + Podman + Minikube + Nginx]"
LOG_FILE="$HOME/wsl2_minikube_nginx.log"

# -------------------------------
# Colors
# -------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# -------------------------------
# Logging functions
# -------------------------------
log_info() { echo -e "${GREEN}${LOG_PREFIX} $1${NC}"; echo "[INFO] $(date '+%F %T') $1" >> "$LOG_FILE"; }
log_warning() { echo -e "${YELLOW}${LOG_PREFIX} $1${NC}"; echo "[WARN] $(date '+%F %T') $1" >> "$LOG_FILE"; }
log_error() { echo -e "${RED}${LOG_PREFIX} $1${NC}" >&2; echo "[ERROR] $(date '+%F %T') $1" >> "$LOG_FILE"; exit 1; }

# -------------------------------
# Check systemd
# -------------------------------
check_systemd() {
  log_info "Checking systemd..."
  if ! pidof systemd >/dev/null 2>&1; then
    log_error "Systemd is not enabled. Add [boot] systemd=true to /etc/wsl.conf and restart WSL."
  fi
}

# -------------------------------
# Update packages
# -------------------------------
update_packages() {
  log_info "Updating packages..."
  sudo apt update -y && sudo apt upgrade -y
}

# -------------------------------
# Configure Podman
# -------------------------------
configure_podman() {
  log_info "Configuring Podman..."
  sudo mkdir -p /etc/containers
  if [ ! -f /etc/containers/containers.conf ]; then
    echo -e "[engine]\ncgroup_manager = \"cgroupfs\"\nevents_logger = \"file\"" | sudo tee /etc/containers/containers.conf
  else
    sudo sed -i 's/cgroup_manager = .*/cgroup_manager = "cgroupfs"/' /etc/containers/containers.conf
    sudo sed -i 's/events_logger = .*/events_logger = "file"/' /etc/containers/containers.conf
  fi

  if ! command -v podman &>/dev/null; then
    log_info "Installing Podman..."
    sudo apt install -y podman
  else
    log_info "Podman already installed ($(podman --version))"
  fi

  systemctl --user enable podman.socket --now || log_warning "Podman socket already enabled."
  export DOCKER_HOST=unix:///run/user/$UID/podman/podman.sock
  if ! grep -qxF "export DOCKER_HOST=unix:///run/user/$UID/podman/podman.sock" ~/.bashrc; then
    echo "export DOCKER_HOST=unix:///run/user/$UID/podman/podman.sock" >> ~/.bashrc
  fi
}

# -------------------------------
# Install kubectl
# -------------------------------
install_kubectl() {
  if ! command -v kubectl &>/dev/null; then
    log_info "Installing kubectl..."
    KUBECTL_VERSION=$(curl -sL "$KUBECTL_VERSION_URL" || echo "v1.33.1")
    curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
    chmod +x kubectl
    sudo mv kubectl /usr/local/bin/kubectl
  else
    log_info "kubectl already installed ($(kubectl version --client | head -n1))"
  fi
}

# -------------------------------
# Install Minikube
# -------------------------------
install_minikube() {
  if ! command -v minikube &>/dev/null; then
    log_info "Installing Minikube..."
    curl -LO "$MINIKUBE_BINARY_URL"
    sudo install minikube-linux-amd64 /usr/local/bin/minikube
    rm -f minikube-linux-amd64
  else
    log_info "Minikube already installed ($(minikube version | head -n1))"
  fi
}

# -------------------------------
# Reset Minikube
# -------------------------------
reset_minikube() {
  if minikube status &>/dev/null; then
    log_info "Deleting existing Minikube cluster..."
    minikube delete || true
    minikube cache delete || true
  else
    log_info "No existing Minikube cluster found."
  fi
}

# -------------------------------
# Start Minikube
# -------------------------------
start_minikube() {
  log_info "Starting Minikube..."
  minikube start --driver=podman --kubernetes-version="$K8S_VERSION" --container-runtime=cri-o --cni=bridge || log_error "Failed to start Minikube."
  eval $(minikube -p minikube podman-env)
}

# -------------------------------
# Enable Minikube registry
# -------------------------------
enable_registry() {
  log_info "Enabling Minikube registry addon..."
  minikube addons enable registry || log_warning "Registry addon already enabled or failed."
}

# -------------------------------
# Pull Nginx image
# -------------------------------
pull_nginx_image() {
  log_info "Pulling Nginx image inside Minikube..."
  minikube ssh -- sudo podman pull "$NGINX_IMAGE" || log_warning "Failed to pull Nginx image."
}

# -------------------------------
# Deploy Nginx
# -------------------------------
deploy_nginx() {
  log_info "Deploying Nginx..."
  kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
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
  selector:
    app: nginx
  ports:
  - port: 80
    targetPort: 80
    nodePort: 30080
EOF
}

# -------------------------------
# Restart Nginx
# -------------------------------
restart_nginx() {
  log_info "Restarting Nginx pods..."
  kubectl delete pod -l app=nginx || true
  kubectl rollout status deployment/nginx-deployment --timeout=5m || log_warning "Rollout may be delayed."
}

# -------------------------------
# Health check
# -------------------------------
health_check() {
  log_info "Performing Nginx health check..."
  POD_NAME=$(kubectl get pods -l app=nginx -o jsonpath='{.items[0].metadata.name}')
  if [ -n "$POD_NAME" ]; then
    if kubectl exec "$POD_NAME" -- curl -sSf http://localhost >/dev/null; then
      log_info "Nginx is running."
    else
      log_warning "Nginx container not responding."
    fi
  else
    log_warning "No Nginx pod found."
  fi
}

# -------------------------------
# Port-forward Nginx for localhost access
# -------------------------------
port_forward_nginx() {
  log_info "Starting kubectl port-forward to localhost:30080..."
  kubectl port-forward svc/nginx-service 30080:80 >/dev/null 2>&1 &
  sleep 2
}

# -------------------------------
# Main
# -------------------------------
main() {
  log_info "Starting deployment..."
  check_systemd
  update_packages
  configure_podman
  install_kubectl
  install_minikube
  reset_minikube
  start_minikube
  enable_registry
  pull_nginx_image
  deploy_nginx
  restart_nginx
  health_check
  port_forward_nginx

  log_info "Deployment complete!"
  echo "Access Nginx at: http://localhost:30080"
  echo "Check pods: kubectl get pods"
  echo "Check services: kubectl get svc"
}

main
