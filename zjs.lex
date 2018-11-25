%{
  #include <stdio.h>
  #include "zjs.h"
  #include "zjs.tab.h"

%}

%option noyywrap

%%

(end)          { return(END); }
(;)            { return(END_STATEMENT); }
(point)        { return(POINT); }
(line)         { return(LINE); }
(circle)       { return(CIRCLE); }
(rectangle)    { return(RECTANGLE); }
(setColor)     { return(SET_COLOR); }
[0-9]+         { return(INT); }
[0-9]+\.[0-9]+ { return(FLOAT); }
[\t|\s|\n]+    { ; }
.              { printf("ERROR: Invalid input: %s\n", yytext); }
%%

//Since this lex file has a compatible y file, there will be no main 
//function here. This lex file simply determines if input has valid tokens or not
