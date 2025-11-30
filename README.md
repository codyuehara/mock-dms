# mock-dms
Containerized module that communicates with other instances via FastDDS

## Dependencies
 - https://github.com/chriskohlhoff/asio/releases/tag/asio-1-31-0
 - https://github.com/foonathan/memory/releases/tag/v0.7-4
 - https://github.com/leethomason/tinyxml2/tree/9.0.0
 - FastDDS from source
 - openssl

## Background
This repo is designed to build FastDDS from source inside a Docker container. 

## Build & Run
```
docker build -t fastdds .
docker run -it fastdds:lastest
```

