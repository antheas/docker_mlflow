# Copy over ssh keys from cert directory, if they exist
if [ -f /cert/ssh_host_ed25519_key ]; then
  echo "Copying ssh_host_ed25519_key..."
  cp /cert/ssh_host_ed25519_key /etc/ssh/ssh_host_ed25519_key
  cp /cert/ssh_host_ed25519_key.pub /etc/ssh/ssh_host_ed25519_key.pub
  chmod 600 /etc/ssh/ssh_host_ed25519_key || true
else
  echo "Saving new ssh_host_ed25519_key..."
  cp /etc/ssh/ssh_host_ed25519_key /cert/ssh_host_ed25519_key
  cp /etc/ssh/ssh_host_ed25519_key.pub /cert/ssh_host_ed25519_key.pub
  chown $CUID:$CGID /cert/ssh_host_ed25519_key /cert/ssh_host_ed25519_key.pub || true
fi

if [ -f /cert/ssh_host_rsa_key ]; then
  echo "Copying ssh_host_rsa_key..."
  cp /cert/ssh_host_rsa_key /etc/ssh/ssh_host_rsa_key
  cp /cert/ssh_host_rsa_key.pub /etc/ssh/ssh_host_rsa_key.pub
  chmod 600 /etc/ssh/ssh_host_rsa_key || true
else
  echo "Saving new ssh_host_rsa_key..."
  cp /etc/ssh/ssh_host_rsa_key /cert/ssh_host_rsa_key
  cp /etc/ssh/ssh_host_rsa_key.pub /cert/ssh_host_rsa_key.pub
  chown $CUID:$CGID /cert/ssh_host_rsa_key /cert/ssh_host_rsa_key.pub || true
fi