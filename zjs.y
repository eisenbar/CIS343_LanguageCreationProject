%{
  #include <stdio.h>
  #include <errno.h>
  #include <stdlib.h>
  #include "zjs.h"

  int yylex();
  int yyerror(const char* err);
  extern FILE* yyin;
%}

%union{
 int intVal;
 int floatVal;
}

//All the valid tokens within our grammar
%token END
%token END_STATEMENT
%token LINE
%token POINT
%token CIRCLE
%token RECTANGLE
%token SET_COLOR
%token <intVal> INT
%token <floatVal> FLOAT

%%

/***********************************
* All of my error handling will be done as the
*tokens are being parsed.
*This portion will also call the function from the
*header file.
***********************************/

program:        list_of_expr END
	;

list_of_expr:	expr
	|	list_of_expr
	;

expr:	line
    |	point
    |   circle
    |   rectangle
    |   set_color
    ;

line: LINE INT INT INT INT END_STATEMENT	{
	if($2 >= 0 && $2 <= WIDTH && $3 >= 0 && $3 <= HEIGHT && $4 >= 0 && $4 <= WIDTH && $5 >= 0 && $5<= HEIGHT){
		line($2, $3, $4, $5);
	}
	else {
		yyerror("ERROR: LINE, points must be between %d and %d\n", WIDTH, HEIGHT);
	}
    }
    ;

point: POINT INT INT END_STATEMENT		{
    	if ($2 >= 0 && $2 <= WIDTH && $3 >= 0 && $3 <= HEIGHT){
		point($2, $3);
	}
	else{
		yyerror("ERROR: POINT, points must be between %d and %d\n", WIDTH, HEIGHT);
	}
    }
    ;

circle: CIRCLE INT INT INT END_STATEMENT        {
	if( $2 >= 0 && $2 <= WIDTH && $3 >= 0 && $3 <= HEIGHT && $4 >= 0 && $4 <= WIDTH ){
		circle($2, $3, $4);
	}
	else{
		yyerror("ERROR: CIRCLE, points must be between %d and %d\n", WIDTH, HEIGHT);
	}
    }
    ;

rectangle: RECTANGLE INT INT INT INT END_STATEMENT  {
	if( $2 >= 0 && $2 <= WIDTH && $3 >= 0 && $3 <= HEIGHT && $4 >= 0 && $4 <= WIDTH && $5 >= 0 && $5<= HEIGHT){
		rectangle($2, $3, $4, $5);
	}
	else{
                yyerror("ERROR: RECTANGLE, points must be between %d and %d\n", WIDTH, HEIGHT);
        }
    }
    ;

set_color: SET_COLOR INT INT INT END_STATEMENT  {
	if ($2 >= 0 && $2 <= 255 && $3 >= 0 && $3 <= 255 && $4 >= 0 && $4 <= 255) {
    		set_color($2, $3, $4);
	}
	else{
		yyerror("ERROR: SET_COLOR, numbers have to be between 0 and 225\n");
	}
    }
    ;

%%


//main function
int main(int argc, char** argv){
	setup();
	yyin = fopen(argv[1], "r");

	//checks if yyin can be opened
	if(!yyin){
	 fclose(yyin);
	 yyerror("ERROR: Could not open file in main!");
	 return 1;
	}
	yyparse();
	finish();
	return 0;
	
}

//error function
int yyerror(const char* err){
	printf("s\n", err);
	return 1;
}
