unit AnalizadorSintactico;
//{$codepage UTF8}

interface


uses Tipos,AnalizadorLexico,crt;

procedure ProcedimientoAnalizadorSintactico(r:string;var raiz:T_Arbol_derivacion; var compilacion:boolean);

implementation
procedure CrearTablaSimbolos(var l:T_Tabla);
begin
creartabla(l);
AgregarTabla(l,'inicio',T_inicio);
AgregarTabla(l,'fin',T_fin);
AgregarTabla(l,'var',T_var);

AgregarTabla(l,'constante',T_const);
AgregarTabla(l,'raiz',T_raiz);
AgregarTabla(l,'si',T_si);
AgregarTabla(l,'entonces',T_entonces);
AgregarTabla(l,'sino',T_sino);


AgregarTabla(l,'leer',T_leer);
AgregarTabla(l,'escribir',T_escribir);
AgregarTabla(l,'mientras',T_mientras);
AgregarTabla(l,'or',T_or);
AgregarTabla(l,'and',T_and);
AgregarTabla(l,'not',T_not);
AgregarTabla(l,'texto',T_Cadena);


end;

procedure CrearTAS(var tabla:TAS);
  var
    I, K : simbolos;
  begin
    for K := V_Cuerpo to V_MultDiv do
   begin
     for I:= T_inicio to pesos do
     begin
       crearlista(Tabla[k,i]);
     end;
  end;
//FORMATO DE INSERCION DE LA TAS, DE LA FORMA InsertarValorTAS(Tabla[Fila,Columna],Valor) TAS[fila,columna]=Valo
//CUERPO
        InsertarValorTAS(Tabla[V_Cuerpo,T_inicio],T_inicio);
        InsertarValorTAS(Tabla[V_Cuerpo,T_inicio],V_MultiSent);
        InsertarValorTAS(Tabla[V_Cuerpo,T_inicio],T_fin);

//MULTISENT
        InsertarValorTAS(Tabla[V_MultiSent,T_id],V_Sentencia);
        InsertarValorTAS(Tabla[V_MultiSent,T_id],T_pyComa);
        InsertarValorTAS(Tabla[V_MultiSent,T_id],V_MultiSent);

        InsertarValorTAS(Tabla[V_MultiSent,T_leer],V_Sentencia);
        InsertarValorTAS(Tabla[V_MultiSent,T_leer],T_pyComa);
        InsertarValorTAS(Tabla[V_MultiSent,T_leer],V_MultiSent);

        InsertarValorTAS(Tabla[V_MultiSent,T_escribir],V_Sentencia);
        InsertarValorTAS(Tabla[V_MultiSent,T_escribir],T_pyComa);
        InsertarValorTAS(Tabla[V_MultiSent,T_escribir],V_MultiSent);

        InsertarValorTAS(Tabla[V_MultiSent,T_si],V_Sentencia);
        InsertarValorTAS(Tabla[V_MultiSent,T_si],T_pyComa);
        InsertarValorTAS(Tabla[V_MultiSent,T_si],V_MultiSent);

        InsertarValorTAS(Tabla[V_MultiSent,T_mientras],V_Sentencia);
        InsertarValorTAS(Tabla[V_MultiSent,T_mientras],T_pyComa);
        InsertarValorTAS(Tabla[V_MultiSent,T_mientras],V_MultiSent);

        InsertarValorTAS(Tabla[V_MultiSent,T_var],V_Sentencia);
        InsertarValorTAS(Tabla[V_MultiSent,T_var],T_pyComa);
        InsertarValorTAS(Tabla[V_MultiSent,T_var],V_MultiSent);

        Tabla[V_MultiSent,T_fin].tam:=0;     //TAS[MultiSent,fin]=epsilon

//SENTENCIA
        InsertarValorTAS(Tabla[V_Sentencia,T_id],V_Asignacion);

        InsertarValorTAS(Tabla[V_Sentencia,T_leer],V_Lectura);

        InsertarValorTAS(Tabla[V_Sentencia,T_escribir],V_Escritura);

        InsertarValorTAS(Tabla[V_Sentencia,T_si],V_VarCondicional);

        InsertarValorTAS(Tabla[V_Sentencia,T_mientras],V_VarMientras);

        InsertarValorTAS(Tabla[V_Sentencia,T_var],V_Variables);

//VARIABLES
        InsertarValorTAS(Tabla[V_Variables,T_var],T_var);
        InsertarValorTAS(Tabla[V_Variables,T_var],T_inicio);
        InsertarValorTAS(Tabla[V_Variables,T_var],V_ListaVariables);
        InsertarValorTAS(Tabla[V_Variables,T_var],T_fin);


