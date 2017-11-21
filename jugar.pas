Program sudoku;
uses utils,interfaz;
var
  archivo:TASudokuBoard;
begin
  assign(archivo,'datos/sudoku_boards.dat');
  mostrarTablerosIniciales(archivo);
//  Randomize;
//  MenuPrincipal;
end.
