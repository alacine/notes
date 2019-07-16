## nginx 配置

服务器上用到的配置, 记录备用

转发 neo4j 端口
```
location /neo4j {
    proxy_pass http://127.0.0.1:7474:7474/browser;
}
```

转发 jupyter book 端口
```
location /jupyter/ {
    proxy_pass http://127.0.0.1:28888;
    proxy_set_header Host $host;
    proxy_set_header X-Real-Scheme $scheme;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";

    proxy_read_timeout 120s;
    proxy_next_upstream error;
}
```

转发 tomcat 端口
```
location ^~ /tomcat/ {
    proxy_pass http://127.0.0.1:8080/;
    proxy_redirect off;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header Host $host;
    proxy_set_header X-Real-Scheme $scheme;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";

    proxy_next_upstream error;
    // xxxx 为 webapps 目录下的项目名称
    // 设置 cookie 保存位置, 保持 Session
    proxy_cookie_path /xxxx /;
}
```