//LISTAVARIABLES
        InsertarValorTAS(Tabla[V_ListaVariables,T_id],T_id);
        InsertarValorTAS(Tabla[V_ListaVariables,T_id],V_MultiVar);

//MultiVar
        InsertarValorTAS(Tabla[V_MultiVar,T_id],T_id);
        InsertarValorTAS(Tabla[V_MultiVar,T_id],V_MultiVar);
        Tabla[V_MultiVar,T_fin].tam:=0;

//Asignación
        InsertarValorTAS(Tabla[V_Asignacion,T_id],T_id);
        InsertarValorTAS(Tabla[V_Asignacion,T_id],T_opAsig);
        InsertarValorTAS(Tabla[V_Asignacion,T_id],V_ExpArit);

//Lectura
        InsertarValorTAS(Tabla[V_Lectura,T_leer],T_leer);
        InsertarValorTAS(Tabla[V_Lectura,T_leer],T_parentesisApertura);
        InsertarValorTAS(Tabla[V_Lectura,T_leer],T_Cadena);
        InsertarValorTAS(Tabla[V_Lectura,T_leer],T_coma);
        InsertarValorTAS(Tabla[V_Lectura,T_leer],T_id);
        InsertarValorTAS(Tabla[V_Lectura,T_leer],T_parentesisCierre);

//Escritura
        InsertarValorTAS(Tabla[V_Escritura,T_escribir],T_escribir);
        InsertarValorTAS(Tabla[V_Escritura,T_escribir],T_parentesisApertura);
        InsertarValorTAS(Tabla[V_Escritura,T_escribir],T_Cadena);
        InsertarValorTAS(Tabla[V_Escritura,T_escribir],T_coma);
        InsertarValorTAS(Tabla[V_Escritura,T_escribir],V_ExpArit);
        InsertarValorTAS(Tabla[V_Escritura,T_escribir],T_parentesisCierre);

//Numero
        InsertarValorTAS(Tabla[V_Numero,T_id],T_id);
        InsertarValorTAS(Tabla[V_Numero,T_parentesisApertura],T_parentesisApertura);
        InsertarValorTAS(Tabla[V_Numero,T_parentesisApertura],V_ExpArit);
        InsertarValorTAS(Tabla[V_Numero,T_parentesisApertura],T_parentesisCierre);
        InsertarValorTAS(Tabla[V_Numero,T_const],T_const);
        InsertarValorTAS(Tabla[V_Numero,T_menos],T_menos);
        InsertarValorTAS(Tabla[V_Numero,T_menos],V_Numero);

//Condicion
        InsertarValorTAS(Tabla[V_Condicion,T_id],V_Parte1Cond);
        InsertarValorTAS(Tabla[V_Condicion,T_id],V_Disyuncion);

        InsertarValorTAS(Tabla[V_Condicion,T_parentesisApertura],V_Parte1Cond);
        InsertarValorTAS(Tabla[V_Condicion,T_parentesisApertura],V_Disyuncion);

        InsertarValorTAS(Tabla[V_Condicion,T_const],V_Parte1Cond);
        InsertarValorTAS(Tabla[V_Condicion,T_const],V_Disyuncion);

        InsertarValorTAS(Tabla[V_Condicion,T_menos],V_Parte1Cond);
        InsertarValorTAS(Tabla[V_Condicion,T_menos],V_Disyuncion);

        Tabla[V_Condicion,T_not].tam:=0;

//Parte1Cond
        InsertarValorTAS(Tabla[V_Parte1Cond,T_not],V_Negacion);
        InsertarValorTAS(Tabla[V_Parte1Cond,T_not],V_Conjuncion);

//Negación
        InsertarValorTAS(Tabla[V_Negacion,T_id],V_CondRel);

        InsertarValorTAS(Tabla[V_Negacion,T_parentesisApertura],V_CondRel);

        InsertarValorTAS(Tabla[V_Negacion,T_const],V_CondRel);

        InsertarValorTAS(Tabla[V_Negacion,T_menos],V_CondRel);

        InsertarValorTAS(Tabla[V_Negacion,T_not],T_not);
        InsertarValorTAS(Tabla[V_Negacion,T_not],V_CondRel);

//Disyuncion
        Tabla[V_Disyuncion,T_entonces].tam:=0;

        InsertarValorTAS(Tabla[V_Disyuncion,T_or],T_or);
        InsertarValorTAS(Tabla[V_Disyuncion,T_or],V_Parte1Cond);
        InsertarValorTAS(Tabla[V_Disyuncion,T_or],V_Disyuncion);

        Tabla[V_Disyuncion,T_corcheteCierre].tam:=0;

