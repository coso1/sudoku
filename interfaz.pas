unit interfaz;

interface
uses utils,crt;
procedure mostrarMenuPrincipal;
procedure mostrarMenuUsuario;
procedure mostrarMenuJuego;
procedure MenuPrincipal();
procedure crearUsuario(var info:TUsuario);
procedure usuarioExistente(var usuario:TUsuario;var inicioSesion:Boolean);
procedure MenuUsuario(info:TUsuario);
procedure nuevaPartida(var tabJugar:TSudokuBoard);
procedure cargarPartida(info:TUsuario;var tabJugar:TSudokuBoard);
procedure eliminarJugador(info:TUsuario);
procedure MenuJuego(tabJugar:TSudokuBoard;info:TUsuario);

implementation
procedure mostrarMenuPrincipal;
begin
  ClrScr;
	Writeln('------- SUDOKU PA LO PIBE -------');
	Writeln('Seleccione una opción:');
	Writeln('1) Crear usuario.');
	Writeln('2) Usuario existente.');
	Writeln('3) Salir.');
  Write('Opcion: ');
end;
procedure mostrarMenuUsuario;
begin
  ClrScr;
	Writeln('Seleccione una opción:');
  Writeln('1) Nueva partida');
	Writeln('2) Cargar partida');
  Writeln('3) Eliminar usuario');
	Writeln('4) Salir');
  Write('Opcion: ');
end;
procedure mostrarMenuJuego;
begin
  ClrScr;
	Writeln('Seleccione una opción:');
	Writeln('1) Insertar elemento');
	Writeln('2) Guarda partida.');
	Writeln('3) Salir.');
  Write('Opcion: ');
end;
procedure MenuPrincipal();
var
  opcion:Char;
  info:TUsuario;
  inicioSesion:Boolean;//indica si se inicio la sesion
begin
  mostrarMenuPrincipal();
  readln(opcion);
  while (opcion <> '3') do
  begin
    case opcion of
      '1': crearUsuario(info);
      '2': usuarioExistente(info,inicioSesion);
    else
      begin
        Writeln('Ingrese una opción válida.');
        Writeln('Presione una tecla para continuar.');
        ReadKey;//Espera a presionar una tecla para alcanzar a leer el mensaje
      end;
    end;

    if ((opcion = '1') or (opcion = '2')) and (inicioSesion) then
    begin
        MenuUsuario(info);
    end;

    mostrarMenuPrincipal();
    readln(opcion);
  end;
end;

procedure crearUsuario(var info:TUsuario);
var
  listaUsuarios:TLUsuario;
  archUsuarios:TAUsuario;
  encontrado:TUsuario;
begin
  Assign(archUsuarios,'datos/usuarios.dat');
  iniUsuario(listaUsuarios);
  cargarUsuario(listaUsuarios,archUsuarios);
  Write('Ingrese el nombre de usuario: ');
  Readln(info.user);

  buscarUsuario(info.user,listaUsuarios,encontrado);//buscar el usuario por nombre para ver si ya existe

  if(info.user = encontrado.user) then //Si ya existe el usuario
  begin
    Writeln('El usuario "',info.user,'" ya existe');
    ReadKey;
  end
  else
  begin
    Write('Ingrese una contraseña: ');
    Readln(info.pass);
    insertarUsuario(listaUsuarios,info);
    guardarUsuario(archUsuarios,listaUsuarios);
  end;
end;

procedure usuarioExistente(var usuario:TUsuario;var inicioSesion:Boolean);
var
  encontrado:TUsuario;
  verificar:Boolean;
  archUsuarios:TAUsuario;
  listaUsuarios:TLUsuario;
begin
  Assign(archUsuarios,'datos/usuarios.dat');
  iniUsuario(listaUsuarios);
  cargarUsuario(listaUsuarios,archUsuarios);

  verificar:= false;
	inicioSesion:= false;
  while not verificar do
  begin
    Write('Ingrese el nombre de usuario: ');
    Readln(usuario.user);
    if not (usuario.user = '') then
      verificar := true;
  end;
  Write('Ingrese una contraseña: ');
  Readln(usuario.pass);
  buscarUsuario(usuario.user,listaUsuarios,encontrado);
  if(usuario.user = encontrado.user) and (usuario.pass = encontrado.pass)then //Si encuentra el usuario y la contraseña coincide
  begin
		inicioSesion := true;
  end
  else
  begin
    Writeln('Usuario o contraseña incorrectas');
  end;
end;

procedure MenuUsuario(info:TUsuario);
var
  opcion:Char;
	tabJugar:TSudokuBoard;
  eliminado:Boolean;
begin

  //muestra menu
  mostrarMenuUsuario;
  Readln(opcion);

  while opcion <> '4' do
  begin
    eliminado:=false;
    case opcion of
      '1': nuevaPartida(tabJugar);
      '2': cargarPartida(info,tabJugar);
      '3': begin
            eliminarJugador(info);
            eliminado:=true;
            end;
    else
      Writeln('Eligen una opción valida.');
    end;

    if (opcion = '1') or (opcion = '2') then
  	begin
  			MenuJuego(tabJugar,info);
  	end;
    if (eliminado) then
      opcion := '4'
    else
    begin
      //mostrar menu
      mostrarMenuUsuario;
      Readln(opcion);
    end;
  end;

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

procedure cargarPartida(info:TUsuario;var tabJugar:TSudokuBoard);
var
  partidas:TLSudokuBoard;
  max,pos:Integer;
  archPartidas :TASudokuBoard;
begin
  Assign(archPartidas,'datos/'+info.user+'.dat');
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

procedure eliminarJugador(info:TUsuario);
var
  archPartidas :TASudokuBoard;
  archUsuarios :TAUsuario;
  listaUsuarios:TLUsuario;
begin
  Assign(archUsuarios,'datos/usuarios.dat');
  iniUsuario(listaUsuarios);
  cargarUsuario(listaUsuarios,archUsuarios);
  eliminarUsuario(info,listaUsuarios);
  guardarUsuario(archUsuarios,listaUsuarios);
  Assign(archPartidas,'datos/'+info.user+'.dat');
  {$I-}
  erase(archPartidas);
  {$I+}
  if (IOResult <> 0) then
    writeln('Archivo de partidas no creado');
end;

procedure MenuJuego(tabJugar:TSudokuBoard;info:TUsuario);
begin

end;
end.
