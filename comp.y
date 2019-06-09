%{
#include "header.h"

GHashTable *    artistas;
GSList *        nomes_aux, * ensinou_aux, * aprendeu_aux;
GSList *        eventos_aux;
GSList *        obras_aux;
P_DATA          vida_aux, data_aux, lancamento_aux;
P_EVENTO        evento_aux;
P_OBRA          obra_aux;
char *          nome_aux;
char *          cidade_aux;
char *          pais_aux;
char *          nomenasc_aux;
char *          tipo;
char *          titulo;
int             flag;
int             flag2;

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

artista: '{' pessoal ',' formacao ',' EVENTOS ':' '[' eventos  ']' ',' OBRAS ':' '[' obras ']' '}'      {
                                                                                                            asprintf(&$$, "{%s, %s, [%s], [%s]}", $2, $4, $9, $15);
                                                                                                            ensinou_aux = g_slist_alloc();
                                                                                                            aprendeu_aux = g_slist_alloc();
                                                                                                            g_hash_table_insert(artistas, nome_aux,newArtista(nome_aux, cidade_aux, pais_aux, data_aux, nomenasc_aux, ensinou_aux, aprendeu_aux, eventos_aux, obras_aux));
                                                                                                        }
       ;

pessoal:  NOME ':' nome ',' naturalidade ',' VIDA ':' data ',' NOMENASC ':' nomenasc                    {
                                                                                                            flag = L_PESSOAL;
                                                                                                            asprintf(&$$, "%s, %s, {%s}, {%s}", $3, $5, $9, $13);
                                                                                                            nome_aux = strdup($3);
                                                                                                            nomenasc_aux = strdup($13);
                                                                                                        }
      ;

nome: STR                                                                       {asprintf(&$$, "%s", $1);}
    ;

naturalidade: CIDADE ':' cidade ',' PAIS ':' pais                               {
                                                                                    cidade_aux = strdup($3);
                                                                                    pais_aux = strdup($7);
                                                                                    asprintf(&$$, "%s, %s", $3, $7);
                                                                                }
            ;

cidade: STR                                                                     {asprintf(&$$, "%s", $1);}
      ;

pais: STR                                                                       {asprintf(&$$, "%s", $1);}
    ;

data: '(' NUM '/' NUM '/' NUM')'                                                {   if (flag == L_PESSOAL) {
                                                                                        vida_aux = newData($2, $4, $6, 0, 0, 0);
                                                                                    } else if ( flag == L_EVENTO){
                                                                                        data_aux = newData($2, $4, $6, 0, 0, 0);
                                                                                    } else if (flag == L_OBRA) {
                                                                                        lancamento_aux = newData($2, $4, $6, 0, 0, 0);
                                                                                    }
                                                                                    asprintf(&$$, "(%d/%d/%d)", $2, $4, $6);
                                                                                }
    | '(' NUM '/' NUM '/' NUM '-' NUM '/' NUM '/' NUM ')'                       {
                                                                                    if (flag == L_PESSOAL) {
                                                                                        vida_aux = newData($2, $4, $6, $8, $10, $12);
                                                                                    } else if ( flag == L_EVENTO){
                                                                                        data_aux = newData($2, $4, $6, $8, $10, $12);
                                                                                    } else if (flag == L_OBRA) {
                                                                                        lancamento_aux = newData($2, $4, $6, $8, $10, $12);
                                                                                    }
                                                                                    asprintf(&$$, "(%d/%d/%d - %d/%d/%d)", $2, $4, $6, $8, $10, $12);
                                                                                }
    ;

nomenasc: STR                                                                   {asprintf(&$$, "%s", $1);}
        ;

formacao: ENSINOU ':' '[' nomes ']' ',' APRENDEU ':' '[' nomes']'               {flag = L_FORMACAO; flag2 = 0; asprintf(&$$, "ENSINOU: [%s], APRENDEU: [%s]", $4, $10);}
        ;

nomes:                                                                          {
                                                                                    asprintf(&$$, "");
                                                                                    if (flag == L_FORMACAO) {
                                                                                        if ( flag2 == 0)
                                                                                            flag2 = 1;
                                                                                        else
                                                                                            flag2 = 0;
                                                                                    }
                                                                                }
     | nome                                                                     {
                                                                                    asprintf(&$$, "%s", $1);
                                                                                    if (flag == L_FORMACAO){
                                                                                        if (flag2 == 0) {
                                                                                            flag2 = 1;
                                                                                            g_slist_append(ensinou_aux, strdup($1));
                                                                                        }else if (flag2 == 1) {
                                                                                            flag2 = 0;
                                                                                            g_slist_append(aprendeu_aux, strdup($1));
                                                                                        }
                                                                                    } else if (flag == L_EVENTO) {
                                                                                        g_slist_append(nomes_aux, strdup($1));
                                                                                    } else if (flag == L_OBRA) {
                                                                                        g_slist_append(nomes_aux, strdup($1));
                                                                                    }
                                                                                }
     | nome ',' nomes                                                           {
                                                                                    asprintf(&$$, "%s; %s", $1, $3);
                                                                                     if (flag == L_FORMACAO){
                                                                                         if (flag2 == 0) {
                                                                                             g_slist_append(ensinou_aux, strdup($1));
                                                                                         }else if (flag2 == 1) {
                                                                                             g_slist_append(aprendeu_aux, strdup($1));
                                                                                         }
                                                                                     } else if (flag == L_EVENTO) {
                                                                                         g_slist_append(nomes_aux, strdup($1));
                                                                                     } else if (flag == L_OBRA) {
                                                                                         g_slist_append(nomes_aux, strdup($1));
                                                                                     }
                                                                                }
     ;

eventos:                                                                        {asprintf(&$$, "");}
       | evento                                                                 {asprintf(&$$, "%s", $1);}
       | evento ',' eventos                                                     {asprintf(&$$, "%s; %s", $1, $3);}
       ;

evento: '{' TIPO ':' tipo ',' DATA ':' data ',' ARTISTAS ':' '[' nomes ']' '}'  {
                                                                                    flag = L_EVENTO;
                                                                                    nomes_aux = g_slist_alloc();
                                                                                    asprintf(&$$, "TIPO: %s, DATA: %s, ARTISTAS: [%s]", $4, $8, $13);
                                                                                    g_slist_append(eventos_aux, newEvento(atoi($4), data_aux, nomes_aux));
                                                                                }
      ;

tipo: CONCERTO                                                                  {asprintf(&$$, "Concerto");}
    | SARAU                                                                     {asprintf(&$$, "Sarau");}
    | FESTIVAL                                                                  {asprintf(&$$, "Festival");}
    ;

obras:                                                                          {asprintf(&$$, "");}
     | obra                                                                     {asprintf(&$$, "%s", $1);}
     | obra ',' obras                                                           {asprintf(&$$, "%s; %s", $1, $3);}
     ;

obra: '{' TITULO ':' nome ',' ARTISTAS ':' '[' nomes ']' ',' LANCAMENTO ':' data '}'   {
                                                                                            flag = L_OBRA;
                                                                                            nomes_aux = g_slist_alloc();
                                                                                            asprintf(&$$, "TITULO: %s, ARTISTAS: [%s], LANCAMENTO: %s", $4, $9, $14);
                                                                                            g_slist_append(obras_aux, newObra(strdup($4), nomes_aux, lancamento_aux));
                                                                                       }
    ;

%%
#include "lex.yy.c"

/* struct definitions */
struct data {
    int dn;
    int mn;
    int an;
    int dm;
    int mm;
    int am;
};

struct obra {
    char *      titulo;
    P_DATA      lancamento;
    GSList *    artistas;
};

struct evento {
    int         tipo;
    P_DATA      data;
    GSList *    artistas;
};

struct artista {
    char *      nome;
    char *      cidade;
    char *      pais;
    P_DATA      vida;
    char *      nomenasc;
    GSList *    aprendeu;
    GSList *    ensinou;
    GSList *    eventos;
    GSList *    obras;
};


/* fuction definitions */

P_DATA    newData(int dn, int mn, int an, int dm, int mm, int am){
    P_DATA r = malloc(sizeof(struct data));
    r->dn = dn;
    r->mn = mn;
    r->an = an;
    r->dm = dm;
    r->mm = mm;
    r->am = am;
}

void    destroyData(void * v){
    if (!v)
        return;
    P_DATA d = (P_DATA) v;
    free(d);
}

P_OBRA    newObra(char * titulo, GSList * artistas,P_DATA lancamento){
    P_OBRA o          = malloc(sizeof(struct obra));
    o->titulo       = strdup(titulo);
    o->artistas     = artistas;
    o->lancamento   = lancamento;
}
void    destroyObra(void * v){
    if (!v)
        return;
    P_OBRA o = (P_OBRA) v;
    g_slist_free_full(o->artistas, free);
    free(o->titulo);
    destroyData(o->lancamento);
    free(o);
}

P_EVENTO  newEvento(int tipo, P_DATA data, GSList * artistas){
    P_EVENTO e    = malloc(sizeof(struct evento));
    e->tipo     = tipo;
    e->data     = data;
    e->artistas = artistas;
}

void    destroyEvento(void * v){
    if (!v)
        return;
    P_EVENTO e = (P_EVENTO) v;
    destroyData(e->data);
    g_slist_free_full(e->artistas, free);
    free(e);
}

P_ARTISTA newArtista(char * nome, char * cidade,
                    char * pais, P_DATA vida, char * nomenasc,
                    GSList * ensinou, GSList * aprendeu,
                    GSList * eventos, GSList * obras){
    P_ARTISTA a   = malloc(sizeof(struct artista));
    a->nome     = strdup(nome);
    a->vida     = vida;
    a->cidade   = strdup(cidade);
    a->pais     = strdup(pais);
    a->nomenasc = strdup(nomenasc);
    a->ensinou  = ensinou;
    a->aprendeu = aprendeu;
    a->eventos  = eventos;
    a->obras    = obras;
}

void    destroyArtista(void * v){
    if (!v)
        return;
    P_ARTISTA a = (P_ARTISTA) v;
    free(a->nome);
    free(a->cidade);
    free(a->pais);
    free(a->nomenasc);
    destroyData(a->vida);
    g_slist_free_full(a->ensinou, free);
    g_slist_free_full(a->aprendeu, free);
    g_slist_free_full(a->eventos, &destroyEvento);
    g_slist_free_full(a->obras, &destroyObra);
}

char * dataToString(P_DATA d){
    char * res;
    if(d->dm == 0){
        asprintf(&res, "(%d/%d/%d)", d->dn, d->mn, d->an);
    } else
        asprintf(&res, "(%d/%d/%d-%d/%d/%d)", d->dn, d->mn, d->an, d->dm, d->mm, d->am);
    return res;
}

void    artistaToString(void * k, void * v, void * ud){
    P_ARTISTA a = (P_ARTISTA) v;
    printf("Nome: %s\n", a->nome);
    printf("Cidade: %s\n", a->cidade);
    printf("Pais: %s\n", a->pais);
    printf("Vida: %s\n", dataToString(a->vida));
    printf("Nome de nascença: %s\n", a->nomenasc);
}


void yyerror(char* s) {
	printf("%s", s);
}

int main() {
    artistas = g_hash_table_new_full(g_str_hash, g_str_equal, free, &destroyArtista);
    nomes_aux   = g_slist_alloc();
    eventos_aux = g_slist_alloc();
    obras_aux   = g_slist_alloc();

	yyparse();
    printf("-----------PARSING DONE -------------\n");

    g_hash_table_foreach(artistas, &artistaToString, NULL);

	return 0;
}
