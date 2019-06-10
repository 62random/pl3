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
void    printArtista(void * k, void * v, void *ud);
char *  dataToString(P_DATA d);
//utility functions
//defines types of events
#define             FESTIVAL_D            0
#define             CONCERTO_D            1
#define             SARAU_D               2
//defines labels to control parsing
#define             L_PESSOAL             0
#define             L_FORMACAO            1
#define             L_EVENTO              2
#define             L_OBRA                3
//define formatting of output to .dot file
#define             SHAPE_ARTISTA(F, A)            fprintf(F, "\t\"%s\" \t[shape=box, style=filled, fillcolor=\"#8B95C9\", color=\"#8B95C9\"];\n", A);
#define             SHAPE_OBRA(F, O)               fprintf(F, "\t\"%s\" \t[style=filled, color=\"#E8DBC5\", fillcolor=\"#E8DBC5\"];\n", O);
#define             SHAPE_EVENTO(F, E)             fprintf(F, "\t\"%s\" \t[shape=diamond, style=filled, fillcolor=\"#CCC9E7\", color=\"#CCC9E7\"];\n", E);
#define             SHAPE_ENSINOU(F, X, Y)         fprintf(F, "\t\"%s\" \t-> \t\"%s\" \t[arrowsize=0.4, weight=0.1, color=\"#8B95C9\"];\n", X, Y);
#define             SHAPE_CRIOU(F, X, Y)           fprintf(F, "\t\"%s\" \t-> \t\"%s\" \t[arrowsize=0.4, weight=0.1, color=\"#E8DBC5\"];\n", X, Y);
#define             SHAPE_PARTICIPOU(F, X, Y)      fprintf(F, "\t\"%s\" \t-> \t\"%s\" \t[arrowsize=0.4, weight=0.1, color=\"#CCC9E7\"];\n", X, Y);
#define             GRAPH_TEMPLATE(F)              fprintf(F, "digraph Museu {\n\tsize=\"31,41\";\n\tnode [fontname=\"helvetica\"];\n\tranksep=3.0;\n\tnodesep=2.0;\n\toverlap=\"false\";\n\tsplines=\"true\";\n");
