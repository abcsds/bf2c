#
# Build specifications for lex and yacc
#

# Build syntax
YACC = $(patsubst %.y, %, $(wildcard [a-z]*.y))

# Build lexicon
LEX  = $(filter-out $(YACC), $(patsubst %.l, %, $(wildcard [a-z]*.l)))

# Generate all programs
EXE  = $(LEX) $(YACC)

# Build lex object files
OBJL = $(patsubst %, %.yy.o, $(LEX))

# Build yacc object files
OBJLY = $(patsubst %, %.yy.o, $(YACC))

all:  $(EXE)
	echo $(OBJLY)

%.yy.c:  %.l
	lex  -o$*.yy.c $*.l

%.tab.c %.tab.h: %.y
	yacc -d $*.y

%.tab.o: %.tab.c
	gcc -c $*.tab.c

$(OBJL): %.yy.o : %.yy.c
	gcc -c $*.yy.c

$(OBJLY): %.yy.o : %.yy.c %.tab.h
	gcc -c $*.yy.c

$(LEX): %: %.yy.o
	gcc -o $* $*.yy.o -lfl

$(YACC): %: %.yy.o %.tab.o
	gcc -o $* $*.yy.o $*.tab.o -ll

.PHONY: clean mrproper

mrproper: clean
	rm -f $(EXE)
clean:
	rm -f *~
	rm -f *.yy.c
	rm -f *.tab.c
	rm -f *.tab.h
	rm -f *.o
	rm -f result.c