//Conjuncion
        Tabla[V_Conjuncion,T_entonces].tam:=0;

        Tabla[V_Conjuncion,T_or].tam:=0;

        InsertarValorTAS(Tabla[V_Conjuncion,T_and],T_and);
        InsertarValorTAS(Tabla[V_Conjuncion,T_and],V_Parte1Cond);
        InsertarValorTAS(Tabla[V_Conjuncion,T_and],V_Conjuncion);

        Tabla[V_Conjuncion,T_corcheteCierre].tam:=0;


//CondRel
        InsertarValorTAS(Tabla[V_CondRel,T_id],V_ExpArit);
        InsertarValorTAS(Tabla[V_CondRel,T_id],T_OperadorRelacional );
        InsertarValorTAS(Tabla[V_CondRel,T_id],V_ExpArit);

        InsertarValorTAS(Tabla[V_CondRel,T_parentesisApertura],V_ExpArit);
        InsertarValorTAS(Tabla[V_CondRel,T_parentesisApertura],T_OperadorRelacional );
        InsertarValorTAS(Tabla[V_CondRel,T_parentesisApertura],V_ExpArit);

        InsertarValorTAS(Tabla[V_CondRel,T_const],V_ExpArit);
        InsertarValorTAS(Tabla[V_CondRel,T_const],T_OperadorRelacional );
        InsertarValorTAS(Tabla[V_CondRel,T_const],V_ExpArit);

        InsertarValorTAS(Tabla[V_CondRel,T_menos],V_ExpArit);
        InsertarValorTAS(Tabla[V_CondRel,T_menos],T_OperadorRelacional );
        InsertarValorTAS(Tabla[V_CondRel,T_menos],V_ExpArit);

        InsertarValorTAS(Tabla[V_CondRel,T_corcheteApertura],T_corcheteApertura);
        InsertarValorTAS(Tabla[V_CondRel,T_corcheteApertura],V_Condicion);
        InsertarValorTAS(Tabla[V_CondRel,T_corcheteApertura],T_corcheteCierre);

//VarCondicional
        InsertarValorTAS(Tabla[V_VarCondicional,T_si],T_si);
        InsertarValorTAS(Tabla[V_VarCondicional,T_si],V_Condicion);
        InsertarValorTAS(Tabla[V_VarCondicional,T_si],T_entonces);
        InsertarValorTAS(Tabla[V_VarCondicional,T_si],V_Cuerpo);
        InsertarValorTAS(Tabla[V_VarCondicional,T_si],V_SINO);

//SINO
        InsertarValorTAS(Tabla[V_SINO,T_sino],T_sino);
        InsertarValorTAS(Tabla[V_SINO,T_sino],V_Cuerpo);

//VarMientras
        InsertarValorTAS(Tabla[V_VarMientras,T_mientras],T_mientras);
        InsertarValorTAS(Tabla[V_VarMientras,T_mientras],V_Condicion);
        InsertarValorTAS(Tabla[V_VarMientras,T_mientras],T_entonces);
        InsertarValorTAS(Tabla[V_VarMientras,T_mientras],V_Cuerpo);

//ExpArit
        InsertarValorTAS(Tabla[V_ExpArit,T_id],V_Op1);
        InsertarValorTAS(Tabla[V_ExpArit,T_id],V_SumaRes);

        InsertarValorTAS(Tabla[V_ExpArit,T_parentesisApertura],V_Op1);
        InsertarValorTAS(Tabla[V_ExpArit,T_parentesisApertura],V_SumaRes);

        InsertarValorTAS(Tabla[V_ExpArit,T_const],V_Op1);
        InsertarValorTAS(Tabla[V_ExpArit,T_const],V_SumaRes);

        InsertarValorTAS(Tabla[V_ExpArit,T_menos],V_Op1);
        InsertarValorTAS(Tabla[V_ExpArit,T_menos],V_SumaRes);

//Op1
        InsertarValorTAS(Tabla[V_Op1,T_id],V_RaizPot);
        InsertarValorTAS(Tabla[V_Op1,T_id],V_MultDiv);

        InsertarValorTAS(Tabla[V_Op1,T_parentesisApertura],V_RaizPot);
        InsertarValorTAS(Tabla[V_Op1,T_parentesisApertura],V_MultDiv);

        InsertarValorTAS(Tabla[V_Op1,T_const],V_RaizPot);
        InsertarValorTAS(Tabla[V_Op1,T_const],V_MultDiv);

        InsertarValorTAS(Tabla[V_Op1,T_menos],V_RaizPot);
        InsertarValorTAS(Tabla[V_Op1,T_menos],V_MultDiv);

