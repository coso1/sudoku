unit interfaz;
interface
uses utils,crt;
procedure mostrarMenuPrincipal;
procedure mostrarMenuUsuario;
procedure mostrarMenuJuego;
procedure MenuPrincipal(var salida:Boolean;listaUsuarios:TLUsuario;var arch:TAUsuario);
procedure crearUsuario(lista:TLUsuario;var usuario:TUsuario;var arch:TAUsuario);
procedure usuarioExistente(lista:TLUsuario;var usuario:TUsuario;var inicioSesion:Boolean);
procedure MenuUsuario(var salida:Boolean;info:TUsuario;var listaUsuarios:TLUsuario;var archUsuarios:TAUsuario);
procedure nuevaPartida(var tabJugar:TSudokuBoard);
procedure cargarPartida(info:TUsuario;var tabJugar:TSudokuBoard;var archPartidas :TASudokuBoard);
procedure eliminarJugador(info:TUsuario;var listaUsuarios:TLUsuario;var archPartidas:TASudokuBoard;var archUsuarios:TAUsuario);
procedure MenuJuego(var salida:Boolean;tablero:TSudokuBoard;info:TUsuario);


implementation

procedure mostrarMenuPrincipal;
begin
	Writeln('------- SUDOKU PA LO PIBE -------');
	Writeln('Seleccione una opción:');
	Writeln('1) Crear usuario.');
	Writeln('2) Usuario existente.');
	Writeln('3) Salir.');
end;
procedure mostrarMenuUsuario;
begin
	Writeln('Seleccione una opción:');
  Writeln('1) Nueva partida');
	Writeln('2) Cargar partida');
  Writeln('3) Eliminar usuario');
	Writeln('4) Salir');
end;
procedure mostrarMenuJuego;
begin
	Writeln('Seleccione una opción:');
	Writeln('1) Insertar elemento');
	Writeln('2) Guarda partida.');
	Writeln('3) Salir.');
end;

procedure MenuPrincipal(var salida:Boolean;listaUsuarios:TLUsuario;var arch:TAUsuario);
var
  info:TUsuario;
  opcion:Char;
  salidaUsuario,inicioSesion:Boolean;

begin
  salidaUsuario := false;
  ClrScr;
  mostrarMenuPrincipal();
  Write('Opcion: ');
  readln(opcion);
  case opcion of
    '1': crearUsuario(listaUsuarios,info,arch);
    '2': usuarioExistente(listaUsuarios,info,inicioSesion);
    '3': salida:=true;
  else
    begin
      Writeln('Ingrese una opción válida.');
      Writeln('Presione una tecla para continuar.');
      ReadKey;//Espera a presionar una tecla para alcanzar a leer el mensaje
    end;
  end;


end;
procedure crearUsuario(lista:TLUsuario;var usuario:TUsuario;var arch:TAUsuario);
var
  buscado:TUsuario;
  listo:Boolean;
begin
  listo:= false;
  while not listo do
  begin
    Write('Ingrese el nombre de usuario: ');
    Readln(usuario.user);
    if not (usuario.user = '') then
      listo := true;
  end;
  buscarUsuario(usuario.user,lista,buscado);
  if(usuario.user = buscado.user) then //Si ya existe el usuario
  begin
    Writeln('El usuario "',usuario.user,'" ya existe');
  end
  else
  begin
    Write('Ingrese una contraseña: ');
    Readln(usuario.pass);
    insertarUsuario(lista,usuario);
    guardarUsuario(lista,arch);
  end;
end;

procedure usuarioExistente(lista:TLUsuario;var usuario:TUsuario;var inicioSesion:Boolean);
var
  buscado:TUsuario;
  listo:Boolean;
