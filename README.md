# 基于nginx的ssl测试服务容器

## 下载image

```bash
$ docker pull alchemy-studio/NginxSsl
```

## 手工启动容器

```bash
$ docker run -it -p 443:443 alchemy-studio/NginxSsl sh
```

进入容器shell后启动`nginx`：

```bash
root# nginx
```

在host宿主访问服务：

```bash
curl -k -v https://localhost
```

## 自动启动容器和服务

```bash
$ docker-compose up
```

## 用到本容器的文章

* [用nginx架设tls/sni服务（一）](http://weinan.io/2020/01/10/nginx.html)
* [用nginx架设tls/sni服务（二）](http://weinan.io/2020/01/14/nginx.html)
* [使用wireshark对https通信进行数据捕获（上）](http://weinan.io/2020/01/24/ssl.html)
