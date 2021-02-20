%{ 
#include<stdio.h> 
#include<math.h>

extern FILE *yyin;
extern int temp;

FILE *fp_out;

int errFlag=0;
int exitFlag=0;
int nilFlag=0;
int printFlag=1;
int isList=0;
int boolFlag=0;
int arr[999];
int ind1=0;
int ind2=0;
int noRes=0;

%} 

%token KW_AND
%token KW_OR
%token KW_NOT   
%token KW_EQUAL
%token KW_LESS
%token KW_NIL
%token KW_LIST
%token KW_APPEND
%token KW_CONCAT
%token KW_SET
%token KW_DEFFUN
%token KW_DEFVAR
%token KW_FOR
%token KW_WHILE
%token KW_IF
%token KW_EXIT 
%token KW_LOAD
%token KW_TRUE
%token KW_FALSE
%token OP_PLUS
%token OP_MINUS
%token OP_DIV
%token OP_MULT
%token OP_OP
%token OP_CP
%token OP_DBLMULT
%token OP_OC
%token OP_CC
%token OP_COMMA
%token OP_LIST
%token COMMENT
%token VALUE
%token IDENTIFIER
%token NEWLINE
%start START

%% 

START: | INPUT{ 
	if(errFlag == 0 && exitFlag ==0){
		printf("Syntax OK.\n");
		fprintf(fp_out, "Syntax OK.\n");

		if(!noRes){
			int res = $$;

			if(isList == 1){

				printf("Result: ");
				fprintf(fp_out, "Result: ");
			    
			    printf("(");
			    fprintf(fp_out, "(");

			    for(int i=0;i<ind1;++i){
			        if(i == (ind1-1)){
			            printf("%d", arr[i]);
			            fprintf(fp_out, "%d", arr[i]);
			        }
			        else{
			            printf("%d ",arr[i]);
			            fprintf(fp_out, "%d ", arr[i]);
			        }
			    }
			    printf(") \n\n");
			    fprintf(fp_out, ") \n\n");

			    ind1=0;
			    
			    ind2=0;
			    isList=0;			
			}
			else if(boolFlag == 1){
				if(nilFlag){
					printf("Result: NIL \n\n");
					fprintf(fp_out, "Result: NIL \n\n");
					nilFlag=0;
				}else{
				    if(res == 1){
					    printf("Result: T \n\n");
					    fprintf(fp_out, "Result: T \n\n");
				    }
				    else{
				        printf("Result: NIL \n\n");
				        fprintf(fp_out, "Result: NIL \n\n");
				    }
				    //boolFlag=0;		
				}
				boolFlag=0;
			}
			else{
				if(printFlag){
					printf("Result: %d\n\n", res);
					fprintf(fp_out, "Result: %d\n\n", res);	
				}
				else{
					printFlag=1;	
					printf("\n");
					fprintf(fp_out, "\n");
				}
			}
		}
		else{
			noRes=0;
			printf("\n");
			fprintf(fp_out, "\n");
		}
	}
	return 0;};

INPUT: EXPI | EXPLISTI | EXPB{ boolFlag=1; } | EXIT;

