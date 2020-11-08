grammar Expr;

options {
	language=Java;
}

@members {
    // declare java variables here
}

arithmetic_op returns [ double v ]: (e = do_arithmetic_operation {$v = $e.v;} {System.out.println("Resultado: " + $v);}  NEWLINE*)+;

do_arithmetic_operation returns [ double v ]:
	    NUMBER {$v = Double.parseDouble( $NUMBER.text);} (
	        SUM_OP e = do_arithmetic_operation {$v += $e.v;} | SUB_OP e = do_arithmetic_operation {$v -= $e.v;} | MULT_OP e = do_arithmetic_operation {$v *= $e.v;} | DIV_OP e = do_arithmetic_operation {$v /= $e.v;}
	    ) |
	    NUMBER {$v = Double.parseDouble($NUMBER.text);} |
	    '(' e = do_arithmetic_operation {$v = $e.v;} ')'
    ;

prog: stat+;
stat: arithmetic_op |
      NUMBER |
      TEXT
      ;

NUMBER: DIGIT+ ('.' DIGIT+)?;
DIGIT: '0'..'9';
TEXT : ('a'..'z' | 'A'..'Z')+;
NEWLINE: '\r'? '\n';

SUM_OP: '+';
SUB_OP: '-';
MULT_OP: '*';
DIV_OP: '/';

RELATIONAL_OPERATORS: '=' | '<>' | '<' | '>' | '<=' | '>=';
RELATIONAL_OPERATORATION: NUMBER RELATIONAL_OPERATORS NUMBER;
