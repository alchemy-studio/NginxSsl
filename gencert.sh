set -x
mkdir -p /cert
chown nginx /cert
cd /cert

openssl req \
    -new \
    -newkey rsa:4096 \
    -days 365 \
    -nodes \
    -x509 \
    -subj "/C=CN/ST=Beijing/L=Beijing/O=Personal/CN=localhost" \
    -keyout localhost.key \
    -out localhost.crt
chown -R nginx localhost.*


openssl req \
    -new \
    -newkey rsa:4096 \
    -days 365 \
    -nodes \
    -x509 \
    -subj "/C=CN/ST=Beijing/L=Beijing/O=Personal/CN=foo.io" \
    -keyout foo.key \
    -out foo.crt
chown -R nginx foo.*

openssl req \
    -new \
    -newkey rsa:4096 \
    -days 365 \
    -nodes \
    -x509 \
    -subj "/C=CN/ST=Beijing/L=Beijing/O=Personal/CN=bar.io" \
    -keyout bar.key \
    -out bar.crt
chown -R nginx bar.*

echo '127.0.0.1 foo.io bar.io' >> /etc/hosts

cd /etc/nginx/
sed -ie '/http {/r/root/nginx-ssl.conf' nginx.conf
cat /etc/nginx/nginx.conf

mkdir -p /etc/nginx/html/localhost
touch /etc/nginx/html/localhost/index.html
echo "Hello, world!" > /etc/nginx/html/localhost/index.html

mkdir -p /etc/nginx/html/foo
touch /etc/nginx/html/foo/index.html
echo "Foo!" > /etc/nginx/html/foo/index.html

mkdir -p /etc/nginx/html/bar
touch /etc/nginx/html/bar/index.html
echo "Bar!" > /etc/nginx/html/bar/index.html

chown -R nginx /etc/nginx/html/*
