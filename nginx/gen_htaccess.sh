mkdir -p /etc/apache2
printf "${HTTP_USER}:$(openssl passwd -crypt ${HTTP_PASS})\n" > /etc/apache2/.htpasswd