sudo apt install zsh -y 
sudo chsh -s /usr/bin/zsh

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# 플러그인 디렉토리로 이동
cd ~/.oh-my-zsh/custom/plugins
# zsh-syntax-highlighting 설치
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
# zsh-autosuggestions 설치
git clone https://github.com/zsh-users/zsh-autosuggestions

vim ~/.zshrc
ZSH_THEME="robbyrussell"
ZSH_THEME="agnoster"
ZSH_THEME="bira"
ZSH_THEME="jonathan"
ZSH_THEME="junkfood"
ZSH_THEME="strug"
ZSH_THEME="xiong-chiamiov"


plugins=(git zsh-syntax-highlighting zsh-autosuggestions)


prompt_context() {
    if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then 
      prompt_segment black default "%(!.%{%F{yellow}%}.)$USER"
    fi
}

omz update

uninstall_oh_my_zsh
