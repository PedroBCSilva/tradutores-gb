grammar Expr;

options {
	language=Java;
}

@header {
import java.util.HashMap;
}

@members {
    HashMap attributions = new HashMap();
}

arithmetic_op returns [ double v ]: (e = do_arithmetic_operation {$v = $e.v;} {System.out.println("Resultado: " + $v);}  NEWLINE*)+;

attribution_operation: TEXT ATTRIBUTION_SYMBOL (e = arithmetic_op {
                                                    attributions.put($TEXT.text, $e.v);
                                                    System.out.println("MAP: " + attributions.get($TEXT.text));
                                                  })
    ;

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
      TEXT |
      attribution_operation
      ;

NUMBER: DIGIT+ ('.' DIGIT+)?;
DIGIT: '0'..'9';
TEXT : ('a'..'z' | 'A'..'Z')+;
NEWLINE: '\r'? '\n';

ATTRIBUTION_SYMBOL : ':=';

SUM_OP: '+';
SUB_OP: '-';
MULT_OP: '*';
DIV_OP: '/';

RELATIONAL_OPERATORS: '=' | '<>' | '<' | '>' | '<=' | '>=';
RELATIONAL_OPERATORATION: NUMBER RELATIONAL_OPERATORS NUMBER;
