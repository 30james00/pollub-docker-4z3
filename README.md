# LABORATORIUM PROGRAMOWANIA W CHMURACH OBLICZENIOWYCH
## Wykorzystanie magazynów przechowywania danych w środowisku Docker

### 2.
Zbudować obraz i nazwać go lab4docker  
`docker build --tag local/lab4docker .`

### 3.
1. W systemie macierzystym konfiguruje serwer NFS zgodnie z instrukcją  
`https://www.tecmint.com/install-nfs-server-on-ubuntu/`  
Poprawki zgodnie z:
`https://stackoverflow.com/questions/56646627/docker-nfs-volume-mysql-how-to-fix-failed-to-copy-file-info`   
2. Tworzę wolumen NFS  
`docker volume create --driver local --opt type=nfs --opt o=nfsvers=4,addr=192.168.1.109,rw --opt device=:/remotevol RemoteVol`

### 4.
1. Uruchamiam kontener alpine4 zgodnie z instrukcją  
`docker run --name alpine4 --mount source=RemoteVol,target=/logi local/lab4docker`
2. Uruchomienie kontenera z ograniczoną pamięcią RAM  
`docker run --name alpine4 --mount source=RemoteVol,target=/logi -m 100k local/lab4docker`

### 5.
a. Sprawdzenie dokonane za pomocą polecenia  
`docker inspect alpine4 | jq .[].Mounts`  
Ponadto można sprawdzić obecność pliku na maszynie macierzystej  
```json
[
  {
    "Type": "volume",
    "Name": "RemoteVol",
    "Source": "/var/lib/docker/volumes/RemoteVol/_data",
    "Destination": "/logi",
    "Driver": "local",
    "Mode": "z",
    "RW": true,
    "Propagation": ""
  }
]
```
b. Sprawdzenie użycia pamięci RAM  
  Uruchomiam w jednej konsoli  
  `docker stats`  
  Uruchomiam w drugiej kontenera za pomocą polecenia (dlatego skrypt włączam za pomocą CMD, a nie ENTRYPOINT)  
  `docker run --rm -it -m 512m --name alpine4 --mount source=test,target=/logi local/lab4docker sleep 10`
```
CONTAINER ID   NAME      CPU %     MEM USAGE / LIMIT   MEM %     NET I/O       BLOCK I/O   PIDS
d2c34bca39e7   alpine4   0.00%     320KiB / 512MiB     0.06%     4.82kB / 0B   0B / 0B     1
```


### 6.
Uruchamiam narzędzie cAdvisor z domyślnymi ustawieniami
```
VERSION=v0.36.0 # use the latest release version from https://github.com/google/cadvisor/releases
sudo docker run \
  --volume=/:/rootfs:ro \
  --volume=/var/run:/var/run:ro \
  --volume=/sys:/sys:ro \
  --volume=/var/lib/docker/:/var/lib/docker:ro \
  --volume=/dev/disk/:/dev/disk:ro \
  --publish=8080:8080 \
  --detach=true \
  --name=cadvisor \
  --privileged \
  --device=/dev/kmsg \
  gcr.io/cadvisor/cadvisor:$VERSION
```