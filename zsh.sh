# Zsh 설치 및 기본 쉘 변경
# Zsh 패키지 설치
sudo apt install zsh -y
# 현재 사용자의 기본 쉘을 Zsh로 변경
sudo chsh -s /usr/bin/zsh

# Oh My Zsh 설치 스크립트 실행
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# 플러그인 디렉토리로 이동
cd ~/.oh-my-zsh/custom/plugins
# zsh-syntax-highlighting 플러그인 설치 (Git 저장소 클론)
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
# zsh-autosuggestions 플러그인 설치 (Git 저장소 클론)
git clone https://github.com/zsh-users/zsh-autosuggestions

# ~/.zshrc 파일 편집 (Zsh 설정 파일)
vim ~/.zshrc
# Zsh 테마 설정 (예시)
ZSH_THEME="robbyrussell"
# 다른 테마 예시:
ZSH_THEME="agnoster"
ZSH_THEME="bira"
ZSH_THEME="jonathan"
ZSH_THEME="junkfood"
ZSH_THEME="strug"
ZSH_THEME="xiong-chiamiov"


# ~/.zshrc 파일에 플러그인 목록 설정
plugins=(git zsh-syntax-highlighting zsh-autosuggestions)


# 프롬프트 컨텍스트 설정을 위한 함수
prompt_context() {
    # 현재 사용자가 기본 사용자가 아니거나 SSH 클라이언트를 통해 접속한 경우
    if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
      # 프롬프트에 사용자 이름을 노란색으로 표시하는 세그먼트 추가
      prompt_segment black default "%(!.%{%F{yellow}%}.)$USER"
    fi
}

# Oh My Zsh 업데이트
omz update

# Oh My Zsh 제거 스크립트 실행
uninstall_oh_my_zsh
