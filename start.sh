# antlr setup
export CLASSPATH=".:/usr/local/lib/antlr-4.8-complete.jar:$CLASSPATH"
alias antlr4='java -jar /usr/local/lib/antlr-4.8-complete.jar'
alias grun='java org.antlr.v4.gui.TestRig'

FILE_NAME=$1
INITIAL_RULE=$2
TEST_FILE=$3
TEST_RIG_PARAM=$4

antlr4 "${FILE_NAME}.g4" -o out
find ./out ./src -type f -name "*.java" | xargs javac -d ./out
cd out/br/unisinos
grun $FILE_NAME $INITIAL_RULE "../${TEST_FILE}" $TEST_RIG_PARAM
