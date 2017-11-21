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
procedure insertarXY(var tabJugar:TSudokuBoard);
procedure consultarFila(tabJugar:TSudokuBoard);
procedure consultarColumna(tabJugar:TSudokuBoard);

implementation
procedure mostrarMenuPrincipal;
begin
  ClrScr;
	Writeln('------- SUDOKU PA LO PIBE -------');
	Writeln('Seleccione una opción:');
	Writeln('1) Crear usuario.');
	Writeln('2) Usuario existente.');
	Writeln('3) Salir del juego.');
  Write('Opcion: ');
end;
procedure mostrarMenuUsuario;
begin
  ClrScr;
	Writeln('Seleccione una opción:');
  Writeln('1) Nueva partida');
	Writeln('2) Cargar partida');
  Writeln('3) Eliminar usuario');
	Writeln('4) Cambiar de usuario/Cerrar sesion');
  Write('Opcion: ');
end;
procedure mostrarMenuJuego;
begin
  ClrScr;
	Writeln('Seleccione una opción:');
	Writeln('1) Insertar elemento');
  Writeln('2) Consultar fila.');
  Writeln('3) Consultar columna.');
  Writeln('4) Consultar box.');
  Writeln('5) Consultar tablero.');
  Writeln('6) Guardar partida.');
	Writeln('7) Salir de la partida.');
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
  verificado:Boolean;
begin
  Assign(archUsuarios,'datos/usuarios.dat');
  iniUsuario(listaUsuarios);
  cargarUsuario(archUsuarios,listaUsuarios);
  verificado:=false;
  while not verificado do
  begin
    Write('Ingrese el nombre de usuario: ');
    Readln(info.user);
    buscarUsuario(info.user,listaUsuarios,encontrado);//buscar el usuario por nombre para ver si ya existe
    if(info.user = encontrado.user) then //Si ya existe el usuario
    begin
      Writeln('El usuario "',info.user,'" ya existe');
    end
    else
    begin
      verificado:=true;
    end;
  end;
  Write('Ingrese una contraseña: ');
  Readln(info.pass);
  insertarUsuario(listaUsuarios,info);
  guardarUsuario(archUsuarios,listaUsuarios);
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
  cargarUsuario(archUsuarios,listaUsuarios);

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
  cargarUsuario(archUsuarios,listaUsuarios);
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
var
  opcion:Char;
begin
  tabJugar.sudokuParcial := tabJugar.sudokuInicial;
  mostrarMenuJuego();
  Writeln('Nombre: ',tabJugar.nombre);
  Writeln('Dificultad: ',tabJugar.nivel);
  mostrarTableroParcial(tabJugar);
  Write('Opcion: ');
  readln(opcion);

  while opcion <> '7' do
  begin

    case opcion of
      '1': insertarXY(tabJugar);
      '2': consultarFila(tabJugar);
      '3': consultarColumna(tabJugar);
      (*'4': consultarBox();
      '5': consultarTablero();
      '6': guardarPartida();*)
    end;

    mostrarMenuJuego();
    Writeln('Nombre: ',tabJugar.nombre);
    Writeln('Dificultad: ',tabJugar.nivel);
    mostrarTableroParcial(tabJugar);
    Write('Opcion: ');
    readln(opcion);
  end;
end;

procedure insertarXY(var tabJugar:TSudokuBoard);
var
  i,j,valor:Integer;
begin
  i:=0;//valor para que entre al ciclo la primera vez
  j:=0;//valor para que entre al ciclo la primera vez
  valor:=-1;//valor para que entre al ciclo la primera vez

  while (j < 1) or (j > 9) do
  begin
    Write('Ingrese la coordenada x (Entre 1 y 9): ');
    Readln(j);
  end;
  while (i < 1) or (i > 9) do
  begin
    Write('Ingrese la coordenada y (Entre 1 y 9): ');
    Readln(i);
  end;

  while (valor < 0) or (valor > 9) do
  begin
    Write('Ingrese el valor a insertar (Entre 0 y 9): ');
    Readln(valor);
  end;

  if not (isInitialValue(tabJugar,i,j)) then
  begin
    tabJugar.sudokuParcial[i,j] := valor;
  end
  else
  begin
    writeln('El valor solicitado no se puede modificar (Presione una tecla para contiuar).');
    ReadKey;//pausa
  end;
end;

procedure consultarFila(tabJugar:TSudokuBoard);
var
  i:Integer;
begin
  i:=0;
  while (i < 1) or (i > 9) do
  begin
    Write('Ingrese la coordenada y (Entre 1 y 9): ');
    Readln(i);
  end;
  if(compruebaFila(tabJugar,i,1))then
  begin
    Writeln('La fila individualmente es valida.');
  end
  else
  begin
    Writeln('La fila NO es valida.');
  end;
  ReadKey;
end;
procedure consultarColumna(tabJugar:TSudokuBoard);
var
  j:Integer;
begin
  j:=0;
  while (j < 1) or (j > 9) do
  begin
    Write('Ingrese la coordenada x (Entre 1 y 9): ');
    Readln(j);
  end;
  if(compruebaColumna(tabJugar,j))then
  begin
    Writeln('La columna individualmente es valida.');
  end
  else
  begin
    Writeln('La columna NO es valida.');
  end;
  ReadKey;
end;
end.
