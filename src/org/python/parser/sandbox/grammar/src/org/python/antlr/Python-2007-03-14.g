/*
Changes
Copyright (c) 2007 Jim Baker
+ any other contributors

same-old BSD license stuff

Objective: construct generational grammar to represent desired AST
Let's freely using node copying to make visiting super simple

May want to emulate existing CPython AST as much as possible, however;
not certain if there's really much payoff in doing so with Jython AST
stuff, however. BUT TRYING TO DO SO!

Another concern: the Terence/Loring parser is overly permissive in
terms of the Python syntax it will accept, e.g.,

F(10)^2 = 20
- or do we just do this during compilation...

which neither makes sense or legal!

So need to fix that, instead of raising problem in compilation phase.

*/

/*
 [The 'BSD licence']
 Copyright (c) 2004 Terence Parr and Loring Craymer
 All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions
 are met:
 1. Redistributions of source code must retain the above copyright
    notice, this list of conditions and the following disclaimer.
 2. Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in the
    documentation and/or other materials provided with the distribution.
 3. The name of the author may not be used to endorse or promote products
    derived from this software without specific prior written permission.

 THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
 INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

/** Beginning of Python 2.5 Grammar, Jim Baker, based on
 *
 *  Python 2.3.3 Grammar
 *
 *  Terence Parr and Loring Craymer
 *  February 2004
 *
 *  Converted to ANTLR v3 November 2005 by Terence Parr.
 *
 *  This grammar was derived automatically from the Python 2.3.3
 *  parser grammar to get a syntactically correct ANTLR grammar
 *  for Python.  Then Terence hand tweaked it to be semantically
 *  correct; i.e., removed lookahead issues etc...  It is LL(1)
 *  except for the (sometimes optional) trailing commas and semi-colons.
 *  It needs two symbols of lookahead in this case.
 *
 *  Starting with Loring's preliminary lexer for Python, I modified it
 *  to do my version of the whole nasty INDENT/DEDENT issue just so I
 *  could understand the problem better.  This grammar requires
 *  PythonTokenStream.java to work.  Also I used some rules from the
 *  semi-formal grammar on the web for Python (automatically
 *  translated to ANTLR format by an ANTLR grammar, naturally <grin>).
 *  The lexical rules for python are particularly nasty and it took me
 *  a long time to get it 'right'; i.e., think about it in the proper
 *  way.  Resist changing the lexer unless you've used ANTLR a lot. ;)
 *
 *  I (Terence) tested this by running it on the jython-2.1/Lib
 *  directory of 40k lines of Python.
 *
 *  REQUIRES ANTLR v3
 */
grammar Python;

options {
    ASTLabelType=CommonTree;
    language=Java;
    output=AST;
}


tokens {
    INDENT;
    DEDENT;

    Module;
    Name; Body;
    Decorators; Decorator;
    ClassDef; Bases; 
    FunctionDef;
    Expr;
    Args;
    If; Test;
    OrElse; /* follow Python.asdl in naming... */
    Elif; /* is this even necessary? check the CPython AST... */
    With; Context;
    Try; Except; Finally;
    For; Target; Iter;
    Body;
    While; 
    Pass; Print;
    Return; Yield; 
    Decorator;

    LONG_INTEGER;
}

@header { 
package org.python.antlr;
} 

@lexer::header { 
package org.python.antlr;
} 


@lexer::members {
/** Handles context-sensitive lexing of implicit line joining such as
 *  the case where newline is ignored in cases like this:
 *  a = [3,
 *       4]
 */
int implicitLineJoiningLevel = 0;
int startPos=-1;
}

module
    : file_input -> ^(Module file_input) 
    ;

single_input
    : NEWLINE
	| simple_stmt
	| compound_stmt NEWLINE
	;

file_input
    :   (NEWLINE | stmt)*
	;

eval_input
    :   (NEWLINE)* testlist (NEWLINE)*
	;

/* add decorators */
funcdef
    :  decorator* 'def' NAME parameters COLON suite
    -> ^(FunctionDef ^(Name NAME) ^(Args parameters) ^(Decorators decorator*) ^(Body suite))
/*	{System.out.println("found method def "+$NAME.text);} */
	;

/* do decorators require a newline? */
decorator
    :   ATSIGN NAME parameters? NEWLINE
    ->  ^(Decorator ^(Name NAME) ^(Args parameters?))
    ;

parameters
    :   LPAREN (varargslist)? RPAREN
	;

varargslist
    :   defparameter (options {greedy=true;}:COMMA defparameter)*
        (COMMA
            ( STAR NAME (COMMA DOUBLESTAR NAME)?
            | DOUBLESTAR NAME
            )?
        )?
    |   STAR NAME (COMMA DOUBLESTAR NAME)?
    |   DOUBLESTAR NAME
    ;

