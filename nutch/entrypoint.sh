#!/bin/bash

export JAVA_HOME=/usr/lib/jvm/java-7-oracle/jre/
cd /root/nutch
bin/crawl ./urls ./crawl 5
bin/nutch solrindex http://solr-developernetwork:8983/solr/developernetwork crawl/crawldb/ -linkdb crawl/linkdb/ crawl/segments/* -filter -normalize -deleteGone

