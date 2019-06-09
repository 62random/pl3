#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#ifdef __APPLE__
#include </Library/Frameworks/Mono.framework/Versions/5.16.0/include/glib-2.0/glib.h>
#else
#include <glib.h>
#endif


// typedef struct definitions
typedef struct data * P_DATA;
typedef struct obra * P_OBRA;
typedef struct evento * P_EVENTO;
typedef struct artista * P_ARTISTA;

// function declarations
int     asprintf(char ** str, const char * fmt, ...);
int     yylex();
void    yyerror(char * s);
int     yydebug = 1;
// constructors and destroyers
P_DATA    newData(int dn, int mn, int an, int dm, int mm, int am);
void    destroyData(void * v);
P_OBRA    newObra(char * titulo, GSList * artistas,P_DATA lancamento);
void    destroyObra(void * v);
P_EVENTO  newEvento(int tipo, P_DATA data, GSList * artistas);
void    destroyEvento(void * v);
P_ARTISTA newArtista(char * nome, char * cidade,
                    char * pais, P_DATA vida, char * nomenasc,
                    GSList * ensinou, GSList * aprendeu,
                    GSList * eventos, GSList * obras);
void    destroyArtista(void * v);
char *  dataToString(P_DATA d);
//utility functions
//defines
#define             FESTIVAL_D            0
#define             CONCERTO_D            1
#define             SARAU_D               2

#define             L_PRG                 0
#define             L_ARTISTAS            1
#define             L_ARTISTA             2
#define             L_PESSOAL             3
#define             L_NOME                4
#define             L_NATURALIDADE        5
#define             L_CIDADE              6
#define             L_PAIS                7
#define             L_DATA                8
#define             L_NOMENASC            9
#define             L_FORMACAO            10
#define             L_NOMES               11
#define             L_EVENTOS             12
#define             L_EVENTO              13
#define             L_TIPO                14
#define             L_OBRAS               15
#define             L_OBRA                16
