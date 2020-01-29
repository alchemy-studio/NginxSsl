# 基于nginx的ssl测试服务容器

## 部署结构

架构图：

![](https://raw.githubusercontent.com/alchemy-studio/nginx-ssl/master/FF91A024-2B1D-4F3A-AA29-449C18E16082.png)

## 下载image

```bash
$ docker pull alchemystudio/nginx-ssl
```

## 手工启动容器

```bash
$ docker run -it -p 443:443 alchemystudio/nginx-ssl sh
```

进入容器shell后启动`nginx`：

```bash
root# nginx
```

在host宿主访问服务：

```bash
$ curl -k -v https://localhost
```

```bash
$ curl -k -v --resolve foo.io:443:127.0.0.1 https://foo.io
```

```bash
$ curl -k -v --resolve bar.io:443:127.0.0.1 https://bar.io
```

## 自动启动容器和服务

```bash
$ docker-compose pull
```

```bash
$ docker-compose up
```

## 用到本容器的文章

* [使用wireshark对https通信进行数据捕获（上）](http://weinan.io/2020/01/24/ssl.html)
* [使用wireshark对https通信进行数据捕获（下）](http://weinan.io/2020/01/28/ssl.html)
* [用nginx架设tls/sni服务（一）](http://weinan.io/2020/01/10/nginx.html)
* [用nginx架设tls/sni服务（二）](http://weinan.io/2020/01/14/nginx.html)
* [用nginx架设tls/sni服务（三）](http://weinan.io/2020/01/29/ssl.html)

