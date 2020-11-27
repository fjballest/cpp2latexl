#
#	Makefile for C++2LaTeX-l on GNU/Linux systems
#

CC	= gcc
CFLAGS	= -O2 -traditional
LDFLAGS = -s 

LEX	= flex

TROFF	= psroff

target: c++2latex

all:	c++2latex 

c++2latex:	lex.yy.o libyywrap.o
	$(CC) $(LDFLAGS) -o c++2latex lex.yy.o libyywrap.o

lex.yy.c: c++2latex.flex
	flex c++2latex.flex

#	Set up *your* own, here:
BINDIR	=	/usr/local/bin
TEXDIR	=	/tmp
MAN1DIR	=	/tmp

install:
	cp c++2latex $(BINDIR)
	-rm $(BINDIR)/c2latex
	ln -s $(BINDIR)/c++2latex $(BINDIR)/c2latex
	cp clst.sty noweb2e.sty $(TEXDIR)


uninstall:
	rm -f $(BINDIR)/c++2latex
	rm -f $(BINDIR)/c2latex
	rm -f $(TEXDIR)/clst.sty $(TEXDIR)/noweb2e.sty


SRC	=	.
VERS	=	-l-0.1
tape:	c++2latex.c
	rm -f C++2LaTeX$(VERS).tar.Z
	tar cf C++2LaTeX$(VERS).tar $(SRC)/LICENSE \
		$(SRC)/Makefile \
		$(SRC)/README \
		$(SRC)/c++2latex.flex \
		$(SRC)/clst.sty
		$(CONFIG)/README 
	gzip C++2LaTeX$(VERS).tar

clean:
	rm -f c++2latex.c *.c.tex *.aux *.log *.Z lex.yy.c c++2latex  *.o

clobber:
	rm -f c++2latex.c *.c.dvi *.c.tex *.aux *.log *.o
