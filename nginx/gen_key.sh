if [ ! -f "/cert/nginx.key" ]; then
  mkdir -p /cert
  openssl req -x509 -nodes \
    -days 3650 \
    -newkey rsa:2048 \
    -subj "/CN=$CCN" -addext "subjectAltName = $CSAN" \
    -keyout /cert/nginx.key -out /cert/nginx.crt
  chown -R $CUID:$CGID /cert
fi