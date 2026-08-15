#!/bin/sh

# Replace placeholders with environment variables passed from docker-compose
sed -i "s/{{NODE_NAME}}/${NODE_NAME:-Unknown Node}/g" /usr/share/nginx/html/index.html
sed -i "s/{{NODE_IP}}/${NODE_IP:-Unknown IP}/g" /usr/share/nginx/html/index.html

# Execute the main process (nginx)
exec nginx -g 'daemon off;'
