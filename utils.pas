{ *********************************************************************************

			Introduccion a la Algoritmica y Programación
						Año 2017

  Unit con acciones y funciones necesarias para la solucion del Proyecto Sudoku

  - Declaracion del tablero y tipos necesarios para la implementacion.
  - Acciones para la muestra los tableros.


  En esta unit debe implementar todas las acciones y funciones incompletas,
  Ademas debe agregar todas las que sean y crea necesarias para su solución.


  Integrantes del grupo:	Lopez Ayrton, Androetto Pablo


en problemas poner que pusismos var en todos los lista
  *************************************************************************************}

Unit utils;

Interface

uses crt;

Const

N = 9; //Tamaño de la matriz.

Type

TValidos = 1..9;
TConValidos = array[TValidos] of Integer;
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
TASudokuBoard = file of TSudokuBoard;

TNSudokuBoard = Record
					info: TSudokuBoard;
					next: ^TNSudokuBoard;
					end;

TLSudokuBoard = Record
						q:^TNSudokuBoard;
						end;
//Tipo registro usuario
TUsuario = Record
				user,pass:String;
				end;

//Tipo archivo de usuario
TAUsuario = file of TUsuario;


//TNodo de usuario
TNUsuario = Record
					info: TUsuario;
					next,back: ^TNUsuario;
					end;

//Tipo puntero de TNodo de usaurio(TLista de usuario)
//TLUsuario= ^TNUsuario;
TLUsuario = Record
						q,u:^TNUsuario;
						end;
//****************************************************************************************************//


//Dado un tablero y una posicion de la matriz dice si ese campo se corresponde a un valor inicial o no.
Function isInitialValue(board : TSudokuBoard; i,j : Integer) : Boolean;

//Muestra el tablero inicial, los espacios libres se representan con el numero 0.
Procedure mostrarTableroInicial (board : TSudokuBoard);

//Muestra el tablero parcial comprobando si un valor es inicial o no, para marcarlo con colores diferentes.
Procedure mostrarTableroParcial (board : TSudokuBoard);

//Muestra los 9 tableros iniciales que se encuentan en el archivo sudoku_boards.dat indicando el nombre y el nivel.
Procedure mostrarTablerosIniciales(var archivo : TASudokuBoard);

//Funcion que retorna verdadero si la fila dada esta completa con valores del 1 al 9 sin repetidos.
Function compruebaFila(board : TSudokuBoard; fila,x : Integer) : Boolean;

//Funcion que retorna verdadero si la columna dada esta completa con valores del 1 al 9 sin repetidos.
Function compruebaColumna(board : TSudokuBoard; columna : Integer) : Boolean;

//Funcion que retorna verdadero si el box dado esta completa con valores del 1 al 9 sin repetidos.
Function compruebaBox(board : TSudokuBoard; box : Integer) : Boolean;

//Acciones y funcion para listas y archivos de usuarios
//Inicializa la lista de usuario
procedure iniUsuario(var lista:TLUsuario);

//Verifica que la lista esta inicialzada
function verIniUsuario(var lista:TLUsuario):boolean;

procedure insertarUsuario(var lista:TLUsuario;info:TUsuario);


procedure eliminarUsuario(info:TUsuario;var lista:TLUsuario);

//Busca un usuario por nombre y si lo encuentra lo devuelve por el parametro "encontrado"
procedure buscarUsuario(nombre:String;var lista:TLUsuario;var encontrado:TUsuario);

//guarda una lista en un archivo de usuarios
procedure guardarUsuario(var arch:TAUsuario;var lista:TLUsuario);

//Carga los datos del archivo en una lista
procedure cargarUsuario(var arch:TAUsuario;var lista:TLUsuario);




//Acciones y funcion para listas y archivos de TSudokuBoard
//Inicializa la lista de SudokuBoard
procedure iniSudokuBoard(var lista:TLSudokuBoard);

