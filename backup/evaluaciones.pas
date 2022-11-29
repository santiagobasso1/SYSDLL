unit Evaluaciones;

//{$codepage UTF8}
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Tipos, Math, crt;

const
  maxlistareal = 100;
  maxestado = 100;

type
  telementoestado = record
    id: string;
    valor: real;
  end;

  T_Estado = record
    elementos: array [1..maxestado] of telementoestado;
    cant: word;
  end;


procedure InicializarEstado(var e: T_Estado);
procedure AgregarVariable(var e: T_Estado; var id: string);
procedure AsignarValor(var e: T_Estado; var id: string; valor: real);
function ObtenerValor(var e: T_Estado; var lexid: string): real;
procedure EvaluarCuerpo(var arbol: T_Arbol_derivacion; var estado: T_Estado);
procedure EvaluarMultiSent(var arbol: T_Arbol_derivacion; var estado: T_Estado);
procedure EvaluarSentencia(var arbol: T_Arbol_derivacion; var estado: T_Estado);
procedure EvaluarVariables(var arbol: T_Arbol_derivacion; var estado: T_Estado);
procedure EvaluarListaVariables(var arbol: T_Arbol_derivacion; var estado: T_Estado);
procedure EvaluarMultiVar(var arbol: T_Arbol_derivacion; var estado: T_Estado);
procedure EvaluarAsignacion(var arbol: T_Arbol_derivacion; var estado: T_Estado);
procedure EvaluarLectura(var arbol: T_Arbol_derivacion; var estado: T_Estado);
procedure EvaluarEscritura(var arbol: T_Arbol_derivacion; var estado: T_Estado);
procedure EvaluarNumero(var arbol: T_Arbol_derivacion; var estado: T_Estado; var valor: real);
procedure EvaluarCondicion(var arbol: T_Arbol_derivacion; var estado: T_Estado; var resultado:boolean);
procedure EvaluarParte1Cond(var arbol: T_Arbol_derivacion; var estado: T_Estado;var resultado:boolean);
procedure EvaluarNegacion(var arbol: T_Arbol_derivacion; var estado: T_Estado;var resultado:boolean);
procedure EvaluarDisyuncion(var arbol: T_Arbol_derivacion; var estado: T_Estado;var aux:boolean; var resultado:boolean);
procedure EvaluarConjuncion(var arbol: T_Arbol_derivacion; var estado: T_Estado;var aux:boolean; var resultado:boolean);
procedure EvaluarCondRel(var arbol: T_Arbol_derivacion; var estado: T_Estado;var resultado:boolean);
procedure EvaluarVarCondicional(var arbol: T_Arbol_derivacion; var estado: T_Estado);
procedure EvaluarSINO(var arbol: T_Arbol_derivacion; var estado: T_Estado);
procedure EvaluarVarMientras(var arbol: T_Arbol_derivacion; var estado: T_Estado);
procedure EvaluarExpArit(var arbol: T_Arbol_derivacion; var estado: T_Estado;var valor: real);
procedure EvaluarOp1(var arbol: T_Arbol_derivacion; var estado: T_Estado;var valor: real);
procedure EvaluarSumaRes(var arbol: T_Arbol_derivacion; var estado: T_Estado;var aux: real; var valor: real);
procedure EvaluarRaizPot(var arbol: T_Arbol_derivacion; var estado: T_Estado; var valor: real);
procedure EvaluarPot(var arbol: T_Arbol_derivacion; var estado: T_Estado;var aux: real; var valor: real);
procedure EvaluarMultDiv(var arbol: T_Arbol_derivacion; var estado: T_Estado;var aux: real; var valor: real);

implementation






procedure InicializarEstado(var e: T_Estado);
begin
  e.cant := 0;
end;




procedure AgregarVariable(var e: T_Estado; var id: string);
begin
  E.cant := E.cant + 1;
  E.elementos[E.cant].id := id;
  E.elementos[E.cant].valor := 0;
end;

procedure AsignarValor(var e: T_Estado; var id: string; valor: real);
var
  i: integer;
begin
  for i := 1 to E.cant do
  begin
    if upcase(E.elementos[i].id) = upcase(id) then
      E.elementos[i].valor := valor;
  end;
end;


