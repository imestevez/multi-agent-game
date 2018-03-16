// Agent judge in project crush.mas2j

/* Initial beliefs and rules */

endOfGame :- 
	//.print("VERIFICANDO END OF GAME ========================================================>") &
	movs(player1,M1) & movs(player2,M2) &
	points(player1,P1) & points(player2,P2) &
	sizeof(N) & 
	celdas1(C1) & celdas2(C2) &
	movs(Movs) &
	level(L)&
	((M1 > Movs & M2= Movs) | 													// CONDICION DE MOVIMIENTOS
	((C1 > N*N*3/4)& P1 > 99&L==1) | ((C2 > N*N*3/4)& P2 > 99&L==1) | 			// GANADOR NIVEL 1
	((C1 > N*N*3/4)& P1 > 199&L==2) | ((C2 > N*N*3/4)& P2 > 199&L==2)) &		// GANADOR NIVEL 2
	.print("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$") &
	.print("ENTRE AQUI CON: M1= ",M1," , P1= ",P1," , C1= ",C1) &
	.print("--------------------------------------------------------------------------------") &
	.print("ENTRE AQUI CON: M2= ",M2," , P2= ",P2," , C2= ",C2) &
	.print("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$").


x(0).
y(9).

color(0,16).
color(N,C) :- color(N-1,C1) & C = C1*2.

chooseC(C) :- .random(X) & Exp = math.floor(X*6) & color(Exp,C).

contiguas(X,X,Y1,Y2) :- math.abs(Y1-Y2) = 1.
contiguas(X1,X2,Y,Y) :- math.abs(X1-X2) = 1.

left(X,Y,C,0) :- not steak(C,X,Y).
left(X,Y,C,N) :- steak(C,X,Y) & left(X-1,Y,C,N1) & N = N1+1.

right(X,Y,C,0) :- not steak(C,X,Y).
right(X,Y,C,N) :- steak(C,X,Y) & right(X+1,Y,C,N1) & N = N1+1.

up(X,Y,C,0) :- not steak(C,X,Y).
up(X,Y,C,N) :- steak(C,X,Y) & up(X,Y-1,C,N1) & N = N1+1.

down(X,Y,C,0) :- not steak(C,X,Y).
down(X,Y,C,N) :- steak(C,X,Y) & down(X,Y+1,C,N1) & N = N1+1.

lineH(X,Y,C,S,L) :- left(X,Y,C,N) & right(X,Y,C,M) & L = N+M-1 & L >= 3 & S = X-N+1.

lineV(X,Y,C,S,L) :- up(X,Y,C,N) & down(X,Y,C,M) & L = N+M-1 & L >= 3 & S = Y-N+1.

figSquare(X,Y) :- steak(C,X,Y) & steak(C,X+1,Y) & steak(C,X,Y-1) & steak(C,X+1,Y-1).

inSquare(X1,Y1,X,Y) :- figSquare(X,Y) & .member([X1,Y1],[[X,Y],[X+1,Y],[X,Y-1],[X+1,Y-1]]).

inT(X,Y,X1,Y1,D) :- lineV(X,Y,C,S,3) & X1 = X & Y1 = S   & lineH(X1,Y1,C,X1-1,3) & D = down. //T (X,Y en V)
inT(X,Y,X1,Y1,D) :- lineH(X,Y,C,S,3) & X1 = S+1 & Y1 = Y & lineV(X1,Y1,C,Y1,3)   & D = down. //T (X,Y en H)

inT(X,Y,X1,Y1,D) :- lineV(X,Y,C,S,3) & X1 = X & Y1 = S+2 & lineH(X1,Y1,C,X1-1,3) & D = up. //T inv (X,Y en V)
inT(X,Y,X1,Y1,D) :- lineH(X,Y,C,S,3) & X1 = S+1 & Y1 = Y & lineV(X1,Y1,C,Y1-2,3) & D = up. //T inv (X,Y en H)

inT(X,Y,X1,Y1,D) :- lineV(X,Y,C,S,3) & X1 = X & Y1 = S+1 & lineH(X1,Y1,C,X1-2,3) & D = right. //|- (X,Y en V)
inT(X,Y,X1,Y1,D) :- lineH(X,Y,C,S,3) & X1 = S+2 & Y1 = Y & lineV(X1,Y1,C,Y1-1,3) & D = right. //|- (X,Y en H)

inT(X,Y,X1,Y1,D) :- lineV(X,Y,C,S,3) & X1 = X & Y1 = S+1 & lineH(X1,Y1,C,X1,3)   & D = left. //-| (X,Y en V)
inT(X,Y,X1,Y1,D) :- lineH(X,Y,C,S,3) & X1 = S & Y1 = Y   & lineV(X1,Y1,C,Y1-1,3) & D = left. //-| (X,Y en H)

mapa(L) :- mapa1(L) | mapa2(L).

mapa2([[  16, 32,   16,   32,   64,   65,   16,   32, 512, 256],
             [128,   4, 256, 512,   16, 256, 512,     4,   32,   64],
	         [128, 16,   32, 256, 512, 512, 256, 128,   64,   64],
	         [ 32, -32,   17, 128,   33, 512, 256, 128, 128,   17],
	         [ 64,  64,   32, 128,   32,   16, 512, 256, 128,   65],
             [128,   4, 256, 512,  -64, 256,-512,     4,   32,   32],
	         [128, 17,   32,   32, 512, 512, 256, 129,   64,   64],
       	     [ -32, 16,  -64,   32,   64, 512,-256,-128, 128,   16],
	         [  64, 64,   32, 129,   32,   17, 512, 256, 128,   64],
	         [256,256,128,-128,   64, 512, 512,   64,  -32,   64]]).

	   
