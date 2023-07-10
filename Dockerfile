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
RUN chown -R nginx:0 /var/run/nginx /var/log/nginx /var/cache/nginx && \
	chmod -R g=u /var/run/nginx /var/log/nginx /var/cache/nginx
USER nginx:nginx
EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