defparameter
    :   fpdef (ASSIGN test)?
    ;

fpdef
    :   NAME
	|   LPAREN fplist RPAREN
	;

fplist
    :   fpdef (options {greedy=true;}:COMMA fpdef)* (COMMA)?
	;


stmt: simple_stmt
	| compound_stmt
	;

simple_stmt
    :   small_stmt (options {greedy=true;}:SEMI small_stmt)* (SEMI)? NEWLINE
	;

small_stmt: expr_stmt
	| print_stmt
	| del_stmt
	| pass_stmt
	| flow_stmt
	| import_stmt
	| global_stmt
	| exec_stmt
	| assert_stmt
	;

/* Need to write this to distinguish assignment from just evaluating
   an expression. Also an Expr needs to be further unpacked, such as
   dotted names, function application, etc.

   augassign is not quite right, it's just one of a possible assignment

*/

expr_stmt
	: lhs=exprlist (augassign rhs=exprlist)?
    -> ^(Expr augassign? $lhs $rhs?)
	;

augassign
    : PLUSEQUAL
	| MINUSEQUAL
	| STAREQUAL
	| SLASHEQUAL
	| PERCENTEQUAL
	| AMPEREQUAL
	| VBAREQUAL
	| CIRCUMFLEXEQUAL
	| LEFTSHIFTEQUAL
	| RIGHTSHIFTEQUAL
	| DOUBLESTAREQUAL
	| DOUBLESLASHEQUAL
    | ASSIGN
	;

/* IMSM: there's some interesting logic here, but for now we're going to keep it simple! */

print_stmt
    :   'print  '
    (   testlist
    |   RIGHTSHIFT testlist
    )?
/* 	-> ^(Print testlist)  */
    ;

del_stmt: 'del' exprlist
	;

pass_stmt: 'pass' -> ^(Pass)
	;

flow_stmt: break_stmt
	| continue_stmt
	| return_stmt
	| raise_stmt
	| yield_stmt
	;

break_stmt: 'break'
	;

continue_stmt: 'continue'
	;

return_stmt: 'return' (testlist)?
    -> ^(Return testlist)
	;

yield_stmt: 'yield' testlist
    -> ^(Yield testlist)
	;

raise_stmt: 'raise' (test (COMMA test (COMMA test)?)?)?
	;

import_stmt
    :   'import' dotted_as_name (COMMA dotted_as_name)*
	|   'from' dotted_name 'import'
        (STAR | import_as_name (COMMA import_as_name)*)
	;

import_as_name
    :   NAME (NAME NAME)?
	;

dotted_as_name: dotted_name (NAME NAME)?
	;

dotted_name: NAME (DOT NAME)*
    -> ^(Name NAME*)
	;

global_stmt: 'global' NAME (COMMA NAME)*
	;

exec_stmt: 'exec' expr ('in' test (COMMA test)?)?
	;

assert_stmt: 'assert' test (COMMA test)?
	;


compound_stmt: if_stmt
	| while_stmt
	| for_stmt
    | with_stmt
	| try_stmt
	| funcdef
	| classdef
	;

/* exprlist is too broad, since we can't do arbitrary functions here,
   however we can arbitrary tuple unpacking */

for_stmt: 'for' exprlist 'in' testlist COLON body=suite ('else' COLON else_suite=suite)?
    -> ^(For ^(Target exprlist) ^(Iter testlist) ^(Body $body) ^(OrElse $else_suite)?)
	;

while_stmt: 'while' test COLON body=suite ('else' COLON else_suite=suite)?
    -> ^(While ^(Test test) ^(Body $body) ^(OrElse $else_suite)?)
	;

if_stmt: 'if' test COLON body=suite ('elif' test COLON elif_suite=suite)* ('else' COLON else_suite=suite)?
    -> ^(If ^(Test test) ^(Body $body) ^(Elif $elif_suite)* ^(OrElse $else_suite)?)
	;

with_stmt: 'with' context=exprlist ('as' args=exprlist)? COLON body=suite
    -> ^(With ^(Context $context) ^(Target $args) ^(Body $body))
    ;

try_stmt
    :   'try' COLON try_suite=suite
        except_clauses
        ('else' COLON else_suite=suite)?
        'finally' COLON finally_suite=suite
    -> ^(Try $try_suite ^(Except except_clauses) ^(OrElse $else_suite) ^(Finally $finally_suite))
	;

except_clauses
    : (except_clause COLON suite)+ 
    ;

except_clause: 'except' (test (COMMA test)?)?
	;

suite: simple_stmt
	| NEWLINE INDENT (stmt)+ DEDENT
	;


test: and_test ('or' and_test)*
	| lambdef
	;

and_test
	: not_test ('and' not_test)*
	;

not_test
	: 'not' not_test
	| comparison
	;

comparison: expr (comp_op expr)*
	;

