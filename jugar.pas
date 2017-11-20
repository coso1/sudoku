Program sudoku;
uses utils,interfaz;
var
  archUsers:TAUsuario; //Archivo de usuarios
  listaUsuarios:TLUsuario;
  salidaPrincipal:Boolean;
begin
  Assign(archUsers,'datos/usuarios.dat');
  salidaPrincipal := false;
  iniUsuario(listaUsuarios);
  cargarUsuario(listaUsuarios,archUsers);//carga los datos del archivo en la lista
  while not salidaPrincipal do
  begin
    MenuPrincipal(salidaPrincipal,listaUsuarios,archUsers);
  end;
end.
