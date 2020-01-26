* 基于nginx的ssl测试服务容器

```bash
$ docker build .
Sending build context to Docker daemon  69.12kB
Step 1/9 : FROM nginx
 ---> c7460dfcab50
Step 2/9 : RUN apt-get update
 ---> Using cache
 ---> 3cede930a68b
Step 3/9 : RUN apt-get install openssl
 ---> Using cache
 ---> 9652bc7762d2
Step 4/9 : RUN apt-get install -y curl
 ---> Using cache
 ---> c373740f22ff
Step 5/9 : RUN apt-get install -y vim
 ---> Using cache
 ---> 55fe5d5431e5
Step 6/9 : RUN apt-get install -y procps
 ---> Running in 4485945aca86
Reading package lists...
Building dependency tree...
Reading state information...
The following additional packages will be installed:
  libncurses6 libprocps7 psmisc
The following NEW packages will be installed:
  libncurses6 libprocps7 procps psmisc
0 upgraded, 4 newly installed, 0 to remove and 1 not upgraded.
Need to get 549 kB of archives.
After this operation, 1866 kB of additional disk space will be used.
Get:1 http://deb.debian.org/debian buster/main amd64 libncurses6 amd64 6.1+20181013-2+deb10u2 [102 kB]
Get:2 http://deb.debian.org/debian buster/main amd64 libprocps7 amd64 2:3.3.15-2 [61.7 kB]
Get:3 http://deb.debian.org/debian buster/main amd64 procps amd64 2:3.3.15-2 [259 kB]
Get:4 http://deb.debian.org/debian buster/main amd64 psmisc amd64 23.2-1 [126 kB]
debconf: delaying package configuration, since apt-utils is not installed
Fetched 549 kB in 8s (67.0 kB/s)
Selecting previously unselected package libncurses6:amd64.
(Reading database ... 9573 files and directories currently installed.)
Preparing to unpack .../libncurses6_6.1+20181013-2+deb10u2_amd64.deb ...
Unpacking libncurses6:amd64 (6.1+20181013-2+deb10u2) ...
Selecting previously unselected package libprocps7:amd64.
Preparing to unpack .../libprocps7_2%3a3.3.15-2_amd64.deb ...
Unpacking libprocps7:amd64 (2:3.3.15-2) ...
Selecting previously unselected package procps.
Preparing to unpack .../procps_2%3a3.3.15-2_amd64.deb ...
Unpacking procps (2:3.3.15-2) ...
Selecting previously unselected package psmisc.
Preparing to unpack .../psmisc_23.2-1_amd64.deb ...
Unpacking psmisc (23.2-1) ...
Setting up psmisc (23.2-1) ...
Setting up libprocps7:amd64 (2:3.3.15-2) ...
Setting up libncurses6:amd64 (6.1+20181013-2+deb10u2) ...
Setting up procps (2:3.3.15-2) ...
update-alternatives: using /usr/bin/w.procps to provide /usr/bin/w (w) in auto mode
update-alternatives: warning: skip creation of /usr/share/man/man1/w.1.gz because associated file /usr/share/man/man1/w.procps.1.gz (of link group w) doesn't exist
Processing triggers for libc-bin (2.28-10) ...
Removing intermediate container 4485945aca86
 ---> f942555e6c03
Step 7/9 : COPY gencert.sh /root/
 ---> 616d28f85386
Step 8/9 : COPY nginx-ssl.conf /root/
 ---> 1e4c04a8c71a
Step 9/9 : RUN sh /root/gencert.sh
 ---> Running in 6cb828c102f7
+ mkdir -p /cert
+ chown nginx /cert
+ cd /cert
+ openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj /C=CN/ST=Beijing/L=Beijing/O=Personal/CN=localhost -keyout localhost.key -out localhost.crt
Generating a RSA private key
.....................................................................................................................................................................................................................................................++++
..........................................................................++++
writing new private key to 'localhost.key'
-----
+ chown -R nginx localhost.crt localhost.key
+ cd /etc/nginx/
+ sed -ie /http {/r/root/nginx-ssl.conf nginx.conf
+ cat /etc/nginx/nginx.conf
+ mkdir -p /etc/nginx/html/

user  nginx;
worker_processes  1;

error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;


events {
    worker_connections  1024;
}


http {
    server {
      listen 443 ssl;
      server_name localhost;
      ssl_certificate /cert/localhost.crt;
      ssl_certificate_key /cert/localhost.key;
    }
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    keepalive_timeout  65;

    #gzip  on;

    include /etc/nginx/conf.d/*.conf;
}
+ chown nginx /etc/nginx/html/
+ touch /etc/nginx/html/index.html
+ echo Hello, world!
+ chown nginx /etc/nginx/html/index.html
Removing intermediate container 6cb828c102f7
 ---> 7329f2a606c2
Successfully built 7329f2a606c2
$ docker run -it 7329f2a606c2 sh
# pwd
/
# nginx
# ps -ef
UID        PID  PPID  C STIME TTY          TIME CMD
root         1     0  0 03:02 pts/0    00:00:00 sh
root         7     1  0 03:02 ?        00:00:00 nginx: master process nginx
nginx        8     7  0 03:02 ?        00:00:00 nginx: worker process
root         9     1  0 03:02 pts/0    00:00:00 ps -ef
# curl -v -k https://localhost
* Expire in 0 ms for 6 (transfer 0x55564e8adf50)
* Expire in 1 ms for 1 (transfer 0x55564e8adf50)
* Expire in 0 ms for 1 (transfer 0x55564e8adf50)
* Expire in 1 ms for 1 (transfer 0x55564e8adf50)
* Expire in 0 ms for 1 (transfer 0x55564e8adf50)
* Expire in 0 ms for 1 (transfer 0x55564e8adf50)
* Expire in 1 ms for 1 (transfer 0x55564e8adf50)
* Expire in 0 ms for 1 (transfer 0x55564e8adf50)
* Expire in 0 ms for 1 (transfer 0x55564e8adf50)
* Expire in 1 ms for 1 (transfer 0x55564e8adf50)
* Expire in 0 ms for 1 (transfer 0x55564e8adf50)
* Expire in 0 ms for 1 (transfer 0x55564e8adf50)
* Expire in 1 ms for 1 (transfer 0x55564e8adf50)
* Expire in 0 ms for 1 (transfer 0x55564e8adf50)
* Expire in 0 ms for 1 (transfer 0x55564e8adf50)
* Expire in 1 ms for 1 (transfer 0x55564e8adf50)
* Expire in 0 ms for 1 (transfer 0x55564e8adf50)
* Expire in 0 ms for 1 (transfer 0x55564e8adf50)
* Expire in 1 ms for 1 (transfer 0x55564e8adf50)
* Expire in 0 ms for 1 (transfer 0x55564e8adf50)
* Expire in 0 ms for 1 (transfer 0x55564e8adf50)
* Expire in 1 ms for 1 (transfer 0x55564e8adf50)
* Expire in 0 ms for 1 (transfer 0x55564e8adf50)
* Expire in 0 ms for 1 (transfer 0x55564e8adf50)
* Expire in 1 ms for 1 (transfer 0x55564e8adf50)
* Expire in 0 ms for 1 (transfer 0x55564e8adf50)
* Expire in 0 ms for 1 (transfer 0x55564e8adf50)
* Expire in 1 ms for 1 (transfer 0x55564e8adf50)
* Expire in 0 ms for 1 (transfer 0x55564e8adf50)
* Expire in 0 ms for 1 (transfer 0x55564e8adf50)
* Expire in 1 ms for 1 (transfer 0x55564e8adf50)
* Expire in 0 ms for 1 (transfer 0x55564e8adf50)
* Expire in 0 ms for 1 (transfer 0x55564e8adf50)
* Expire in 1 ms for 1 (transfer 0x55564e8adf50)
* Expire in 0 ms for 1 (transfer 0x55564e8adf50)
* Expire in 0 ms for 1 (transfer 0x55564e8adf50)
* Expire in 1 ms for 1 (transfer 0x55564e8adf50)
* Expire in 0 ms for 1 (transfer 0x55564e8adf50)
* Expire in 0 ms for 1 (transfer 0x55564e8adf50)
* Expire in 1 ms for 1 (transfer 0x55564e8adf50)
* Expire in 0 ms for 1 (transfer 0x55564e8adf50)
* Expire in 0 ms for 1 (transfer 0x55564e8adf50)
* Expire in 1 ms for 1 (transfer 0x55564e8adf50)
* Expire in 0 ms for 1 (transfer 0x55564e8adf50)
* Expire in 0 ms for 1 (transfer 0x55564e8adf50)
* Expire in 1 ms for 1 (transfer 0x55564e8adf50)
* Expire in 0 ms for 1 (transfer 0x55564e8adf50)
* Expire in 0 ms for 1 (transfer 0x55564e8adf50)
* Expire in 0 ms for 1 (transfer 0x55564e8adf50)
*   Trying 127.0.0.1...
* TCP_NODELAY set
* Expire in 150000 ms for 3 (transfer 0x55564e8adf50)
* Expire in 200 ms for 4 (transfer 0x55564e8adf50)
* Connected to localhost (127.0.0.1) port 443 (#0)
* ALPN, offering h2
* ALPN, offering http/1.1
* successfully set certificate verify locations:
*   CAfile: none
  CApath: /etc/ssl/certs
* TLSv1.3 (OUT), TLS handshake, Client hello (1):
* TLSv1.3 (IN), TLS handshake, Server hello (2):
* TLSv1.2 (IN), TLS handshake, Certificate (11):
* TLSv1.2 (IN), TLS handshake, Server key exchange (12):
* TLSv1.2 (IN), TLS handshake, Server finished (14):
* TLSv1.2 (OUT), TLS handshake, Client key exchange (16):
* TLSv1.2 (OUT), TLS change cipher, Change cipher spec (1):
* TLSv1.2 (OUT), TLS handshake, Finished (20):
* TLSv1.2 (IN), TLS handshake, Finished (20):
* SSL connection using TLSv1.2 / ECDHE-RSA-AES256-GCM-SHA384
* ALPN, server accepted to use http/1.1
* Server certificate:
*  subject: C=CN; ST=Beijing; L=Beijing; O=Personal; CN=localhost
*  start date: Jan 26 03:02:13 2020 GMT
*  expire date: Jan 25 03:02:13 2021 GMT
*  issuer: C=CN; ST=Beijing; L=Beijing; O=Personal; CN=localhost
*  SSL certificate verify result: self signed certificate (18), continuing anyway.
> GET / HTTP/1.1
> Host: localhost
> User-Agent: curl/7.64.0
> Accept: */*
> 
127.0.0.1 - - [26/Jan/2020:03:02:50 +0000] "GET / HTTP/1.1" 200 14 "-" "curl/7.64.0" "-"
< HTTP/1.1 200 OK
< Server: nginx/1.17.7
< Date: Sun, 26 Jan 2020 03:02:50 GMT
< Content-Type: text/html
< Content-Length: 14
< Last-Modified: Sun, 26 Jan 2020 03:02:13 GMT
< Connection: keep-alive
< ETag: "5e2d0135-e"
< Accept-Ranges: bytes
< 
Hello, world!
* Connection #0 to host localhost left intact
# 
```

## 参考资料

https://superuser.com/questions/226192/avoid-password-prompt-for-keys-and-prompts-for-dn-information

