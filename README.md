### nginx 每个版本支持的模块

### nginx-1.21.5-alpine-thirdlib 版本
- 此版本是在官方镜像中添加第三方模块，模块主要包括下文中列表中国
- 构建方式`./build.sh 1.21.5 "nginx-rtmp-module ngx_http_proxy_connect_module ngx_waf"`

| 模块名字                          | 模块版本    | 地址                                                         | 说明       |
|-------------------------------|---------|------------------------------------------------------------|----------|
| nginx-rtmp-module             | v1.2.2  | <https://github.com/arut/nginx-rtmp-module>                | 支持rtmp协议 |
| ngx_http_proxy_connect_module | v0.0.3  | <https://github.com/chobits/ngx_http_proxy_connect_module> | 支持正向代理   |
| ngx_waf                       | v10.1.2 | <https://github.com/ADD-SP/ngx_waf>                        | 支持waf    |

### nginx-1.23.2-alpine-forward

- 这个是版本主要是添加了nginx作为正向代理服务器的支持（解决正向代理https的问题），详细的配置可以参考[ngx_http_proxy_connect_module](https://github.com/chobits/ngx_http_proxy_connect_module)
- 构建方式：直接执行`build.sh`即可