//SumaRes
        Tabla[V_SumaRes,T_entonces].tam:=0;

        Tabla[V_SumaRes,T_parentesisCierre].tam:=0;

        InsertarValorTAS(Tabla[V_SumaRes,T_menos],T_menos);
        InsertarValorTAS(Tabla[V_SumaRes,T_menos],V_Op1);
        InsertarValorTAS(Tabla[V_SumaRes,T_menos],V_SumaRes);

        Tabla[V_SumaRes,T_or].tam:=0;

        Tabla[V_SumaRes,T_and].tam:=0;

        Tabla[V_SumaRes,T_corcheteCierre].tam:=0;

       { Tabla[V_SumaRes,T_mayor].tam:=0;

        Tabla[V_SumaRes,T_menor].tam:=0;

        Tabla[V_SumaRes,T_mayorIgual].tam:=0;

        Tabla[V_SumaRes,T_menorIgual].tam:=0;

        Tabla[V_SumaRes,T_igual].tam:=0;

        Tabla[V_SumaRes,T_distinto].tam:=0;}

        InsertarValorTAS(Tabla[V_SumaRes,T_mas],T_Mas);
        InsertarValorTAS(Tabla[V_SumaRes,T_mas],V_Op1);
        InsertarValorTAS(Tabla[V_SumaRes,T_mas],V_SumaRes);

        Tabla[V_SumaRes,T_pyComa].tam:=0;

//RaizPot
        InsertarValorTAS(Tabla[V_RaizPot,T_id],V_Numero);
        InsertarValorTAS(Tabla[V_RaizPot,T_id],V_Pot);

        InsertarValorTAS(Tabla[V_RaizPot,T_parentesisApertura],V_Numero);
        InsertarValorTAS(Tabla[V_RaizPot,T_parentesisApertura],V_Pot);

        InsertarValorTAS(Tabla[V_RaizPot,T_const],V_Numero);
        InsertarValorTAS(Tabla[V_RaizPot,T_const],V_Pot);

        InsertarValorTAS(Tabla[V_RaizPot,T_menos],V_Numero);
        InsertarValorTAS(Tabla[V_RaizPot,T_menos],V_Pot);

        InsertarValorTAS(Tabla[V_RaizPot,T_Raiz],T_Raiz);
        InsertarValorTAS(Tabla[V_RaizPot,T_Raiz],T_parentesisApertura);
        InsertarValorTAS(Tabla[V_RaizPot,T_Raiz],V_RaizPot);
        InsertarValorTAS(Tabla[V_RaizPot,T_Raiz],T_parentesisCierre);

//Pot
        Tabla[V_Pot,T_entonces].tam:=0;

        Tabla[V_Pot,T_parentesisCierre].tam:=0;

        Tabla[V_Pot,T_menos].tam:=0;

        Tabla[V_Pot,T_or].tam:=0;

        Tabla[V_Pot,T_and].tam:=0;

        Tabla[V_Pot,T_corcheteCierre].tam:=0;

        {Tabla[V_Pot,T_mayor].tam:=0;

        Tabla[V_Pot,T_menor].tam:=0;

        Tabla[V_Pot,T_mayorIgual].tam:=0;

        Tabla[V_Pot,T_menorIgual].tam:=0;

        Tabla[V_Pot,T_igual].tam:=0;

        Tabla[V_Pot,T_distinto].tam:=0;   }

        Tabla[V_Pot,T_mas].tam:=0;

        InsertarValorTAS(Tabla[V_Pot,T_potencia],T_potencia);
        InsertarValorTAS(Tabla[V_Pot,T_potencia],V_RaizPot);

        Tabla[V_Pot,T_division].tam:=0;

        Tabla[V_Pot,T_multiplicacion].tam:=0;

        Tabla[V_Pot,T_pyComa].tam:=0;