EXPI: OP_OP OP_PLUS EXPI EXPI OP_CP { $$=$3+$4; }
	| OP_OP OP_MINUS EXPI EXPI OP_CP { $$=$3-$4; }		
	| OP_OP OP_MULT EXPI EXPI OP_CP { $$=$3*$4; } 
	| OP_OP OP_DIV EXPI EXPI OP_CP { $$=$3/$4; } 	
	| OP_OP OP_DBLMULT EXPI EXPI OP_CP { $$=pow($3,$4); } 
	| IDENTIFIER { $$=1; printFlag=0;}
	| VALUE { $$=$1; }	
	| OP_OP IDENTIFIER EXPLISTI OP_CP { 
	    isList=1;
	    $$=$3; 
	}	
	| OP_OP KW_SET IDENTIFIER EXPI OP_CP { $$=$4; }	
	| OP_OP KW_DEFFUN IDENTIFIER IDLIST EXPLISTI OP_CP{
	    isList=1;
	    $$=$5;
	}	
	| OP_OP KW_IF EXPB EXPLISTI OP_CP { 
	    isList=1;
	    $$=$3; 
	    if($$ == 0){ /*????????*/
	        ind1=0;
	        arr[0]=NULL;
	    }
	}	
	| OP_OP KW_IF EXPB EXPLISTI EXPLISTI OP_CP{ 
	    isList=1;
	    $$=$3;
	    if($$ == 1){ /*????*/
	        ind1=ind2;
	    }
	    else{
	        ind1 -= ind2;
	        for(int i=0;i<ind1;++i){
	            arr[i]=arr[ind2+i];
	        }
	    }
	}	
	| OP_OP KW_WHILE EXPB EXPLISTI OP_CP{ 
	    isList=1;
	    $$=$3; 
	    if($$ == 0){
	        ind1=0;
	        arr[0]=NULL;
	    }
	}
	| OP_OP KW_FOR OP_OP IDENTIFIER EXPI EXPI OP_CP EXPLISTI OP_CP{
	    isList=1;
	}
	| OP_OP KW_DEFVAR IDENTIFIER EXPI OP_CP { $$=$4; } 	
	| OP_OP KW_LIST VALUES OP_CP{
	    isList=1;
	    $$=1; 
	}
	| OP_OP KW_LOAD OP_OC IDENTIFIER OP_CC OP_CP { $$=1; printFlag=0; } /*?*/
	| COMMENT { 
	    printf("COMMENT\n"); 
	    fprintf(fp_out, "COMMENT\n");
	    noRes=1;
	}
	| OP_OP KW_EXIT OP_CP {
		noRes=1;
	}
;

EXPLISTI: OP_OP KW_CONCAT EXPLISTI EXPLISTI OP_CP{
		    isList=1;
		    $$=1; 
		}
	| OP_OP KW_APPEND EXPI EXPLISTI OP_CP{
	    $$=1;

	    for(int i=ind1-1; i>-1; --i)
	    	arr[i+1] = arr[i];
	    arr[0] = $3;
	
	    isList=1;
	    ++ind1;
	}
	| LISTVALUE{$$=1;}
;

EXPB: OP_OP KW_AND EXPB EXPB OP_CP { $$=$3&&$4; } 
	| OP_OP KW_OR EXPB EXPB OP_CP { $$=$3||$4; } 
	| OP_OP KW_NOT EXPB OP_CP { $$=!$3; } 
	| OP_OP KW_EQUAL EXPB EXPB OP_CP { $$=($3==$4); } 
	| OP_OP KW_EQUAL EXPI EXPI OP_CP { $$=($3==$4); } 
	| BinaryValue{$$=$1;};
	| OP_OP KW_LESS EXPI EXPI OP_CP { $$=($3<$4); } /*????????*/
;

LISTVALUE: OP_LIST VALUES OP_CP{
	    isList=1;
	    if(ind2==0)
	        ind2=ind1;
	}
	| OP_LIST OP_CP {
	    isList=1;
	    $$ = ind1 = 0;
	}
	| KW_NIL{$$=0; boolFlag=1; nilFlag=1; };
;

VALUES: VALUES VALUE  {
	    arr[ind1++]=$2;
	}
	| VALUE {
	    arr[ind1++]=$1;
	}
;

BinaryValue: KW_TRUE { $$=1; }
	| KW_FALSE { $$=0; }
;

IDLIST: OP_OP IDENT_LIST OP_CP;

IDENT_LIST: IDENT_LIST IDENTIFIER | IDENTIFIER;

EXIT: NEWLINE { noRes=1; exitFlag=1; return 0; };

%%

int main(int argc, char *argv[]){ 
    fp_out = fopen ("parsed_cpp.txt", "w");

    if(argc == 1){
        yyin = stdin;
		while(exitFlag == 0)	
			yyparse();        
    }
    else if(argc == 2){
        yyin = fopen(argv[1], "r"); 

        if(yyin == NULL){
            printf("File could not opened.\n");
            return -1;
        }

		while(exitFlag == 0){
			yyparse();        
		}
    }
    else
        printf("You entered wrong command line.\n");

    return 0;
}

int yyerror(const char * ch) 
{ 
    errFlag=1;
    exitFlag=1; /* ?????? hata gelince ciksin mi*/
	printf("\nSYNTAX_ERROR Expression not recognized\n"); 
	printf(fp_out, "\nSYNTAX_ERROR Expression not recognized\n"); 
}
