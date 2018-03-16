
/******************************************************
******************** PLAYER GRUPO 2.1 *****************
*******************************************************
***************** IV罭 MART蚇EZ EST蒝EZ ***************
***************** ISMAEL V罿QUEZ FERN罭DEZ ************
***************** IV罭 DE DIOS FERN罭DEZ **************
***************** IV罭 FERN罭DEZ S罭CHEZ **************
*******************************************************/



/* Initial beliefs and rules */
player(1).
vecesRecorrido(0).
filaY(9).
objetivo(0). //Almacena el Plan que realiza el intercambio
contiguas(X,X,Y1,Y2) :- math.abs(Y1-Y2) = 1.
contiguas(X1,X2,Y,Y) :- math.abs(X1-X2) = 1.

izquierda(X,Y,C,0) :- not steak(C,X,Y).
izquierda(X,Y,C,N) :- steak(C,X,Y) & izquierda(X-1,Y,C,N1) & N = N1+1.

derecha(X,Y,C,0) :- not steak(C,X,Y).
derecha(X,Y,C,N) :- steak(C,X,Y) & derecha(X+1,Y,C,N1) & N = N1+1 & not C==4.

arriba(X,Y,C,0) :- not steak(C,X,Y).
arriba(X,Y,C,N) :- steak(C,X,Y) & arriba(X,Y-1,C,N1) & N = N1+1 & not C==4.

abajo(X,Y,C,0) :- not steak(C,X,Y).
abajo(X,Y,C,N) :- steak(C,X,Y) & abajo(X,Y+1,C,N1) & N = N1+1 & not C==4.

fila(X,Y,C,T) :- steak(C1,X,Y) & izquierda(X-1,Y,C,N) & derecha(X+1,Y,C,M) & N+M >= T-1 & not C == C1 & not C1==4.
columna(X,Y,C,T) :- steak(C1,X,Y) & arriba(X,Y-1,C,N) & abajo(X,Y+1,C,M) & N+M >= T-1 & not C == C1 & not C1==4.


/* Initial goals */


/* Plans */

+canExchange(N) : player(N) & sizeof(T)<- 
			.print("Numero del player: ", N);
			.wait(500);
			-+filaY(T);
			-+vecesRecorrido(0);
			-+objetivo(0); 
			!buscarMovimientos.		

+tryAgain : sizeof(T) <- 
			+myTurn; 
			.abolish(tryAgain);
			.wait(500);
			-+filaY(T);
			-+vecesRecorrido(0);
			!buscarMovimientos.

/*
	AGRUPACION QUE AMPLIEN REGION
*/


//Agrupaci髇 5

			
+!buscarMovimientos: objetivo(P) & not P==1 & filaY(Y) & columna(X,Y,C,5) & steak(C,X-1,Y) 
					& player(N) & player(N+1,X,Y) & steak(C1,X,Y) & not C1 == 4  & not C ==4
	<- -+objetivo(1); !intercambiar(der,steak(C,X-1,Y)).

+!buscarMovimientos : objetivo(P) & not P==2 & filaY(Y) & columna(X,Y,C,5) & steak(C,X+1,Y) 
					& player(N) & player(N+1,X,Y)& steak(C1,X,Y) & not C1 == 4  & not C ==4
	<- -+objetivo(2); !intercambiar(izq,steak(C,X+1,Y)). 

+!buscarMovimientos : objetivo(P) & not P==3 & filaY(Y) &fila(X,Y,C,5) & steak(C,X,Y-1) 
					& player(N) & player(N+1,X,Y) & steak(C1,X,Y) & not C1 == 4  & not C ==4
	<- -+objetivo(3); !intercambiar(bajar,steak(C,X,Y-1)). 

+!buscarMovimientos : objetivo(P) & not P==4 & filaY(Y) &fila(X,Y,C,5) & steak(C,X,Y+1) 
					& player(N) & player(N+1,X,Y) & steak(C1,X,Y) & not C1 == 4  & not C ==4
	<- -+objetivo(4); !intercambiar(subir,steak(C,X,Y+1)). 

	
