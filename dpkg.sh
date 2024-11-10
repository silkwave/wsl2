sudo dpkg --configure -a
sudo apt-get install -f

dpkg -l
sudo dpkg -I  firefox_75.0+build3-0ubuntu1_amd64.deb   #해당 .deb 파일에 대한 정보 확인
sudo dpkg -i  firefox_75.0+build3-0ubuntu1_amd64.deb   #해당 파일 설치 또는 최신 버전으로 업그레이드
sudo dpkg -C firefox_75.0+build3-0ubuntu1_amd64.deb   #해당 .deb 파일이 설치한 파일의 목록 확인

sudo dpkg -S firefox                         # 해당 패키지에 대한 정보 확인
sudo dpkg -r firefox                         # 해당 패키지 삭제 (삭제시 설정파일들은 남겨둡니다.)
sudo dpkg -P firefox                        # 해당 패키지와 해당 패키지의 설정파일을 모두 삭제

dpkg -l : 설치된 패키지 목록 확인
dpkg -L <패키지명> : 해당 패키지로부터 설치된 모든 파일목록 확인
dpkg -C <.deb 파일> : 해당 .deb 파일이 설치한 파일의 목록 확인
dpkg -s <패키지명> : 해당 패키지에 대한 정보 확인
dpkg -S <파일명> : 해당 파일명 또는 경로가 포함된 패키지들을 검색
dpkg -I(대문자 i) <.deb 파일> : 해당 .deb 파일에 대한 정보 확인
dpkg -P <패키지명> : 패키지에 대한 정보를 보여준다.
sudo dpkg -i <.deb 파일> : 해당 파일 설치 또는 최신 버전으로 업그레이드
sudo dpkg -r <패키지명> : 해당 패키지 삭제 (삭제시 설정파일들은 남겨둡니다.)
sudo dpkg -P <패키지명> : 해당 패키지와 해당 패키지의 설정파일을 모두 삭제
sudo dpkg -x <.deb 파일> <디렉토리> : 파일에 포함되어 있는 파일들을 지정된 디렉토리에 압축 해제 ( *이명령을 실행할 경
##############################################
sudo apt-cache search '\-ko$'
