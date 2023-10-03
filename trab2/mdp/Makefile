all: maquinadepilha entrada.txt
	./maquinadepilha < entrada.txt

lex.yy.c: mdp.l
	lex mdp.l

maquinadepilha: lex.yy.c
	g++ -std=c++17 lex.yy.c -o maquinadepilha -ll

clean:
	rm maquinadepilha lex.yy.c
	
