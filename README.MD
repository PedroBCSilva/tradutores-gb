# Tradutores GB
Please follow this [tutorial](https://www.antlr.org/) to install Antlr, after that you can use the *start.sh* to run the code, you can follow this example below.
 
```
./start.sh FILE_NAME_WITHOUT_EXTENSION FIRST_RULE PATH_TO_TEST_FILE

./start.sh Expr prog final_test.cc
```

You can also use the `-gui` parameter to show the tree it created
```
/start.sh Expr prog final_test.cc -gui
```

It's recommended to use `ANTLR v4 grammar plugin` on Intellij and import this file as project. It can render the tree created with the script if you click with mouse right click on the main rule of `g4` file, select the `Test Rule prog`. This plugin can help development since all changes can be tested on Intellij with custom inputs.
