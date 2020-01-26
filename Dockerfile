FROM nginx
RUN apt-get update
RUN apt-get install openssl
RUN apt-get install -y curl
RUN apt-get install -y vim
RUN apt-get install -y procps
COPY gencert.sh /root/
COPY nginx-ssl.conf /root/
RUN sh /root/gencert.sh