//Agrupaci髇 T  con region
+!buscarMovimientos : objetivo(P) & not P==5 & filaY(Y) & steak(C,X,Y) & steak(C,X-1,Y+1) 
					& steak(C1,X,Y+1) & steak(C,X+1,Y+1) & steak(C,X,Y+2) & steak(C,X,Y+3) 
					& player(N) & player(N+1,X,Y) & not C == C1 & steak(C1,X,Y) & not C1 == 4  
					& not C ==4
	<- -+objetivo(5); !intercambiar(bajar,steak(C,X,Y)). 
	
+!buscarMovimientos : objetivo(P) & not P==6 & filaY(Y) &steak(C,X,Y) & steak(C,X-1,Y-1) 
					& steak(C1,X,Y-1)& steak(C,X+1,Y-1) & steak(C,X,Y-2) & steak(C,X,Y-3)
					& player(N) & player(N+1,X,Y) & not C == C1	& steak(C1,X,Y) & not C1 == 4 
					& not C ==4
	<- -+objetivo(6); !intercambiar(subir,steak(C,X,Y)).
	
+!buscarMovimientos : objetivo(P) & not P==7 & filaY(Y) &steak(C,X,Y) & steak(C,X+1,Y-1) 
					& steak(C1,X+1,Y) & steak(C,X+2,Y) & steak(C,X+3,Y) & steak(C,X+1,Y+1) 
					& player(N) & player(N+1,X,Y)& not C == C1 & steak(C1,X,Y) & not C1 == 4  
					& not C ==4
	<- -+objetivo(7); !intercambiar(der,steak(C,X,Y)).  
	
+!buscarMovimientos : objetivo(P) & not P==8 & filaY(Y) &steak(C,X,Y) & steak(C,X-1,Y-1) 
					& steak(C1,X-1,Y) & steak(C,X-2,Y) & steak(C,X-3,Y) & steak(C,X-1,Y+1) 
					& player(N) & player(N+1,X,Y) & not C == C1	& steak(C1,X,Y) & not C1 == 4 
					& not C ==4
	<- -+objetivo(8); !intercambiar(izq,steak(C,X,Y)).
	
	
//Agrupaci髇 Cuadrado  con region
+!buscarMovimientos : objetivo(P) & not P==9 & filaY(Y) & steak(C,X,Y) & steak(C1,X+1,Y) 
					& steak(C,X+2,Y) & steak(C,X+1,Y+1) & steak(C,X+2,Y+1)& player(N)
					& player(N+1,X,Y) & not C == C1 & steak(C1,X,Y) & not C1 == 4  
					& not C ==4
	<- -+objetivo(9); !intercambiar(der,steak(C,X,Y)). 
	
+!buscarMovimientos : objetivo(P) & not P==10 & filaY(Y) &steak(C,X,Y) & steak(C1,X+1,Y) 
					& steak(C,X+2,Y) & steak(C,X+1,Y-1) & steak(C,X+2,Y-1)& player(N) 
					& player(N+1,X,Y) & not C == C1	& steak(C1,X,Y) & not C1 == 4  
					& not C ==4
	<- -+objetivo(10); !intercambiar(der,steak(C,X,Y)). 
	
+!buscarMovimientos : objetivo(P) & not P==11 & filaY(Y) & steak(C,X,Y) & steak(C1,X-1,Y)
					& steak(C,X-2,Y) & steak(C,X-1,Y+1) & steak(C,X-2,Y+1)& player(N) 
					& player(N+1,X,Y) & not C == C1	& steak(C1,X,Y) & not C1 == 4  
					& not C ==4
	<- -+objetivo(11); !intercambiar(izq,steak(C,X,Y)). 
	
+!buscarMovimientos : objetivo(P) & not P==12 & filaY(Y) & steak(C,X,Y) & steak(C1,X-1,Y) 
					& steak(C,X-2,Y) & steak(C,X-1,Y-1) & steak(C,X-2,Y-1)& player(N) 
					& player(N+1,X,Y) & not C == C1 & steak(C1,X,Y) & not C1 == 4  
					& not C ==4
	<- -+objetivo(12); !intercambiar(izq,steak(C,X,Y)).
	
