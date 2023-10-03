all: geradorFI entrada.txt
	./geradorFI < entrada.txt

lex.yy.c: tradutor.l
	lex tradutor.l

geradorFI: lex.yy.c
	g++ -std=c++17 lex.yy.c -o geradorFI -ll

clean:
	rm geradorFI lex.yy.c
	
