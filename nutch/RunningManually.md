Instead of running deploy-nutch.sh, do this:

```
docker run -it --name nutchcontainer-interactive --link solr-developernetwork:solr-developernetwork -v /docker-data/devnetwork-nutch-temp:/root/nutch/crawl --entrypoint /bin/bash nhsd-nutch
```

You are now in the container.
You can edit the config in ~/nutch/config directly now if you want to
To start the crawl type:

```
cd /root/nutch
bin/crawl ./urls ./crawl 1
```

Note: This does a single crawl rather than 5, so is a lot quicker!
Finally, try to push the results into Solr:

```
bin/nutch solrindex http://solr-developernetwork:8983/solr/developernetwork crawl/crawldb/ -linkdb crawl/linkdb/ crawl/segments/* -filter -normalize -deleteGone
```

This is the point at which it usually fails.
Normally you can see the error in:

```
/root/nutch/logs/hadoop.log
```

