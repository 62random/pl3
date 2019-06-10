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
int             tipo;
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
%type  <s>artista artistas pessoal nome naturalidade data nomenasc cidade pais formacao obras obra nomes eventos evento tipo ensinou aprendeu
%%

prg: '[' artistas ']'					                                        {printf("[\n\t%s\n]\n", $2); }
   ;

artistas:                                                                       {asprintf(&$$, "");}
        | artista                                                               {asprintf(&$$, "%s", $1);}
        | artista ',' artistas                                                  {asprintf(&$$, "%s, %s", $1, $3);}
        ;

artista: '{' pessoal ',' formacao ',' EVENTOS ':' '[' eventos  ']' ',' OBRAS ':' '[' obras ']' '}'      {
                                                                                                            asprintf(&$$, "{%s, %s, [%s], [%s]}", $2, $4, $9, $15);
                                                                                                            g_hash_table_insert(artistas, nome_aux,newArtista(nome_aux, cidade_aux, pais_aux, vida_aux, nomenasc_aux, ensinou_aux, aprendeu_aux, eventos_aux, obras_aux));
                                                                                                            ensinou_aux = g_slist_alloc();
                                                                                                            aprendeu_aux = g_slist_alloc();
                                                                                                            obras_aux = g_slist_alloc();
                                                                                                            eventos_aux = g_slist_alloc();
                                                                                                        }
       ;

pessoal:  NOME ':' nome ',' naturalidade ',' VIDA ':' data ',' NOMENASC ':' nomenasc                    {
                                                                                                            asprintf(&$$, "%s, %s, {%s}, {%s}", $3, $5, $9, $13);
                                                                                                            nome_aux = strdup($3);
                                                                                                            nomenasc_aux = strdup($13);
                                                                                                            flag = L_FORMACAO;
                                                                                                        }
      ;

nome: STR                                                                       {asprintf(&$$, "%s", $1);}
    ;

