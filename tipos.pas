unit Tipos;

//{$CODEPAGE UTF8}
 interface
 uses crt;
 const
   celdavacia=-1;



type

 archivo=file of char;

 simbolos=(T_inicio, T_fin, T_pyComa, T_var, T_id, T_opAsig, T_leer, T_parentesisApertura, T_parentesisCierre, T_Cadena, T_coma, T_escribir, T_const, T_menos, T_not, T_or, T_and, {T_mayor, T_menor, T_mayorIgual,}T_OperadorRelacional, {T_menorIgual, T_igual, T_distinto,} T_si, T_entonces,  T_corcheteApertura, T_corcheteCierre, T_sino, T_mientras, T_mas, T_raiz, T_potencia, T_multiplicacion, T_division
 ,pesos ,V_Cuerpo, V_MultiSent, V_Sentencia, V_Variables, V_ListaVariables, V_MultiVar, V_Asignacion, V_Lectura, V_Escritura, V_Numero, V_Condicion, V_Parte1Cond, V_Negacion, V_Disyuncion, V_Conjuncion, V_CondRel, V_VarCondicional, V_SINO, V_VarMientras, V_ExpArit, V_Op1, V_SumaRes, V_RaizPot, V_Pot, V_MultDiv, error);



 Terminales=T_inicio..pesos;

 Variables=V_Cuerpo..V_MultDiv;

 T_DatoSimbolos=simbolos;

 T_PunteroSimbolos=^T_NodoSimbolos;

 T_NodoSimbolos=record
        info:simbolos;
        sig:T_PunteroSimbolos;
       end;

 T_ListaSimbolos=record
          cab:T_PunteroSimbolos;
          tam:integer;
          act:T_PunteroSimbolos;
         end;

 TAS = array [Variables,Terminales] of T_ListaSimbolos;

 T_Arbol_derivacion=^T_nodo_arbol;


 tdatop=record
        x:simbolos;
        parbol:T_Arbol_derivacion;

 end;

 tpunterop=^tnodop;
 tnodop= record
        info:tdatop;
        sig: tpunterop;
       end;

 tpila= record
        tope:tpunterop;
        tam:cardinal;
       end;

 tdatotabla=simbolos;

 tpunterotabla=^tnodotabla;

 tnodotabla=record
             lex:string;
             comp:tdatotabla;
             sig:tpunterotabla;
            end;

 T_Tabla= record
          cab:tpunterotabla;
          tam:cardinal;
         end;



 T_nodo_arbol= record
 simbolo:simbolos;
 lexema:string;
 hijos:array[1..10] of T_Arbol_derivacion;
 cant:byte;

 end;

procedure crearlista (var l:T_ListaSimbolos);
procedure InsertarValorTAS(var l:T_ListaSimbolos;x:T_DatoSimbolos);
function  TamanioLista(l:T_ListaSimbolos):cardinal;
procedure primero(var l:T_ListaSimbolos);
procedure siguiente(var l:T_ListaSimbolos);
procedure leeractual(var l:T_ListaSimbolos; var elemento:simbolos);
function finlista(var l:T_ListaSimbolos):boolean;
procedure crearArbol(var arbol:T_Arbol_derivacion;elemento:simbolos);
procedure ihijo(var arbol:T_Arbol_derivacion;i:byte;var simbolo:simbolos;var puntero:T_Arbol_derivacion);
procedure AgregarHijo(var padre:T_Arbol_derivacion;var hijo:T_Arbol_derivacion);
function canthijos(var arbol:T_Arbol_derivacion):byte;
procedure CrearPila(var p:tpila);
procedure apilar(var p:tpila; x:tdatop);
procedure EliminarP(var p:tpila;var x:tdatop);
procedure ruta(var n:string; var r:string);
 procedure creartabla(var l:T_Tabla);
procedure AgregarTabla(var l:T_Tabla; lexema:string; comp:Terminales);
procedure BuscarEnTabla(var l:T_Tabla; lexema:string;var comp:simbolos);


implementation
procedure crearlista (var l:T_ListaSimbolos);
begin
 l.cab:=nil;
 l.tam:=celdavacia;
