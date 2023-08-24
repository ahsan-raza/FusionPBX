# **Upgrade Notes for freeswitch**

To upgrade freeswitch version, first we need to fetch it from the debain package registry. Use the following commands to grab it.


`docker run -it docker.io/library/debian:12.1-slim bash`
```

 TOKEN=<pat_token>
 apt-get update \
  && apt-get install -y gnupg2 wget lsb-release \
  && wget --http-user=signalwire --http-password=$TOKEN -O /usr/share/keyrings/signalwire-freeswitch-repo.gpg https://freeswitch.signalwire.com/repo/deb/debian-release/signalwire-freeswitch-repo.gpg \
  && echo "machine freeswitch.signalwire.com login signalwire password $TOKEN" > /etc/apt/auth.conf \
  && chmod 600 /etc/apt/auth.conf \
  && echo "deb [signed-by=/usr/share/keyrings/signalwire-freeswitch-repo.gpg] https://freeswitch.signalwire.com/repo/deb/debian-release/ `lsb_release -sc` main" > /etc/apt/sources.list.d/freeswitch.list \
  && echo "deb-src [signed-by=/usr/share/keyrings/signalwire-freeswitch-repo.gpg] https://freeswitch.signalwire.com/repo/deb/debian-release/ `lsb_release -sc` main" >> /etc/apt/sources.list.d/freeswitch.list \
  && apt-get update
apt-cache madison freeswitch-meta-all
```


result will be something like

```
freeswitch-meta-all | 1.10.10~release~24~4cb05e7f4a~bookworm-1~bookworm+1 | https://freeswitch.signalwire.com/repo/deb/debian-release bookworm/main amd64 Packages
freeswitch | 1.10.10~release~24~4cb05e7f4a~bookworm-1~bookworm+1 | https://freeswitch.signalwire.com/repo/deb/debian-release bookworm/main Sources
```

choose the version of freeswitch you want and put it inside the build.sh or .gitlab-ci.yml. Remember, this will only update the freeswitch version not the fusionPBX version.
