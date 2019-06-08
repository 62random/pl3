%option noyywrap

%%

"({|}|(|)|;|,|/|-)"                           {return yytext[0];}
"[0-9]+"                                      {yylval.val = atoi(yytext); return NUM;}
"(CONCERTO|FESTIVAL|SARAU|ENSINOU|APRENDEU)"  {return yytext;}
"'[a-zA-Z ]*'"                                {return STR;}

%%
