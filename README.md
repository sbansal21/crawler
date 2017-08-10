## crawler
A collection of scripts that generates various server configuration files given a dev VM and stores those files in a custom directory structure, working as a complement to the 'lighthouse' diagnostic suite.

## Set Up
The entirety of crawler's functionality can be accessed through its various Shell scripts. These scripts include wrappers for the Java applications (e.g. the ZooKeeper .properties file generator) and can be run as normal Shell scripts.

## Functionality
Crawler retrieves and generates various server configuration files (e.g. .properties, .config, .yaml) from individual dev environments and populates user-specified root directories.

## Design
Crawler was developed as a collection of both regular scripts and wrappers for Java applications and heavily utilizes the ZooKeeper API.

<!---
### Generating Directories
Crawler works with the ZooKeeper API to generate full .properties files for all fabrics within a given dev environment. It generates a directory for the given dev environment within the root directory, and then, given a path within ZooKeeper to follow, it creates nested directories for each fabric within that ZooKeeper path. Within those fabric directories, it creates another directory named `common`, under which the .properties files can be found for each fabric. Furthermore, certain branches can be excepted from the general `server.properties` file for readability--these excepted branches are then given their own file named `server.<branch>.properties`. Detailed usage statements can be found in the application help pages, but as an example, this command creates a directory `dev` within `C:/Users/user/root` and populates it with the fabrics found within `/alcatrazproperties/2.5` of the host IP `127.0.0.1`:

```
~$ java -jar ADS_v1.1.jar zk generate 127.0.0.1 /alcatrazproperties/2.5 C:/Users/user/root dev blacklist purge
generated .properties file(s) for fabric1
generated .properties file(s) for fabric2
generated .properties file(s) for fabric3
``` 

For each fabric within that environment, the command will then create some file `root/dev/fabric/server.properties` and, if there is a `blacklist` branch but no `purge` branches within the fabric, the command will additionally create a file `root/dev/fabric/server.blacklist.properties`.

-->

## Planned Updates
- automated directory population directly from dev VMs
	
Further suggestions welcome. For information on contacting developers, please see ['Developers' section](#developers).

## Accessibility
The code can be found online on [the GitHub page for crawler](https://github.com/sbansal21/crawler).

## Developers
+ Sumeet Bansal (sbansal@actiance.com)