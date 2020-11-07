grammar Expr;
INT : '0'..'9'+;
sum: INT '+' INT NEWLINE;
sub: INT '-' INT NEWLINE;
NEWLINE: '\r'? '\n';
prog: stat+;
stat: sum {System.out.println("soma");} | sub;
