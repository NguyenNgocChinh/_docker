#!/bin/sh
set -e

# Remove vendor and reinstall packages
echo "$(tput setaf 2)";
if [ ! -d "vendor" ]; then
  echo "Installing vendor..."
  rm -rf composer.lock
  composer install
fi

if [ ! -d "node_modules" ]; then
  echo "Installing node_modules..."
  rm -rf package-lock.json
  npm install
fi
echo "$(tput setaf 7)";

# Enable Laravel queue workers
if [ "${ENABLE_WORKER:-0}" = "0" ]; then
  rm -f /etc/supervisor.d/worker.conf.default
fi

# Enable Laravel horizon
if [ "${ENABLE_HORIZON:-0}" = "0" ]; then
  rm -f /etc/supervisor.d/horizon.conf.default
fi

exec "$@"
