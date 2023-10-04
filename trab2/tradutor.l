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
enum TOKEN { ID = 256, NUM, STRING, PRINT, MAX, NEGNUM, POSNUM, DTOS, MDC};

%}

WS	    [ \n\t]
DIGITO	[0-9]
LETRA	[A-Za-z_]

PRINT [Pp][Rr][Ii][Nn][Tt]
MAX [Mm][Aa][Xx]
DTOS [Dd][Tt][Oo][Ss]
MDC [Mm][Dd][Cc]
NUM	{DIGITO}+("."{DIGITO}+)?
ID	{LETRA}({LETRA}|{DIGITO})*
STRING \"([^\"\n\\]|(\\\")|\"\"|"\\\\")+\"

%%

{WS}  		{ }
{STRING} 	{ lexema = yytext; return STRING; }
{NUM} 		{ lexema = yytext; return NUM; }
{PRINT}     { lexema = yytext; return PRINT; }
{MAX}    { lexema = yytext; return MAX; }
{DTOS} { lexema = yytext; return DTOS; }
{MDC} { lexema = yytext; return MDC; }
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
void Fat();

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
    case PRINT : casa( PRINT ); E(); print("print #"); casa(';'); S_linha(); break;
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
  print("^");
}

void E() {
  switch( token ) {
    case '-' : casa('-'); print("0"); T(); print("-"); E_linha(); break;
    case '+' : casa('+'); T(); E_linha(); break;
    default: T(); E_linha();
  }
}

void E_linha() {
  switch( token ) {
    case '+' : casa( '+' ); T(); print("+"); E_linha(); break;
    case '-' : casa( '-' ); T(); print("-"); E_linha(); break;
  }
}

void T() {
  P();
  T_linha();
}

void T_linha() {
  switch( token ) {
    case '*' : casa( '*' ); P(); print("*"); T_linha(); break;
    case '/' : casa( '/' ); P(); print("/"); T_linha(); break;
  }
}


void P() {
  Fat();
  W();
}

void W() {
  switch ( token ) {
    case '^' : casa( '^' ); P(); print("power #"); break;
  }
}

void Fat(){
  F();
  if(token == '!') {
    casa('!'); print("fat #");
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
    case MAX : casa( MAX ); casa('('); E(); casa(','); E(); casa(')'); print("max #"); S_linha(); break;
    case DTOS: casa( DTOS ); casa('('); E(); casa(')'); print("dtos #"); S_linha(); break;
    case MDC: casa( MDC ); casa('('); E(); casa(','); E(); casa(')'); print("mdc #"); S_linha(); break;
    case '(': 
      casa( '(' ); E(); casa( ')' ); break;
    default:
      cout << "errou" << endl; exit(1);
  }
}

int main() {
    token = yylex();
    S();
    return 0;
}
