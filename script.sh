flex comp.l 
yacc -d -v comp.y 
gcc y.tab.c `pkg-config --cflags --libs glib-2.0` -g -o prog 
./prog < teste.txt
awk '!a[$0]++' graph.tmp > graph.dot
neato -Tpng graph.dot -o graph.png
eog graph.png
rm graph.dot graph.png graph.tmp