function ObtenerValor(var e: T_Estado; var lexid: string): real;
var
  i: integer;
begin
  ObtenerValor := 0;
  for i := 1 to E.cant do
  begin
    if upcase(E.elementos[i].id) = upcase(lexid) then
      ObtenerValor := E.elementos[i].valor;
  end;
end;

//Cuerpo -> inicio MultiSent fin

procedure EvaluarCuerpo(var arbol: T_Arbol_derivacion; var estado: T_Estado);
begin
  EvaluarMultiSent(arbol^.hijos[2], estado);
end;
//MultiSent -> Sentencia ; MultiSent | epsilon

procedure EvaluarMultiSent(var arbol: T_Arbol_derivacion; var estado: T_Estado);
begin
  if arbol^.cant > 0 then    //Epsilon
  begin
    EvaluarSentencia(arbol^.hijos[1], estado);
    EvaluarMultiSent(arbol^.hijos[3], estado);
  end;
end;

//Sentencia -> Asignacion | Lectura | Escritura | VarCondicional | VarMientras | Variables

procedure EvaluarSentencia(var arbol: T_Arbol_derivacion; var estado: T_Estado);
begin

  case arbol^.hijos[1]^.simbolo of
    V_Asignacion: EvaluarAsignacion(arbol^.hijos[1], estado);
    V_Lectura: EvaluarLectura(arbol^.hijos[1], estado);
    V_Escritura: EvaluarEscritura(arbol^.hijos[1], estado);
    V_VarCondicional: EvaluarVarCondicional(arbol^.hijos[1], estado);
    V_VarMientras: EvaluarVarMientras(arbol^.hijos[1], estado);
    V_Variables: EvaluarVariables(arbol^.hijos[1], estado);
  end;
end;

//Variables -> var inicio ListaVariables fin

procedure EvaluarVariables(var arbol: T_Arbol_derivacion; var estado: T_Estado);
begin
  EvaluarListaVariables(arbol^.hijos[3], estado);
end;
//ListaVariables ->  id MultiVar
procedure EvaluarListaVariables(var arbol: T_Arbol_derivacion; var estado: T_Estado);
begin
  AgregarVariable(estado, arbol^.hijos[1]^.lexema);
  EvaluarMultiVar(arbol^.hijos[2], estado);
end;

//MultiVar-> id MultiVar | epsilon
procedure EvaluarMultiVar(var arbol: T_Arbol_derivacion; var estado: T_Estado);
begin
  if arbol^.cant > 0 then
  begin
    AgregarVariable(estado, arbol^.hijos[1]^.lexema);
    EvaluarMultiVar(arbol^.hijos[2], estado);
  end;
end;

//Asignacion -> id := ExpArit

procedure EvaluarAsignacion(var arbol: T_Arbol_derivacion; var estado: T_Estado);
var
  valor: real;
begin
  EvaluarExpArit(arbol^.hijos[3], estado, valor);
  AsignarValor(estado, arbol^.hijos[1]^.lexema, valor);
end;

//Lectura -> leer (texto, id)
procedure EvaluarLectura(var arbol: T_Arbol_derivacion; var estado: T_Estado);
var
  aux:real;
begin
  write(arbol^.hijos[3]^.lexema);
  readln(aux);
  AsignarValor(estado,arbol^.hijos[5]^.lexema,aux);
end;

//Escritura -> escribir (texto, ExpArit )
procedure EvaluarEscritura(var arbol: T_Arbol_derivacion; var estado: T_Estado);
var
  aux:real;
begin
  EvaluarExpArit(arbol^.hijos[5],estado,aux);
  write(arbol^.hijos[3]^.lexema);
  writeln(aux:0:2);
end;


//  Numero -> id | (ExpArit) | const  | - Numero

procedure EvaluarNumero(var arbol: T_Arbol_derivacion; var estado: T_Estado; var valor: real);
begin
  case arbol^.hijos[1]^.simbolo of
    T_id:
    begin
      valor:=ObtenerValor(estado,arbol^.hijos[1]^.lexema);
    end;
    T_parentesisApertura:
    begin
      EvaluarExpArit(arbol^.hijos[2],estado,valor);
    end;

    T_const:
    begin
      val(arbol^.hijos[1]^.lexema,valor);        //Val Calculate numerical/enumerated value of a string.
    end;

    T_menos:
    begin
      EvaluarNumero(arbol^.hijos[2],estado,valor);
    end;
  end;

