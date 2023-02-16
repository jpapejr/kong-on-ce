FROM registry.access.redhat.com/ubi8/ubi:8.1
   
COPY kong.yaml /kong/declarative/kong.yaml
COPY kong-enterprise-edition-3.1.1.3.rhel8.amd64.rpm /tmp/kong.rpm

ENV KONG_DATABASE off
ENV KONG_DECLARATIVE_CONFIG /kong/declarative/kong.yaml
ENV KONG_PROXY_ACCESS_LOG /dev/stdout
ENV ONG_ADMIN_ACCESS_LOG /dev/stdout
ENV KONG_PROXY_ERROR_LOG /dev/stderr
ENV KONG_ADMIN_ERROR_LOG /dev/stderr
ENV KONG_ADMIN_LISTEN 0.0.0.0:8001, 0.0.0.0:8444 ssl 
   
RUN set -ex; \
    yum install -y /tmp/kong.rpm \
    && rm /tmp/kong.rpm \
    && chown kong:0 /usr/local/bin/kong \
    && chown -R kong:0 /usr/local/kong \
    && ln -s /usr/local/openresty/bin/resty /usr/local/bin/resty \
    && ln -s /usr/local/openresty/luajit/bin/luajit /usr/local/bin/luajit \
    && ln -s /usr/local/openresty/luajit/bin/luajit /usr/local/bin/lua \
    && ln -s /usr/local/openresty/nginx/sbin/nginx /usr/local/bin/nginx \
    && kong version
   
COPY docker-entrypoint.sh /docker-entrypoint.sh
   
USER kong
   
ENTRYPOINT ["/docker-entrypoint.sh"]
   
EXPOSE 8000 8443 8001 8444 8002 8445 8003 8446 8004 8447
   
STOPSIGNAL SIGQUIT
   
HEALTHCHECK --interval=10s --timeout=10s --retries=10 CMD kong health
   
CMD ["kong", "docker-start"]
 
