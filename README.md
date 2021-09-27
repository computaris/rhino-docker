# rhino-docker

It's local docker-compose test to run it locally:
1. Run `./generate-rhino-keystores.sh changeit changeit` (to remove certs: `rm -rf certs/`)
2. Download correct version of rhino e.g `rhino-install-3.0.0.12`
3. Unzip it and copy `rhino-install-3.0.0.12.tar` to `C:\Users\your_user\IdeaProjects\rhino-docker\rhino`
4. Run `build.sh`
5. Run `docker-compose up`
6. Login to container and check if rhino-console (/opt/opencloud/rhino/client/bin/rhino-console) is working
