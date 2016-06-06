%{
#include "brainfuck.tab.h"
#include <string.h>
#include <stdlib.h>

void error()
{
  fprintf(stdout, "Grammar error. Line: %d\n", yylineno);
  exit(1);
}

%}

INT     [0-9]+
ID      [A-Za-z][A-Za-z0-9]*

%%
">" {
  yylval=1;
  return POINTER;
}

"<" {
  yylval=-1;
  return POINTER;
}

"+" {
  yylval=1;
  return VALUE;
}

"-" {
  yylval=-1;
  return VALUE;
}

"[" {
  return LOOP_BEGIN;
}

"]" {
  return LOOP_END;
}
"," {
  return INPUT;
}

"." {
  return OUTPUT;
}

[ \t] { /* Do nothing */ }

[\n] { return yytext[0]; }

. { yylval=yytext[0]; return COMMENT; }

%%