//Agrupaci髇 4  con region
+!buscarMovimientos : objetivo(P) & not P==13 & filaY(Y) & fila(X,Y,C,4) & steak(C,X,Y+1) 
					& player(N) & player(N+1,X,Y) & steak(C1,X,Y) & not C1 == 4  & not C ==4
	<- -+objetivo(13); !intercambiar(subir,steak(C,X,Y+1)).

+!buscarMovimientos : objetivo(P) & not P==14 & filaY(Y) & fila(X,Y,C,4) & steak(C,X,Y-1)
					& player(N) & player(N+1,X,Y) & steak(C1,X,Y) & not C1 == 4  & not C ==4
	<- -+objetivo(14); !intercambiar(bajar,steak(C,X,Y-1)). 
	
+!buscarMovimientos : objetivo(P) & not P==15 & filaY(Y) &columna(X,Y,C,4) & steak(C,X+1,Y)
					& player(N) & player(N+1,X,Y) & steak(C1,X,Y) & not C1 == 4  & not C ==4
	<- -+objetivo(15); !intercambiar(izq,steak(C,X+1,Y)). 
	
+!buscarMovimientos : objetivo(P) & not P==16 & filaY(Y) & columna(X,Y,C,4) & steak(C,X-1,Y)
					& player(N) & player(N+1,X,Y) & steak(C1,X,Y) & not C1 == 4  & not C ==4
	<- -+objetivo(16); !intercambiar(der,steak(C,X-1,Y)).


//Agrupaci髇  3 con region
+!buscarMovimientos : objetivo(P) & not P==17 & filaY(Y) &  fila(X,Y,C,3) & steak(C,X,Y-1)
					& player(N) & player(N+1,X,Y) & steak(C1,X,Y) & not C1 == 4 & not C ==4 
	<- -+objetivo(17); !intercambiar(bajar,steak(C,X,Y-1)). 
	
+!buscarMovimientos : objetivo(P) & not P==18 & filaY(Y) &fila(X,Y,C,3) & steak(C,X,Y+1)
					& player(N) & player(N+1,X,Y) & steak(C1,X,Y) & not C1 == 4  & not C ==4
	<- -+objetivo(18); !intercambiar(subir,steak(C,X,Y+1)). 
	
+!buscarMovimientos : objetivo(P) & not P==19 & filaY(Y) & columna(X,Y,C,3) & steak(C,X+1,Y)
					& player(N) & player(N+1,X,Y) & steak(C1,X,Y) & not C1 == 4  & not C ==4
	<- -+objetivo(19);!intercambiar(izq,steak(C,X+1,Y)). 
	
+!buscarMovimientos : objetivo(P) & not P==20 & filaY(Y) &columna(X,Y,C,3) & steak(C,X-1,Y)
					& player(N) & player(N+1,X,Y) & steak(C1,X,Y) & not C1 == 4  & not C ==4
	<- -+objetivo(20); !intercambiar(der,steak(C,X-1,Y)).


/*
	AGRUPACION SIN REGION
*/

//Agrupaci髇  5
+!buscarMovimientos : objetivo(P) & not P==21 & filaY(Y) & fila(X,Y,C,5) & steak(C,X,Y-1)
					& steak(C1,X,Y) & not C1 == 4  & not C ==4
	<- -+objetivo(21); !intercambiar(bajar,steak(C,X,Y-1)). 
	
+!buscarMovimientos : objetivo(P) & not P==22 & filaY(Y) & fila(X,Y,C,5) & steak(C,X,Y+1)
					& steak(C1,X,Y) & not C1 == 4  & not C ==4
	<- -+objetivo(22);!intercambiar(subir,steak(C,X,Y+1)). 
	
