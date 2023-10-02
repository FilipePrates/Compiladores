%{
#include <stdlib.h>
#include <math.h>
#include <map>
#include <vector>
#include <string>
#include <iostream>

using namespace std;
int token;
string lexema;
enum TOKEN { ID = 256, NUM, STRING };

%}

WS	    [ \n\t]
DIGITO	[0-9]
LETRA	[A-Za-z_]

NUM	{DIGITO}+("."{DIGITO}+)?
ID	{LETRA}({LETRA}|{DIGITO})*

STRING \"[^\"\n]*\"

%%

{WS}  		{ }
{STRING} 	{ lexema = yytext; return STRING; }
{NUM} 		{ lexema = yytext; return NUM; }
{ID}		{ lexema = yytext; return ID; }

.		    { lexema = yytext; return yytext[0]; }
%%
void S();
void A();
void E();
void E_linha();
void T();
void T_linha();
void F();

void S(){
    cout << "adasdsa" << endl;
    return;
}

void casa(int esperado) {
    cout << "Esperado:" << esperado << endl;
    cout << "Token:" << token << endl;
	if (token == esperado) token = yylex();
	else cout << "erro" << endl;
}

void A() {
// Guardamos o lexema pois a função 'casa' altera o seu valor.
  string temp = lexema; 
  casa( ID );
  cout << temp;
  casa( '=' );
  E();
}

void E() {
  T();
  E_linha();
}

void E_linha() {
  switch( token ) {
    case '+' : casa( '+' ); T(); cout << "+"; E_linha(); break;
    case '-' : casa( '-' ); T(); cout << "-"; E_linha(); break;
  }
}

void T() {
  F();
  T_linha();
}

void T_linha() {
  switch( token ) {
    case '*' : casa( '*' ); F(); cout << "*"; T_linha(); break;
    case '/' : casa( '/' ); F(); cout << "/"; T_linha(); break;
  }
}

void F() {
  cout << "F:" << token;
  switch( token ) {
    case ID : {
      string temp = lexema;
      casa( ID );
      cout << temp << "@";  } 
      break;
    case NUM : {
      string temp = lexema;
      casa( NUM ); cout << temp; }
      break;
    case STRING : {
      string temp = lexema;
      casa( STRING ); cout << temp; }
      break;
    case '(': 
      casa( '(' ); E(); casa( ')' ); break;
    default:
      cout << "erro" << endl;
  }
}

int main() {
    cout << "=== Tradutor ===" << endl;
    token = yylex();
    A();
    if (token == 0) cout << "Ok" << endl;
    return 0;
}
