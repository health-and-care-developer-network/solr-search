#!/bin/bash

# Simple script to scrape all URLs from the API hub page and add them to the seed file, so we make sure we are indexing all API specs
wget --convert-links https://developer-test.nhs.uk/apis -O /root/nutch/apihub.htm
sed -n 's/.*href="\([^"]*\).*/\1/p' /root/nutch/apihub.htm >> /root/nutch/urls/seed.txt

# De-duplicate the seed file
awk '!seen[$0]++' /root/nutch/urls/seed.txt > /root/nutch/urls/seed2.txt
rm /root/nutch/urls/seed.txt
mv /root/nutch/urls/seed2.txt /root/nutch/urls/seed.txt

