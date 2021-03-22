%declaracion de librerias para la interfaz

:-use_module(library(pce)).
:-use_module(library(pce_style_item)).

% metodo principal para iniciar la interfaz grafica, declaracion de
% botones, labels, y la pocicion en pantalla.
inicio:-
	new(Menu, dialog('Yerberito - Sistema Experto', size(1500,1000))),
	new(L,label(nombre,'Sistema Experto Yerberito')),
	new(A,label(nombre,'S16120276 - C16120547')),
	new(@texto,label(nombre,'Responde unas preguntas para tu recomendaci�n')),
	new(@respl,label(nombre,'')),
	new(Salir,button('Salir',and(message(Menu, destroy),message(Menu,free)))),
	new(@boton,button('Comenzar',message(@prolog,botones))),


	send(Menu,append(L)),new(@btncarrera,button('Diagnostico?')),
	send(Menu,display,L,point(80,20)),
	send(Menu,display,A,point(150,400)),
	send(Menu,display,@boton,point(100,150)),
	send(Menu,display,@texto,point(20,100)),
	send(Menu,display,Salir,point(20,400)),
	send(Menu,display,@respl,point(20,130)),
	send(Menu,open_centered).

%Descripcion de la planta y recomendaciones

conocimiento('Chile (Capsicum):
	Recomendaciones:
El chile verde se usa en medicina contra el asma 
(cocidas las hojas) y el reumatismo (aplicando pa�os 
calientes con el cocimiento del fruto)

S�lo diremos que darles chile picante a los ni�os es 
la peor estupidez.

Y los adultos que lo coman, s�panse (por si no lo 
han notado) que irrita las mucosas estomacales, 
inflama el h�gado, produce diarrea e irrita las hemorroides.
'):-chile,!.

conocimiento('Chichigua (Solanum mammosum):
	Recomendaciones:
El fruto de este arbusto es una baya amarilla, que 
contiene unas semillitas molidas que, 
- Constipado: molidas en alcohol, se aplican como cataplasma.
- Afecciones de la piel: se frotan los frutos 
en la parte afectada.
- Otra: Se calienta el fruto en aceite y este se aplica 
en gotas en la nariz en el caso de constipado.
'):-chichigua,!.

conocimiento('Cilantro (Coriandrum sativum):
	Recomendaciones:
Aparte de su uso en la comida mexicana tiene grandes 
propiedades digestivas y estomacales al eliminar gases, 
flatos y dem�s olores desagradables emanados del tubo 
digestivo, am�n de que es �til en caso de c�licos.

�No puede faltar en los tacos!
'):-cilantro,!.

conocimiento('Ricino (Ricinus communis):
	Recomendaciones:
Esta planta es todav�a el mejor purgante que hay, pues 
no irrita el tubo digestivo del ni�o. 

�Desde la biblia se usa!

�til pues en estre�imiento, peritonitis, lombrices, 
hernia estrangulada, etc.
Ca�da de cabello.
'):-ricino,!.

conocimiento('Rosal (Rosa):
	Recomendaciones:
Muchos lectores se van a azotar al ver que la 
archifamosa rosa es una planta medicinal, y lo es, 
los p�talos secos a la sombra son laxantes y astringentes 
muy usados como infusi�n en c�licos infantiles y empachos.

Tambi�n en los ojos, para la conjuntivitis de ni�os y 
adultos y para ayudar al beb� (antes de que tome el pecho) 
a digerir la leche materna.
'):-rosal,!.

conocimiento('Romero (Salvia rosmarinus):
	Recomendaciones:
Esta modesta planta se usa desde siglos por las mujeres 
en lavados vaginales pero resulta que tiene otras propiedades.
Tomado como t� es estimulante emenagogo y estomacal, es 
decir, regulariza la mentruaci�n, estimula la digesti�n y conforta los nervios.

Fumado ayuda en casos de asma.
Tmbi�n ayuda a evitar la ca�da del cabello.
'):-romero,!.

conocimiento('Sin resultados, usted no dio la informacion necesaria o suficiente').

conocimiento('Hola'):-herbolaria,!.

% preguntas para dirigir a la planta adecuada con su respectivo
% identificador

herbolaria:- sherbolaria,
	pregunta('hola').

chile:- schile,
	pregunta('�Dificultad para respirar?');
	pregunta('�Tienes asma?').

chichigua:- schichigua,
	pregunta('�Dificultad para respirar?'),
	pregunta('�Constipado?');
	pregunta('�Afecciones de la piel?'),
	pregunta('�Constipado leve?').
	
cilantro:- scilantro,
	pregunta('�Gases?'),
	pregunta('�Mal olor?');
	pregunta('�C�licos?').

ricino:- sricino,
        pregunta('�Gases? '),
	pregunta('�Estre�imiento?');
	pregunta('�Peritonitis?');
	pregunta('�Lombrices?');
	pregunta('�Caida de cabello?').
	
rosal:- srosal,
	pregunta('�Conjuntivitis?'),
        pregunta('�C�licos?');
	pregunta('�Empacho?');
	pregunta('�Indigesti�n?').

romero:- sromero,
	pregunta('�Menstruaci�n?');
	pregunta('�Asma?');
	pregunta('�Ca�da de cabello?').

%identificador de falla que dirige a las preguntas correspondientes

sherbolaria:-pregunta('�Quieres un remedio natural?'),!.
schile:-pregunta('�Eres adulto?'),!.
schichigua:-pregunta('�Dolor corporal?'),!.
scilantro:-pregunta('�Digesti�n mala?'),!.
sricino:-pregunta('�Empacho?'),!.
srosal:-pregunta('�Dolor ojos?'),!.
sromero:-pregunta('�Nerviosismo?'),!.

% proceso de la recomendaci�n basado en preguntas de si y no, cuando el
% usuario dice si, se pasa a la siguiente pregunta del mismo ramo, si
% dice que no se pasa a la pregunta del siguiente ramo


:-dynamic si/1,no/1.
preguntar(Problema):- new(Di,dialog('Recomendaci�n planta')),
     new(L2,label(texto,'Responde las siguientes preguntas')),
     new(La,label(prob,Problema)),
     new(B1,button(si,and(message(Di,return,si)))),
     new(B2,button(no,and(message(Di,return,no)))),

         send(Di,append(L2)),
	 send(Di,append(La)),
	 send(Di,append(B1)),
	 send(Di,append(B2)),

	 send(Di,default_button,si),
	 send(Di,open_centered),get(Di,confirm,Answer),
	 write(Answer),send(Di,destroy),
	 ((Answer==si)->assert(si(Problema));
	 assert(no(Problema)),fail).

% cada vez que se conteste una pregunta la pantalla se limpia para
% volver a preguntar

pregunta(S):-(si(S)->true; (no(S)->fail; preguntar(S))).
limpiar :- retract(si(_)),fail.
limpiar :- retract(no(_)),fail.
limpiar.

% proceso de eleccion de acuerdo al diagnostico basado en las preguntas
% anteriores

botones :- lim,
	send(@boton,free),
	send(@btncarrera,free),
	conocimiento(Falla),
	send(@texto,selection(' ')),
	send(@respl,selection(Falla)),
	new(@boton,button('inicia procedimiento mecanico',message(@prolog,botones))),
        send(Menu,display,@boton,point(40,50)),
        send(Menu,display,@btncarrera,point(20,50)),
limpiar.
lim :- send(@respl, selection('')).
