

* Port 4242 for connection
* Mount /config for configuration
* Mount /etc/localhost for for time syncronization

Updates happen on start . SSH is disabled. (rather use nsenter).



# lonix/quassel


**sample create command:**
```
docker create --name=<name> -v /etc/localtime:/etc/localtime:ro -v <path to data>:/config -e PGID=<gid> -e PUID=<uid>  -p 4242:4242 lonix/quassel:2.0
```

**You need to map**
* PORT: 4242 for quassel-core
* MOUNT: /etc/localhost for timesync (Not required)
* MOUNT: /config for Configuration storage
* VARIABLE: PGID for for GroupID
* VARIABLE: PUID for for UserID

It is based on phusion-baseimage with ssh removed. (use docker exec).


**Credits**
lonix <lonixx@gmail.com>

**Versions**
2.0 New gid\uid fix, and code cleanup.
1.0: Inital release

