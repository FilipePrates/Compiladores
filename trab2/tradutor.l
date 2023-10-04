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
enum TOKEN { ID = 256, NUM, STRING, PRINT };

%}

WS	    [ \n\t]
DIGITO	[0-9]
LETRA	[A-Za-z_]

PRINT [Pp][Rr][Ii][Nn][Tt]
NUM	{DIGITO}+("."{DIGITO}+)?
ID	{LETRA}({LETRA}|{DIGITO})*
STRING \"([^\"\n\\]|(\\\")|\"\"|"\\\\")+\"

%%

{WS}  		{ }
{STRING} 	{ lexema = yytext; return STRING; }
{NUM} 		{ lexema = yytext; return NUM; }
{PRINT}     { lexema = yytext; return PRINT; }
{ID}		{ lexema = yytext; return ID; }
.		    { lexema = yytext; return yytext[0]; }
%%
void S();
void S_linha();
void A();
void E();
void E_linha();
void T();
void T_linha();
void F();
void P();
void W();

void casa(int esperado) {
	if (token == esperado){
      token = yylex();
  } else {
      cout << endl << "Erro no 'casa', era pra ser: " << to_string(esperado) << " , mas recebemos :" << token << endl;
      exit(1);
  }
}

void print(string s){
  cout << s << " ";
}

void S(){
  // switch( token ) {
   // case ID : A();  break;
   // case PRINT : S_linha(); break;
   // default : return;
  //}
  if(token == ID) A();
  S_linha();
}

void S_linha(){
  switch( token ) {
    case PRINT : casa( PRINT ); E(); print("print #"); S_linha(); break;
    case ID : A(); S_linha(); break;
  }
}


void A() {
  string temp = lexema; 
  casa( ID );
  print(temp);
  casa( '=' );
  E();
  casa(';');
  print("=");
  if(token != 0) print("^");
}

void E() {
  T();
  E_linha();
}

void E_linha() {
  switch( token ) {
    case '+' : casa( '+' ); T(); print("+"); E_linha(); break;
    case '-' : casa( '-' ); T(); print("-"); E_linha(); break;
  }
}

void T() {
  F();
  T_linha();
}

void T_linha() {
  switch( token ) {
    case '*' : casa( '*' ); P(); print("*"); T_linha(); break;
    case '/' : casa( '/' ); P(); print("/"); T_linha(); break;
  }
}


void P() {
  F();
  W();
}

void W() {
  switch( token ) {
    case '^' : casa( '^' ); P(); print("^"); break;
  }
}

void F() {
  // cout << "F: " << token;
  switch( token ) {
    case ID : {
      string temp = lexema;
      casa( ID );
      print(temp);print("@");  } 
      break;
    case NUM : {
      string temp = lexema;
      casa( NUM ); print(temp); }
      break;
    case STRING : {
      string temp = lexema;
      casa( STRING ); print(temp); }
      break;
    case '(': 
      casa( '(' ); E(); casa( ')' ); break;
   case '-': 
     casa('-'); print("0"); F(); print("-"); break;
    default:
      cout << "errou" << endl; exit(1);
  }
}

int main() {
    token = yylex();
    S();
    return 0;
}
