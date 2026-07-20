FROM nginx:alpine

LABEL maintainer="Université Polytechnique de Gitega"

LABEL version="1.0.0"

COPY app/ /usr/share/nginx/html/

EXPOSE 80

HEALTHCHECK \
--interval=30s \
--timeout=5s \
CMD wget --quiet --tries=1 --spider http://localhost || exit 1
