grammar Expr;

options {
	language=Java;
}

@header {
package br.unisinos.tradutores.generated;
import java.util.HashMap;
}

@members {
    HashMap attributions = new HashMap();
}

program:      statement+;
statement:    (
                (
                    while_stat |
                    if_stat |
                    arithmetic_op |
                    relational_op |
                    NUMBER |
                    attribution_operation |
                )SEMICOLON
              );

arithmetic_op returns [ double v ]: (e = do_arithmetic_operation SPACES*);

attribution_operation: TEXT ATTRIBUTION_SYMBOL (e = arithmetic_op)
    ;

do_arithmetic_operation returns [ double v ]:
	    NUMBER (
	        SUM_OP e = do_arithmetic_operation |
            SUB_OP e = do_arithmetic_operation |
            MULT_OP e = do_arithmetic_operation |
            DIV_OP e = do_arithmetic_operation
	    ) |
	    TEXT (
            SUM_OP e = do_arithmetic_operation |
            SUB_OP e = do_arithmetic_operation |
            MULT_OP e = do_arithmetic_operation |
            DIV_OP e = do_arithmetic_operation
        ) |
	    NUMBER |
	    '(' do_arithmetic_operation ')' |
	    '(' do_arithmetic_operation ')' (
            SUM_OP e = do_arithmetic_operation |
            SUB_OP e = do_arithmetic_operation |
            MULT_OP e = do_arithmetic_operation |
            DIV_OP e = do_arithmetic_operation
         )|
	    TEXT
    ;

relational_op returns [ boolean cond ] : (e = do_relational_operation SPACES*) ;

do_relational_operation returns [ boolean cond, double value ] :
        NUMBER (
            EQ e = do_arithmetic_operation | DIF e = do_arithmetic_operation |
            SM e = do_arithmetic_operation  | SMALLER_EQ e = do_arithmetic_operation |
            BIG e = do_arithmetic_operation | BIGGER_EQ e = do_arithmetic_operation |
        ) |
        TEXT (
            EQ e = do_arithmetic_operation | DIF e = do_arithmetic_operation |
            SM e = do_arithmetic_operation  | SMALLER_EQ e = do_arithmetic_operation |
            BIG e = do_arithmetic_operation | BIGGER_EQ e = do_arithmetic_operation |
        ) |
        NUMBER
;

while_stat: WHILE relational_op DO statement+ END;
if_stat: IF relational_op THEN statement+ (END | (else_stat)?);
else_stat: ELSE statement+ END;

IF: 'if';
THEN: 'then';
ELSE: 'else';
WHILE: 'while';
DO: 'do';
END: 'end';
NUMBER: DIGIT+ ('.' DIGIT+)?;
DIGIT: '0'..'9';
TEXT : ('a'..'z' | 'A'..'Z')+;
SEMICOLON: ';';
SPACES: [ \u000B\t\r\n] -> channel(HIDDEN);

ATTRIBUTION_SYMBOL : ':=';

SUM_OP: '+';
SUB_OP: '-';
MULT_OP: '*';
DIV_OP: '/';

EQ: '=';
DIF: '<>';
SM: '<';
SMALLER_EQ: '<=';
BIG: '>';
BIGGER_EQ: '>=';
