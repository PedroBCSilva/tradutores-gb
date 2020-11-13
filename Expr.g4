grammar Expr;

options {
	language=Java;
}

@header {
package br.unisinos;

import java.util.HashMap;
import br.unisinos.*;
}

@rulecatch {
    // ANTLR does not generate its normal rule try/catch
    catch(RecognitionException e) {
        throw e;
    }
}

@parser::members {
    HashMap attributions = new HashMap();
//    @Override
//    public void displayRecognitionError(String[] tokenNames, RecognitionException e) {
//        String hdr = getErrorHeader(e);
//        String msg = getErrorMessage(e, tokenNames);
//        throw new RuntimeException(hdr + ":" + msg);
//    }
}

@lexer::members {
//    @Override
//    public void displayRecognitionError(String[] tokenNames, RecognitionException e) {
//        String hdr = getErrorHeader(e);
//        String msg = getErrorMessage(e, tokenNames);
//        throw new RuntimeException(hdr + ":" + msg);
//    }
}

arithmetic_op returns [ double v ]: (e = do_arithmetic_operation {$v = $e.v;} {System.out.println("Resultado: " + $v);}  SPACES*)+;

attribution_operation: TEXT ATTRIBUTION_SYMBOL (e = arithmetic_op {
                                                    attributions.put($TEXT.text, $e.v);
                                                    System.out.println("MAP: " + attributions.get($TEXT.text));
                                                  }) |
                       TEXT ATTRIBUTION_SYMBOL TEXT {
                            attributions.put($ctx.getStart().getText(), $TEXT.text);
                            System.out.println("MAP: " + attributions.get($ctx.getStart().getText()));}
    ;

do_arithmetic_operation returns [ double v ]:
	    NUMBER {$v = Double.parseDouble( $NUMBER.text);} (
	        SUM_OP e = do_arithmetic_operation {$v += $e.v;} | 
            SUB_OP e = do_arithmetic_operation {$v -= $e.v;} | 
            MULT_OP e = do_arithmetic_operation {$v *= $e.v;} | 
            DIV_OP e = do_arithmetic_operation {$v /= $e.v;}
	    ) |
	    NUMBER {$v = Double.parseDouble($NUMBER.text);} |
	    '(' e = do_arithmetic_operation {$v = $e.v;} ')'
    ;

relational_op returns [ boolean cond ] : (e = do_relational_operation {$cond = $e.cond;} {System.out.println("Resultado: " + $cond);} SPACES*)+ ;

do_relational_operation returns [ boolean cond, double value ] :
        NUMBER {$value = Double.parseDouble($NUMBER.text);} (
            EQ e = do_arithmetic_operation {$cond = ($value == $e.v);} | DIF e = do_arithmetic_operation {$cond = ($value != $e.v);} |
            SM e = do_arithmetic_operation {$cond = ($value < $e.v);}  | SMALLER_EQ e = do_arithmetic_operation {$cond = ($value <= $e.v);} |
            BIG e = do_arithmetic_operation {$cond = ($value > $e.v);} | BIGGER_EQ e = do_arithmetic_operation {$cond = ($value >= $e.v);} |
        ) |
        NUMBER {$value = Double.parseDouble($NUMBER.text);}
;

program:      statement+;
statement:    (arithmetic_op |
              relational_op |
              attribution_operation |
              (NUMBER | TEXT))
              SEMICOLON;

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
