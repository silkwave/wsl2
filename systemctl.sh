loginctl enable-linger silkwave
loginctl list-users
loginctl list-sessions
loginctl show-user

systemd-analyze
systemctl-analyze plot > plot.html
systemd-analyze critical-chain
systemctl --failed
systemctl list-dependencies
systemctl list-dependencies podman
journalctl

명령어 	설명
# journalctl 	부팅 로그를 포함하여 전체적인 시스템 로그 확인
# journalctl -k 	현재 부트에서 kernel 메시지를 출력
# journalctl -f 	지속적으로 로그를 출력
# journalct -u --unit=UNIT 	특정 Unit에 대한 메시지를 출력
# journalctl -b 	마지막 부팅 이후의 시스템 로그를 출력
# journalctl --sine=today 	오늘 로그만 출력
# journalctl --since=2019-12-01 --until=2019-12-06 	기간별(시작일/종료일) 로그 출력
# journalctl -p err 	특정 속성에 따른 조회 (debug, info, err 등)

systemd-analyze
systemd-analyze blame
systemd-analyze critical-chain

=================================

systemctl --user status podman.socket
systemctl --user start podman.socket
ls -l /run/user/$(id -u)/podman/podman.sock
echo $DOCKER_HOST

journalctl --user-unit podman.service
journalctl --user -u podman.service

sudo systemctl --failed