shopt -s expand_aliases
source ~/.bashrc

FILE_NAME=$1
INITIAL_RULE=$2
TEST_FILE=$3
TEST_RIG_PARAM=$4

antlr4 "${FILE_NAME}.g4" -o out
find ./out -type f -name "*.java" | xargs javac
cd out
grun $FILE_NAME $INITIAL_RULE "../${TEST_FILE}" $TEST_RIG_PARAM