# myTDX in Docker

This repository contains a Dockerfile and other dependencies required to build the image containing [myTDX](https://github.com/MoonCactus/myTDX). 
It bases on Alpine Linux, so the resulting image takes about 99MB of space.
The main file (which is `index.php` in this case) is hosted using the built-in web server provided by PHP.
Thus, it is recommended to run it behind a TLS termination proxy such as nginx for both security and performance reasons.

## Building the image

The image is built automatically on Docker Hub.
Should you need to build it yourself, follow the steps below.

1. Enter the directory.
1. Run `docker build -t mytdx .`.
1. Don't forget about the dot :)

## Using the image

You can start the container using `docker run`, but I recommend to run it using docker-compose.
Please note that this assumes you're using it behind a reverse proxy.
Below is an example definition.

```yaml
version: "2"
services:
  mytdx:
      image: "extincteagle/mytdx"
      container_name: "mytdx"
      restart: unless-stopped

networks:
  default:
    external:
      name: "web"
```

The built-in web server is listening on the port 80.
The container is bound to the external Docker network of the name "web" (this is the same network on which you should have your reverse proxy).

In the case of nginx, simply add the "proxy_pass" directive and point it to the name of the container (in this case defined by the "container_name" key)..
Below is an example of the nginx configuration block, hosting the application on `http://hostname/todo`.

```
location /todo/ {
        proxy_pass http://mytdx/;
        sub_filter 'href="/' 'href="/todo/';
        sub_filter 'src="/' 'src="/todo/';
        sub_filter 'mytinytodo.mttUrl = "/' 'mytinytodo.mttUrl = "/todo/';
        sub_filter_once off;
}
```

These subfilters are only necessary if you decide to host the application elsewhere than on the root of the server.
In other case, `proxy_pass` is all that's needed.
