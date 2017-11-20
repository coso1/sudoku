unit interfaz;

interface
uses utils,crt;
procedure mostrarMenuPrincipal;
procedure mostrarMenuUsuario;
procedure mostrarMenuJuego;

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
begin
  salidaPrincipal:=false;

  mostrarMenuPrincipal();
  readln(opcion);
  while not opcion <> '3' do
  begin

    case opcion of
      '1': crearUsuario();
      '2': usuarioExistente(info,inicioSesion);
      '3': salida:=true;
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

procedure crearUsuario();
var
  listaUsuarios:TLUsuario;
  archUsuarios:TAUsuario;
  encontrado:TUsuario;
  verificar:Boolean;//Si el nombre de usuario esta verificado
begin
  Assign(archUsuarios,'datos/usuarios.dat');
  iniUsuario(listaUsuarios);
  cargarUsuario(listaUsuarios,archUsuarios);

  verificar:= false;
  while not verificar do// mientas se escriba un usuario vacio volver a preguntar nombre
  begin
    Write('Ingrese el nombre de usuario: ');
    Readln(usuario.user);
    if not (usuario.user = '') then
      verificar := true;
  end;

  buscarUsuario(usuario.user,lista,encontrado);//buscar el usuario por nombre para ver si ya existe

  if(usuario.user = encontrado.user) then //Si ya existe el usuario
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
	salidaJuego:Boolean;
	archPartidas :TASudokuBoard;
begin
  //muestra menu
  mostrarMenuUsuario;
  Readln(opcion);

  while opcion <> '4' do
  begin
    case opcion of
      '1': nuevaPartida(tabJugar);
      '2': cargarPartida(info,tabJugar);
      '3': eliminarJugador(info);
      '4': salida := true;
    else
      Writeln('Eligen una opción valida.');
    end;

    if (opcion = '1') or (opcion = '2') then
  	begin
  			MenuJuego(tabJugar,info);
  	end;
  end;
  //mostrar menu
  mostrarMenuUsuario;
  Readln(opcion);
end;

end.
