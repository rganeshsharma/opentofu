#!/usr/bin/env bash

set -euo pipefail

export DIGITALOCEAN_TOKEN="$(
    security find-generic-password \
        -a "$USER" \
        -s digitalocean-api-token \
        -w
)"

export SPACES_ACCESS_KEY="$(
    security find-generic-password \
        -a "$USER" \
        -s digitalocean-spaces-access-key \
        -w
)"

export SPACES_SECRET_KEY="$(
    security find-generic-password \
        -a "$USER" \
        -s digitalocean-spaces-secret-key \
        -w
)"

export AWS_ACCESS_KEY_ID="$SPACES_ACCESS_KEY"
export AWS_SECRET_ACCESS_KEY="$SPACES_SECRET_KEY"

echo "DigitalOcean and Spaces credentials loaded."
