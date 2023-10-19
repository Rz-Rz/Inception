FROM debian:bookworm

#this install nginx/openssl and remove the apt cache to reduce image size.
RUN apt -y update && apt install -y nginx && apt install openssl -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

#create a dir for the ssl certificate
RUN mkdir /etc/nginx/ssl

#generate certif
RUN openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
       -out /etc/nginx/ssl/kdhrif.crt \
       -keyout /etc/nginx/ssl/kdhrif.key \
       -subj "/C=FR/ST=Paris/L=Paris/O=42 School/OU=kdhrif/CN=kdhrif.42.fr/"

COPY ./conf/nginx.conf /etc/nginx/nginx.conf
COPY ./conf/index.html /usr/share/nginx/html/index.html

RUN mkdir -p /run/nginx

#expose port
EXPOSE 443 80

CMD ["nginx", "-g", "daemon off;"]