begin
  listo:= false;
	inicioSesion:= false;
  while not listo do
  begins
    Write('Ingrese el nombre de usuario: ');
    Readln(usuario.user);
    if not (usuario.user = '') then
      listo := true;
  end;
  Write('Ingrese una contraseña: ');
  Readln(usuario.pass);
  buscarUsuario(usuario.user,lista,buscado);
  if(usuario.user = buscado.user) and (usuario.pass = buscado.pass)  then //Si encuentra el usuario y la contraseña coincide
  begin
    Writeln('Iniciando sesión');
		inicioSesion := true;
  end
  else
  begin
    Writeln('Usuario o contraseña incorrectas');
  end;
  Writeln('Presione una tecla para continuar.');
  ReadKey;
end;

procedure MenuUsuario(var salida:Boolean;info:TUsuario;var listaUsuarios:TLUsuario;var archUsuarios:TAUsuario);
var
  opcion:Char;
	tabJugar:TSudokuBoard;
	salidaJuego:Boolean;
	archPartidas :TASudokuBoard;
begin
	Assign(archPartidas,'datos/'+info.user+'.dat');
	salidaJuego := false;
  ClrScr;
  Writeln('Hola ',info.user,'!');
  mostrarMenuUsuario;
  Writeln('Opción: ');
  Readln(opcion);
  case opcion of
    '1': nuevaPartida(tabJugar);
  	'2': cargarPartida(info,tabJugar,archPartidas);
		'3': eliminarJugador(info,listaUsuarios,archPartidas,archUsuarios);
		'4': salida := true;
  else

  end;

	if (opcion = '1') or (opcion = '2') then
	begin
		while not salidaJuego do
			MenuJuego(salidaJuego,tabJugar,info);
	end;

  ReadKey;
end;

procedure nuevaPartida(var tabJugar:TSudokuBoard);
var
  opcion,max:Integer; //Opcion de dificultad
  completa,nueva:TLSudokuBoard;
  archCompleta :TASudokuBoard;
	dificultad:Nivel;
begin
  iniSudokuBoard(nueva);
  iniSudokuBoard(completa);
  Assign(archCompleta,'datos/sudoku_boards.dat');
  cargarSudokuBoard(archCompleta,completa);
  opcion := 0;
  Writeln('Seleccione la dificultad:');
  Writeln('1) Dificl');
  Writeln('2) Normal');
  Writeln('3) Facil');
  while (opcion < 1) or (opcion > 3) do
  begin
    Write('Dificultad: ');
    Readln(opcion);
  end;
 case opcion of
 		1: dificultad := dificil;
		2: dificultad := normal;
		3: dificultad := facil;
 end;
  dificutladSudokuBoard(dificultad,completa,nueva,max);
  buscarSudokuBoard(Random(max)+1,nueva,tabJugar);
  Write('Nombre de la partida: ');
  readln(tabJugar.nombre);
end;

procedure cargarPartida(info:TUsuario;var tabJugar:TSudokuBoard;var archPartidas :TASudokuBoard);
var
  partidas:TLSudokuBoard;
  max,pos:Integer;
begin
  pos:=0;
  iniSudokuBoard(partidas);
  cargarSudokuBoard(archPartidas,partidas);
  Writeln('Selecciona una de las siguientes partidas: ');
  mostrarSudokuBoard(partidas,max);
  while (pos < 1) or (pos > max) do
  begin
    Write('Partida nº: ');
    Readln(pos);
  end;
  buscarSudokuBoard(pos,partidas,tabJugar);
end;

procedure eliminarJugador(info:TUsuario;var listaUsuarios:TLUsuario;var archPartidas:TASudokuBoard;var archUsuarios:TAUsuario);
begin
	//eliminar usuario de la lista de usuarios

	eliminarUsuario(info.user,listaUsuarios);

	//guardarUsuario(listaUsuarios,archUsuarios);
	//Erase(archPartidas);

end;

procedure MenuJuego(var salida:Boolean;tablero:TSudokuBoard;info:TUsuario);
begin
 writeln('menu de juego');
 salida := true;
 ReadKey;
end;

end.
