flex comp.l 
yacc -d -v comp.y 
gcc y.tab.c `pkg-config --cflags --libs glib-2.0` -g -o cena
./cena < teste.txt
neato -Tpng graph.dot -o graph.png
eog graph.png