end;

procedure InsertarValorTAS(var l:T_ListaSimbolos;x:T_DatoSimbolos);
var aux,ant,act:T_PunteroSimbolos;

begin
 if l.tam=celdavacia then l.tam:=0;
 inc(l.tam);
 new(aux);
 aux^.info:=x;
  if (l.cab=nil) then
   begin
    aux^.sig:=l.cab;
    l.cab:=aux;
   end
  else
   begin
    ant:=l.cab;
    act:=l.cab^.sig;
     while (act<>nil)  do
      begin
       ant:=act;
       act:=act^.sig;
      end;
    aux^.sig:=act;
    ant^.sig:=aux;
   end;
end;

function  TamanioLista(l:T_ListaSimbolos):cardinal;

begin
 TamanioLista:=l.tam;
end;

procedure CrearPila(var p:tpila);

begin
p.tope:=nil;
p.tam:=0;
end;

procedure apilar(var p:tpila; x:tdatop);
var aux:tpunterop;

begin
new(aux);
aux^.info:=x;
aux^.sig:=p.tope;
p.tope:=aux;
inc(p.tam);
end;

procedure EliminarP(var p:tpila;var x:tdatop);
var aux:tpunterop;

begin
  x:=p.tope^.info;
  aux:=p.tope;
  p.tope:=aux^.sig;
  dispose(aux);
  dec(p.tam);
end;

procedure ruta(var n:string; var r:string);
Var aux1:string;
 begin
   aux1:='.txt';
   gotoxy(74,13);
   readln(n);
   r:=n+aux1;
 end;

procedure creartabla(var l:T_Tabla);
begin
 l.cab:=nil;
 l.tam:=0;
end;

procedure BuscarEnTabla(var l:T_Tabla; lexema:string;var comp:simbolos);
   var act:tpunterotabla;
        encontrado:boolean;
  begin
   encontrado:=false;
   act:=l.cab;
    while (act <> nil)and (not encontrado) do
     begin

      if upcase(act^.lex)=upcase(lexema) then
       begin
       comp:=act^.comp;
       encontrado:=true;
       end
      else
       act:=act^.sig;
     end;
    if act=nil then
     comp:=T_id;
  end;

procedure AgregarTabla(var l:T_Tabla; lexema:string; comp:Terminales);
 var aux,ant,act:tpunterotabla;

begin
 inc(l.tam);
 new(aux);
 aux^.lex:=lexema;
 aux^.comp:=comp;
  if l.cab=nil  then
   begin
    aux^.sig:=l.cab;
    l.cab:=aux;
   end
  else
   begin
    ant:=l.cab;
    act:=l.cab^.sig;
     while act<>nil  do
      begin
       ant:=act;
       act:=act^.sig;
      end;
    aux^.sig:=act;
    ant^.sig:=aux;
   end;
end;

procedure primero(var l:T_ListaSimbolos);
begin
  l.act:=l.cab;
end;

procedure siguiente(var l:T_ListaSimbolos);
begin
  l.act:=l.act^.sig;
end;

procedure leeractual(var l:T_ListaSimbolos; var elemento:simbolos);
begin
  elemento:=l.act^.info;
end;

function finlista(var l:T_ListaSimbolos):boolean;
begin
  finlista:=l.act=nil;
end;

procedure crearArbol(var arbol:T_Arbol_derivacion;elemento:simbolos);
begin
  new(arbol);
  arbol^.simbolo:=elemento;
  arbol^.lexema:='';
  arbol^.cant:=0;
end;

procedure ihijo(var arbol:T_Arbol_derivacion;i:byte;var simbolo:simbolos;var puntero:T_Arbol_derivacion);
begin
  puntero:=arbol^.hijos[i];
  simbolo:=puntero^.simbolo;
end;

procedure AgregarHijo(var padre:T_Arbol_derivacion;var hijo:T_Arbol_derivacion);
begin
  inc(padre^.cant);
  padre^.hijos[padre^.cant]:=hijo;
end;

function canthijos(var arbol:T_Arbol_derivacion):byte;
begin
  canthijos:=arbol^.cant;
end;

END.

