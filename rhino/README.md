# rhino-docker

It's local docker-compose test to run it locally:
1. Run `./generate-rhino-keystores.sh changeit changeit` (to remove certs: `rm -rf certs/`)
2. Download correct version of rhino e.g `rhino-install-3.0.0.19`
3. Copy `rhino-install-3.0.0.19.tar` to `rhino-docker\rhino`
4. Run `build.sh`
5. Run `docker-compose up`
6. Connect to container by `docker exec -it rhinoA /opt/opencloud/rhino/client/bin/rhino-console` and check if rhino-console (`/opt/opencloud/rhino/client/bin/rhino-console`) is working
