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
cd /etc/nginx/
sed -ie '/http {/r/root/nginx-ssl.conf' nginx.conf
cat /etc/nginx/nginx.conf
mkdir -p /etc/nginx/html/
chown nginx /etc/nginx/html/
touch /etc/nginx/html/index.html
echo "Hello, world!" > /etc/nginx/html/index.html
chown nginx /etc/nginx/html/index.html