//MultDiv
        Tabla[V_MultDiv,T_entonces].tam:=0;

        Tabla[V_MultDiv,T_menos].tam:=0;

        Tabla[V_MultDiv,T_or].tam:=0;

        Tabla[V_MultDiv,T_and].tam:=0;

        Tabla[V_MultDiv,T_corcheteCierre].tam:=0;

        Tabla[V_MultDiv,T_parentesisCierre].tam:=0;  //AGREGADO

        {Tabla[V_MultDiv,T_mayor].tam:=0;

        Tabla[V_MultDiv,T_menor].tam:=0;

        Tabla[V_MultDiv,T_mayorIgual].tam:=0;

        Tabla[V_MultDiv,T_menorIgual].tam:=0;

        Tabla[V_MultDiv,T_igual].tam:=0;

        Tabla[V_MultDiv,T_distinto].tam:=0;}

        InsertarValorTAS(Tabla[V_MultDiv,T_division],T_division);
        InsertarValorTAS(Tabla[V_MultDiv,T_division],V_RaizPot);
        InsertarValorTAS(Tabla[V_MultDiv,T_division],V_MultDiv);

        InsertarValorTAS(Tabla[V_MultDiv,T_multiplicacion],T_multiplicacion);
        InsertarValorTAS(Tabla[V_MultDiv,T_multiplicacion],V_RaizPot);
        InsertarValorTAS(Tabla[V_MultDiv,T_multiplicacion],V_MultDiv);

        Tabla[V_MultDiv,T_mas].tam:=0;

        Tabla[V_MultDiv,T_pyComa].tam:=0;


  end;


procedure ProcedimientoAnalizadorSintactico(r : string; var raiz:T_Arbol_derivacion; var compilacion : boolean);
 type
  result = (procesando,exito,errorlex,errorsint);
 var
  tas1:TAS;
  pilasint:tpila;
  ComponenteLexico:simbolos;
  control:longint;
  Lexema:string;
  ts:T_Tabla;
  resultado:result;
  f:archivo;
  info:tdatop;
  i:byte;
  elemento:simbolos;
  arbol:T_Arbol_derivacion;
  hijo:T_Arbol_derivacion;
  simbolo:simbolos;
  puntero:T_Arbol_derivacion;
  aux1,aux2:T_Arbol_derivacion;
  aux:tpunterop;

begin
CrearTablaSimbolos(ts);
 CrearTAS(tas1);
 CrearPila(pilasint);
 info.x:=pesos;
 info.parbol:=nil;
 apilar(pilasint,info);
 info.x:=V_Cuerpo;
 crearArbol(raiz,V_Cuerpo);
 info.parbol:=raiz;
 apilar(pilasint,info);

 control:=0;
  assign(f,r);
 {$I-}
 reset(f);
 {$I+}
 if ioresult <> 0 then
 begin
  writeln('Hay un error en el archivo, intentelo de nuevo');
  compilacion:=false;
  readkey;

 end
    else
    begin

    ObtenerSiguienteComponenteLexico(f,control,ComponenteLexico,lexema,ts);

    writeln('Existe el archivo');

    resultado := procesando;
        while resultado = procesando do
        begin
        EliminarP(pilasint,info);
        if info.x in [T_inicio..T_division] then   //Se fija si está entre los terminales
        begin
          if info.x=ComponenteLexico then
           begin
             info.parbol^.lexema:=lexema;
            ObtenerSiguienteComponenteLexico(f,control,ComponenteLexico,lexema,ts);
           end
          else
          begin
             resultado:=errorsint;
             writeln('Error Sintactico, se esperaba: ',info.x,' y se obtuvo: ',ComponenteLexico);
             readkey;
          end;
        end
       else
       if info.x in [V_Cuerpo..V_MultDiv] then        //Se fija si es una variable en caso de no ser terminal
        begin
         if tas1[info.x,ComponenteLexico].tam=celdavacia then
           begin
           resultado:=errorsint;
           writeln('Error sintactico, desde ',info.x,' no se puede llegar a: ',ComponenteLexico);
           readkey;
           end
          else
           begin

           primero(tas1[info.x,ComponenteLexico]);
           while not finlista(tas1[info.x,ComponenteLexico]) do
            begin
              leeractual(tas1[info.x,ComponenteLexico],elemento);
              CrearArbol(hijo,elemento);
              AgregarHijo(info.parbol,hijo);
              siguiente(tas1[info.x,ComponenteLexico]);

            end;

           aux1:=info.parbol;
           for i:= aux1^.cant downto 1 do       //Apila producciones de variables
               begin
               aux2:=aux1^.hijos[i];
               info.x:=aux2^.simbolo;
               info.parbol:=aux2;
               apilar(pilasint,info);

               end;
           end;
        end
       else

       if (info.x=pesos) and (ComponenteLexico=pesos) then
        resultado:=exito;
   end;
  if resultado=exito then
   compilacion:=true
  else
   compilacion:=false;
 end;
 end;


end.
