ARG NGINX_VERSION=1.21.5
#ARG ENABLE_MODULES="nginx-rtmp-module ngx_http_proxy_connect_module"
FROM nginx:${NGINX_VERSION}-alpine as builder

ARG ENABLED_MODULES

RUN set -ex \
    && if [ "$ENABLED_MODULES" = "" ]; then \
        echo "No additional modules enabled, exiting"; \
        exit 1; \
    fi \
    && mkdir -p /usr/local/src/build/

WORKDIR /usr/local/src/
COPY ./ /usr/local/src/build/

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/' /etc/apk/repositories \
    && apk add --no-cache --virtual .build-deps gcc libc-dev make openssl-dev pcre-dev zlib-dev linux-headers libxslt-dev gd-dev geoip-dev perl-dev libedit-dev mercurial bash alpine-sdk findutils \
    && curl -L "http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz" -o nginx.tar.gz \
    && tar -zxC /usr/local/src -f nginx.tar.gz \
    && mv /usr/local/src/nginx-$NGINX_VERSION /usr/local/src/nginx \
    && cd /usr/local/src/build/ \
    && for module in $ENABLED_MODULES; do \
            echo "Building $module for nginx-$NGINX_VERSION"; \
            if [ -d /usr/local/src/build/$module ]; then \
                echo "Building $module from user-supplied sources"; \
                # check if module sources file is there and not empty
                if [ ! -s /usr/local/src/build/$module/source ]; then \
                    echo "No source file for $module in modules/$module/source, exiting"; \
                    exit 1; \
                fi; \
                # some modules require build dependencies
                if [ -f /usr/local/src/build/$module/build-deps ]; then \
                    echo "Installing $module build dependencies"; \
                    apk update && apk add $(cat /usr/local/src/build/$module/build-deps | xargs); \
                fi; \
                curl -o /usr/local/src/$module.tar.gz -L $(cat /usr/local/src/build/$module/source | xargs); \
                tar -xf /usr/local/src/$module.tar.gz -C /usr/local/src/; \
                mv /usr/local/src/${module}-* /usr/local/src/$module; \
                if [ -f /usr/local/src/build/$module/prebuild ]; then \
                    echo "Running prebuild script for $module"; \
                    chmod +x /usr/local/src/build/$module/prebuild;  \
                    source /usr/local/src/build/$module/prebuild /usr/local/src/$module; \
                    cd /usr/local/src/; \
                fi; \
                BUILT_MODULES="$BUILT_MODULES --add-dynamic-module=/usr/local/src/$module"; \
            else \
                echo "Don't know how to build $module module, exiting"; \
                exit 1; \
            fi; \
        done \
#    && CONFARGS=$(nginx -V 2>&1 | sed -n -e 's/^.*arguments: //p') \
#    && CONFARGS=${CONFARGS/-Os -fomit-frame-pointer -g/-Os} \
#    && export CONFARGS="$CONFARGS $BUILT_MODULES" \
#    && echo "config for nginx with $CONFARGS" \
    && cd /usr/local/src/nginx \
    && ./configure ./configure --sbin-path=/usr/sbin/nginx --modules-path=/usr/lib/nginx/modules --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock --http-client-body-temp-path=/var/cache/nginx/client_temp --http-proxy-temp-path=/var/cache/nginx/proxy_temp --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp --http-scgi-temp-path=/var/cache/nginx/scgi_temp --with-perl_modules_path=/usr/lib/perl5/vendor_perl --user=nginx --group=nginx --with-compat --with-file-aio --with-threads --with-http_addition_module --with-http_auth_request_module --with-http_dav_module --with-http_flv_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_mp4_module --with-http_random_index_module --with-http_realip_module --with-http_secure_link_module --with-http_slice_module --with-http_ssl_module --with-http_stub_status_module --with-http_sub_module --with-http_v2_module --with-mail --with-mail_ssl_module --with-stream --with-stream_realip_module --with-stream_ssl_module --with-stream_ssl_preread_module --with-cc-opt='-Os -fomit-frame-pointer -g' --with-ld-opt=-Wl,--as-needed,-O1,--sort-common $BUILT_MODULES \
    && make  \
    && make install \
    && mkdir -p /modules/ \
    && cp -a ./objs/*.so /modules/ \

FROM nginx:${NGINX_VERSION}-alpine
RUN apk add --no-cache pcre-dev
COPY --from=builder /modules/ /usr/lib/nginx/modules/
COPY --from=builder /usr/sbin/nginx /usr/sbin/nginx