+!buscarMovimientos : objetivo(P) & not P==23 & filaY(Y) & columna(X,Y,C,5) & steak(C,X+1,Y) 
					& steak(C1,X,Y) & not C1 == 4  & not C ==4
	<- -+objetivo(23); !intercambiar(izq,steak(C,X+1,Y)). 
	
+!buscarMovimientos : objetivo(P) & not P==24 & filaY(Y) & columna(X,Y,C,5) & steak(C,X-1,Y) 
					& steak(C1,X,Y) & not C1 == 4  & not C ==4
	<- -+objetivo(24); !intercambiar(der,steak(C,X-1,Y)).

//Agrupaci髇 T
+!buscarMovimientos : objetivo(P) & not P==25 & filaY(Y) & steak(C,X,Y) & steak(C,X-1,Y+1) 
					& steak(C1,X,Y+1) & steak(C,X+1,Y+1) & steak(C,X,Y+2) & steak(C,X,Y+3)
					& not C == C1 & not C1 == 4  & not C ==4
	<- -+objetivo(25); !intercambiar(bajar,steak(C,X,Y)).
	
+!buscarMovimientos : objetivo(P) & not P==26 & filaY(Y) & steak(C,X,Y) & steak(C,X-1,Y-1) 
					& steak(C1,X,Y-1) & steak(C,X+1,Y-1) & steak(C,X,Y-2) & steak(C,X,Y-3) 
					& not C == C1 & not C1 == 4  & not C ==4
	<- -+objetivo(26); !intercambiar(subir,steak(C,X,Y)). 
	
+!buscarMovimientos : objetivo(P) & not P==27 & filaY(Y) & steak(C,X,Y) & steak(C,X+1,Y-1) 
					& steak(C1,X+1,Y) & steak(C,X+2,Y) & steak(C,X+3,Y) & steak(C,X+1,Y+1) 
					& not C == C1 & not C1 == 4  & not C ==4
	<- -+objetivo(27); !intercambiar(der,steak(C,X,Y)).  
	
+!buscarMovimientos : objetivo(P) & not P==28 & filaY(Y) & steak(C,X,Y) & steak(C,X-1,Y-1) 
					& steak(C1,X-1,Y) & steak(C,X-2,Y) & steak(C,X-3,Y) & steak(C,X-1,Y+1) 
					& not C == C1 & not C1 == 4  & not C ==4
	<- -+objetivo(28); !intercambiar(izq,steak(C,X,Y)). 

	
//Agrupaci髇 Cuadrado
+!buscarMovimientos : objetivo(P) & not P==29 & filaY(Y) & steak(C,X,Y) & steak(C1,X+1,Y) 
					& steak(C,X+2,Y) & steak(C,X+1,Y+1) & steak(C,X+2,Y+1) & not C == C1
					& not C1 == 4  & not C ==4
	<- -+objetivo(29); !intercambiar(der,steak(C,X,Y)).
	
+!buscarMovimientos : objetivo(P) & not P==30 & filaY(Y) & steak(C,X,Y) & steak(C1,X+1,Y) 
					& steak(C,X+2,Y) & steak(C,X+1,Y-1) & steak(C,X+2,Y-1) & not C == C1
					& not C1 == 4  & not C ==4
	<- -+objetivo(30); !intercambiar(der,steak(C,X,Y)). 
	
+!buscarMovimientos : objetivo(P) & not P==31 & filaY(Y) & steak(C,X,Y) & steak(C1,X-1,Y) 
					& steak(C,X-2,Y) & steak(C,X-1,Y+1) & steak(C,X-2,Y+1) & not C == C1
					& not C1 == 4  & not C ==4
	<- -+objetivo(31); !intercambiar(izq,steak(C,X,Y)).
	
+!buscarMovimientos : objetivo(P) & not P==32 & filaY(Y) &  steak(C,X,Y) & steak(C1,X-1,Y) 
					& steak(C,X-2,Y) & steak(C,X-1,Y-1) & steak(C,X-2,Y-1) & not C == C1
					& not C1 == 4  & not C ==4
	<- -+objetivo(32); !intercambiar(izq,steak(C,X,Y)).
	
	
