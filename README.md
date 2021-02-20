# GppInterpreter

A parser that accepts any set of valid G++ expressions and reject incorrect expressions. 
It checks if the input syntax is correct while generating the parse tree.
G++ programming language is Lisp like programming language and it is described in Gppsyntax.pdf file.  

It implemented two different ways: using Flex and Yacc, and in Lisp.  

You can run this program with following commands:  

## Part 1 - Lisp Interpreter  

clisp gpp_interpreter.lisp or clisp gpp_interpreter.lisp <file_name>  

## Part 2 - Yacc Interpreter  

There is a makefile in this part.  
  
make
./gpp_interpreter.out or ./gpp_interpreter.out <file_name> 
  
*In both part, if you enter file name as parameter, it reads file. Otherwise program enters into REPL mode.*  

You can check assignment file and report for more details and sample input/output.





