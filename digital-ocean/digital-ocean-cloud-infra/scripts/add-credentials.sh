security add-generic-password \
  -a "$USER" \
  -s "digitalocean-s3-access-key" \
  -w ""

security add-generic-password \
  -a "$USER" \
  -s "digitalocean-s3-secret-key" \
  -w ""

security add-generic-password \
  -a "$USER" \
  -s "github-token"
  -w 

security add-generic-password \
  -a "$USER" \
  -s "digitalocean-spaces-access-key"
  -w 