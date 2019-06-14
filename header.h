
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <glib.h>




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
P_EVENTO  newEvento(int tipo, char * nome, P_DATA data, GSList * artistas);
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
#define             SHAPE_ARTISTA(F, A)            fprintf(F, "\t\"%s\" \t[label=\"%s\", href=\"pages/%s.html\", shape=box, style=filled, fillcolor=\"#5A659E\", color=\"#5A659E\"];\n", A, A, A);
#define             SHAPE_OBRA(F, O)               fprintf(F, "\t\"%s\" \t[label=\"%s\", href=\"pages/%s.html\", style=filled, color=\"#CCBA8C\", fillcolor=\"#CCBA8C\"];\n", O, O, O);
#define             SHAPE_EVENTO(F, E)             fprintf(F, "\t\"%s\" \t[label=\"%s\", href=\"pages/%s.html\", shape=polygon, style=filled, fillcolor=\"#DD7230\", color=\"#DD7230\"];\n", E, E, E);
#define             SHAPE_ENSINOU(F, X, Y)         fprintf(F, "\t\"%s\" \t-> \t\"%s\" \t[arrowsize=0.4, weight=0.1, color=\"#5A659E\"];\n", X, Y);
#define             SHAPE_CRIOU(F, X, Y)           fprintf(F, "\t\"%s\" \t-> \t\"%s\" \t[arrowsize=0.4, weight=0.1, color=\"#CCBA8C\"];\n", X, Y);
#define             SHAPE_PARTICIPOU(F, X, Y)      fprintf(F, "\t\"%s\" \t-> \t\"%s\" \t[arrowsize=0.4, weight=0.1, color=\"#DD7230\"];\n", X, Y);
#define             GRAPH_TEMPLATE(F)              fprintf(F, "digraph Museu {\n\tsize=\"31,41\";\n\tnode [fontname=\"helvetica\"];\n\tranksep=3.0;\n\tnodesep=2.0;\n\toverlap=\"false\";\n\tsplines=\"true\";\n");
//defin formatting of output to html files
#define             HTML_PARAGRAPH(F, S)           fprintf(F, "<p> %s </p>\n", S);
#define             HTML_TITLE(F,T)                fprintf(F, "<h1> %s </h1>\n", T);
#define             HTML_END(F)                    fprintf(F, "</div>\n</body>\n</html>");
#define             HTML_START_OBRAS(F)            fprintf(F, "<h3>Obras</h3> \
                                                                  <table class=\"table\"> \
                                                                    <thead> \
                                                                      <tr> \
                                                                        <th scope=\"col\">Nome</th> \
                                                                        <th scope=\"col\">Lançamento</th> \
                                                                      </tr> \
                                                                    </thead> \
                                                                    <tbody>\n");
#define             HTML_START_EVENTOS(F)          fprintf(F, "<h3>Eventos</h3> \
                                                                  <table class=\"table\"> \
                                                                    <thead> \
                                                                      <tr> \
                                                                        <th scope=\"col\">Tipo</th> \
                                                                        <th scope=\"col\">Nome</th> \
                                                                        <th scope=\"col\">Data</th> \
                                                                      </tr> \
                                                                    </thead> \
                                                                    <tbody>\n");
#define             HTML_START_ENSINOU(F)          fprintf(F, "<h3>Influenciou:</h3> \
                                                                  <table class=\"table\"> \
                                                                    <thead> \
                                                                      <tr> \
                                                                        <th scope=\"col\">Artista</th> \
                                                                      </tr> \
                                                                    </thead> \
                                                                    <tbody>\n");
#define             HTML_START_APRENDEU(F)         fprintf(F, "<h3>Influenciado por:</h3> \
                                                                  <table class=\"table\"> \
                                                                    <thead> \
                                                                      <tr> \
                                                                        <th scope=\"col\">Artista</th> \
                                                                      </tr> \
                                                                    </thead> \
                                                                    <tbody>\n");
#define             HTML_START_ARTISTAS(F)         fprintf(F,   "<table class=\"table\"> \
                                                                    <thead> \
                                                                      <tr> \
                                                                        <th scope=\"col\">Artista</th> \
                                                                      </tr> \
                                                                    </thead> \
                                                                    <tbody>\n");
#define             HTML_END_TABLE(F)              fprintf(F, "</tbody>\n</table>\n");
#define             HTML_EVENTO_ROW(F, T, N, D)    fprintf(F, "<tr> \
                                                                  <td>%s</td> \
                                                                  <td>%s</td> \
                                                                  <td>%s</td> \
                                                                </tr>\n", T, N, D);
#define             HTML_OBRAS_ROW(F, N, L)        fprintf(F, "<tr> \
                                                                  <td>%s</td> \
                                                                  <td>%s</td> \
                                                                </tr>\n", N, L);
#define             HTML_NOME_ROW(F, N)            fprintf(F, "<tr> \
                                                                  <td>%s</td> \
                                                                </tr>\n", N);
#define             HTML_BEGINNING(F)              fprintf(F, "<!doctype html> \
                                                                <html lang=\"en\"> \
                                                                  <head> \
                                                                    <meta charset=\"utf-8\"> \
                                                                    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1, shrink-to-fit=no\"> \
                                                                    <meta name=\"description\" content=\"\"> \
                                                                    <meta name=\"author\" content=\"\"> \
                                                                \
                                                                    <title>Processamento de Linguagens</title> \
                                                                \
                                                                    <link rel=\"canonical\" href=\"https://getbootstrap.com/docs/4.0/examples/grid/\"> \
                                                                \
                                                                    <link href=\"bootstrap.min.css\" rel=\"stylesheet\"> \
                                                                \
                                                                    <link href=\"grid.css\" rel=\"stylesheet\"> \
                                                                  </head> \
                                                                \
                                                                  <body> \
                                                                    <div class=\"container\">\n");
