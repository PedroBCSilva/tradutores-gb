# Tradutores GB
Please follow this [tutorial](https://www.antlr.org/) to install Antlr, after that you can use the *start.sh* to run the code, you can follow this example below.
The project is built by maven. Don't forget to import or enable auto-import of dependencies.

To generate antlr4 files:
 ```
mvn generate-sources
 ```
To build the whole project and run tests, run:
```
mvn install
```
You can also run both together:
```
mvn generate-sources install
```
 
Or to run maven AND command line TestRig automatically:
```
./start.sh PATH_TO_TEST_FILE

./start.sh src/test/resources/test.cc
```

You can also use the `-gui` parameter to show the tree it created
```
./start.sh src/test/resources/test.cc -gui
```

It's recommended to use `ANTLR v4 grammar plugin` on Intellij and import this file as project. It can render the tree created with the script if you click with mouse right click on the main rule of `g4` file, select the `Test Rule program`. This plugin can help development since all changes can be tested on Intellij with custom inputs.
