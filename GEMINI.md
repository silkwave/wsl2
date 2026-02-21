# Directory Overview

This directory contains a collection of shell scripts and notes for setting up and managing a development environment on Windows Subsystem for Linux 2 (WSL2). It is a personal knowledge base rather than a software project.

## Key Files

The directory includes scripts for various setup and configuration tasks. Most of these are not meant to be executed as a whole, but rather serve as a reference for commands.

-   **`wsl_install.sh`**: A collection of commands for installing and configuring a WSL2 environment with Ubuntu. It includes package installation, repository configuration, and WSL settings.

-   **`systemctl.sh`**: A reference for `systemd` and `journalctl` commands, useful for managing services and viewing logs.

-   **`dpkg.sh`**: A reference for `dpkg` and `apt-get` commands for managing Debian packages.

-   **`docker-compose..sh`**: Contains a `Dockerfile` snippet and a `docker-compose.yml` for a Jupyter datascience notebook environment.

-   **`fcitx.sh`**: Commands for setting up the Fcitx input method framework for Korean language support.

-   **`fonts-noto-cjk.sh`**: Commands for installing Noto CJK fonts and configuring the system locale for Korean.

-   **`install_k8s_with_podman.sh`**: A complete, executable script to set up a Kubernetes environment with Minikube and Podman.

-   **`jupyternotebook.sh`**: Instructions and snippets for setting up Jupyter Notebook/Lab with Docker or Podman.

-   **`oracle.sh`**: Commands for setting up an Oracle 19c database with Podman.

-   **`podman.sh`**: Instructions for installing and configuring Podman and Podman Compose.

-   **`redis.sh`**: Commands for running a Redis container with Podman and common Redis CLI commands.

-   **`xfce4.sh`**: Commands for installing and configuring the XFCE4 desktop environment.

-   **`zsh.sh`**: Commands for installing and configuring Zsh and Oh My Zsh.

## Usage

The scripts in this directory are intended to be used as a reference. You can copy and paste commands from the files to set up your WSL2 environment. The only script that is meant to be executed directly is `install_k8s_with_podman.sh`.
