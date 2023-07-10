# Build stage
FROM node:alpine as boro
USER root
WORKDIR /app
COPY . .
RUN npm install && npm run build

# Production stage
USER root
FROM nginx:alpine
COPY nginx/nginx.conf /etc/nginx
WORKDIR /usr/share/nginx/html
RUN rm -rf ./*
COPY --from=boro /app/build .

# Change ownership recursively
RUN chmod -R 777 /usr/share/nginx && \
    chmod -R 777 /var/cache/nginx && \
    chmod -R 777 /var/log/nginx && \
    chmod -R 777 /run/nginx.pid && \
    chmod -R 777 /etc/nginx && \
    chmod -R 777 /var/run && \
    chmod -R 777 /var/log/nginx /var/cache/nginx/ && \ 
    chmod -R 777 /etc/nginx/* && \

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