mapa1([[ 17, 33, 17, 32, 64, 64, 16, 33,513,257],
       [129, -32,256,512, 16,256,512, 16, -32, 65],
	   [129, 16, 64, 16,512,512,256,128, 64, 65],
	   [ 64, 16, 16, -32, -32,-512,-256,128,128, 16],
	   [ 64, 64, 32,-128, -32, -16,-512,256,128, 64],
       [128, 64,256,-512, -16,-256,-512,512, 32,128],
	   [128, 16, 32, -32,-512,-512,-256,128, 64, 64],
	   [ 33, 16, 128, 32, 32,512,256,128,128, 17],
	   [ 65, -64, 32,128, 32, 16,512,256,-128, 65],
	   [257,257,129,128, 64,512,512, 65, 33, 65]]).

/* Initial goals */

!start.

/* Plans */

+!start : true <- 
	+turn(0);
	+winner1(0);
	+winner2(0);	
	!asignoTurno;
	+level(1);
	!level1;
	!winner;
	!clearMovs;
	!clearSpecials;
	-+level(2);
	!level2;
	!winner.
	
+!asignoTurno <-
	.all_names(L);
	for (.member(Player,L)){
		if (not Player ==judge) {
			.print("En esta partida juega el agente: ",Player);
			?turn(T);
			+player(T,Player);
			+movs(Player,0);
			+points(Player,0);
			.send(Player,tell,turn(T));
			-+turn((T+1) mod 2);
			.print("El agente: ", Player," juega con turno: ", T);
		} else {
			.print("Arbitra el agente: ", Player);
		};
	};
	-+turn(0).

	
+!winner : 	points(player1,Pt1) & points(player2,Pt2) & winner1(W1) & winner2(W2) &
			celdas1(Cel1) & celdas2(Cel2) & sizeof(N) & level(L) <-
	if ((Cel1 > N*N*3/4) & Pt1 > 100) {
		-+winner1(W1+1);
		.print("En el Nivel:", L," ha ganado el player1 con: ", Cel1, " celdas dominadas y ",Pt1," puntos conseguidos.");
	} else {
		if ((Cel2 > N*N*3/4) & Pt2 > 100) {
			-+winner2(W2+1);
			.print("En el Nivel:", L," ha ganado el player2 con: ", Cel2, " celdas dominadas y ",Pt2," puntos conseguidos.");
		} else {
			.print("En el Nivel:", L," no hay ganadores. El player1 suma ",Pt1," puntos y el player2:", Pt2, " puntos.");
		}
	};
	.wait(2000);
	if (L == 2) {
		?winner1(G1);
		?winner2(G2);
		if ((G1 > G2) | (G1==G2 & Pt1>Pt2)){
			.print("EL GANADOR ES EL PLAYER1 CON ",G1," PARTIDAS GANADAS Y ",Pt1," PUNTOS ACUMULADOS,");
		} else {
			if ((G2 > G1) | (G1==G2 & Pt2>Pt1)){
				.print("EL GANADOR ES EL PLAYER2 CON ",G2," PARTIDAS GANADAS Y ",Pt2," PUNTOS ACUMULADOS,");
			} else {
				.print("NO HAY GANADOR EL PLAYER1 Y EL PLAYER2 GANARON ",G1,",",G2," PARTIDAS.");
				.print("Y CONSIGUIERON: ",Pt1,",",Pt2," PUNTOS ACUMULADOS.");
			}
		}
	}.

+!level1 : mapa1(Mapa) & sizeof(N) <-
	!iniciarTablero (Mapa) ;
	/*for(.range(I,0,50)){
		.random(N1);
		Al1=N1*N;
		X = math.floor(Al1);
		.random(N2);
		Al2=N2*N;
		Y = math.floor(Al2);
		if(steak(C,X,Y)){
			?steak(C,X,Y);
			deleteSteak(C,X,Y);   
			put(X,Y,4,0);
		}else{
			put(X,Y,4,0);
		}*/
		
		?steak(C,0,9);
		deleteSteak(C,0,9);   
		put(0,9,4,0);
		
		?steak(C1,2,9);
		deleteSteak(C1,2,9);   
		put(2,9,4,0);
		
		?steak(C2,1,8);
		deleteSteak(C2,1,8);   
		put(1,8,4,0);
	
	-+movs(4);
	.broadcast(tell,canExchange(0)); 	// SE AVISA A TODOS LOS JUGADORES QUE EL JUGADOR CON TURNO 0 PUEDE COMENZAR
	.wait(endOfGame); 					// SE JUEGA HASTA QUE SE CUMPLEN LAS CONDICIONES
	.broadcast(tell,stop);				// SE AVISA DEL FIN DE JUEGO A TODOS LOS JUGADORES
	!getPuntos(Player1,Player2);		// SE VISUALIZAN LOS RESULTADOS
	!getMovs(Mov1,Mov2);
	.print("Fin do Level 1. O resultado foi: Player1=",Player1," puntos  en ",Mov1," movementos.");
	.print("Fin do Level 1. O resultado foi: Player2=",Player2," puntos  en ",Mov2," movementos.").

+!level2 : mapa2(Mapa) <-
	!iniciarTablero (Mapa) ;
	-+movs(9);
	-+turn(0);
	.broadcast(tell,canExchange(0)); 	// SE AVISA A TODOS LOS JUGADORES QUE EL JUGADOR CON TURNO 0 PUEDE COMENZAR
	.wait(endOfGame); 				// SE JUEGA HASTA QUE SE CUMPLEN LAS CONDICIONES
	.broadcast(tell,stop);				// SE AVISA DEL FIN DE JUEGO A TODOS LOS JUGADORES
	!getPuntos(Player1,Player2);		// SE VISUALIZAN LOS RESULTADOS
	!getMovs(Mov1,Mov2);
	!getMovs(Mov1,Mov2);
	.print("Fin do xogo. O resultado foi: Player1=",Player1," puntos  en ",Mov1," movementos.");
	.print("Fin do xogo. O resultado foi: Player2=",Player2," puntos  en ",Mov2," movementos.").
	
/*****************************************************************/
/********************     Iniciar Taboleiro    *******************/
/*****************************************************************/	
+!iniciarCeldas <-
	.abolish(celdas1(_));
	.abolish(celdas2(_));
	+celdas1(0);
	+celdas2(0);	
	.wait(200).
	
