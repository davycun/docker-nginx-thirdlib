ARG NGINX_VERSION=1.23.2
#ARG ENABLE_MODULES="nginx-rtmp-module ngx_http_proxy_connect_module"
FROM nginx:${NGINX_VERSION}-alpine as builder

RUN mkdir -p /usr/local/src

WORKDIR /usr/local/src/

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/' /etc/apk/repositories \
    && apk add --no-cache --virtual .build-deps gcc libc-dev make openssl-dev pcre-dev zlib-dev linux-headers libxslt-dev gd-dev geoip-dev perl-dev libedit-dev mercurial bash alpine-sdk findutils \
    && curl -L "http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz" -o nginx.tar.gz \
    && tar -zxC /usr/local/src -f nginx.tar.gz \
    && mv /usr/local/src/nginx-$NGINX_VERSION /usr/local/src/nginx \
    && cd /usr/local/src/ \
    && curl -L -o master.zip https://github.com/chobits/ngx_http_proxy_connect_module/archive/refs/heads/master.zip \
    && unzip master.zip \
    && mv ngx_http_proxy_connect_module-master ngx_http_proxy_connect_module \
    && cd /usr/local/src/nginx \
    && patch -p1 < /usr/local/src/ngx_http_proxy_connect_module/patch/proxy_connect_rewrite_102101.patch \
    && CONFARGS=$(nginx -V 2>&1 | sed -n -e 's/^.*arguments: //p') \
    && CONFARGS=${CONFARGS/-Os -fomit-frame-pointer -g/-Os} \
    && export CONFARGS="$CONFARGS --add-dynamic-module=/usr/local/src/ngx_http_proxy_connect_module" \
    && echo "config for nginx with $CONFARGS" \
    && cd /usr/local/src/nginx \
    && ./configure --sbin-path=/usr/sbin/nginx --modules-path=/usr/lib/nginx/modules --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock --http-client-body-temp-path=/var/cache/nginx/client_temp --http-proxy-temp-path=/var/cache/nginx/proxy_temp --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp --http-scgi-temp-path=/var/cache/nginx/scgi_temp --with-perl_modules_path=/usr/lib/perl5/vendor_perl --user=nginx --group=nginx --with-compat --with-file-aio --with-threads --with-http_addition_module --with-http_auth_request_module --with-http_dav_module --with-http_flv_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_mp4_module --with-http_random_index_module --with-http_realip_module --with-http_secure_link_module --with-http_slice_module --with-http_ssl_module --with-http_stub_status_module --with-http_sub_module --with-http_v2_module --with-mail --with-mail_ssl_module --with-stream --with-stream_realip_module --with-stream_ssl_module --with-stream_ssl_preread_module --with-cc-opt='-Os -fomit-frame-pointer -g' --with-ld-opt=-Wl,--as-needed,-O1,--sort-common --add-dynamic-module=/usr/local/src/ngx_http_proxy_connect_module \
    && make && make install \
    && mkdir /modules/ \
    && cp -a ./objs/*.so /modules/ \
    && ls -la /modules/

FROM nginx:${NGINX_VERSION}-alpine
RUN apk add --no-cache pcre-dev
COPY --from=builder /modules/ /usr/lib/nginx/modules/
COPY --from=builder /usr/sbin/nginx /usr/sbin/nginx


