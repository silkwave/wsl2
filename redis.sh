# Redis podman 이미지 다운로드
podman pull redis

# Redis 컨테이너 실행 (기본 포트 6379로 실행)
podman run --name redis -p 6379:6379 -d redis

podman exec -it redis bash

 redis-cli -h 127.0.0.1 -p 6379

#Key-Value 저장 및 조회
SET mykey "Hello Redis"  # 데이터 저장
GET mykey                # 데이터 조회
DEL mykey                # 데이터 삭제

#데이터 만료 시간 설정
SET session "user123"
EXPIRE session 60      # 60초 후 데이터 삭제
TTL session           # 남은 TTL 조회

#여러 개의 Key-Value 저장
MSET key1 "value1" key2 "value2"
MGET key1 key2

#데이터 구조별 명령어
SET user "John Doe"
GET user
APPEND user " is a developer"
GET user

#Hash (해시)
HSET user:1001 name "Alice"
HSET user:1001 age 25
HGET user:1001 name
HGETALL user:1001

#List (리스트)
LPUSH tasks "Task 1"
LPUSH tasks "Task 2"
LRANGE tasks 0 -1
LPOP tasks

#Set (집합)
SADD myset "Apple"
SADD myset "Banana"
SADD myset "Orange"
SMEMBERS myset

#Sorted Set (정렬된 집합)
ZADD leaderboard 100 "Player1"
ZADD leaderboard 200 "Player2"
ZRANGE leaderboard 0 -1 WITHSCORES
ZRANK leaderboard "Player1"

#서버 정보 확인
INFO

#모든 키 조회
KEYS *

#데이터 삭제
FLUSHALL  # 전체 데이터 삭제
FLUSHDB   # 현재 DB 데이터만 삭제

#Redis 종료
QUIT
