if [ ! -f "/cert/nginx.key" ]; then
  mkdir -p /cert
  openssl req -x509 -nodes \
    -days 3650 \
    -newkey rsa:2048 \
    -subj "/CN=*" -addext "subjectAltName = DNS:*,IP:127.0.0.1" \
    -keyout /cert/nginx.key -out /cert/nginx.crt
  chown -R $CUID:$CGID /cert
fi