# Introduction Jenkins

## Create RSA Key
```bash
$ ssh-keygen -f remote-key -m PEM
```
Create remote host Dockerfile
```Dockerfile
FROM ubuntu:18.04

RUN apt-get update && \
 apt-get install -y openssh-server

RUN useradd remote_user && \
    echo "remote_user:1234" | chpasswd && \
    mkdir /home/remote_user/.ssh -p && \
    chmod 700 /home/remote_user/.ssh && \
    mkdir -p -m 0755 /var/run/sshd

COPY remote-key.pub /home/remote_user/.ssh/authorized_keys

RUN chown remote_user:remote_user -R /home/remote_user && \
    chmod 400 /home/remote_user/.ssh/authorized_keys

CMD /usr/sbin/sshd -D

```