%{
#include <stdio.h>
#include <strings.h>
#define BUF_MAX 3000

//======================================= Define necesary functions

int pointerPos=0;

//--------------------------------------- Pointer handling functions
int pointerStack[BUF_MAX];
int stackIndex=-1;

int pointerPush(int pos){
  if(stackIndex>=BUF_MAX)
    return -1; // Error: stack overflow
  stackIndex++;
  pointerStack[stackIndex]=pos;
  return 1;
}

int pointerPop(){
  if(stackIndex==-1)
    return -1; // Error: empty stack
  int p = pointerStack[stackIndex];
  stackIndex--;
  return p;
}
//---------------------------------------- Indentation printer
int ind=1;

void printInd(){
  int i=0;
  for(i=0;i<ind;i++){
    printf("\t");
  }
}
//---------------------------------------- Print C file

void printHeader(){
  printf("\
#include <stdio.h>\n\
#define BUF_MAX 3000\n\
int buffer[BUF_MAX];\n\n\
int main(){\n \
\tint *ptr=&buffer[0];\n");
}

void printFooter(){
  printf("}\n");
}
//======================================== Start syntax definition

%}
// Declare tokens
%token POINTER VALUE INPUT OUTPUT LOOP_BEGIN LOOP_END COMMENT

%%

input:
    | input commands
    ;


pointer_ch : pointer_ch POINTER { $$ = $1 + $2 }
           | POINTER
           ;

value_ch : value_ch VALUE { $$ = $1 + $2 }
         | VALUE
         ;

commands : commands pointer_ch {
				pointerPos=pointerPos+$2;
				printInd();
				int chVal=$2;
				char sign='+';
				if(chVal!=0){
					if(chVal<0){
						sign='-';
						chVal*=(-1);
					}
					if(chVal==1) printf("ptr%c%c;\t\t",sign,sign);
					else printf("ptr%c=%d;\t\t",sign,chVal);
				}
				printf("//ptr=&buffer[%d]\n",pointerPos);
				}
	 | commands value_ch {
				printInd();
				int chVal=$2;
				char sign='+';
				if(chVal!=0){
					if(chVal<0){
						sign='-';
						chVal*=(-1);
					}
					if(chVal==1) printf("(*ptr)%c%c;\t\t//buffer[%d]%c%c\n",sign, sign, pointerPos,sign,sign);
					else printf("(*ptr)%c=%d;\t\t//buffer[%d]%c=%d\n",sign, chVal,pointerPos,sign,chVal);
				}
			     }
	 | commands INPUT {
				printInd();
				printf("(*ptr)=getchar();");
				printf("\t\t//buffer[%d]=getchar();",pointerPos);
				printf("\n");
				}
	 | commands OUTPUT {
				printInd();
				printf("putchar(*ptr);");
				printf("\t\t//putchar(buffer[%d]);",pointerPos);
				printf("\n");
				}
	 | commands loop
	 | commands '\n'
	 | commands comments { printf("/*comment*/\n"); };
	 | /**/
         ;


loop : loop_b commands loop_e
     ;

loop_b : LOOP_BEGIN {
			putchar('\n');
			printInd();
			printf("while(*ptr){");
			ind++;
			pointerPush(pointerPos);
			printf("\t\t//while(buffer[%d]){",pointerPos);
			printf("\n");
			}


loop_e : LOOP_END {
			ind--;
			printInd();
			printf("}");
			printf("\t\t//while(buffer[%d]);",pointerPos);
			int outP=pointerPop();
			if(outP==pointerPos)
				printf("while OK!\n");
			else
				printf("while not OK\n");
			printf("\n\n"); }

comments: comments COMMENT
	| COMMENT
	;
%%

main()
{
  printHeader();
  yyparse();
  printFooter();
}

yyerror(s)
char *s;
{
    fprintf(stderr, "%s\n", s);
}