comp_op: LESS
	|GREATER
	|EQUAL
	|GREATEREQUAL
	|LESSEQUAL
	|ALT_NOTEQUAL
	|NOTEQUAL
	|'in'
	|'not' 'in'
	|'is'
	|'is' 'not'
	;

expr: xor_expr (VBAR^ xor_expr)*
	;

xor_expr: and_expr (CIRCUMFLEX^ and_expr)*
	;

and_expr: shift_expr (AMPER^ shift_expr)*
	;

shift_expr: arith_expr ((LEFTSHIFT|RIGHTSHIFT)^ arith_expr)*
	;

arith_expr: term ((PLUS|MINUS)^ term)*
/*    -> ^((PLUS|MINUS) term term) */
	;

term: factor ((STAR | SLASH | PERCENT | DOUBLESLASH )^ factor)*
	;

factor
	: (PLUS|MINUS|TILDE)^ factor
	| power
	;

power
	:   atom (trailer)* (options {greedy=true;}:DOUBLESTAR factor)?
	;

atom: LPAREN (testlist)? RPAREN
	| LBRACK (listmaker)? RBRACK
	| LCURLY (dictmaker)? RCURLY
	| BACKQUOTE testlist BACKQUOTE
	| NAME
	| INT
    | LONGINT
    | FLOAT
    | COMPLEX
	| (STRING)+
	;

listmaker: test ( list_for | (options {greedy=true;}:COMMA test)* ) (COMMA)?
	;

lambdef: 'lambda' (varargslist)? COLON test
	;

trailer: LPAREN (arglist)? RPAREN
	| LBRACK subscriptlist RBRACK
	| DOT NAME
	;

subscriptlist
    :   subscript (options {greedy=true;}:COMMA subscript)* (COMMA)?
	;

subscript
	: DOT DOT DOT
    | test (COLON (test)? (sliceop)?)?
    | COLON (test)? (sliceop)?
    ;

sliceop: COLON (test)?
	;

/* the problem here is, we need to either construct a tuple or scalar;
   this is based on wthe comma operator itself; but can we do this in
   a subsequent tree grammar, or in the compilation phase, looking at
   the cardinality of the list?  probably that's the best option!

   not certain how CPython does it yet
*/

exprlist
    :   expr (options {k=2;}:COMMA expr)* (COMMA)?
	;

testlist
    :   test (options {k=2;}: COMMA test)* (COMMA)?
    ;

dictmaker
    :   test COLON test
        (options {k=2;}:COMMA test COLON test)* (COMMA)?
    ;

classdef: 'class' NAME (LPAREN testlist RPAREN)? COLON suite
    -> ^(ClassDef ^(Name NAME) ^(Bases testlist) ^(Body suite))
/*	{System.out.println("found class def "+$NAME.text);} */
	;

arglist: argument (COMMA argument)*
        ( COMMA
          ( STAR test (COMMA DOUBLESTAR test)?
          | DOUBLESTAR test
          )?
        )?
    |   STAR test (COMMA DOUBLESTAR test)?
    |   DOUBLESTAR test
    ;

argument : test (ASSIGN test)?
         ;

list_iter: list_for
	| list_if
	;

list_for: 'for' exprlist 'in' testlist (list_iter)?
	;

list_if: 'if' test (list_iter)?
	;

LPAREN	: '(' {implicitLineJoiningLevel++;} ;

RPAREN	: ')' {implicitLineJoiningLevel--;} ;

LBRACK	: '[' {implicitLineJoiningLevel++;} ;

RBRACK	: ']' {implicitLineJoiningLevel--;} ;

ATSIGN  : '@' ;

COLON 	: ':' ;

COMMA	: ',' ;

SEMI	: ';' ;

PLUS	: '+' ;

MINUS	: '-' ;

STAR	: '*' ;

SLASH	: '/' ;

VBAR	: '|' ;

AMPER	: '&' ;

LESS	: '<' ;

GREATER	: '>' ;

ASSIGN	: '=' ;

PERCENT	: '%' ;

BACKQUOTE	: '`' ;

LCURLY	: '{' {implicitLineJoiningLevel++;} ;

RCURLY	: '}' {implicitLineJoiningLevel--;} ;

CIRCUMFLEX	: '^' ;

TILDE	: '~' ;

EQUAL	: '==' ;

NOTEQUAL	: '!=' ;

ALT_NOTEQUAL: '<>' ;

LESSEQUAL	: '<=' ;

LEFTSHIFT	: '<<' ;

GREATEREQUAL	: '>=' ;

RIGHTSHIFT	: '>>' ;

PLUSEQUAL	: '+=' ;

MINUSEQUAL	: '-=' ;

DOUBLESTAR	: '**' ;

STAREQUAL	: '*=' ;

DOUBLESLASH	: '//' ;

SLASHEQUAL	: '/=' ;