//Agrupaci髇 4
+!buscarMovimientos : objetivo(P) & not P==33 & filaY(Y) &  fila(X,Y,C,4) & steak(C,X,Y-1)
					& steak(C1,X,Y) & not C1 == 4  & not C ==4
	<- -+objetivo(33); !intercambiar(bajar,steak(C,X,Y-1)). 
	
+!buscarMovimientos : objetivo(P) & not P==34 & filaY(Y) & fila(X,Y,C,4) & steak(C,X,Y+1)
					& steak(C1,X,Y) & not C1 == 4 & not C ==4 
	<- -+objetivo(34);!intercambiar(subir,steak(C,X,Y+1)). 
	
+!buscarMovimientos : objetivo(P) & not P==35 & filaY(Y) & columna(X,Y,C,4) & steak(C,X+1,Y) 
					& steak(C1,X,Y) & not C1 == 4  & not C ==4
	<- -+objetivo(35); !intercambiar(izq,steak(C,X+1,Y)). 
	
+!buscarMovimientos : objetivo(P) & not P==36 & filaY(Y) &  columna(X,Y,C,4) & steak(C,X-1,Y)
					& steak(C1,X,Y) & not C1 == 4  & not C ==4
	<- -+objetivo(36);!intercambiar(der,steak(C,X-1,Y)).


//Agrupaci髇  3
+!buscarMovimientos : objetivo(P) & not P==37 & filaY(Y) &  fila(X,Y,C,3) & steak(C,X,Y-1) 
					& steak(C1,X,Y) & not C1 == 4  & not C ==4
	<- -+objetivo(37); !intercambiar(bajar,steak(C,X,Y-1)). 
	
+!buscarMovimientos : objetivo(P) & not P==38 & filaY(Y) &  fila(X,Y,C,3) & steak(C,X,Y+1) 
					& steak(C1,X,Y) & not C1 == 4  & not C ==4
	<- -+objetivo(38);!intercambiar(subir,steak(C,X,Y+1)). 
	
+!buscarMovimientos : objetivo(P) & not P==39 & filaY(Y) &  columna(X,Y,C,3) & steak(C,X+1,Y) 
					& steak(C1,X,Y) & not C1 == 4 
	<- -+objetivo(39); !intercambiar(izq,steak(C,X+1,Y)). 
	
+!buscarMovimientos : objetivo(P) & not P==40 & filaY(Y) &  columna(X,Y,C,3) & steak(C,X-1,Y) 
					& steak(C1,X,Y) & not C1 == 4  & not C ==4
	<- -+objetivo(40); !intercambiar(der,steak(C,X-1,Y)).


+!buscarMovimientos :filaY(Y) & Y > 0 <-
	-+filaY(Y-1);
	!buscarMovimientos.
	
+!buscarMovimientos :filaY(Y) & Y == 0 <-
	-+filaY(9);
	!moverBasica.
	
	
//B醩icos con region
+!moverBasica : objetivo(P) & not P==41 & filaY(Y) & steak(C1,X,Y) & steak(C,X,Y-1) 
			& player(N) & player(N+1,X,Y) & not C == C1 & not C1 ==4 & not C ==4
	<- -+objetivo(41); !intercambiar(bajar,steak(C,X,Y-1)).
	
+!moverBasica :objetivo(P) & not P==42 & filaY(Y) &  steak(C1,X,Y) & steak(C,X,Y+1) 
			& player(N) & player(N+1,X,Y) & not C == C1 & not C1 ==4  & not C ==4
	<- -+objetivo(42); !intercambiar(subir,steak(C,X,Y+1)).
	
+!moverBasica : objetivo(P) & not P==43 & filaY(Y) & steak(C1,X,Y) & steak(C,X+1,Y) 
			& player(N) & player(N+1,X,Y)& not C == C1 & not C1 ==4  & not C ==4
	<- -+objetivo(43); !intercambiar(izq,steak(C,X+1,Y)).
	
