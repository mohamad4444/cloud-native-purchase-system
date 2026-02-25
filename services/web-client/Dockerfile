ARG NGINX_VERSION=latest
FROM nginx:${NGINX_VERSION}

# Remove default nginx config
RUN rm /etc/nginx/conf.d/default.conf

# Copy your custom nginx config
COPY nginx.conf /etc/nginx/nginx.conf

# Copy your frontend static files into the default html folder
COPY web/ /usr/share/nginx/html/
