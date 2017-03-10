Build the container with build-solr.sh
Start the container with deploy-solr.sh
You can see the console at http://localhost:8983/

Open a console in the container:
```
docker exec -it solr-developernetwork /bin/bash
cd /opt/solr/server/solr/developernetwork
```


To integrate with wordpress install the solr-power wordpress plugin (requires quite a bit of customisation to work).
You will also need to install curl php5-curl.

