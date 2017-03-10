FROM apache/nutch

RUN mkdir -p /root/nutch/urls/
RUN mkdir -p /root/nutch/plugins/extractor/

COPY files/extractor /root/nutch/plugins/extractor/
COPY files/conf /root/nutch/conf/
COPY files/urls /root/nutch/urls/