end;

//Condicion -> Parte1Cond Disyuncion
procedure EvaluarCondicion(var arbol: T_Arbol_derivacion; var estado: T_Estado; var resultado:boolean);
var
  aux:boolean;
begin
  EvaluarParte1Cond(arbol^.hijos[1],estado,aux);
  EvaluarDisyuncion(arbol^.hijos[2],estado,aux,resultado);
end;


//Parte1Cond -> Negacion Conjuncion

procedure EvaluarParte1Cond(var arbol: T_Arbol_derivacion; var estado: T_Estado;var resultado:boolean);
var
  aux:boolean;
begin
  EvaluarNegacion(arbol^.hijos[1],estado,aux);
  EvaluarConjuncion(arbol^.hijos[2],estado,aux,resultado);
end;

//Negacion -> not CondRel | CondRel

procedure EvaluarNegacion(var arbol: T_Arbol_derivacion; var estado: T_Estado;var resultado:boolean);
begin
  case arbol^.hijos[1]^.simbolo of
    T_not:
    begin
      EvaluarCondRel(arbol^.hijos[2],estado,resultado);
      resultado:=not resultado;
    end;
    else EvaluarCondRel(arbol^.hijos[1],estado,resultado);
  end;
end;


//Disyuncion -> or Parte1Cond Disyuncion | epsilon

procedure EvaluarDisyuncion(var arbol: T_Arbol_derivacion; var estado: T_Estado;var aux:boolean; var resultado:boolean);
var
  aux2,resultadoParte1Cond:boolean;
begin
  if arbol^.cant > 0 then
  begin
    EvaluarParte1Cond(arbol^.hijos[2],estado,resultadoParte1Cond);
    aux2:=aux or resultadoParte1Cond;
    EvaluarDisyuncion(arbol^.hijos[3],estado,aux2,resultado);
  end
  else
  resultado:=aux;
end;

//Conjuncion -> and Parte1Cond Conjuncion  | epsilon

procedure EvaluarConjuncion(var arbol: T_Arbol_derivacion; var estado: T_Estado;var aux:boolean; var resultado:boolean);
var
  aux2,resultadoParte1Cond:boolean;
begin
  if arbol^.cant > 0 then
  begin
    EvaluarParte1Cond(arbol^.hijos[2],estado,resultadoParte1Cond);
    aux2:=aux and resultadoParte1Cond;
    EvaluarConjuncion(arbol^.hijos[3],estado,aux2,resultado);
  end
  else
  resultado:=aux;
end;



//CondRel -> ExpArit OperadorRelacional ExpArit | [Condicion]

procedure EvaluarCondRel(var arbol: T_Arbol_derivacion; var estado: T_Estado;var resultado:boolean);
var
  aux1,aux2:real;
begin
  case arbol^.hijos[1]^.simbolo of
    V_ExpArit:
    begin
      EvaluarExpArit(arbol^.hijos[1],estado,aux1);
      EvaluarExpArit(arbol^.hijos[3],estado,aux2);
      case arbol^.hijos[2]^.lexema of
        '>':resultado:=aux1>aux2;
        '<':resultado:=aux1<aux2;
        '=':resultado:=aux1=aux2;
        '>=':resultado:=aux1>=aux2;
        '<=':resultado:=aux1<=aux2;
        '<>':resultado:=aux1<>aux2;
      end;
    end;
    T_corcheteApertura:EvaluarCondicion(arbol^.hijos[2],estado,resultado);
  end;
end;


//VarCondicional -> si Condicion entonces Cuerpo SINO
procedure EvaluarVarCondicional(var arbol: T_Arbol_derivacion; var estado: T_Estado);
var
  resultadoCondicion:boolean;
begin
  EvaluarCondicion(arbol^.hijos[2],estado,resultadoCondicion);
  if resultadoCondicion then
  begin
      EvaluarCuerpo(arbol^.hijos[4],estado);
  end
  else
  EvaluarSINO(arbol^.hijos[5],estado);
end;