+!limpiarTablero: sizeof(N) <-
	for (.range(I,0,N)) {
		for (.range(J,0,N)) {
			!removeSteak(I,J);
		}
	}.
	
+!iniciarTablero(Mapa) 
	<-
	!iniciarCeldas;
	!limpiarTablero;
	?celdas1(C1);
	?celdas2(C2);
	!recorreMapa(Mapa);
	-+promotionTo(0);
	.print("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
	!startPuntos.

//Rutina para xerar o taboleiro automaticamente	(comentar a de arriba)
/*+!iniciarTablero : true 
	<-
	!completarTablero;
	!startPuntos.*/
	
/*****************************************************************/
/********************    Peticions Xogador     *******************/
/*****************************************************************/	
+accionIlegal(Ag) : amarilla(N) <- 
	if (N<3) {
		-+amarilla(N+1)
	} else {
		+trampa(Ag)
	}.
	
+accionIlegal(Ag) : not amarilla(N) <- 
	+amarilla(1). // Controla si algun player intenta realizar un movimiento ilegal

+trampa(Ag) <- 
	.kill_agent(Ag);
	.print("Vinme forzado a matar ao axente", Ag, " por trampulleiro."). // Elimina al tramposo reiterado

/*****************************************************************/
/********************      Colocar Ficha       *******************/
/*****************************************************************/

+putSteak(X)[source(Source)] : not steak(_,X,0) <-
	?chooseC(C);
	.print("Recibin de ", Source, " a solicitude de colocar un steak ",C," en: ", X,",",0);
	.wait(50);
	.print("Po?o ficha ",C," en ",X);
	!putSteak(X,0,C,0).

+putSteak(X,Y)[source(Source)] : not steak(_,X,Y) <-
	?chooseC(C);
	.print("Recibin de ", Source, " a solicitude de colocar un steak ",C," en: ", X,",",Y);
	.wait(50);
	.print("Po?o ficha ",C," en ",X);
	!putSteak(X,Y,C,0).
	
+putSteak(X,Y,C)[source(Source)] : not steak(C,X,Y) <-
	.print("Recibin de ", Source, " a solicitude de colocar un steak ",C," en: ", X,",",Y);
	.wait(50);
	.print("Po?o ficha ",C," en ",X,",",Y);
	!putSteak(X,Y,C,0).

/*****************************************************************/	
/********************  Intercambio de Fichas   *******************/
/*****************************************************************/	
+exchange(X1,Y1,X2,Y2)[source(Source)] : endOfGame.

+exchange(X1,Y1,X2,Y2)[source(Source)] : 
	player(T,Source) & turn(T) &
	steak(4,X1,Y1) | steak(4,X2,Y2)
	<-
	.abolish(exchange(X1,Y1,X2,Y2));
	.print("Recibin de ", Source, " a solicitude de intercambiar un obst?culo: ",C1," en ", X1, ", ",Y1," o ", C2, " en ", X2, ", ",Y2);
	-+accionIlegal(Source);
	?movs(Source,M1);
	.send(Source,tell,tryAgain).

+exchange(X1,Y1,X2,Y2)[source(Source)] : 
	player(T,Source) & turn(T) &
	steak(C1,X1,Y1) & steak(C2,X2,Y2) & not C1 == C2 & contiguas(X1,X2,Y1,Y2) 
	<-
	.abolish(exchange(X1,Y1,X2,Y2));
	-+promotionTo(0);
	.print("Recibin de ", Source, " a solicitude de intercambiar o steak ", C1, " en: ", X1, ", ",Y1," por o steak ", C2, " en: ", X2, ", ",Y2, " que vou atender inmediatamente.");
	if (X1==X2) {-+dir(0);};
	if (Y1==Y2) {-+dir(1);};
	!exchangeSteak(X1,Y1,X2,Y2);
	.print("Feito o intercambio.");
	!addMov;
	.wait(50);
	?turn(T);
	if (player(T+1,X1,Y1) | player(T+1,X2,Y2)) {
		-+promotionTo(T+1)
	} else {
		if ((player(P,X1,Y1) & not P==T+1) |
			(player(P,X2,Y2) & not P==T+1) ){
			-+promotionTo(P)
		} else {
			-+promotionTo(0);		
		}
	};
	
	!checkForActions(C2,X1,Y1); 
	!checkForActions(C1,X2,Y2);	

	?movs(Source,Mov);
	!updatePoints;
	!updateCells;
	.print(Source," realizou ata agora ",Mov," movimentos.");
	.send(Source,untell,tryAgain);		//reiniciamos su percepcion de volver a jugar
	-+turn((T+1) mod 2);
	?player((T+1) mod 2,Player);
	.print("Ahora es el turno del ",Player,"      <<<<<<<<<<<<<<<<<<<<<<<<==========================>>>>>>>>>>>>>>>>>>>>>");
	.send(Player,tell,tryAgain).
	
+exchange(X1,Y1,X2,Y2)[source(Source)] : 
	player(T,Source) & turn(T) &
	steak(C1,X1,Y1) & steak(C2,X2,Y2) & not contiguas(X1,X2,Y1,Y2) 
	<-
	.abolish(exchange(X1,Y1,X2,Y2));
	.print("Recibin de ", Source, " a solicitude de intercambiar dous steak que non son contiguos: ", X1, ", ",Y1," e ", X2, ", ",Y2);
	-+accionIlegal(Source);
	?movs(Source,M1);
	.send(Source,tell,tryAgain).
	
+exchange(X1,Y1,X2,Y2)[source(Source)] : 
	player(T,Source) & turn(T) &
	steak(C,X1,Y1) & steak(C,X2,Y2)
	<-
	.abolish(exchange(X1,Y1,X2,Y2));
	.print("Recibin de ", Source, " a solicitude de intercambiar dous steak que son da mesma cor: ",C1," en ", X1, ", ",Y1," e ", C2, " en ", X2, ", ",Y2);
	-+accionIlegal(Source);
	?movs(Source,M1);
	.send(Source,tell,tryAgain).
	
+exchange(X1,Y1,X2,Y2)[source(Source)]:
	player(T,Source) & turn(T) &
	not steak(_,X1,Y1) | not steak(_ ,X2,Y2)
	<-
	.abolish(exchange(X1,Y1,X2,Y2));
	.print("Recibin de ", Source, " a solicitude de intercambiar algun steak que non existe: ", X1, ", ",Y1," ou ", X2, ", ",Y2);
	-+accionIlegal(Source);
	?movs(Source,M1);
	.send(Source,tell,tryAgain).
	
+exchange(X1,Y1,X2,Y2)[source(Source)]:
	player(T1,Source) & turn(T2) & not T1 == T2
	<-
	.abolish(exchange(X1,Y1,X2,Y2));
	.print("Recibin de ", Source, " a solicitude de intercambiar os steaks: ", X1, ", ",Y1," e ", X2, ", ",Y2," fora de turno.");
	-+accionIlegal(Source);
	?movs(Source,M1);
	.send(Source,tell,tryAgain).
	
+exchange(X1,Y1,X2,Y2)[source(Source)] <- 
	.print("Algo va mal??????????????????????????????????????????????????????????????????????").

/********************************************************************/
/********************   Comproba as accions   *******************/
/********************************************************************/	
+!checkForActions(_,_,_) : endOfGame.
+!checkForActions(C,X,Y) : not steak(C,X,Y).

//T
+!checkForActions(C,X,Y)[source(Source)] :
	inT(X1,Y1,X,Y,D)
    <-
	.print("Detectada T: ",X,",",Y,"(",D,")");
	!destroyT(X,Y,D).
//Cadrado
+!checkForActions(C,X,Y)[source(Source)] :
	inSquare(X,Y,X1,Y1)
	<-
	.print("Detectado Cadrado: ",X,",",Y);
	!destroySquare(X,Y).
//Linea Horizontal
+!checkForActions(C,X,Y)[source(Source)] :
	lineH(X,Y,C,S,L)
	<-
	.print("Detectada LineaH: ",X,",",Y,"(",S,",",L,")");
	!destroyLineH(X,Y,S,L).	
//Linea Vertical
+!checkForActions(C,X,Y)[source(Source)] :
	lineV(X,Y,C,S,L)
	<-
	.print("Detectada LineaV: ",X,",",Y,"(",S,",",L,")");
	!destroyLineV(X,Y,S,L).	
	
+!checkForActions(C,X,Y)<- !addPuntos(0).

/*****************************************************************/
/********************   Executa as accions    *******************/
/*****************************************************************/	
//Li?a Horizontal
+!destroyLineH(X,Y,S,L)[source(Source)] : steak(C,X,Y) <-
	.print(L," en horizontal en (",S,",",Y,"):",C," [",X,":",Y,"]");

	//Elimina fila
	if(L == 3){
		!clearNRow(L,S,Y);
	}	
	//Crea ficha especial
	if(L == 4){
		if(X == S){
			!clearNRow(L-1,S+1,Y);
			!promote2IP(X,Y);
		} else {
			!clearNRow(L,S,Y);
			put(X,Y,C,0);
			!promote2IP(X,Y);
		};
		.print("La posicion a promocionar a IP es: (", X,", ",Y,").");
	}	
	if(L > 4){
		if(X == S){
			!clearNRow(L-1,S+1,Y);
			!promote2CT(X,Y);
		} else {
			!clearNRow(L,S,Y);
			put(X,Y,C,0);
			!promote2CT(X,Y);
		};
		.print("La posicion a promocionar a CT es: (", X,", ",Y,").");
	};
	!moveSteaks;
	?promotionTo(P);
	-promotionTo(P);
	+promotionTo(0);
	!completarTablero.	
+!destroyLineH(X,Y,S,L).	

//Li?a Vertical
+!destroyLineV(X,Y,S,L)[source(Source)] : steak(C,X,Y) <-
	.print(L," en vertical en (",X,",",S,"):",C," [",X,":",Y,"]");

	//Elimina columna
	if(L == 3){
		!clearNColumn(L,X,S);
	}	
	//Crea ficha especial
	if(L == 4){
		if(Y == S){
			!clearNColumn(L-1,X,S+1);
			!promote2IP(X,Y);
		}else{
			!clearNColumn(L,X,S);
			put(X,Y,C,0);
			!promote2IP(X,Y);
		};
		.print("La posicion a promocionar a IP es: (", X,", ",Y,").");
	}	
	if(L > 4){
		if(Y == S){
			!clearNColumn(L-1,X,S+1);
			!promote2CT(X,Y);
		}else{
			!clearNColumn(L,X,S);
			put(X,Y,C,0);
			!promote2CT(X,Y);
			//!promote2CT(X,S+L-1);
		};
		.print("La posicion a promocionar a CT es: (", X,", ",Y,").");
	}
	!moveSteaks;
	?promotionTo(P);
	-promotionTo(P);
	+promotionTo(0);
	!completarTablero.
+!destroyLineV(X,Y,S,L).	

//T	
+!destroyT(X,Y,D)[source(Source)] : steak(C,X,Y) <-
	.print("T ",D," en (",X,",",Y,"): ",C);
	!promote2CO(X,Y);
	if(D=down){
		!clearSteak(X-1,Y); !clearSteak(X+1,Y);
		!clearNColumn(2,X,Y+1);
	}
	if(D=up){
		!clearSteak(X-1,Y); !clearSteak(X+1,Y);
		!clearNColumn(2,X,Y-2);
	}
	if(D=left){
		!clearSteak(X,Y-1); !clearSteak(X,Y+1);
		!clearNRow(2,X-2,Y);
	}
	if(D=right){
		!clearSteak(X,Y-1); !clearSteak(X,Y+1);
		!clearNRow(2,X+1,Y);
	}
	!moveSteaks;
	?promotionTo(P);
	-promotionTo(P);
	+promotionTo(0);
	!completarTablero.

//Cadrado 
+!destroySquare(X,Y)[source(Source)] : 
		steak(C,X,Y) & steak(C,X-1,Y) & steak(C,X,Y-1) & steak(C,X-1,Y-1) <-
	.print("Cadrado en (",X,",",Y,")");
	!promote2GS(X,Y);	
	!clearSteak(X-1,Y);
	!clearSteak(X,Y-1);
	!clearSteak(X-1,Y-1);
	?promotionTo(P);
	-promotionTo(P);
	+promotionTo(0);
	!moveSteaks;
	!completarTablero.

+!destroySquare(X,Y)[source(Source)] : 
		steak(C,X,Y) & steak(C,X+1,Y) & steak(C,X,Y-1) & steak(C,X+1,Y-1) <-
	.print("Cadrado en (",X,",",Y,")");
	!promote2GS(X,Y);	
	!clearSteak(X+1,Y);
	!clearSteak(X,Y-1);
	!clearSteak(X+1,Y-1);
	?promotionTo(P);
	-promotionTo(P);
	+promotionTo(0);
	!moveSteaks;
	!completarTablero.

+!destroySquare(X,Y)[source(Source)] : 
		steak(C,X,Y) & steak(C,X,Y+1) & steak(C,X-1,Y) & steak(C,X-1,Y+1) <-
	.print("Cadrado en (",X,",",Y,")");
	!promote2GS(X,Y+1);	
	!clearSteak(X,Y);
	!clearSteak(X-1,Y+1);
	!clearSteak(X-1,Y);
	?promotionTo(P);
	-promotionTo(P);
	+promotionTo(0);
	!moveSteaks;
	!completarTablero.

+!destroySquare(X,Y)[source(Source)] : 
		steak(C,X,Y) & steak(C,X+1,Y) & steak(C,X,Y+1) & steak(C,X+1,Y+1) <-
	.print("Cadrado en (",X,",",Y,")");
	!promote2GS(X,Y+1);	
	!clearSteak(X,Y);
	!clearSteak(X+1,Y+1);
	!clearSteak(X+1,Y);
	?promotionTo(P);
	-promotionTo(P);
	+promotionTo(0);
	!moveSteaks;
	!completarTablero.
	
/*****************************************************************/
/********************    Completa as fichas    *******************/
/*****************************************************************/
+!recorreMapa(Mapa) : sizeof(N) & celdas1(C1) & celdas2(C2) <-
	.print("El numero de celdas dominadas por los jugadores es:  player1:", C1," , player2:",C2);
	for (.member(Fila,Mapa)) {
		for (.member(C,Fila)) {
			//.wait(300);
			?y(J);
			?x(I);
			.print("steak(",I,",",J,",",C,").");
			if (C<0) {
			//.wait(celdas(2,_));
			?celdas2(PC2);
			.print("El jugador 2 domina: ",PC2," celdas.........................................................................");
			-+celdas2(PC2+1);
			};
			if (C mod 2 ==1) {
				//.wait(celdas(1,_));
				?celdas1(PC1);
				.print("El jugador 1 domina: ",PC1," celdas.........................................................................");
				-+celdas1(PC1+1);
				put(I,J,C-1,-5);
			} else {
				put(I,J,C,0);
			};
			-+x(I+1);
		};
		?y(J);
		-+y(J-1);
		-+x(0);
	};
	-+y(N).

//-!recorreMapa(Mapa).

+!putNewSteakOnTop(X) : not steak(_,X,0) <-
	?chooseC(C);
	.wait(50);
	!putSteak(X,0,C,0);
	!moveColSteaks(X);
	!putNewSteakOnTop(X)
	.
+!putNewSteakOnTop(X).

+!completarTablero : endOfGame.
+!completarTablero : sizeof(N) <-
	for (.range(X,0,N)) {
		!putNewSteakOnTop(X);
	//	.print("Nueva pieza................................");
	};
	+reChecking;
	!reCheck.

//Comproba todo o taboleiro para ver se se crearon agrupacios ao completar.	

+!findSpecials(ListaEspeciales) <-
/*Buscamos las piezas especiales*/
	.findall(st(X,Y,C,3), figSquare(X,Y)&steak(C,X,Y),ListaGestores);
	.findall(st(X,Y,C,1), (lineH(X,Y,C,X,L) & L > 3 & L < 5) | (lineV(X,Y,C,Y,L) & L > 3 & L < 5), ListaIps);
	.findall(st(X,Y,C,2), (lineH(X,Y,C,X,L) & L > 4) | ( lineV(X,Y,C,Y,L) & L > 4), ListaCatedros);
	.findall(st(X,Y,C,4), (inT(X,Y,X-1,Y-1,_) & steak(C,X,Y)), ListaCompradores);
	.concat(ListaGestores,ListaIps,ListaCatedros,ListaCompradores,ListaEspeciales);
	.print("Esta es la lista de piezas especiales encontradas: ",ListaEspeciales).


+!findToDelete(List) <-
	.findall(todelete(Y,X), inSquare(X,Y,_,_) | ( lineH(X,Y,C,_,L) & L >2) | ( lineV(X,Y,C,_,L) & L >2) | inT(X,Y,_,_,_),List);
	.print("Eliminables: ",List).

+!reCheck : sizeof(N) & reChecking <-
	!findSpecials(ListaEspeciales);
	.print("Esperamos para comprobar");
	.wait(40);
	!findToDelete(List)
	.print("Comprobamos posibles combinacions xeradas automaticamente");
	.abolish(reChecking);
	/*for (.range(Y,0,N)) {
		for (.range(X,0,N)) {
			if(steak(C,X,Y)){
				//.print("------------Check: ", X, ",", Y); //Debug
				!checkForActions(C,X,Y);
			}
		}
	}*/
	for (.member(todelete(Y,X),List)) {
			if(steak(C,X,Y)& not .member(st(X,Y,C,_),ListaEspeciales)){
				//.print("------------Check: ", X, ",", Y); //Debug
				//!checkForActions(C,X,Y);
				if (special(X,Y,C,T)) {
					+detectada;
					.print("Detecta que la pieza es ESPECIALLLLLLLLLLLLLLLLLLLLLLLLLLLLLL.");
				}
				!clearSteak(X,Y);
				if (detectada) {
					-detectada;
					.print("Deberia haber eliminado la pieza especial:",special(X,Y,C,T),"  y realizado su efecto....................");
				    .wait(2000);
				};
				//Aplicando técnicas de plegado y desplegado 
				//optimizamos esta llamada y la dejamos como:
				};
			if (.member(st(X,Y,C,T),ListaEspeciales)) {
				!promote(X,Y,T);
				.print("Ahora se a?aden las nuevas piezas especiales......",ListaEspeciales);
			}
	};
	//.print("Caen las piezas superiores#@#@##@##@###@###@#@#@#@#@#@");
	!moveSteaks;
	//.print("Añadimos las piezas especiales de", ListaEspeciales);
	if (not List ==[]) {
		//.print("Pasamos a completar el Tablero========================>>>>>>>>>>>");
		!completarTablero
	}.

/*****************************************************************/
/********************   Po?er / Quitar ficha   *******************/
/*****************************************************************/	
+!putSteak(X,Y,C,L) : promotionTo(1) <-
	.print("La celda pasa a ser del player1----------------------------------------------------------------------------------------------");
    -special(X,Y,_,_);
	.broadcast(untell,special(X,Y,_,_));
	if (L==0) {
		put(X,Y,C,-5);
	} else{
		put(X,Y,C,-L);
	};
	.print(put(X,Y,C,-L));
	if (L>0) {
		+special(X,Y,C,L);
		.broadcast(tell,special(X,Y,C,L));
	}.
	
+!putSteak(X,Y,C,L) : promotionTo(2) <-
	.print("La celda pasa a ser del player2------------------------------------------------------------------------");
    -special(X,Y,_,_);
	.broadcast(untell,special(X,Y,_,_));
	put(X,Y,-C,L);
	.print(put(X,Y,-C,L));
	if (L>0) {
		+special(X,Y,C,L);
		.broadcast(tell,special(X,Y,C,L));
	}.

+!putSteak(X,Y,C,L) : player(1,X,Y) <-
	.print("La celda es del player1----------------------------------------------------------------------------------------------");
    -special(X,Y,_,_);
	.broadcast(untell,special(X,Y,_,_));
	if (L==0) {
		put(X,Y,C,-5);
	} else{
		put(X,Y,C,-L);
	};
	.print(put(X,Y,C,-L));
	if (L>0) {
		+special(X,Y,C,L);
		.broadcast(tell,special(X,Y,C,L));
	}.
	
+!putSteak(X,Y,C,L) : player(2,X,Y) <-
	.print("La celda es del player2------------------------------------------------------------------------");
    -special(X,Y,_,_);
	.broadcast(untell,special(X,Y,_,_));
	put(X,Y,-C,L);
	.print(put(X,Y,-C,L));
	if (L>0) {
		+special(X,Y,C,L);
		.broadcast(tell,special(X,Y,C,L));
	}.

+!putSteak(X,Y,C,L) <-
	.print("La celda no es nadie-------------------------------------------------------------------------------------------------------");
    -special(X,Y,_,_);
	.broadcast(untell,special(X,Y,_,_));
	put(X,Y,C,L);
	.print(put(X,Y,C,L));
	if (L>0) {
		+special(X,Y,C,L);
		.broadcast(tell,special(X,Y,C,L));
	}.

+!removeSteak(X,Y) : steak(C,X,Y) <-
	//-special(X,Y,_,_);
	deleteSteak(C,X,Y).
+!removeSteak(X,Y).

+!exchangeSteak(X1,Y1,X2,Y2) : steak(C1,X1,Y1) & steak(C2,X2,Y2) <-
	!removeSteak(X1,Y1) |&| !removeSteak(X2,Y2);
	//!recoloca(X1,Y1,X2,Y2);
	//!recoloca(X2,Y2,X1,Y1);
	if (special(X1,Y1,C1,L1)) {
		-special(X1,Y1,_,_);
		!putSteak(X2,Y2,C1,L1);
	} else {
		!putSteak(X2,Y2,C1,0);
	};
	if (special(X2,Y2,C2,L2)) {
		-special(X2,Y2,_,_);
		!putSteak(X1,Y1,C2,L2);
	} else {
		!putSteak(X1,Y1,C2,0);
	}.
	
/*****************************************************************/
/********************  Eliminacion de fichas   *******************/
/*****************************************************************/
+!clearRow(Y) : sizeof(N) <- !clearNRow(N+1,0,Y).
	
+!clearColumn(X) : sizeof(N) <- !clearNColumn(N+1,X,0).

+!clearNRow(N,X,Y) <-
	for (.range(I,0,N-1)) {
		if (steak(C,X+I,Y)) {
			!clearSteak(X+I,Y);
		}
	}.

+!clearNColumn(N,X,Y) <-
	for (.range(J,0,N-1)) {
		if (steak(C,X,Y+J)) {
			!clearSteak(X,Y+J);
		};
	}.
	
+!clearColor(C) : sizeof(N) <-
	for (.range(X,0,N)) {
		for (.range(Y,N,0,-1)) {
			if (steak(C,X,Y)) {
				!clearSteak(X,Y);
			}
		}
	}.

/*****************************************************************/
/********************  Eliminacion de 1 ficha  *******************/
/*****************************************************************/
+!clearSteak(_,_) : endOfGame.
//Elimina unha ficha: Pon a celda en blanco -> distingue dos obstaculos
//Elimina IP -> Elimina Fila / Columna
+!clearSteak(X,Y) : steak(C,X,Y) & C > 4 & special(X,Y,C,1) <-
	!addPuntosBySteak(X,Y);
	!removeSteak(X,Y);
	?promotionTo(P);
	-promotionTo(P);
	if (player(1,X,Y)){+promotionTo(1);};
	if (player(2,X,Y)){+promotionTo(2);};
	if (not player(_,X,Y)) {+promotionTo(0);};
	?dir(H);
	if (H==1) {
		.print("IP -> Rompemos fila ",Y);
		!clearRow(Y);
	} else {
		.print("IP -> Rompemos columna ",X);
		!clearColumn(X);
	}.
	
//Elimna CT -> Elimina todas as fichas da mesma cor
+!clearSteak(X,Y) : steak(C,X,Y) & C > 4 & special(X,Y,C,2) <-
	!addPuntosBySteak(X,Y);
	!removeSteak(X,Y);
	?promotionTo(P);
	-promotionTo(P);
	if (player(1,X,Y)){+promotionTo(1);};
	if (player(2,X,Y)){+promotionTo(2);};
	if (not player(_,X,Y)) {+promotionTo(0);};
	.print("CT -> Eliminamos todos os membros de ",C);
	!clearColor(C).	
	
//Elimina GS -> Elimina ficha aleatoria do grupo (cor)
+!clearSteak(X,Y) : steak(C,X,Y) & C > 4 & special(X,Y,C,3) <-
	!addPuntosBySteak(X,Y);
	!removeSteak(X,Y);
	?promotionTo(P);
	-promotionTo(P);
	if (player(1,X,Y)){+promotionTo(1);};
	if (player(2,X,Y)){+promotionTo(2);};
	if (not player(_,X,Y)) {+promotionTo(0);};
	.print("GS -> Elimina membro aleatorio de ",C," en ",X,",",Y);
	?steak(C,RandomX,RandomY) & not RandomX == X & not RandomY == Y;
	!clearSteak(RandomX,RandomY);
	?promotionTo(Pl);
	-promotionTo(Pl);
	+promotionTo(0)
	.
//Elimina CO -> Elimina area de 5x5
+!clearSteak(X,Y) : steak(C,X,Y) & C > 4 & special(X,Y,C,4) <-
	!addPuntosBySteak(X,Y);
	!removeSteak(X,Y);
	?promotionTo(P);
	-promotionTo(P);
	if (player(1,X,Y)){+promotionTo(1);};
	if (player(2,X,Y)){+promotionTo(2);};
	if (not player(_,X,Y)) {+promotionTo(0);};
	.print("CO -> Elimina fichas en area 5x5 alrededor");
	for (.range(I,Y-2,Y+2)) {
		!clearNRow(5,X-2,I);
	}.
//Elimina ficha normal
+!clearSteak(X,Y) : steak(C,X,Y) & C > 4 <-
	!addPuntosBySteak(X,Y);
	!removeSteak(X,Y).
//Elimina obstaculo
/*
+!clearSteak(X,Y) : steak(C,X,Y) & C == 4 <-
	!removeSteak(X,Y).
*/
+!clearSteak(X,Y).

+!clearSpecials <- .abolish(special(_,_,_,_)).

/*****************************************************************/
/********************     Caida de fichas      *******************/
/*****************************************************************/	
//Comproba todo o taboleiro para facer caer as fichas
+!moveSteaks : endOfGame.
+!moveSteaks : sizeof(N) <-
	for (.range(I,0,N)) {
		//.print("--Revisa columna ",N-I);
		!moveColSteaks(N-I);
	}.
+!moveColSteaks(X) : sizeof(N) <-
	for (.range(J,0,N-1)) {
		!moveOneSteak(X,N-J);
	}.

//Comproba unha posicion concreta para ver se hai un oco
//Sen ficha arriba -> Seguir mirando arriba
+!moveOneSteak(X,Y) : not steak(_,X,Y) & Y > 0 & not steak(_,X,Y-1) <-
	!moveOneSteak(X,Y-1);!downSteak(X,Y-1).
	
//Obstaculo arriba -> Baixar ficha diagonal
+!moveOneSteak(X,Y) : not steak(_,X,Y) & steak(4,X,Y-1) & steak(C,X+1,Y-1) & Y > 1 & C > 4 <-
	.print(X,":",Y);
	!downSteak(X+1,Y-1);
	!moveColSteaks(X+1);
	.
//Ficha arriba -> Baixar
+!moveOneSteak(X,Y) : not steak(_,X,Y) & Y > 0 <-
	!downSteak(X,Y-1).
	
+!moveOneSteak(_,_).

//Realiza a caida da ficha
+!downSteak(X,Y) : 	steak(C,X,Y) & steak(_,X,Y+1) & steak(4,X-1,Y) & 
					not steak(_,X-1,Y+1) & C > 4 & special(X,Y,C,L) <-	
	!putSteak(X-1,Y+1,C,L);
	!removeSteak(X,Y).
	
+!downSteak(X,Y) : 	steak(C,X,Y) & steak(_,X,Y+1) & steak(4,X-1,Y) & 
					not steak(_,X-1,Y+1) & C > 4 <-	
	!putSteak(X-1,Y+1,C,0);
	!removeSteak(X,Y).
	
+!downSteak(X,Y) : 	steak(C,X,Y) & not steak(_,X,Y+1) & C > 4 & 
					special(X,Y,C,L) <-	
	!putSteak(X,Y+1,C,L);
	!removeSteak(X,Y).
	
+!downSteak(X,Y) : 	steak(C,X,Y) & not steak(_,X,Y+1) & C > 4 <-	
	!putSteak(X,Y+1,C,0);
	!removeSteak(X,Y).
	
+!downSteak(X,Y).

/*****************************************************************/
/********************   Promoci?n de fichas    *******************/
/*****************************************************************/	
+!promote2IP(X,Y) 	: 	steak(_,X,Y) 	<- !promote(X,Y,1); .concat("Promovido a IP en ",X,",",Y,S); 	!addPuntos(4).		//IP
+!promote2CT(X,Y)	: 	steak(_,X,Y) 	<- !promote(X,Y,2); .concat("Promovido a CT en ",X,",",Y,S); 	!addPuntos(8).		//CT
+!promote2GS(X,Y)	:	steak(_,X,Y) 	<- !promote(X,Y,3); .concat("Promovido a GS en ",X,",",Y,S); 	!addPuntos(4).		//GS
+!promote2CO(X,Y)	: 	steak(_,X,Y) 	<- !promote(X,Y,4); .concat("Promovido a CO en ",X,",",Y,S); 	!addPuntos(6).		//CO

+!promote(X,Y,L) : steak(C,X,Y) & promotionTo(P) <-
	deleteSteak(C,X,Y);
	if  (P=1) {
		.print("La celda pasa a ser del player1+++++++++++++++++++++++++++++++++++++");
		put(X,Y,C,-L);
	} else { 
	if (P=2) {
		.print("La celda pasa a ser del player2++++++++++++++++++++++++++++++++++++++++");
		put(X,Y,-C,L);
	} else {	
	if  (player(1,X,Y)) {
		.print("La celda sigue siendo del player1+++++++++++++++++++++++++++++++++++++");
		put(X,Y,C,-L);
	} else { 
	if (player(2,X,Y)) {
		.print("La celda sigue siendo del player2++++++++++++++++++++++++++++++++++++++++");
		put(X,Y,-C,L);
	} else {
		.print("La celda no tiene due?o     +++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
		put(X,Y,C,L);
		}
	}}};
	+special(X,Y,C,L);
	.broadcast(tell,special(X,Y,C,L)).
	//.send(player,tell,special(X,Y,C,L)).
+!promote(X,Y,L).

/*******************************************************************/
/********************    Contador de Puntos   *******************/
/*******************************************************************/	
//Comeza a sumar puntos.
+!startPuntos <- 
	.print("INICIALIZO LOS PUNTOS DE CADA JUGADOR EN ESTE NIVEL !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
	?player(0,Player1);
	+pointsMov(Player1,0);
	?pointsMov(Player1,Pt1);
	.print("Puntos del ", Player1,": ",Pt1);
	?player(1,Player2);
	+pointsMov(Player2,0);
	?pointsMov(Player2,Pt2);
	.print("Puntos del ", Player2,": ",Pt2);
	.wait(0).
	
+!addPuntos(Pt) : turn(0) & player(0,player1) <-
	.print("Estamos en el turno 0 y juega el Player 1.");
	?pointsMov(player1,Points);
	.print("A sumar puntos;;;;;;;;;;;;,;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;PLAYER1;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;");
	-pointsMov(player1,Points);
	+pointsMov(player1,Points+Pt);
	.print("Acualizados los puntos en el movimiento........");
	?pointsMov(player1,P);
	.print("O xogador player1 leva acumulados despois do movemento un Total de: ",P," puntos] ").

+!addPuntos(Pt) : turn(1) & player(1,player2) <-
	.print("Estamos en el turno 1 y juega el Player 2.");
	?pointsMov(player2,Points);
	.print("A sumar puntos;;;;;;;;;;;;,;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;PLAYER2;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;");
	-pointsMov(player2,Points);
	+pointsMov(player2,Points+ Pt);
	.print("Acualizados los puntos en el movimiento........");
	?pointsMov(player2,P);
	.print("O xogador player2 leva acumulados despois do movemento un Total de: ",P," puntos] ").


+!addPuntos(_) <- .print("Algo va mal con la puntuacion............................................").

//Determina os puntos que vale cada tipo de ficha
+!addPuntosBySteak(X,Y) : special(X,Y,_,1) 	<- .print("Eliminado IP en ",X,",",Y); 		!addPuntos(2). 	//IP
+!addPuntosBySteak(X,Y) : special(X,Y,_,2) 	<- .print("Eliminado CT en ",X,",",Y);		!addPuntos(10). 	//CT
+!addPuntosBySteak(X,Y) : special(X,Y,_,3) 	<- .print("Eliminado GS en ",X,",",Y);		!addPuntos(5). 	//GS
+!addPuntosBySteak(X,Y) : special(X,Y,_,4) 	<- .print("Eliminado CO en ",X,",",Y);		!addPuntos(8). 	//CO
+!addPuntosBySteak(X,Y) 					<- .print("Eliminada ficha en ",X,",",Y); 	!addPuntos(1). 	//Normal

+!updatePoints : 	turn(0) & player(0,player1) & points(player1,Pt) & pointsMov(player1, PtMov) <-
	-points(player1,Pt);
	-pointsMov(player1,_);
	+pointsMov(player1,0);
	+points(player1,Pt+PtMov).

+!updatePoints : turn(1) & player(1,player2) & points(player2,Pt)  & pointsMov(player2, PtMov) <-
	-points(player2,Pt);
	-pointsMov(player2,_);
	+pointsMov(player2,0);
	+points(player2,Pt+PtMov).

+!getPuntos(P1,P2) <-
	?player(0,Player1);
	?points(Player1,P1);
	?player(1,Player2);
	?points(Player2,P2).
	
/***********************************************************************/
/********************  Contador de Movementos  *******************/
/***********************************************************************/	
+!addMov :  turn(0) & player(0,player1) & movs(player1,Movs) <-
	-movs(player1,Movs);
	+movs(player1,Movs + 1);
	.print("O xogador player1 leva feitos ",Movs+1, " MOVEMENTOS.  )))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))").
		
+!addMov :  turn(1) & player(1,player2) & movs(player2,Movs) <-
	-movs(player2,Movs);
	+movs(player2,Movs + 1);
	.print("O xogador player2 leva feitos ",Movs+1, " MOVEMENTOS.  )))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))").
		
	
+!addMov <- .print("ESTAMOS EN PROBLEMASSSSSSSSSSSSSSSSSSS").

+!clearMovs <-
	.abolish(movs(_,_));
	+movs(player1,0);
	+movs(player2,0).

+!getMovs(Movs1,Movs2)  <-
	?player(0,Player1);
	?movs(Player1,Movs1);
	?player(1,Player2);
	?movs(Player2,Movs2).
	
/***********************************************************************/
/********************  Contador de Celdas  *****************************/
/***********************************************************************/	

+!updateCells <-
	.findall(c1,player(1,_,_),LC1);
	.findall(c2,player(2,_,_),LC2);
	.length(LC1,N1);
	.length(LC2,N2);
	.print("Actualizamos dominaci?n del tablero a:",N1,", ",N2);
	-+celdas1(N1);
	-+celdas2(N2).
	
/*****************************************************************/	
+pos(Ag,X,Y)[source(S)] <- -pos(Ag,X,Y)[source(S)].

