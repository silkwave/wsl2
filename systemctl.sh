# loginctl 명령어를 이용한 사용자 세션 관리
# 'silkwave' 사용자에 대해 링거(linger) 모드 활성화 (사용자 로그아웃 후에도 백그라운드 서비스 실행 유지)
loginctl enable-linger silkwave
# 시스템에 로그인된 사용자 목록 표시
loginctl list-users
# 현재 활성화된 세션 목록 표시
loginctl list-sessions
# 현재 사용자 정보 상세 표시
loginctl show-user

# systemd-analyze 명령어를 이용한 시스템 부팅 성능 분석
# 부팅 시간 분석 요약
systemd-analyze
# 부팅 과정을 SVG 형식의 플롯으로 생성하여 HTML 파일로 저장
systemd-analyze plot > plot.html
# 부팅 시 핵심 서비스들의 의존성 체인 분석
systemd-analyze critical-chain
# 실패한 systemd 유닛 목록 표시
systemctl --failed
# 시스템 유닛들의 의존성 목록 표시
systemctl list-dependencies
# podman 유닛의 의존성 목록 표시
systemctl list-dependencies podman
journalctl

명령어 	설명
# journalctl 	부팅 로그를 포함하여 전체적인 시스템 로그 확인
# journalctl -k 	현재 부트에서 커널 메시지를 출력
# journalctl -f 	지속적으로 로그를 출력 (tail -f와 유사)
# journalctl -u --unit=UNIT 	특정 Unit (서비스)에 대한 메시지를 출력
# journalctl -b 	마지막 부팅 이후의 시스템 로그를 출력
# journalctl --since=today 	오늘 날짜의 로그만 출력
# journalctl --since=2019-12-01 --until=2019-12-06 	특정 기간(시작일/종료일)의 로그 출력
# journalctl -p err 	특정 우선순위(priority)에 따른 로그 조회 (debug, info, err 등)

# systemd-analyze 명령어를 이용한 추가 분석
systemd-analyze        # 부팅 시간 분석 요약
systemd-analyze blame  # 개별 유닛들이 부팅에 소요한 시간 목록 표시
systemd-analyze critical-chain # 부팅 시 핵심 서비스들의 의존성 체인 분석

=================================

=================================

# 사용자(user) 세션에서 Podman 소켓 서비스 상태 확인
systemctl --user status podman.socket
# 사용자(user) 세션에서 Podman 소켓 서비스 시작
systemctl --user start podman.socket
# Podman 소켓 파일 경로 확인
ls -l /run/user/$(id -u)/podman/podman.sock
# DOCKER_HOST 환경 변수 값 출력
echo $DOCKER_HOST

# 사용자(user) 세션에서 Podman 서비스 유닛 로그 확인
journalctl --user-unit podman.service
# 사용자(user) 세션에서 Podman 서비스 유닛 로그 확인 (축약형)
journalctl --user -u podman.service

# 실패한 모든 시스템 유닛(서비스) 목록을 표시
sudo systemctl --failed