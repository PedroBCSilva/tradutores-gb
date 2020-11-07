FILE_NAME=$1
INITIAL_RULE=$2
TEST_FILE=$3
TEST_RIG_PARAM=$4

java org.antlr.v4.Tool "${FILE_NAME}.g4" -o out
find ./out -type f -name "*.java" | xargs javac
cd out
java org.antlr.v4.gui.TestRig $FILE_NAME $INITIAL_RULE "../${TEST_FILE}" $TEST_RIG_PARAM