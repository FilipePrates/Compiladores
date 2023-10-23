Compilador de mini Javascript

Iremos construir um compilador de Javascript para uma forma intermediária de um máquina de pilha, em várias etapas. Em cada etapa algumas funcionalidades serão acrescentadas sobre o que já foi feito, logo uma das características desejáveis do programa é ser manutenível (ser de fácil manutenção e ter boa legibilidade).

Inicialmente teremos variáveis sem tipo definido, mas com os qualificadores adequados: let, const e o var. O escopo no momento será apenas global (fora de todos os blocos). A principal diferença para javascript nesse momento é que todos os comandos devem ser separados por ';'. Ficam de fora nessa primeira etapa também funções e expressões lambda (arrow functions e funções anônimas).

Construções a serem implementadas:

    let, const e var (as variáveis em javascript podem receber valores de qualquer tipo):
        uma variável do tipo let só pode ser declarada uma única vez em cada escopo;
        uma variável declarada com var pode ser declarada diversas vezes, desde que não tenha sido declarada com let ainda;
        se uma variável for declarada com let ela não pode ser declarada de novo com var;
        se uma variável for declarada com var ela não pode ser declarada de novo com let;
        const segue as mesmas regras do let, acrescentando a restrição de que o valor da variável não pode ser alterado (mas seus campos podem).
    Comandos estruturados: if, while, for. Ficam de fora do-while, switch-case-break, return, continue, labels e "forEach" (for específicos para arrays, for in etc).

A nossa máquina de pilha será alterada para poder executar as seguintes instruções:

Instruções
Código Nome Parâmetros Descrição

"#" goto 1 Desvia para o endereço no topo da pilha (ou chama uma função primitiva)
{} newObject 0 novo objeto
[] newArray 0 novo array
@ get 1 busca o valor da variável na pilha de RA’s, até encontrar ou dar erro
= set 2 Armazena o valor no topo da pilha em uma variável (se não existe local, busca global). Empilha esse valor de novo para permitir múltiplas atribuições: a = b = 8
? jumpTrue 2 Testa e desvia para o endereço no topo da pilha
& let 1 declara uma variável (no escopo atual)
[@] getProp 2 Lê a propriedade no topo da pilha de um objeto ou array
[=] setProp 3 (o,p,v) atribui um valor à uma propriedade de um objeto: o[p] = v
(array ou objeto). Empilha esse valor de novo para permitir múltiplas atribuições: a.c = b.c = 8
$ callFunc 2 (n,f) empilha um novo RA e desvia para f. N é o número de parâmetros (os parâmetros da função devem estar empilhados).
~ retFunc 1 desempilha o RA e desvia para o endereço no topo da pilha
^ pop 0 desempilha um parâmetro na pilha de operandos
. halt 0 termina a execução

Cada instrução ocupa um endereço, independente do tamanho de sua string. Ou seja, considere que teremos um array de código onde cada token é uma posição. O array de instruções começa em zero. É permitido armazenar endereços em variáveis, pois pode considerá-los como números inteiros.

É importante notar que a instrução " retFunc" apenas irá desempilhar o Registro de Ativação e desviará para o endereço no topo da pilha, logo é necessário passar para a função o endereço de retorno, que deve ser empilhado. Isso será detalhado na próxima aula, no tópico Registro de Ativação.
Exemplos:

Entrada:

let a = {};
let b = [];
let c, d;
c = 1;
d = 'Hello';
a.campo = c + 1;
b[9] = a.campo;

Saída:

a& a {} = ^
b& b [] = ^
c& d&
c 1 = ^
d 'Hello' = ^
a@ campo c@ 1 + [=] ^
b@ 9 a@ campo[@] [=] ^
.

Espaços, tabulação e quebra de linha serão ignorados sempre que for possível diferenciar uma instrução da seguinte.

Sugestão inicial de gramática: será necessário um símbolo não terminal para tratar lvalues e rvalues. Note que todo lvalue pode ser um rvalue, mas apenas algumas construções podem ser lvalues. são elas:

LVALUE -> id
LVALUEPROP -> E [ E ]
LVALUEPROP -> E . id

Apenas devemos diferencias setProp "[=]" de atribuição "=".

As atribuições devem ser tratadas na produção do operador '=' (que é associativo à direita). Já as operações de leitura "@" e "[@]" devem ser tratadas na conversão de E em lvalue.

E -> LVALUE = E   
 | LVALUEPROP = E
| ...
| LVALUE
| LVALUEPROP

Dessa forma, um lvalue pode ser convertido em um rvalue (símbolo E).
Tratamento de erros

Não serão testados erros de sintaxe. Porém, compilador deve tratar três tipos de erros:

    Quando uma variável for declarada em duplicidade deve encerrar a compilação com a mensagem:

Erro: a variável 'xxx' já foi declarada na linha nn.

    Quando uma variável for utilizada sem ter sido declarada deve encerrar a compilação com a mensagem:

Erro: a variável 'xxx' não foi declarada.

    Quando uma variável const for modificada deve encerrar a compilação com a mensagem:

Erro: tentativa de modificar uma variável constante ('xxx').

Interpretador

./mdp
