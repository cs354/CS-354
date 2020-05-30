# CS354 Student Environment 

This repo contains the scripts to start many of the projects and labs.

## MacOS
Install [Docker for macOS](https://hub.docker.com/editions/community/docker-ce-desktop-mac/)  

## Windows
Unfortunately, Windows is not a suitible environment for low-level development or hacking. For that reason, you must install a Linux Virtual Machine (WSL is not sufficient, you need an actual Linux kernel). We recommend [VirtualBox](https://www.virtualbox.org/) with [Ubuntu](https://ubuntu.com/download/desktop).

Then, follow the Linux instructions below.

## Linux
You make our life easy. Just install Docker. We suggest you use your distribution's package manager to do this, but can also install it manually.  
[Docker for linux](https://docs.docker.com/engine/install/)

### Ubuntu/Debian
`sudo apt install docker.io`

### Arch
`sudo pacman -S docker`

### RHEL/Fedora
You can install docker manually using the link above, or you can try Red Hat's container implementation called podman. Docker is not available in the normal package repos.  
`sudo dnf install podman`