//SINO -> sino Cuerpo | epsilon
procedure EvaluarSINO(var arbol: T_Arbol_derivacion; var estado: T_Estado);
begin
  if arbol^.cant > 0 then
  begin
      EvaluarCuerpo(arbol^.hijos[2],estado);
  end;
end;


//VarMientras -> mientras Condicion entonces Cuerpo
procedure EvaluarVarMientras(var arbol: T_Arbol_derivacion; var estado: T_Estado);
var
  resultadoCondicion:boolean;
begin
  EvaluarCondicion(arbol^.hijos[2],estado,resultadoCondicion);
  while resultadoCondicion do
  begin
      EvaluarCuerpo(arbol^.hijos[4],estado);
      EvaluarCondicion(arbol^.hijos[2],estado,resultadoCondicion); //Renovar condicion
  end;

end;



//ExpArit -> Op1 SumaRes

procedure EvaluarExpArit(var arbol: T_Arbol_derivacion; var estado: T_Estado;var valor: real);
var
  aux: real;
begin
  EvaluarOp1(arbol^.hijos[1], estado, aux);
  EvaluarSumaRes(arbol^.hijos[2], estado, aux, valor);
end;

//Op1 -> RaizPot MultDiv

procedure EvaluarOp1(var arbol: T_Arbol_derivacion; var estado: T_Estado;var valor: real);
var
  aux: real;
begin
  EvaluarRaizPot(arbol^.hijos[1], estado, aux);
  EvaluarMultDiv(arbol^.hijos[2], estado, aux, valor);
end;

//SumaRes -> + Op1 SumaRes| - Op1 SumaRes | epsilon

procedure EvaluarSumaRes(var arbol: T_Arbol_derivacion; var estado: T_Estado;var aux: real; var valor: real);
var
  aux2, resultado: real;
begin
  if arbol^.cant > 0 then
  begin
    if arbol^.hijos[1]^.simbolo = T_mas then
    begin
      EvaluarOp1(arbol^.hijos[2], estado, aux2);
      resultado := aux + aux2;
      EvaluarSumaRes(arbol^.hijos[3], estado, resultado, valor);
    end
    else
    begin
      EvaluarOp1(arbol^.hijos[2], estado, aux2);
      resultado := aux - aux2;
      EvaluarSumaRes(arbol^.hijos[3], estado, resultado, valor);
    end;
  end
  else
  begin
    valor := aux;
  end;
end;


//RaizPot -> Numero Pot | raiz(RaizPot)

procedure EvaluarRaizPot(var arbol: T_Arbol_derivacion; var estado: T_Estado; var valor: real);
var
  aux: real;
begin
  case arbol^.hijos[1]^.simbolo of
    V_Numero:
      begin
        EvaluarNumero(arbol^.hijos[1], estado, aux);
        EvaluarPot(arbol^.hijos[2], estado, aux, valor);
      end;
    T_raiz:
      begin
        EvaluarRaizPot(arbol^.hijos[3], estado, aux);
        valor := sqrt(aux);
      end;
  end;
end;

//Pot -> ^ RaizPot | epsilon

procedure EvaluarPot(var arbol: T_Arbol_derivacion; var estado: T_Estado;var aux: real; var valor: real);
var
  aux1: real;
begin
  if arbol^.cant > 0 then
    begin
      EvaluarRaizPot(arbol^.hijos[2], estado, aux1);
      valor := power(aux, aux1);
    end
    else
      valor := aux;
end;

//MultDiv -> * RaizPot MultDiv | / RaizPot MultDiv | epsilon

procedure EvaluarMultDiv(var arbol: T_Arbol_derivacion; var estado: T_Estado;var aux: real; var valor: real);
var
  aux2, resultado: real;
begin
  if arbol^.cant > 0 then
  begin
    if arbol^.hijos[1]^.simbolo = T_multiplicacion then
    begin
      EvaluarRaizPot(arbol^.hijos[2], estado, aux2);
      resultado := aux * aux2;
      EvaluarMultDiv(arbol^.hijos[3], estado, resultado, valor);
    end
    else
    begin
      EvaluarRaizPot(arbol^.hijos[2], estado, aux2);
      resultado := aux / aux2;
      EvaluarMultDiv(arbol^.hijos[3], estado, resultado, valor);
    end;
  end
  else
  begin
    valor := aux;
  end;
end;


end.