VBAREQUAL	: '|=' ;

PERCENTEQUAL	: '%=' ;

AMPEREQUAL	: '&=' ;

CIRCUMFLEXEQUAL	: '^=' ;

LEFTSHIFTEQUAL	: '<<=' ;

RIGHTSHIFTEQUAL	: '>>=' ;

DOUBLESTAREQUAL	: '**=' ;

DOUBLESLASHEQUAL	: '//=' ;

DOT : '.' ;

FLOAT
	:	'.' DIGITS (Exponent)?
    |   DIGITS ('.' (DIGITS (Exponent)?)? | Exponent)
    ;

long_integer
    :   LONGINT -> ^(LONG_INTEGER LONGINT)
    ;

LONGINT
    :   INT ('l'|'L')
    ;



fragment
Exponent
	:	('e' | 'E') ( '+' | '-' )? DIGITS
	;

INT :   // Hex
        '0' ('x' | 'X') ( '0' .. '9' | 'a' .. 'f' | 'A' .. 'F' )+
        ('l' | 'L')?
    |   // Octal
        '0' DIGITS*
    |   '1'..'9' DIGITS*
    ;

COMPLEX
    :   INT ('j'|'J')
    |   FLOAT ('j'|'J')
    ;

fragment
DIGITS : ( '0' .. '9' )+ ;

NAME:	( 'a' .. 'z' | 'A' .. 'Z' | '_')
        ( 'a' .. 'z' | 'A' .. 'Z' | '_' | '0' .. '9' )*
    ;

/** Match various string types.  Note that greedy=false implies '''
 *  should make us exit loop not continue.
 */
STRING
    :   ('r'|'u'|'ur')?
        (   '\'\'\'' (options {greedy=false;}:.)* '\'\'\''
        |   '"""' (options {greedy=false;}:.)* '"""'
        |   '"' (ESC|~('\\'|'\n'|'"'))* '"'
        |   '\'' (ESC|~('\\'|'\n'|'\''))* '\''
        )
	;

fragment
ESC
	:	'\\' .
	;

/** Consume a newline and any whitespace at start of next line */
CONTINUED_LINE
	:	'\\' ('\r')? '\n' (' '|'\t')* { $channel=HIDDEN; }
	;

/** Treat a sequence of blank lines as a single blank line.  If
 *  nested within a (..), {..}, or [..], then ignore newlines.
 *  If the first newline starts in column one, they are to be ignored.
 */
NEWLINE
    :   (('\r')? '\n' )+
        {if ( startPos==0 || implicitLineJoiningLevel>0 )
            $channel=HIDDEN;
        }
    ;

WS	:	{startPos>0}?=> (' '|'\t')+ {$channel=HIDDEN;}
	;
	
/** Grab everything before a real symbol.  Then if newline, kill it
 *  as this is a blank line.  If whitespace followed by comment, kill it
 *  as it's a comment on a line by itself.
 *
 *  Ignore leading whitespace when nested in [..], (..), {..}.
 */
LEADING_WS
@init {
    int spaces = 0;
}
    :   {startPos==0}?=>
    	(   {implicitLineJoiningLevel>0}? ( ' ' | '\t' )+ {$channel=HIDDEN;}
       	|	( 	' '  { spaces++; }
        	|	'\t' { spaces += 8; spaces -= (spaces \% 8); }
       		)+
        	{
            // make a string of n spaces where n is column number - 1
            char[] indentation = new char[spaces];
            for (int i=0; i<spaces; i++) {
                indentation[i] = ' ';
            }
            String s = new String(indentation);
            emit(new ClassicToken(LEADING_WS,new String(indentation)));
        	}
        	// kill trailing newline if present and then ignore
        	( ('\r')? '\n' {if (token!=null) token.setChannel(99); else $channel=HIDDEN;})*
           // {token.setChannel(99); }
        )

/*
        |   // if comment, then only thing on a line; kill so we
            // ignore totally also wack any following newlines as
            // they cannot be terminating a statement
            '#' (~'\n')* ('\n')+ 
            {if (token!=null) token.setChannel(99); else $channel=HIDDEN;}
        )?
        */
    ;

/** Comments not on line by themselves are turned into newlines.

    b = a # end of line comment

    or

    a = [1, # weird
         2]

    This rule is invoked directly by nextToken when the comment is in
    first column or when comment is on end of nonwhitespace line.

	Only match \n here if we didn't start on left edge; let NEWLINE return that.
	Kill if newlines if we live on a line by ourselves
	
	Consume any leading whitespace if it starts on left edge.
 */
COMMENT
@init {
    $channel=HIDDEN;
}
    :	{startPos==0}?=> (' '|'\t')* '#' (~'\n')* '\n'+
    |	{startPos>0}?=> '#' (~'\n')* // let NEWLINE handle \n unless char pos==0 for '#'
    ;
