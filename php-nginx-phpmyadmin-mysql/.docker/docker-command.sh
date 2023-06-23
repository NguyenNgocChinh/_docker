#!/bin/sh
set -e


# Start supervisor
exec supervisord -n -c /etc/supervisord.conf