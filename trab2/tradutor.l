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

void casa(int esperado);

void casa(int esperado) {
	if (token == esperado){
      token = yylex();
  } else {
      cout << endl << "Erro no 'casa', era pra ser: " << to_string(esperado) << " , mas recebemos :" << token << endl;
      exit(1);
  }
}

void S(){
  A();
  cout << " ";
  S_linha();
}

void S_linha(){
  if( token == ';'){
    casa(';');
  }
  switch( token ) {
    case PRINT : casa( PRINT ); E(); cout << " print #"; S_linha(); break;
    case 0 : return;
    default : A(); S_linha(); break;
  }
}


void A() {
  string temp = lexema; 
  if( token == ID){
    casa( ID );
    cout << temp;
    casa( '=' );
    E();
    cout << " = ^";
  }
}

void E() {
  T();
  E_linha();
}

void E_linha() {
  switch( token ) {
    case '+' : casa( '+' ); T(); cout << " +"; E_linha(); break;
    case '-' : casa( '-' ); T(); cout << " -"; E_linha(); break;
  }
}

void T() {
  F();
  T_linha();
}

void T_linha() {
  switch( token ) {
    case '*' : casa( '*' ); P(); cout << " *"; T_linha(); break;
    case '/' : casa( '/' ); P(); cout << " /"; T_linha(); break;
  }
}


void P() {
  F();
  W();
}

void W() {
  switch( token ) {
    case '^' : casa( '^' ); P(); cout << " ^"; break;
  }
}

void F() {
  // cout << "F: " << token;
  switch( token ) {
    case ID : {
      string temp = lexema;
      casa( ID );
      cout << " " << temp << " @";  } 
      break;
    case NUM : {
      string temp = lexema;
      casa( NUM ); cout << " " << temp; }
      break;
    case STRING : {
      string temp = lexema;
      casa( STRING ); cout << " " << temp; }
      break;
    case '(': 
      casa( '(' ); E(); casa( ')' ); break;
   case '-': 
     casa('-'); cout << " 0"; F(); cout << " -"; break;
    default:
      cout << "errou" << endl; exit(1);
  }
}

int main() {
    token = yylex();
    S();
    return 0;
}
