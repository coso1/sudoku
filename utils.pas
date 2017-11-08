{ *********************************************************************************

			Introduccion a la Algoritmica y Programación
						Año 2017

  Unit con acciones y funciones necesarias para la solucion del Proyecto Sudoku

  - Declaracion del tablero y tipos necesarios para la implementacion.
  - Acciones para la muestra los tableros.


  En esta unit debe implementar todas las acciones y funciones incompletas,
  Ademas debe agregar todas las que sean y crea necesarias para su solución.


  Integrantes del grupo:	Lopez Ayrton, Androetto Pablo

  *************************************************************************************}

Unit utils;

Interface

uses crt;

Const

N = 9; //Tamaño de la matriz.

Type

TValidos = (1,2,3,4,5,6,7,8,9);
TConValidos = set of TValidos;
//Declaracion de un enumerado para manejar los niveles.
Nivel = (dificil, normal, facil);

//La matriz de enteros que representa un tablero.
TSudokuValues = array [1..N, 1..N] of Integer;

{El tablero del juego, el mismo cuenta con el sudoku inicial (no debe ser modificado).
 El tablero parcial, donde el usuario modifica los valores de la matriz (juega),
 solo puede modificar aquellas posiciones que en sudokuInicial tienen valor 0
 el nivel de este tablero
 el nombre del tablero.}
TSudokuBoard = Record
					sudokuInicial : TSudokuValues;
					sudokuParcial : TSudokuValues;
					nivel : Nivel;
					nombre : String;
				end;

//El archivo donde se encuentran guardados los tableros iniciales.
TFile = file of TSudokuBoard;

TUsuario = Record
				nombre,apellido:String;s
				end;

TAUsuario = file of TUsuario;

TPartida = Record
				nombre:String;
				tablero:TSudokuBoard;
				end;

TAPartida= file of TPartida;

TNusuario = Record
					info: TUsuairo;
					next: ^TNUsuatio;
					end;

TLUsuario= ^TNUsuairo;

TNPartidas = Record
					info: TUsuairo;
					next: ^TNUsuatio;
					end;

TLPartida = ^TNPartidas;

//****************************************************************************************************//


//Dado un tablero y una posicion de la matriz dice si ese campo se corresponde a un valor inicial o no.
Function isInitialValue(board : TSudokuBoard; i,j : Integer) : Boolean;

//Muestra el tablero inicial, los espacios libres se representan con el numero 0.
Procedure mostrarTableroInicial (board : TSudokuBoard);

//Muestra el tablero parcial comprobando si un valor es inicial o no, para marcarlo con colores diferentes.
Procedure mostrarTableroParcial (board : TSudokuBoard);

//Muestra los 9 tableros iniciales que se encuentan en el archivo sudoku_boards.dat indicando el nombre y el nivel.
Procedure mostrarTablerosIniciales(var archivo : TFile);

//Funcion que retorna verdadero si la fila dada esta completa con valores del 1 al 9 sin repetidos.
Function compruebaFila(board : TSudokuBoard; fila : Integer) : Boolean;

//Funcion que retorna verdadero si la columna dada esta completa con valores del 1 al 9 sin repetidos.
Function compruebaColumna(board : TSudokuBoard; columna : Integer) : Boolean;

//Funcion que retorna verdadero si el box dado esta completa con valores del 1 al 9 sin repetidos.
Function compruebaBox(board : TSudokuBoard; box : Integer) : Boolean;

procedure menuPrincipal;

procedure menuUsuario;

procedure menuJuego;



Implementation
procedure menuPrincipal;
begin
	Writeln('1) Crear usuario.');
	Writeln('2) Usuario existente.');
	Writeln('3) Salir.');
end;
procedure menuUsuario;
begin
	Writeln('1) Cambiar usuario');
	Writeln('2) Eliminar usuario');
	Writeln('3) Cargar partida');
	Writeln('4) Nueva partida');
	Writeln('5) Salir');
end;
procedure menuJuego;
begin
	Writeln('1) Insertar elemento');
	Writeln('2) Guarda partida.');
	Writeln('3) Salir.');
end;

//Dado un tablero y una posicion de la matriz dice si ese campo se corresponde a un valor inicial o no.
Function isInitialValue(board : TSudokuBoard; i, j : Integer) : Boolean;
begin
	if ((board.sudokuInicial[i,j] <> 0) and (board.sudokuInicial[i,j] = board.sudokuParcial[i,j])) then
	//	no es una posicion vacia         y   el valor no fue modificado (OJO con esta condicion!)
		isInitialValue := True
	else
		isInitialValue := False;
end;

//Muestra el tablero inicial, los espacios libres se representan con el numero 0.
Procedure mostrarTableroInicial (board : TSudokuBoard);
var
	i, j: Integer;