//Verifica que la lista esta inicialzada
function verIniSudokuBoard(var lista:TLSudokuBoard):boolean;

procedure insertarSudokuBoard(var lista:TLSudokuBoard;info:TSudokuBoard);


procedure eliminarSudokuBoard(pos:Integer;var lista:TLSudokuBoard);

//devuelve una nueva lista con los tableros de la dificultad seleccionada
procedure dificutladSudokuBoard(dif:Nivel;var lista:TLSudokuBoard;var nueva:TLSudokuBoard;var max:Integer);

//guarda una lista en un archivo de SudokuBoards
procedure guardarSudokuBoard(var lista:TLSudokuBoard;var arch:TASudokuBoard);

//Carga los datos del archivo en una lista
procedure cargarSudokuBoard(var arch:TASudokuBoard;var lista:TLSudokuBoard);

procedure buscarSudokuBoard(pos:Integer;var lista:TLSudokuBoard;var encontrado:TSudokuBoard);

procedure mostrarSudokuBoard(var lista:TLSudokuBoard;var max:Integer);
procedure mostrarUsuario(var lista:TLUsuario);

Implementation

//Acciones de lista Usuario
procedure iniUsuario(var lista:TLUsuario); //Inicializa la lista de usuario
begin
  new(lista.q);
	new(lista.u);
	lista.q^.next := lista.u;
	lista.q^.back := nil;
	lista.u^.next := nil;
	lista.u^.back := lista.q;
end;

function verIniUsuario(var lista:TLUsuario):boolean;//Verifica que la lista esta inicialzada
begin
  if (lista.q<>nil)then
    begin
        verIniUsuario:=true;
    end;
end;

procedure insertarUsuario(var lista:TLUsuario;info:TUsuario);
var
  aux,primero:^TNUsuario;
begin
  new(aux);
  primero:=lista.q^.next;
  lista.q^.next:=aux;
  aux^.info:=info;
  aux^.next:=primero;
end;


procedure eliminarUsuario(info:TUsuario;var lista:TLUsuario);
var
  aux,ant,sig:^TNUsuario;
begin
	if (lista.q^.next=nil) then
	begin
		writeln('La lista de usuarios no tiene registros guardados.');
	end
	else
	begin
		ant := lista.q;
		aux:=ant^.next;
		sig := aux^.next;
		while (aux^.next <> nil) and (aux^.info.user <> info.user) do
		begin
			ant := ant^.next;
			aux:=ant^.next;
			sig := aux^.next;
		end;
		if(aux^.info.user = info.user) then
		begin
			dispose(aux);
			ant^.next := sig;
			sig^.back := ant;
		end;
	end;
end;

procedure buscarUsuario(nombre:String;var lista:TLUsuario;var encontrado:TUsuario);
var
  aux:^TNUsuario;
begin
  if (lista.q^.next=nil) then
  begin
    writeln('La lista de usuarios no tiene registros guardados.');
  end
  else
  begin
    aux:=lista.q^.next;
		while (aux^.next <> nil) and (aux^.info.user <> nombre) do
		begin
			aux := aux^.next; //Avanzar
		end;
		if (aux^.info.user = nombre) then
		begin
			encontrado := aux^.info;
			write
		end;
  end;
end;

procedure guardarUsuario(var arch:TAUsuario;var lista:TLUsuario);
var
  aux:^TNUsuario;
begin
	if (lista.q^.next=nil) then
  begin
    writeln('La lista de usuarios no tiene registros guardados.');
  end
  else
  begin
		Rewrite(arch);
    aux:=lista.q^.next;
		while (aux^.next <> nil) do
		begin
			write(arch,aux^.info);
			aux := aux^.next; //Avanzar lista
		end;
		Close(arch);
  end;
end;

procedure cargarUsuario(var arch:TAUsuario;var lista:TLUsuario);
var
	usuario:TUsuario;
