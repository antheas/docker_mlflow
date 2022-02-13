if [ ! -f "/cert/.htpasswd" ]; then
  mkdir -p /cert
  printf "${HTTP_USER}:$(openssl passwd -crypt ${HTTP_PASS})\n" > /cert/.htpasswd
  chown -R $CUID:$CGID /cert
fi