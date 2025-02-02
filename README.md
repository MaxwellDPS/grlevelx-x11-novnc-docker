## granalyst2-novnc-docker

This container runs:

* Xvfb - X11 in a virtual framebuffer
* x11vnc - A VNC server that scrapes the above X11 server
* [noNVC](https://kanaka.github.io/noVNC/) - A HTML5 canvas vnc viewer
* Fluxbox - a small window manager
* Explorer.exe - to demo that it works

## Run It

    # Start the container
docker run --platform linux/amd64 --rm -p 8080:8080 -p 8081:8081 -p 9001:9001 -e RESOLUTION=1920x1080x24 professorcha0s/grlevelx:latest

    docker run --rm -p 8080:8080 -p 9001:9001 professorcha0s/grlevelx:latest

docker buildx build --platform linux/amd64 -f Dockerfile -t professorcha0s/grlevelx:latest . 

docker run --rm -p 8080:80 -p 9001:9001 -e RESOLUTION=1920x1080x24 professorcha0s/grlevelx:latest
