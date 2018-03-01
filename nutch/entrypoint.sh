#!/bin/bash

#export JAVA_HOME=/usr/lib/jvm/java-7-oracle/jre/
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre
cd /root/nutch

# Run the script to inject API hub URLs into the seed file
/root/nutch/generate-seeds.sh

# Previously we used the crawl script provided, but the dedup step now seems to fail.. so we'll run the individual steps manually instead.
#bin/crawl -s ./urls ./crawl 5
#bin/nutch solrindex http://solr-developernetwork:8983/solr/developernetwork crawl/crawldb/ -linkdb crawl/linkdb/ crawl/segments/* -filter -normalize -deleteGone

bin/nutch inject crawl/crawldb urls

# Pass 1
bin/nutch generate crawl/crawldb crawl/segments
s1=`ls -d crawl/segments/2* | tail -1`
bin/nutch fetch $s1
bin/nutch fetch $s1
bin/nutch updatedb crawl/crawldb $s1

# Pass 2
bin/nutch generate crawl/crawldb crawl/segments -topN 1000
s2=`ls -d crawl/segments/2* | tail -1`
bin/nutch fetch $s2
bin/nutch parse $s2
bin/nutch updatedb crawl/crawldb $s2

# Pass 3
bin/nutch generate crawl/crawldb crawl/segments -topN 1000
s3=`ls -d crawl/segments/2* | tail -1`
bin/nutch fetch $s3
bin/nutch parse $s3
bin/nutch updatedb crawl/crawldb $s3

# Invert links
bin/nutch invertlinks crawl/linkdb -dir crawl/segments

# Dedup not working....

# Send to SOLR
bin/nutch solrindex http://solr-developernetwork:8983/solr/developernetwork crawl/crawldb/ -linkdb crawl/linkdb/ crawl/segments/* -filter -normalize -deleteGone

# Clean solr
bin/nutch clean crawl/crawldb/ http://solr-developernetwork:8983/solr/developernetwork

