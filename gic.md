# Gramática
## Esta gramática pretende descrever uma rede semântica para representar um Museu dedicado a um músico


p0:   S   ->  Artista
p1:   Artista   ->  '{' Pessoal  ',' '{' Eventos '}' ',' Formacao ',' '{' Obras '}' '}'
p2:   Eventos   ->  Evento ';' Eventos
p4:             |   Evento
p5:   Evento    ->  '{' Tipo ',' Data ',' '{' Nomes '}' '}'
p6:   Tipo      ->  CONCERTO
p7:             |   FESTIVAL
p8:             |   SARAU
p9:   Data      ->  '(' NUM '/' NUM '/' NUM ')'
p10:            |   '(' NUM '/' NUM '/' NUM '-' NUM '/' NUM '/' NUM ')'
p11:  Nomes     ->  NOME ';' Nomes
p12:            |   NOME
p13:  Pessoal   ->  NOME ',' Naturalidade ',' Data ',' NOMENASC        
p14:  Naturalidade  ->  CIDADE ',' PAIS      
p15:  Formacao  ->  
p16:  
p17:
p18:
p19:
p20:
p21:
p22:
p23:
p24:
p25:
p26:
p27:
p28:
p29:
p30:
