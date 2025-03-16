# Redis Docker 이미지 다운로드
docker pull redis

# Redis 컨테이너 실행 (기본 포트 6379로 실행)
docker run --name redis -p 6379:6379 -d redis

docker exec -it redis redis-cli
