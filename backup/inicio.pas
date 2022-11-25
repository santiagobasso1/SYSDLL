unit Inicio;

//{$codepage UTF8}
{$mode objfpc}{$H+}

interface
USES crt,Pantallas,Tipos,AnalizadorSintactico,  Evaluaciones;
var
  n,r:string;
  raiz:T_Arbol_derivacion;
  estado:T_Estado;
  procedure  menu;

implementation
procedure menu;
BEGIN
  recuadroInicio;
  pantallaIngreseNombre;
  ruta(n,r);
  clrscr;
   ProcedimientoAnalizadorSintactico(r,raiz,compilacion);
   if compilacion=false then
   begin
   clrscr;
   writeln('Se detuvo la compilacion debido a un error en el archivo');
   readkey;
   end
   else
   begin
   readkey;
   InicializarEstado(estado);
   clrscr;
   EvaluarPrograma(raiz,estado);
   readkey;
   recuadroFinal();
   readkey;
   end;
end;

end.
