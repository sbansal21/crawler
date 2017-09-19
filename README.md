## crawler
A collection of scripts that generates various server configuration files given a dev VM and stores those files in a custom directory structure, working as a complement to the ['lighthouse' diagnostic suite](https://github.com/sumeet-bansal/lighthouse).

## Set Up
The entirety of crawler's functionality can be accessed through its various Shell scripts. These scripts include wrappers for the Java applications (e.g. the ZooKeeper `properties` file generator) and can be run as normal Shell scripts.

## Functionality
Crawler retrieves and generates various server configuration files (e.g. `.properties`, `.config`, `.yaml`) from individual dev environments and populates user-specified root directories.

## Design
Crawler was developed as a collection of both regular scripts and wrappers for Java applications and heavily utilizes the ZooKeeper API.

### Generating ZooKeeper Files
__Generating ZooKeeper files requires having JRE 1.8 installed.__
Crawler works with the ZooKeeper API to generate full `.properties` files for all fabrics within a given dev environment. It generates a directory for the given dev environment within the root directory, and then, given a path within ZooKeeper to follow, it creates nested directories for each fabric within that ZooKeeper path. Within those fabric directories, it creates another directory named `common`, under which the `.properties` files can be found for each fabric. Furthermore, certain branches can be excepted from the general `server.properties` file for readability&mdash;these excepted branches are then given their own file named `server.<branch>.properties`. Detailed usage statements can be found in the application help pages, but as an example, this command creates a directory `dev` within `C:/Users/user/root` and populates it with the fabrics found within `/alcatrazproperties/2.5` of the host IP `127.0.0.1`:

```
~$ java -jar zk-crawler-1.0.0.jar zk generate 127.0.0.1 /alcatrazproperties/2.5 root dev blacklist purge
generated .properties file(s) for dev/fabric1
generated .properties file(s) for dev/fabric2
generated .properties file(s) for dev/fabric3
```

For each fabric within that environment, the command will then create some file `root/dev/fabric/server.properties` and, if there is a `blacklist` branch but no `purge` branches within the fabric, the command will additionally create a file `root/dev/fabric/server.blacklist.properties`.

However, since crawler is designed as a collection of scripts, a Shell wrapper for ZooKeeper generation is available: [`zk-wrapper.sh`](https://github.com/sumeet-bansal/crawler/blob/master/scripts/zk-wrapper.sh). To use this wrapper, first specify each environment and IP within the associative array of the script. For example, to add `dev1` with environment `127.0.0.1` and `dev3` with environment `127.0.0.3`, modify the script as such:

Before:
```bash
#!/usr/bin/env bash

declare -A IPTable

# to add a dev and their environment, simply add another element to the associative array
IPTable[dev]=env
...
```

After:
```bash
#!/usr/bin/env bash

declare -A IPTable

# to add a dev and their environment, simply add another element to the associative array
IPTable[dev1]=127.0.0.1
IPTable[dev3]=127.0.0.3
...
```

Assuming the [`zk-crawler.jar`](https://github.com/sumeet-bansal/crawler/blob/master/scripts/zk-crawler.jar) file is still in the same directory as the wrapper, [`zk-wrapper.sh`](https://github.com/sumeet-bansal/crawler/blob/master/scripts/zk-wrapper.sh) can then be run as a normal Shell script:
```
~$ chmod u+x zk-wrapper.sh
~$ ./zk-wrapper.sh
generated .properties file(s) for dev1/fabric1
generated .properties file(s) for dev1/fabric2
generated .properties file(s) for dev1/fabric3
generated .properties file(s) for dev3/fabric1
generated .properties file(s) for dev3/fabric2
generated .properties file(s) for dev3/fabric3
```

### Generating Dependency Data
Crawler has three scripts that work in tandem to generate dependency data for a node or set of nodes: [`jar-generator.sh`](https://github.com/sumeet-bansal/crawler/blob/master/scripts/jar-generator.sh), [`jar-organizer.sh`](https://github.com/sumeet-bansal/crawler/blob/master/scripts/jar-organizer.sh), and [`RWC-jar-generator.sh`](https://github.com/sumeet-bansal/crawler/blob/master/scripts/RWC-jar-generator.exp). The first, `jar-generator.sh`, must be run from within an environment. Assuming a standard fabric-naming scheme, `jar-generator.sh` detects which fabric it's being run from and comes hardcoded with the locations of each `lib/` folder for that specific fabric. It then generates a `.jars` file with the structure:
```
dependency1.jar=size1
dependency2.jar=size2
dependency3.jar=size3
```
For example, to generate a `.jars` file for the node `fab-eng02-haz-n2`:
```
sysops@fab-eng02-haz-n2:~$ ./jar-generator.sh
generated ~/fab-eng02-haz-n2.lib.jars
generated ~/fab-eng02-haz-n2.apclib.jars
```
The second, `jar-organizer.sh`, takes a collection of `.jars` files and organizes them in a data store Lighthouse can use. This data store takes the form of a directory structure within a given root directory. For example, to organize all the `.jars` files within the working directory:
```
~$ ./jar-organizer.sh root/RWC-Dev
organized root/RWC-Dev/hazelcast/n2/fab-eng02-haz-n2.lib.jars
organized root/RWC-Dev/hazelcast/n2/fab-eng02-haz-n2.apclib.jars
```
The third, `RWC-jar-generator.sh`, works specifically with the Redwood City dev environments, cycling through them and generating a complete inventory of the dependencies in each node of a fabric. __Note: Generating dependency data through this script requires having the `expect` package installed.__ `RWC-jar-generator.sh` can be easily modified to do the same for any set of environments and takes the sysops password as an argument.
```
~$ ./RWC-jar-generator.sh pass
generated ~/fab-eng02-haz-n1.lib.jars
generated ~/fab-eng02-haz-n1.apclib.jars
organized root/RWC-Dev/hazelcast/n2/fab-eng02-haz-n1.lib.jars
...
generated ~/fab-eng02-stm-n4.lib.jars
organized root/RWC-Dev/storm/n4/fab-eng02-stm-n4.lib.jars
```

### Adding More Extraction Scripts
Since most of these scripts are standalone, they can be added as needed.

## Planned Updates
- automated directory population directly from dev VMs
	
Further suggestions welcome. For information on contacting developers, please see [the 'Developers' section](#developers).

## Code and Build
The code can be found online on [the GitHub page for crawler](https://github.com/sumeet-bansal/crawler) and each release can be found online on [the GitHub releases page for crawler](https://github.com/sumeet-bansal/crawler/releases). The scripts can be found under the [`scripts` directory](https://github.com/sumeet-bansal/crawler/tree/master/scripts) of the repo and the Java code can be found under the [`src` directory](https://github.com/sumeet-bansal/crawler/tree/master/src). Detailed documentation can be found [here](https://cdn.rawgit.com/sumeet-bansal/crawler/master/documentation/main/index.html). The repository is set up as a Maven project that can be easily compiled and built.

### Useful Maven Commands
Specific behavior for each of these commands has been defined in the [POM](https://github.com/sumeet-bansal/crawler/blob/master/pom.xml).

To purge the local dependency cache (e.g. in case of corrupted dependencies):
```
~$ mvn dependency:purge-local-repository
```

To clean out the javadocs and compiled source:
```
~$ mvn clean
```

To compile the main and test source code:
```
~$ mvn compile test-compile
```

To run through the JUnit tests:
```
~$ mvn test
```

To assemble a single JAR packaged with the necessary dependencies:
```
~$ mvn assembly:single
```
Note: the `assembly:single` goal must be run in conjunction with the `compile` phase but is already bound to the `package` phase, which includes additionally compilation and unit testing.

To generate the `main` and `test` class javadocs:
```
~$ mvn javadoc:javadoc javadoc:test-javadoc
```
Note: the generated documentation can be found under `documentation/main/` and `documentation/test/`, for the `main` and `test` classes respectively&mdash;they are manually renamed to match the standard repo structure.

These commands can be chained together as well. For example, to compile and assemble the latest executable JAR:
```
~$ mvn clean compile assembly:single
```
or alternatively,
```
~$ mvn clean package
```
which additionally runs through the unit tests to ensure a working build.

## Developers
+ Sumeet Bansal&ensp;&ensp;sumeetbansal@gmail.com