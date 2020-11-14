# antlr setup
export CLASSPATH=".:/usr/local/lib/antlr-4.8-complete.jar:$CLASSPATH"
alias antlr4='java -jar /usr/local/lib/antlr-4.8-complete.jar'
alias grun='java org.antlr.v4.gui.TestRig'

TEST_FILE=$1
TEST_RIG_PARAM=$2

mvn generate-sources install
find ./target/classes -type f -name "*.java" | xargs javac
cd target/classes
grun "br.unisinos.tradutores.generated.Expr" program "../../${TEST_FILE}" $TEST_RIG_PARAM
