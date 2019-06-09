%option noyywrap
%%
[\n\ \t]*                   { ; }
[0-9]+                      {yylval.val = atoi(yytext);return NUM;}
[{};\(\),-\/:]              {return yytext[0];}
APRENDEU                    {return APRENDEU;}
ENSINOU                     {return ENSINOU;}
FESTIVAL                    {return FESTIVAL;}
CONCERTO                    {return CONCERTO;}
NOME                        {return NOME;}
CIDADE                      {return CIDADE;}
PAIS                        {return PAIS;}
VIDA                        {return VIDA;}
NOMENASC                    {return NOMENASC;}
EVENTOS                     {return EVENTOS;}
TIPO                        {return TIPO;}
DATA                        {return DATA;}
ARTISTAS                    {return ARTISTAS;}
OBRAS                       {return OBRAS;}
TITULO                      {return TITULO;}
ARTISTA                     {return ARTISTA;}
LANCAMENTO                  {return LANCAMENTO;}
[a-zA-Z0-9]*                {yylval.s = strdup(yytext);return STR;}
.                           { ; }
%%
