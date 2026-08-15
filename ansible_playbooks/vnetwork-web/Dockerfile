FROM nginx:alpine

# Remove default nginx static assets
RUN rm -rf /usr/share/nginx/html/*

# Copy our static assets
COPY index.html /usr/share/nginx/html/
COPY styles.css /usr/share/nginx/html/
COPY entrypoint.sh /

# Set executable permission just in case
RUN chmod +x /entrypoint.sh

# Use custom entrypoint to replace placeholders
ENTRYPOINT ["/entrypoint.sh"]
