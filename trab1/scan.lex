%{
// Código em c/c++

#include <iostream>
#include <regex>

using namespace std;

string lexema;

string cleanStringSingle(string s){
    string result;

    regex escapedSingle("\\\\\'|\'\'");

    result = regex_replace(s, escapedSingle, "\'");

    return result.substr(1, result.size() - 2);;
}

string cleanStringDouble(string s){
    string result;

    regex escapedDouble("\\\\\"|\"\"");

    result = regex_replace(s, escapedDouble, "\"");

    return result.substr(1, result.size() - 2);;
}

string cleanStringAgudo(string s){
    string result;

    regex escapedAgudo("\\\\`|``");

    result = regex_replace(s, escapedAgudo, "`");

    return result.substr(1, result.size() - 2);;
}



%}
/* Coloque aqui definições regulares */

WS	[ \t\n]
COM_START "/\*"
COM_END "\*/"
COM_START2 "//"
%%
    /* Padrões e ações. Nesta seção, comentários devem ter um tab antes */
{WS} {} 

[Ff][Oo][Rr] { lexema = yytext; return _FOR; }
[Ii][Ff] { lexema = yytext; return _IF; }

">=" { lexema = yytext; return _MAIG; }
"<=" { lexema = yytext; return _MEIG; }
"==" { lexema = yytext; return _IG; }
"!=" { lexema = yytext; return _DIF; }

[0-9]+[.]?[0-9]*[e]?[+]?[-]?[0-9]+ { lexema = yytext; return _FLOAT; }
[0-9]+ { lexema = yytext; return _INT; }
[$a-zA-Z_][a-zA-Z0-9_]* { lexema = yytext; return _ID; }
[$a-zA-Z_][$a-zA-Z0-9_]* { lexema = yytext; printf( "Erro: Identificador invalido: %s\n", lexema.c_str()); }
\"[^\"]*([\\\"]\"[^\"]*)*\" { lexema = cleanStringDouble(yytext); return _STRING; }
\'[^\']*([\\\']\'[^\']*)*\' { lexema = cleanStringSingle(yytext); return _STRING; }
\`[^\n\`]*[^\\]\` { lexema = cleanStringAgudo(yytext); return _STRING2; }

{COM_START}^(\/\/).*{COM_END} { lexema = yytext; return _COMENTARIO; }
{COM_START2}.* { lexema = yytext; return _COMENTARIO; }

. { lexema = yytext; return yytext[0]; }
%%
