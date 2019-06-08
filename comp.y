%{
%}
%union {
    int val;
    char * txt;
    char * code;
    char * tipo;
    char * formacao;
}
%token  <txt>STR
%token  <val>NUM
%token  <tipo>CONCERTO FESTIVAL SARAU
%token  <formacao>ENSINOU APRENDEU
%type   <code>artistas artista eventos evento tipo data nomes pessoal naturalidade formacao obras obra nome pais cidade nomenasc nomeart 

%%

prog: artistas                                  {}
    ;

artistas: artista ';' artistas                  {} 
        | artista ';'                           {}
        ;

artista: '{' pessoal ',' '{' eventos '}' ',' formacao ',' '{' obras '}'  '}'    {}
       ;

eventos: evento ';' eventos                     {}
       ;

evento: '{' tipo ',' data ',' '{' nomes '}' '}' {}
      ;

tipo: CONCERTO                                  {}
    | FESTIVAL                                  {}
    | SARAU                                     {}
    ;

data: '('NUM'/'NUM'/'NUM')'                     {}
    | '('NUM'/'NUM'/'NUM'-'NUM'/'NUM'/'NUM')'   {}
    ;

nomes: nome ';' nomes                           {}
     | nome ';'                                 {}
     ;

pessoal: nome ',' naturalidade ',' data ',' nomenasc     {printf("Nome: %s\n", $1);}
       ;

nome: STR                                       {printf("Nome2: %s\n", $1);}
    ;

naturalidade: cidade ',' pais                   {} 
            ;

cidade: STR                                     {}
      ;

pais: STR                                       {}
    ;


formacao: ENSINOU '(' nomes ')' ';' formacao    {}
        | APRENDEU '(' nomes ')' ';' formacao   {}
        | formacao ';'                          {}
        ;

obras: obra ';' obras                           {} 
     | obra ';'                                 {}
     ;

obra: '{' nome ',' nomeart ',' data '}'          {}
    ;

nomenasc: STR                                   {}
        ;
nomeart: STR                                    {}
        ;

%%

#include "lex.yy.c"

void yyerror(char *s){
    printf("%s, s");
}

int main(){
    yyparse();
    return 0;
}