begin
	{$I-}
		reset(arch);
	{$I+}
	if IOResult = 0 then
	begin
		while not EOF(arch) do
		begin
			read(arch,usuario);
			insertarUsuario(lista,usuario);
		end;
	end;
	close(arch);
end;

procedure iniSudokuBoard(var lista:TLSudokuBoard);
begin
  new(lista.q);

end;

function verIniSudokuBoard(var lista:TLSudokuBoard):boolean;
begin
  if (lista.q<>nil)then
    begin
        verIniSudokuBoard:=true;
    end;
end;

procedure insertarSudokuBoard(var lista:TLSudokuBoard;info:TSudokuBoard);
var
  aux,primero:^TNSudokuBoard;
begin
  new(aux);
  primero:=lista.q^.next;
	lista.q^.next := aux;
	aux^.next := primero;
	aux^.info := info;
end;


procedure eliminarSudokuBoard(pos:Integer;var lista:TLSudokuBoard);
var
  aux,ant,sig:^TNSudokuBoard;
	i:Integer;
begin
  if (lista.q^.next=nil) then
  begin
    writeln('La lista de tableros no tiene registros guardados.');
  end
  else
  begin
		ant:= lista.q;
    aux:=ant^.next;
		sig := aux^.next;

		i :=1;
		while (aux^.next <> nil) and (i < pos) do
		begin
			ant:= ant^.next; //Avanzar
			aux:=ant^.next;
			sig := aux^.next;
		end;
		if (i = pos) then
		begin
			dispose(aux);
			ant^.next := sig;
		end;
  end;
end;
//devuelve una nueva lista con los tableros de la dificultad seleccionada
procedure dificutladSudokuBoard(dif:Nivel;var lista:TLSudokuBoard;var nueva:TLSudokuBoard;var max:Integer);
var
  aux:^TNSudokuBoard;
begin

  if (lista.q^.next=nil) then
  begin
    writeln('La lista de tableros no tiene registros guardados.');
  end
  else
  begin
    aux:=lista.q^.next;
		max:=0;
		while (aux^.next <> nil) do
		begin
			if (aux^.info.nivel = dif) then
			begin
				insertarSudokuBoard(nueva,aux^.info);
				max+=1;
			end;
			aux := aux^.next; //Avanzar
		end;
  end;
end;

procedure guardarSudokuBoard(var lista:TLSudokuBoard;var arch:TASudokuBoard);
var
  aux:^TNSudokuBoard;
begin
	if (lista.q^.next=nil) then
  begin
    writeln('La lista de tableros no tiene registros guardados.');
  end
  else
  begin
		Rewrite(arch);
    aux:=lista.q^.next;
		while (aux^.next <> nil) do
		begin
			write(arch,aux^.info);
			aux := aux^.next; //Avanzar lista
		end;
		Close(arch);
  end;
end;

procedure cargarSudokuBoard(var arch:TASudokuBoard;var lista:TLSudokuBoard);
var
	tablero:TSudokuBoard;
begin
	{$I-}
		reset(arch);
	{$I+}
	if IOResult = 0 then
	begin
		while not EOF(arch) do
		begin
			read(arch,tablero);
			insertarSudokuBoard(lista,tablero);
		end;
	end;
	close(arch);
end;

procedure buscarSudokuBoard(pos:Integer;var lista:TLSudokuBoard;var encontrado:TSudokuBoard);
var
  aux:^TNSudokuBoard;
	i:Integer;
begin
  if (lista.q^.next=nil) then
  begin
    writeln('La lista de tableros no tiene registros guardados.');
  end
  else
  begin
    aux:= lista.q^.next;
		i:=1;
		while (aux^.next <> nil) and (i < pos) do
		begin
			i+=1;
			aux:= aux^.next;
		end;
		encontrado := aux^.info;
  end;
end;

procedure mostrarSudokuBoard(var lista:TLSudokuBoard;var max:Integer);
var
  aux:^TNSudokuBoard;