naturalidade: CIDADE ':' cidade ',' PAIS ':' pais                               {
                                                                                    flag = L_PESSOAL;
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

nomenasc: STR                                                                   {
                                                                                    asprintf(&$$, "%s", $1);
                                                                                    flag = L_FORMACAO;
                                                                                    flag2 = 0;
                                                                                }
        ;

formacao: ensinou ',' aprendeu                                                  {asprintf(&$$, "%s , %s", $1, $3);}
        ;

ensinou: ENSINOU ':' '[' nomes ']'                                              {
                                                                                    asprintf(&$$, "ENSINOU: [%s]", $4);
                                                                                    flag2 = 1;
                                                                                }
        ;

aprendeu: APRENDEU ':' '[' nomes']'                                             {
                                                                                    asprintf(&$$, "APRENDEU: [%s]", $4);
                                                                                    flag = L_EVENTO;
                                                                                }
        ;

nomes:                                                                          {
                                                                                    asprintf(&$$, "");
                                                                                }
     | nome                                                                     {
                                                                                    asprintf(&$$, "%s", $1);
                                                                                    if (flag == L_FORMACAO){
                                                                                        if (flag2 == 0) {
                                                                                            ensinou_aux = g_slist_append(ensinou_aux, strdup($1));
                                                                                        }else if (flag2 == 1) {
                                                                                            aprendeu_aux = g_slist_append(aprendeu_aux, strdup($1));
                                                                                        }
                                                                                    } else if (flag == L_EVENTO) {
                                                                                        nomes_aux = g_slist_append(nomes_aux, strdup($1));
                                                                                    } else if (flag == L_OBRA) {
                                                                                        nomes_aux = g_slist_append(nomes_aux, strdup($1));
                                                                                    }
                                                                                }
     | nome ',' nomes                                                           {
                                                                                    asprintf(&$$, "%s; %s", $1, $3);
                                                                                     if (flag == L_FORMACAO){
                                                                                         if (flag2 == 0) {
                                                                                             ensinou_aux = g_slist_append(ensinou_aux, strdup($1));
                                                                                         }else if (flag2 == 1) {
                                                                                             aprendeu_aux = g_slist_append(aprendeu_aux, strdup($1));
                                                                                         }
                                                                                     } else if (flag == L_EVENTO) {
                                                                                         nomes_aux = g_slist_append(nomes_aux, strdup($1));
                                                                                     } else if (flag == L_OBRA) {
                                                                                         nomes_aux = g_slist_append(nomes_aux, strdup($1));
                                                                                     }
                                                                                }
     ;

eventos:                                                                        {flag = L_OBRA; asprintf(&$$, "");}
       | evento                                                                 {flag = L_OBRA; asprintf(&$$, "%s", $1);}
       | evento ',' eventos                                                     {asprintf(&$$, "%s; %s", $1, $3);}
       ;

evento: '{' TIPO ':' tipo ',' NOME ':' nome ',' DATA ':' data ',' ARTISTAS ':' '[' nomes ']' '}'  {
                                                                                    asprintf(&$$, "TIPO: %s, NOME: %s, DATA: %s, ARTISTAS: [%s]", $4, $8, $12, $17);
                                                                                    eventos_aux = g_slist_append(eventos_aux, newEvento(tipo, strdup($8), data_aux, nomes_aux));
                                                                                    nomes_aux = g_slist_alloc();
                                                                                }
      ;

tipo: CONCERTO                                                                  {asprintf(&$$, "Concerto"); tipo = CONCERTO_D;}
    | SARAU                                                                     {asprintf(&$$, "Sarau"); tipo = SARAU_D;}
    | FESTIVAL                                                                  {asprintf(&$$, "Festival"); tipo = FESTIVAL_D;}
    ;

obras:                                                                          {flag = L_PESSOAL; asprintf(&$$, "");}
     | obra                                                                     {flag = L_PESSOAL; asprintf(&$$, "%s", $1);}
     | obra ',' obras                                                           {asprintf(&$$, "%s; %s", $1, $3);}
     ;

obra: '{' TITULO ':' nome ',' ARTISTAS ':' '[' nomes ']' ',' LANCAMENTO ':' data '}'   {
                                                                                            asprintf(&$$, "TITULO: %s, ARTISTAS: [%s], LANCAMENTO: %s", $4, $9, $14);
                                                                                            obras_aux = g_slist_append(obras_aux, newObra(strdup($4), nomes_aux, lancamento_aux));
                                                                                            nomes_aux = g_slist_alloc();
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
    char *      nome;
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

P_EVENTO  newEvento(int tipo, char * nome, P_DATA data, GSList * artistas){
    P_EVENTO e    = malloc(sizeof(struct evento));
    e->tipo     = tipo;
    e->nome     = nome;
    e->data     = data;
    e->artistas = artistas;
}

void    destroyEvento(void * v){
    if (!v)
        return;
    P_EVENTO e = (P_EVENTO) v;
    destroyData(e->data);
    g_slist_free_full(e->artistas, free);
    free(e->nome);
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

void    printNome(void * v, void * ud) {
    if(!v)
        return;
    printf("%s,", (char *) v);
}

/*FUNCTIONS TO TEST THE LOADING OF DATA IN THE STRUCTURES, THEY SIMPLY PRINT THE DATA */
void    printEvento(void * v, void * ud) {
    if(!v)
        return;
    P_EVENTO e = (P_EVENTO) v;
    char * str;
    switch(e->tipo){
        case CONCERTO_D:
            asprintf(&str,"Concerto");
            break;
        case SARAU_D:
            asprintf(&str,"Sarau");
            break;
        case FESTIVAL_D:
            asprintf(&str,"Festival");
            break;
    }

    printf("%s  %s na data %s com os artistas [", str, e->nome, dataToString(e->data));
    g_slist_foreach(e->artistas, &printNome, NULL);
    printf("],");
}

void    printObra(void * v, void * ud) {
    if(!v)
        return;
    P_OBRA o = (P_OBRA) v;
    printf("%s lançada em %s produzida pelos artistas: [", o->titulo, dataToString(o->lancamento));
    g_slist_foreach(o->artistas, &printNome, NULL);
    printf("],");
}

void    printArtista(void * k, void * v, void * ud){
    P_ARTISTA a = (P_ARTISTA) v;
    printf("Nome: %s\n", a->nome);
    printf("Cidade: %s\n", a->cidade);
    printf("Pais: %s\n", a->pais);
    printf("Vida: %s\n", dataToString(a->vida));
    printf("Nome de nascença: %s\nAprendeu com os artistas: [", a->nomenasc);
    g_slist_foreach(a->aprendeu, &printNome, NULL);
    printf("]\nEnsinou os artistas: [");
    g_slist_foreach(a->ensinou, &printNome, NULL);
    printf("]\nParticipou nos eventos: [");
    g_slist_foreach(a->eventos, &printEvento, NULL);
    printf("]\nCriou as obras: [");
    g_slist_foreach(a->obras, &printObra, NULL);
    printf("]\n");
}

/*FUNCTIONS TO PRINT SOME OF THE DATA CONTAINED IN THE STRUCTURES TO A .DOT GRAPH*/

typedef struct u_d {
    FILE * f;
    char * name;
} * UD;

void    participantesGraph(void * v, void * ud){
    if(!ud || !v)
        return;
    UD d = (UD) ud;
    char * s = (char *) v;

    SHAPE_PARTICIPOU(d->f, s, d->name);
}

void    eventoGraph(void * v, void * ud){
    if(!ud || !v)
        return;
    UD d = (UD) ud;
    P_EVENTO e = (P_EVENTO) v;

    char * str;
    switch (e->tipo){
        case FESTIVAL_D:
            asprintf(&str, "Festival %s em %s",e->nome, dataToString(e->data));
            break;
        case SARAU_D:
            asprintf(&str, "Sarau %s em %s", e->nome, dataToString(e->data));
            break;
        case CONCERTO_D:
            asprintf(&str, "Concerto %s em %s", e->nome, dataToString(e->data));
            break;
    }
    SHAPE_EVENTO(d->f, str);
    SHAPE_PARTICIPOU(d->f, d->name, str);
    UD nd = malloc(sizeof(struct u_d));
    nd->f = d->f;
    nd->name = str;
    g_slist_foreach(e->artistas, &participantesGraph, nd);
    free(nd);
    free(str);
}

void    ensinouGraph(void * v, void * ud){
    if(!ud || !v)
        return;
    UD d = (UD) ud;
    char * s = (char *) v;

    SHAPE_ENSINOU(d->f, d->name, s);
}

void    aprendeuGraph(void * v, void * ud){
    if(!ud || !v)
        return;
    UD d = (UD) ud;
    char * s = (char *) v;

    SHAPE_ENSINOU(d->f, s, d->name);
}

void    criadoresGraph(void * v, void * ud){
    if(!ud || !v)
        return;
    UD d = (UD) ud;
    char * s = (char *) v;

    SHAPE_CRIOU(d->f, s, d->name);
}


void    obraGraph(void * v, void * ud){
    if(!ud || !v)
        return;
    UD d = (UD) ud;
    P_OBRA o = (P_OBRA) v;

    SHAPE_OBRA(d->f, o->titulo);
    SHAPE_CRIOU(d->f, d->name, o->titulo);
    UD nd = malloc(sizeof(struct u_d));
    nd->f = d->f;
    nd->name = o->titulo;
    g_slist_foreach(o->artistas, &criadoresGraph, nd);
    free(nd);
}

void    artistaGraph(void * k, void * v, void * ud){
    if(!ud || !v)
        return;
        FILE * f = (FILE *) ud;
    P_ARTISTA a = (P_ARTISTA) v;

    GRAPH_TEMPLATE(f);
    SHAPE_ARTISTA(f, a->nome);

    UD d = malloc(sizeof(struct u_d));
    d->name = a->nome;
    d->f = f;
    //g_slist_foreach(a->aprendeu, &aprendeuGraph, d);
    g_slist_foreach(a->ensinou, &ensinouGraph, d);
    g_slist_foreach(a->aprendeu, &aprendeuGraph, d);
    g_slist_foreach(a->eventos, &eventoGraph, d);
    g_slist_foreach(a->obras, &obraGraph, d);
    free(d);
}

/*FUNCTIONS TO PRINT THE DATA INTO HTML PAGES */

void artistaHtml( void * k, void * v, void * ud){
    
}

/*---------------------------------------------*/
void yyerror(char* s) {
	printf("%s", s);
}

int main() {
    artistas = g_hash_table_new_full(g_str_hash, g_str_equal, free, &destroyArtista);
    nomes_aux   = g_slist_alloc();
    eventos_aux = g_slist_alloc();
    obras_aux   = g_slist_alloc();
    aprendeu_aux = g_slist_alloc();
    ensinou_aux = g_slist_alloc();

	yyparse();
    printf("-----------PARSING DONE -------------\n");

    g_hash_table_foreach(artistas, &printArtista, NULL);


    FILE * f = fopen("graph.tmp", "w");
    g_hash_table_foreach(artistas, &artistaGraph, f);
    fprintf(f, "}");
    fclose(f);

	return 0;
}