begin
	for i:=1 to N do
	begin
		Writeln();
		if (i = 1) then
			Writeln('.-----------------------.');
		if (i = 4) then
			Writeln('.-----------------------.');
		if (i = 7) then
			Writeln('.-----------------------.');

		Write('| ');
		for j:=1 to N do
		begin
			if (j = 4) then
				Write('| ');
			if (j = 7) then
				Write('| ');
			TextColor(Blue);
			Write(board.sudokuInicial[i,j], ' ');
			TextColor(White);
		end;
		Write ('|');
	end;
	Writeln();
	Writeln('.-----------------------.');
end;

//Muestra el tablero parcial comprobando si un valor es inicial o no, para marcarlo con colores diferentes.
Procedure mostrarTableroParcial (board : TSudokuBoard);
var
	i, j: Integer;
begin
	for i:=1 to N do
	begin
		Writeln();
		if (i = 1) then
			Writeln('.-----------------------.');
		if (i = 4) then
			Writeln('.-----------------------.');
		if (i = 7) then
			Writeln('.-----------------------.');
		Write('| ');
		for j:=1 to N do
		begin
			if (j = 4) then
				Write('| ');
			if (j = 7) then
				Write('| ');
			if (isInitialValue(board, i, j)) then
				TextColor(Blue)
			else
				TextColor(Red);
			Write(board.sudokuParcial[i,j], ' ');
			TextColor(White);
		end;
		Write('|');
	end;
	Writeln();
	Writeln('.-----------------------.');
end;

//Muestra los 9 tableros iniciales que se encuentan en el archivo sudoku_boards.dat indicando el nombre y el nivel.
Procedure mostrarTablerosIniciales(var archivo : TFile);
var
	board : TSudokuBoard;
begin
	Reset(archivo);
	while (not EOF(archivo)) do
	begin
		Read(archivo, board);
		Writeln ();
		Writeln ('****************************');
		Writeln ('Tablero : ', board.nombre);
		Writeln ('Dificultad: ', board.nivel);
		mostrarTableroInicial(board);
		Writeln ('****************************');
	end;
	Close(archivo);
end;

//***** UNA DE LAS SIGUIENTES 3 FUNCIONES DEBE SER IMPLEMENTADA DE MANERA RECURSIVA ******//
//		(para este caso, si necesita cambiar el perfil de la funcion puede hacerlo) 	  //

//Funcion que retorna verdadero si la fila dada esta completa con valores del 1 al 9 sin repetidos.
Function compruebaFila(board : TSudokuBoard; fila,x : Integer) : Boolean;
var
	repetido:Boolean;
	i:Integer;
begin
	repetido := false;
	if(x <> 9) then
		i:=x+1;
		repeat
			if(board.sudokuParcial[x,fila] = board.sudokuParcial[i,fila]) then
			begin
				repetido := true;
			end;
			i+=1;
		until (i=9) or (repetido = true);
		if(repetido)then
			compruebaFila := false;
		else
		begin
			compruebaFila(board,fila,x+1);
		end;
	else
	begin
		compruebaFila := true;
	end;
end;

//Funcion que retorna verdadero si la columna dada esta completa con valores del 1 al 9 sin repetidos.
Function compruebaColumna(board : TSudokuBoard; columna : Integer) : Boolean;
var
	i:Integer;
	repetido:Boolean;
	conjunto:TConValidos;
begin
	repetido := false;
	conjunto := [];//con inicializado
	for i := 1 to 9 do
	begin
		conjunto += board.sudokuParcial[columna,y]
	end;
	i:=1;
	repeat
		if not (i in conjunto) then
			repetido:=true;
		i+=1;
	until (i > 9) or (repetido);
	compruebaColumna := not repetido;
end;

//Funcion que retorna verdadero si el box dado esta completa con valores del 1 al 9 sin repetidos.
Function compruebaBox(board : TSudokuBoard; box : Integer) : Boolean;
var
	filaBox,colBox,i,j,colElem,filaElem: integer;
	conjunto:TConValidos;
	repetido:boolean;
begin
	repetido:=false;
	filaBox = (box + 2) div 3;
	colBox= ((box + 2) mod 3) + 1;
	filaElem:=3*(colBox-1)+1;
	colElem:=3*(filaBox-1)+1;
	j:=filaElem;
	i:=colElem;
	conjunto:=[];
	repeat
		repeat
			conjunto+:board.sudokuParcial[i,j];
			j+=1;
		until (j>colElem+2);
		i+=1;
	until(i>filaElem+2);
	i:=1;
	repeat
		if not (i in conjunto) then
			repetido:=true;
		i+=1;
	until (i > 9) or (repetido);
	compruebaBox:= not repetido;
end;

End.
