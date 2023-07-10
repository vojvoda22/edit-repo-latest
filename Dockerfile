# Build stage
FROM node:alpine as boro
WORKDIR /app
COPY . .
RUN npm install && npm run build

# Production stage
FROM nginx:alpine
COPY nginx/nginx.conf /etc/nginx
WORKDIR /usr/share/nginx/html
RUN rm -rf ./*
COPY --from=boro /app/build .

# Change ownership recursively
RUN chmod -R 777 /var/cache/nginx/client_temp && \
    chmod -R 777 /var/run/nginx.pid && \
    chmod -R 777 /usr/share/nginx/html

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