begin
  if (lista.q^.next=nil) then
  begin
    writeln('La lista de tableros no tiene registros guardados.');
  end
  else
  begin
    aux:=lista.q^.next;
		max:=1;
		while (aux^.next <> nil) do
		begin
			Writeln(max,') ',aux^.info.nombre,'| Dificultad: ',aux^.info.nivel);
			aux := aux^.next; //Avanzar
			max+=1;
		end;
  end;
end;


procedure mostrarUsuario(var lista:TLUsuario);
var
  aux:^TNUsuario;
begin
  if (lista.q^.next=nil) then
  begin
    writeln('La lista de tableros no tiene registros guardados.');
  end
  else
  begin
    aux:=lista.q^.next;
		while (aux^.next <> nil) do
		begin
			Writeln(aux^.info.user,aux^.info.pass);
			aux := aux^.next; //Avanzar
		end;
  end;
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
Procedure mostrarTablerosIniciales(var archivo : TASudokuBoard);
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
	j:integer;
begin
	repetido := false;
	if(x = 9) then
	begin
		compruebaFila:=true;
	end
	else
	begin
		j:=x+1;
		repeat
			if(board.sudokuParcial[fila,x] = board.sudokuParcial[fila,j]) or (board.sudokuParcial[fila,x] = 0) or (board.sudokuParcial[fila,j] = 0)then
			begin
				repetido := true;
			end;
			writeln(board.sudokuParcial[fila,x],',',board.sudokuParcial[fila,j]);
			writeln(repetido);
			j+=1;
		until (j>9) or repetido;
		if(repetido) then
		begin
			compruebaFila := false;
		end
		else
		begin
			compruebaFila := compruebaFila(board,fila,x+1);
		end;
	end;
end;

//Funcion que retorna verdadero si la columna dada esta completa con valores del 1 al 9 sin repetidos.
Function compruebaColumna(board : TSudokuBoard; columna : Integer) : Boolean;
var
	i,j:Integer;
	repetido:Boolean;
	conjunto:TConValidos;
begin
	repetido := false;
	i:=1;
	repeat
		j:=i+1;
		repeat
			if(board.sudokuParcial[i,columna] = board.sudokuParcial[j,columna]) or (board.sudokuParcial[i,columna] = 0) or (board.sudokuParcial[j,columna] = 0) then
			begin
				repetido := true;
			end;
			j+=1;
		until (j>9) or repetido;
		i+=1;
	until (i>9) or repetido;
	compruebaColumna := not repetido;
end;

//Funcion que retorna verdadero si el box dado esta completa con valores del 1 al 9 sin repetidos.
{
|---|---|---|
| 1 | 2 | 3 |
|---|---|---|
| 4 | 5 | 6 |
|---|---|---|
| 7 | 8 | 9 |
|---|---|---|
}
Function compruebaBox(board : TSudokuBoard; box : Integer) : Boolean;
var
	i,j,k,colElem,filaElem: integer;
	repetido:boolean;
	elemento:array[1..9] of Integer;
begin
	k:=1;
	repetido:=false;
	colElem:=3*((box + 2) mod 3)+1; //
																	 // Primer elemento del box
	filaElem:=3*((box + 2) div 3-1)+1;//
	for i := filaElem to filaElem+2 do
	begin
		for j := colElem to colElem+2 do
		begin
			if(board.sudokuParcial[i,j] = 0)then
			begin
				repetido := true;
			end
			else
			begin
				elemento[k] := board.sudokuParcial[i,j];
				k+=1;
			end;
		end;
	end;

	if not (repetido) then //si no encontro ningun cero
	begin
		i:=1;
		repeat
			j:= i+1;
			repeat
				if(elemento[i] = elemento[j]) then
				begin
					repetido := true;
				end;
				j+=1;
			until (j = 10) or repetido;
			i+=1;
		until (i=9) or repetido;
	end;

	compruebaBox:= not repetido;//si hay valores repetidos devuelve falso
end;
End.
