# SOLR Search and Nutch indexer for the NHS Developer Network #

This is a pair of docker images:


## SOLR ##
A SOLR index to index content for search on the developer network.
The content from wordpress is entered into the index directly using a wordpress plugin (solr-power).
Content for other parts of the site, which are hosted in separate Docker containers, is indexed separately using Nutch (see below)

To start the Solr container on a local development machine, clone this repository, then create a directory to hold the data. The default directory is /docker-data/devnetwork-solr-index. Assuming you are not using user namespacing in Docker, the directory will need permissions for user 8983.

```
mkdir /docker-data/devnetwork-solr-index
chown 8983 /docker-data/devnetwork-solr-index
```

Now, build and start the container:

```
cd solr
./build-solr.sh
./deploy-solr.sh
```

You should now be able to see the Solr console at: http://localhost:8983/


## Nutch ##
Nutch is a web crawler which crawls any URLs and generates some metadata about them to add into the Solr index. This allows the developer network search to incorporate all the content from these containers alongside the wordpress content.

Currently this includes indexing of content from three containers:
- The FHIR Reference server
- The NGinx server hosting Jekyll generated API specification content
- The NGinx server hosting other Domain Message Specifications

To build the Nutch container, pull this repository and run:

```
./build-nutch.sh "" develop
```

This will build a container using configuration for the development environment. To build for other environments, instead of develop pass "staging" or "live". The configuration for each of these environments (including URLs to be spidered) is in files/conf-<environment>

Nutch also needs a directory to store it's crawl data during crawling, and by default this is stored in /docker-data/devnetwork-nutch-temp (Nutch runs as root so you shouldn't need to set any permissions unless you are using Docker user namespacing):

```
mkdir /docker-data/devnetwork-nutch-temp
```

Now, start the crawler crawling sites:

```
./deploy-nutch.sh
```

Unless you have commented out any of the URLs this is likely to take a very long time!
By default Nutch runs 5 iterations of the crawler. This may still not cover all possible URLs, but subsequent runs of Nutch will pick up other pages.

Once the crawl is complete it will add indexed pages into Solr. If you open the Solr console and look at the "developernetwork" core, you should see the number of indexed documents. You can also do some test queries in the console to see what metadata is held for Solr entries.

