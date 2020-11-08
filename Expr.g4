grammar Expr;
options {
    language=Java;
}

@members {
    // declare java variables here
}

DIGIT : '0'..'9'+;
TEXT : ('a'..'z' | 'A'..'Z')+;
NEWLINE: '\r'? '\n';
NUMBER: DIGIT+ ('.' DIGIT+)?;

ARITHMETIC_OPERATORS: '+' | '-' | '*' | '/' |;
ARITHMETIC_OPERATORATION : (NUMBER ARITHMETIC_OPERATORS ARITHMETIC_OPERATORS)(ARITHMETIC_OPERATORS NUMBER)*;

RELATIONAL_OPERATORS: '=' | '<>' | '<' | '>' | '<=' | '>=';
RELATIONAL_OPERATORATION: NUMBER RELATIONAL_OPERATORS NUMBER;

prog: stat+;
stat: ARITHMETIC_OPERATORATION |
      RELATIONAL_OPERATORATION |
      NUMBER |
      TEXT
      ;
