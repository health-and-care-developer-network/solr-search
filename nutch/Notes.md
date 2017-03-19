docker pull apache/nutch
docker run -t -i -d --userns=host --net=host --name nutchcontainer apache/nutch /bin/bash
docker attach --sig-proxy=false nutchcontainer

Log in to the container

Edit /root/nutch/conf/regex-urlfilter.txt

Replace final line with:
+^http://localhost:808(0|1).*/

Now, set your user agent. Edit /root/nutch/conf/nutch-default.xml

Find the line with <name>http.agent.name</name> and set a value <value>Nutch-DevNet</value>

cd /root/nutch

mkdir urls
cd urls

Create a file seed.txt with content:

http://localhost:8080
http://localhost:8081/apis/gpconnect

Configure extractor: https://github.com/BayanGroup/nutch-custom-search


Start the crawl:

cd /root/nutch
bin/crawl ./urls ./crawl 5

Takes about half an hour on localhost

Now, push the indexed data into Solr:

bin/nutch solrindex http://localhost:8983/solr/developernetwork crawl/crawldb/ -linkdb crawl/linkdb/ crawl/segments/* -filter -normalize -deleteGone


To delete all entries:

curl "http://localhost:8983/solr/mycore/update?stream.body=<delete><query>*:*</query></delete>&commit=true"
curl "http://localhost:8983/solr/developernetwork/update?stream.body=<delete><query>*:*</query></delete>&commit=true"
