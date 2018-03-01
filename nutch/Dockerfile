FROM apache/nutch

RUN mkdir -p /root/nutch/urls/
RUN mkdir -p /root/nutch/plugins/extractor/

COPY files/extractor /root/nutch/plugins/extractor/
COPY files/conf /root/nutch/conf/

ARG ENVIRONMENT=develop
RUN echo "Copying config for environment: $ENVIRONMENT"

# Copy environment-specific files
COPY files/conf-$ENVIRONMENT/extractors.xml /root/nutch/conf/
COPY files/conf-$ENVIRONMENT/regex-urlfilter.txt /root/nutch/conf/
COPY files/conf-$ENVIRONMENT/seed.txt /root/nutch/urls/
COPY files/conf-$ENVIRONMENT/generate-seeds.sh /root/nutch/

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
RUN chmod +x /root/nutch/generate-seeds.sh

ENTRYPOINT ["/entrypoint.sh"]