+!moverBasica : objetivo(P) & not P==44 & filaY(Y) & steak(C1,X,Y) & steak(C,X-1,Y) & player(N) 
			& player(N+1,X,Y) & not C == C1 & not C1 ==4 & not C ==4
	<- -+objetivo(44); !intercambiar(der,steak(C,X-1,Y)).

//Basicos sin region
+!moverBasica : objetivo(P) & not P==45 & filaY(Y) & steak(C1,X,Y) & steak(C,X,Y-1) 
			& not C == C1 & not C1 ==4 & not C ==4
	<-  -+objetivo(45);!intercambiar(bajar,steak(C,X,Y-1)).
	
+!moverBasica : objetivo(P) & not P==46 & filaY(Y) &  steak(C1,X,Y) & steak(C,X,Y+1) 
			& not C == C1 & not C1 ==4 & not C ==4
	<- -+objetivo(46); !intercambiar(subir,steak(C,X,Y+1)).
	
+!moverBasica : objetivo(P) & not P==47 & filaY(Y) & steak(C1,X,Y) & steak(C,X+1,Y) 
			& not C == C1 & not C1 ==4 & not C ==4
	<- -+objetivo(47); !intercambiar(izq,steak(C,X+1,Y)).
	
+!moverBasica : objetivo(P) & not P==48 & filaY(Y) &  steak(C1,X,Y) & steak(C,X-1,Y) 
			& not C == C1 & not C1 ==4 & not C ==4
	<-  -+objetivo(48); !intercambiar(der,steak(C,X-1,Y)).
	
+!moverBasica :filaY(Y) & Y > 0 <-
	-+filaY(Y-1);
	!moverBasica.
	
+!moverBasica :filaY(Y) & Y == 0 & vecesRecorrido(V) & V==0<-
	-+filaY(9);
	-+vecesRecorrido(V+1);
	!moverBasica.
	
+!moverBasica: filaY(Y) & Y == 0 & vecesRecorrido(V) & V > 0 <-
	.print("no hay movimiento posible en el Tablero");
	-myTurn;
.

+!moverBasica: objetivo(P) <-
	.print("El unico movimiento posible es el objetivo ", P, " ----> No es un movimiento viable");
	-myTurn;
.
	
//	INTERCAMBIAR

+!intercambiar(Direccion,steak(C,X,Y)): objetivo(P) <-
	
	if (Direccion == izq) {
		.print("Pedir intercambio: (",X,", ",Y,") ","-> (",X-1,",",Y,")");
		.print("Relizado el Objetivo ----> ", P);
		.send(judge,tell,exchange(X,Y,X-1,Y));
	}
	if (Direccion == der) {
		.print("Pedir intercambio: (",X,", ",Y,") ","-> (",X+1,",",Y,")");
		.print("Relizado el Objetivo ----> ", P);
		.send(judge,tell,exchange(X,Y,X+1,Y));
	}
	if (Direccion == subir) {
		.print("Pedir intercambio: (",X,", ",Y,") ","-> (",X,",",Y-1,")");
		.print("Relizado el Objetivo ----> ", P);
		.send(judge,tell,exchange(X,Y,X,Y-1));
	}
	if (Direccion == bajar) {
		.print("Pedir intercambio: (",X,", ",Y,") ","-> (",X,",",Y+1,")");
		.print("Relizado el Objetivo ----> ", P);
		.send(judge,tell,exchange(X,Y,X,Y+1));
	}
	.wait(500).

/*****************************************************************/	



+pos(Ag,X,Y)[source(S)] <- -pos(Ag,X,Y)[source(S)].

+ip(X,Y,C) <- .print("Hay un investigador principal en la posici贸n: ", X, ",", Y, " de color:", C).
+ct(X,Y,C) <- .print("Hay un catedratico en la posici贸n: ", X, ",", Y, " de color:", C).
+gs(X,Y,C) <- .print("Hay un gestor en la posici贸n: ", X, ",", Y, " de color:", C).
+co(X,Y,C) <- .print("Hay un comprador en la posici贸n: ", X, ",", Y, " de color:", C).


