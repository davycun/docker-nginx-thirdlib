### 构建基础镜像，only support alpine
- 目的：其实就是把源码下载到nginx官方镜像中，并且把内容放到/srv/nginx 目录下
- 构建方式
  `./build.sh 1.21.5 "nginx-rtmp-module ngx_http_proxy_connect_module ngx_waf"`