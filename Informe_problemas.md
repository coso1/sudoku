# Informes de problemas y soluciones

A continuación se detallan algunos de los problemas mas importantes que tuvimos a la hora de realizar el proyecto y una descripción de como lo solucionamos.

___

Calcular la posición del primer elemento de un box sabiendo la posición del mismo en una matriz imaginaria de 3x3.

```
|---|---|---|
| 1 | 2 | 3 |
|---|---|---|
| 4 | 5 | 6 |
|---|---|---|
| 7 | 8 | 9 |
|---|---|---|
```
intentamos encontrar una formula que dado el numero del bloque nos devuelva la posción en **x** e **y** del primer elemento del bloque.

```pascal
colElem:=3*((box + 2) mod 3)+1;

filaElem:=3*((box + 2) div 3-1)+1;
```
A partir de esos datos se puede recorrer todo el box desde **colElem** hasta **colElem+2** (en x) y desde **filaElem** hasta **filaElem+2** (en y).
___
Tuvimos que rehacer todas las funciones y procedimientos que utilizaban coordenadas en el tablero ya que habíamos usado los ejes de forma contraria a las funciones que ya incluía la unit "utils".

Invertimos los ejes en cada función y procedimiento y el problema se solucionó.

___

Se nos complicó el desarrollo de la función para verificar las columnas, porque estábamos haciendo mal los ciclos y no comparábamos todos los elementos de forma correcta.
___

A la hora de abrir archivos y usar _{$i-}_ y _{$i+}_ seguíamos obteniendo un error cuando el archivo no existía, a causa de que no estábamos comparando la variable **IOResult** para ver que tipo de error obteníamos.
___

Creamos una unit "interfaz" que maneja los menú del juego y las acciones de los mismos.

Hicimos esa unit principalmente porque era muy desordenado hacer todo en un solo archivo.

sin embargo, las acciones principales y necesarias para el manejo de listas, archivos y las reglas básicas del sudoku se encuentran en la unit "utils".
___

Tuvimos el problema de que al guardar una partida esta se duplicaba, ya que no eliminábamos la anterior o sobre escribíamos la partida que estábamos intentando modificar.

Esto lo solucionamos eliminando la partida a modificar de la lista de partidas del usuario justo antes de insertar la nueva partida ya modificada.
Entonces, al guardar las partidas en el archivo, evitamos el duplicado de la partida.
