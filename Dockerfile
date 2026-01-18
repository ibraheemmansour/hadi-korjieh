# Use nginx alpine for a lightweight static file server
FROM nginx:alpine

# Remove default nginx website
RUN rm -rf /usr/share/nginx/html/*

# Copy static files to nginx html directory
COPY index.html /usr/share/nginx/html/
COPY theme1.html /usr/share/nginx/html/
COPY theme2.html /usr/share/nginx/html/
COPY theme3.html /usr/share/nginx/html/
COPY theme4.html /usr/share/nginx/html/
COPY style.css /usr/share/nginx/html/
COPY theme1.css /usr/share/nginx/html/
COPY theme2.css /usr/share/nginx/html/
COPY theme3.css /usr/share/nginx/html/
COPY theme4.css /usr/share/nginx/html/
COPY script.js /usr/share/nginx/html/
COPY img/ /usr/share/nginx/html/img/

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 8080 (Cloud Run requirement)
EXPOSE 8080

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
