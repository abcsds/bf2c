#
# Ogolny makefile do specyfikacji dla Flexa i Bisona
#

# Programy do wygenerowania ze specyfikacji dla Yacc'a
YACC = $(patsubst %.y, %, $(wildcard [a-z]*.y))

# Programy do wygenerowania (tylko) ze specyfikacji dla Lex'a
LEX  = $(filter-out $(YACC), $(patsubst %.l, %, $(wildcard [a-z]*.l)))

# Wszystkie programy do wygenerowania
EXE  = $(LEX) $(YACC)

# Kody po¶rednie skanerów zale¿nych tylko od specyfikacji skanera
OBJL = $(patsubst %, %.yy.o, $(LEX))

# Kody po¶rednie skanerów zale¿nych od specyfikacji skanera i pliku nag³ówkowego parsera
OBJLY = $(patsubst %, %.yy.o, $(YACC))

all:  $(EXE)
	echo $(OBJLY)

%.yy.c:  %.l
	flex  -o$*.yy.c $*.l

%.tab.c %.tab.h: %.y
	bison -d $*.y

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
