# Gramática
## Esta gramática pretende descrever uma rede semântica para representar um Museu

T = {'{', '}', '(', ')', ';', ',', '/', '-', 'NUM', 'STR', 'CONCERTO', 'FESTIVAL', 'SARAU', 'ENSINOU', 'APRENDEU'}

NT = {'Artistas', 'Artista', 'Eventos', 'Evento', 'Tipo', 'Data', 'Nomes', 'Pessoal', 'Naturalidade', 'Formacao', 'Obras', 'Obra', 'NOME', 'NOMENASC', 'NOMEART', 'PAIS', 'CIDADE'}

p0:   Artistas  ->  Artista ';' Artistas
p1:             |   Artista
p2:   Artista   ->  '{' Pessoal  ',' '{' Eventos '}' ',' Formacao ',' '{' Obras '}' '}'
p3:   Eventos   ->  Evento ';' Eventos
p4:             |   &
p5:   Evento    ->  '{' Tipo ',' Data ',' '{' Nomes '}' '}'
p6:   Tipo      ->  CONCERTO
p7:             |   FESTIVAL
p8:             |   SARAU
p9:   Data      ->  '(' NUM '/' NUM '/' NUM ')'
p10:            |   '(' NUM '/' NUM '/' NUM '-' NUM '/' NUM '/' NUM ')'
p11:  Nomes     ->  NOME ';' Nomes
p12:            |   &
p13:  Pessoal   ->  NOME ',' Naturalidade ',' Data ',' NOMENASC        
p14:  Naturalidade  ->  CIDADE ',' PAIS      
p15:  Formacao  ->  ENSINOU '(' Nomes ')' ';'  Formacao
p16:            |   APRENDEU '(' Nomes ')' ';' Formacao
p17:            |   &
p18:  Obras     ->  Obra ';' Obras
p19:            |   &
p20:  Obra      ->  '{' NOME ',' NOMEART ',' Data '}'
p21:  NOME      ->  '''STR'''
p22:  PAIS      ->  '''STR'''
p23:  CIDADE    ->  '''STR'''
p24:  NOMENASC  ->  '''STR'''
p25:  NOMEART   ->  '''STR'''
p26:
p27:
p28:
p29:
p30:
