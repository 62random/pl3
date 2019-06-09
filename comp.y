%{
#include <stdio.h>
#include <string.h>
int asprintf(char ** str, const char * fmt, ...);
int yylex();
void yyerror(char * s);
int yydebug = 1;
%}
%union {
  int val;
  char *s;
}
%token <val>NUM
%token <s>STR
%token APRENDEU ENSINOU SARAU CONCERTO FESTIVAL NOME CIDADE PAIS VIDA NOMENASC EVENTOS TIPO DATA ARTISTAS OBRAS TITULO ARTISTA LANCAMENTO
%type  <s>artista artistas pessoal nome naturalidade data nomenasc cidade pais formacao obras obra nomes eventos evento tipo
%%

prg: '[' artistas ']'					                                        {printf("[\n\t%s\n]\n", $2); }
   ;

artistas:                                                                       {asprintf(&$$, "");}
        | artista                                                               {asprintf(&$$, "%s", $1);}
        | artista ',' artistas                                                  {asprintf(&$$, "%s, %s", $1, $3);}
        ;

artista: '{' pessoal ',' formacao ',' EVENTOS ':' '[' eventos  ']' ',' OBRAS ':' '[' obras ']' '}'      {asprintf(&$$, "{%s, %s, [%s], [%s]}", $2, $4, $9, $15);}
       ;

pessoal:  NOME ':' nome ',' naturalidade ',' VIDA ':' data ',' NOMENASC ':' nomenasc                    {asprintf(&$$, "%s, %s, {%s}, {%s}", $3, $5, $9, $13);}
      ;

nome: STR                                                                       {asprintf(&$$, "%s", $1);}
    ;

naturalidade: CIDADE ':' cidade ',' PAIS ':' pais                               {asprintf(&$$, "%s, %s", $3, $7);}
            ;

cidade: STR                                                                     {asprintf(&$$, "%s", $1);}
      ;

pais: STR                                                                       {asprintf(&$$, "%s", $1);}
    ;

data: '(' NUM '/' NUM '/' NUM')'                                                {asprintf(&$$, "(%d/%d/%d)", $2, $4, $6);}
    | '(' NUM '/' NUM '/' NUM '-' NUM '/' NUM '/' NUM ')'                       {asprintf(&$$, "(%d/%d/%d - %d/%d/%d)", $2, $4, $6, $8, $10, $12);}
    ;

nomenasc: STR                                                                   {asprintf(&$$, "%s", $1);}
        ;

formacao: ENSINOU ':' '[' nomes ']' ',' APRENDEU ':' '[' nomes']'               {asprintf(&$$, "ENSINOU: [%s], APRENDEU: [%s]", $4, $10);}
        ;

nomes:                                                                          {asprintf(&$$, "");}
     | nome                                                                     {asprintf(&$$, "%s", $1);}
     | nome ',' nomes                                                           {asprintf(&$$, "%s; %s", $1, $3);}
     ;

eventos:                                                                        {asprintf(&$$, "");}
       | evento                                                                 {asprintf(&$$, "%s", $1);}
       | evento ',' eventos                                                     {asprintf(&$$, "%s; %s", $1, $3);}
       ;

evento: '{' TIPO ':' tipo ',' DATA ':' data ',' ARTISTAS ':' '[' nomes ']' '}'  {asprintf(&$$, "TIPO: %s, DATA: %s, ARTISTAS: [%s]", $4, $8, $13);}
      ;

tipo: CONCERTO                                                                  {asprintf(&$$, "Concerto");}
    | SARAU                                                                     {asprintf(&$$, "Sarau");}
    | FESTIVAL                                                                  {asprintf(&$$, "Festival");}
    ;

obras:                                                                          {asprintf(&$$, "");}
     | obra                                                                     {asprintf(&$$, "%s", $1);}
     | obra ',' obras                                                           {asprintf(&$$, "%s; %s", $1, $3);}
     ;

obra: '{' TITULO ':' nome ',' ARTISTAS ':' '[' nomes ']' ',' LANCAMENTO ':' data '}'   {asprintf(&$$, "TITULO: %s, ARTISTAS: [%s], LANCAMENTO: %s", $4, $9, $14);}
    ;

%%
#include "lex.yy.c"

void yyerror(char* s) {
	printf("%s", s);
}

int main() {

	yyparse();

	return 0;
}
