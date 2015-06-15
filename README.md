Darkstat
==========================


Darkstat - https://unix4lyfe.org/darkstat/



Running on the latest Phusion release (ubuntu 14.04), with darkstat from repos.

**Pull image**

```
docker pull mace/darkstat
```

**Run container**

```
docker run -d --net="host" --name=<container name> -v <local path to store db/log>:/config -v /etc/localtime:/etc/localtime:ro -e ETH=<Interface to monitor> -e PORT=<Webui port> -e IP_HOST=<hosts ip> -e IP_RANGE=<network to listen on> mace/darkstat
```
Please replace all user variables in the above command defined by <> with the correct values.

**Web-UI**

```
http://<host ip>:[PORT]
```

**Example**

```
docker run -d --net="host"  --name=darkstat -v /mylocal/directory/fordata:/config -v /etc/localtime:/etc/localtime:ro -e ETH=eth0 -e PORT=666 -e IP_HOST=192.168.1.10 -e IP_RANGE=192.168.1.0/255.255.255.0 mace/darkstat
```

**Additional notes**

* To clear the database just delete it on the host.
