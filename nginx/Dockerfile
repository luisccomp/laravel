FROM nginx:1.9-alpine

RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d

RUN mkdir /var/www/html -p && touch /var/www/html/index.php

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
