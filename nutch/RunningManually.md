Instead of running deploy-nutch.sh, do this:

```
docker run -it --name nutchcontainer-interactive --link solr-developernetwork:solr-developernetwork -v /docker-data/devnetwork-nutch-temp:/root/nutch/crawl --entrypoint /bin/bash nhsd-nutch
```

You are now in the container.
You can edit the config in ~/nutch/config directly now if you want to
To start the crawl type:

```
cd /root/nutch
bin/crawl -s ./urls ./crawl 1
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


On the server, if you want to start a new interactive nutch session (for example to interrogare the crawl database), type:

```
docker run -it --name nutchcontainer-interactive --link solr-developernetwork:solr-developernetwork -v /docker-data/devnetwork-nutch-temp:/root/nutch/crawl --entrypoint /bin/bash dn-p-mgmt01:5000/nhsd-nutch
```

Now, list the segments:

```
ls -lrt crawl/segments
```

Now, for each segment, dump all the metadata and check for entries with no solr_id field:

```
echo "--------------------------------------------------------------------"
for file in crawl/segments/*
do
  bin/nutch readseg -dump $file segmentAllContent 1>/dev/null
  entries_with_solr_id=`grep "Parse Metadata" segmentAllContent/dump | grep solr_id | wc -l`
  entries_without_solr_id=`grep "Parse Metadata" segmentAllContent/dump | grep -v solr_id | wc -l`
  echo "Entries in segment - with a solr_id: $entries_with_solr_id , without a solr_id: $entries_without_solr_id"
done
echo "--------------------------------------------------------------------"
```

To delete all entries in the index:

```
curl http://solr-developernetwork:8983/solr/developernetwork/update?commit=true -d '<delete><query>*:*</query></delete>'
```

