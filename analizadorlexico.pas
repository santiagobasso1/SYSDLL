unit AnalizadorLexico;

//{$codepage UTF8}
interface
uses Tipos,crt;
const
 finarchivo=#0;

procedure ObtenerSiguienteComponenteLexico(var fuente:archivo; var control:longint; var ComponenteLexico:simbolos; var lexema:string; ts:T_Tabla);

implementation

procedure leerCar(var fuente:archivo;var control:longint;var car:char);
    begin
    if control<filesize(fuente) then
     begin
      seek(fuente,control);
      read(fuente,car);
     end
    else
    begin
    car:=finarchivo;
    end;


end;


Function EsId(Var Fuente:Archivo;Var Control:Longint;Var Lexema:String):Boolean;
    Const
      q0=0;
      F=[3];
    Type
      Q=0..3;
      Sigma=(Letra, Digito, Otro);
      TipoDelta=Array[Q,Sigma] of Q;
    Var
      EstadoActual:Q;
      Delta:TipoDelta;
      P:Longint;
      Car:char;

       Function CarASimb(Car:Char):Sigma;
    Begin
      Case Car of
        'a'..'z', 'A'..'Z':CarASimb:=Letra;
        '0'..'9'	     :CarASimb:=Digito;
      else
       CarASimb:=Otro;
      End;
    End;

    Begin
      Delta[0,Letra]:=1;
      Delta[0,Digito]:=2;
      Delta[0,Otro]:=2;
      Delta[1,Digito]:=1;
      Delta[1,Letra]:=1;
      Delta[1,Otro]:=3;

      EstadoActual:=q0;
    P:=Control;
    Lexema:= '';
    While EstadoActual in [0..1] do
    begin
         LeerCar(Fuente,P,Car);
         EstadoActual:=Delta[EstadoActual,CarASimb(Car)];
         P:=P+1;
         If EstadoActual = 1 then
              Lexema:= Lexema + car;

    end;
         If EstadoActual in F then
              Control:= P-1;
         EsId:= EstadoActual in F
end;




Function EsConstReal(Var Fuente:Archivo;Var Control:Longint;Var Lexema:String):Boolean;
Const
  q0=0;
  F=[4];
Type
  Q=0..5;
  Sigma=(Digito, coma , Otro);
  TipoDelta=Array[Q,Sigma] of Q;
Var
  P: Longint;
  Car: Char;
  EstadoActual:Q;
  Delta:TipoDelta;

   Function CarASimb(Car:Char):Sigma;
  Begin
    Case Car of
         '0'..'9':CarASimb:=Digito;
         '.' : CarASimb:=Coma;
    else
     CarASimb:= Otro;
    End;
  End;

  Begin

    Delta[0,Coma]:=3;
    Delta[0,Digito]:=1;
    Delta[0,Otro]:=3;

    Delta[1,Coma]:=2;
    Delta[1,Digito]:=1;
    Delta[1,Otro]:=4;

    Delta[2,Coma]:=3;
    Delta[2,Digito]:=5;
    Delta[2,Otro]:=3;

    Delta[5,Coma]:=3;
    Delta[5,Digito]:=5;
    Delta[5,Otro]:=4;

    EstadoActual:=q0;
  P:=Control;
  Lexema:= '';
  While EstadoActual in [0,1,2,5] do
  begin
       LeerCar(Fuente,P,Car);
       EstadoActual:=Delta[EstadoActual,CarASimb(Car)];
       P:=P+1;
       If EstadoActual in [0,1,2,5] then
            Lexema:= Lexema + car;
  end;
       If EstadoActual in F then
            Control:= P-1;
       EsConstReal:= EstadoActual in F
end;


Function EsConstCadena(Var Fuente: Archivo ; Var Control: Longint ; Var Lexema: String): Boolean;
    Const
         q0=0;
         F=[4];
    Type
        Q=0..4;
        Sigma=(Letra, Digito, comilla ,  Otro);
        TipoDelta=Array[Q,Sigma] of Q;
    Var
       EstadoActual:Q;
       Delta:TipoDelta;
       P: Longint;
       Car: Char;
       anterior:Q;

       Function CarASimb(car:char):Sigma;
       begin

         Case Car of
           'a'..'z', 'A'..'Z':CarASimb:=Letra;
           '0'..'9':CarASimb:=Digito;
           '"' : CarASimb:= comilla;
         else
          CarASimb:=Otro;
         end;
         end;
    Begin
        Delta[0,Letra]:=2;
        Delta[0,Digito]:=2;
        Delta[0,Otro]:=2;
        Delta[0,comilla]:=1;

        Delta[1,Letra]:=1;
        Delta[1,Digito]:=1;
        Delta[1,Comilla]:=3;
        Delta[1,Otro]:=1;

        Delta[3,Letra]:=2;
        Delta[3,Digito]:=2;
        Delta[3,Otro]:=4;
        Delta[3,Comilla]:=2;

    EstadoActual:=q0;
    P:=Control;
    Lexema:= '';
    anterior:=q0;
    While EstadoActual in [0,1,3] do
    begin

         LeerCar(Fuente,P,Car);
         EstadoActual:=Delta[EstadoActual,CarASimb(Car)];
         P:=P+1;
         If (EstadoActual in [0,1,3]) and (car <> '"') then
              Lexema:= Lexema + car;

    end;
    If EstadoActual in F then
    begin
         Control:= P;
    end;
    EsConstCadena:=EstadoActual in F;

end;
Function EssimboloEspecial(Var Fuente:archivo;Var Control:Longint; var ComponenteLexico:simbolos; Var Lexema:String):Boolean;
    var
       car:char;
    begin

    leercar(fuente,control,car);
    if car in ['=',',','(',')','[',']',';','>','<','+','-','*','/','^','&','~','|',':'] then
    begin
    essimboloespecial:=true;
    case car of
      ':':begin inc(control);
                leercar(fuente,control,car);
                if car = '=' then
                begin
                     lexema:=':=';
                     ComponenteLexico:=T_opAsig;
                     inc(control);
                end;

          end;
    {  '=': begin
                 ComponenteLexico:=T_Igual;
                 inc(control);
                 end;  }
      ';':begin
            inc(control);
            lexema:=';';
            ComponenteLexico:=T_pyComa;
            end;

      ',': begin
                 ComponenteLexico:=T_Coma;
                 inc(control);
                 end;
      '(': begin
                 ComponenteLexico:=T_parentesisApertura;
                 inc(control);
                 end;
      ')': begin
                 ComponenteLexico:= T_parentesisCierre;
                 inc(control);
                 end;
      {'>': begin inc(control);
                leercar(fuente,control,car);
                if car = '=' then
                begin
                     lexema:='>=';
                     ComponenteLexico:=T_mayorIgual;
                     inc(control);
                end
                else
                begin
                lexema:='>';
                ComponenteLexico:=T_Mayor;
                end;
          end;  }
     { '<': begin inc(control);
                leercar(fuente,control,car);
                if car = '=' then
                begin
                     lexema:='<=';
                     ComponenteLexico:=T_menorIgual;
                     inc(control);
                end
                else
                begin
                lexema:='<';
                ComponenteLexico:=T_Menor;
                end;
          end; }
      '+': begin
                 ComponenteLexico:= T_Mas;
                 inc(control);
                 end;
      '-': begin
                 ComponenteLexico:= T_Menos;
                 inc(control);
                 end;
      '*': begin
                 ComponenteLexico:=T_multiplicacion;
                 inc(control);
                 end;
      '/': begin
                 ComponenteLexico:=T_division;
                 inc(control);
                 end;
      '^': begin
                 ComponenteLexico:=T_Potencia;
                 inc(control);
                 end;
      {'&': begin
                 ComponenteLexico:=T_AND;
                 inc(control);
                 end;}
    {  '~': begin
                 ComponenteLexico:=T_NOT;
                 inc(control);
                 end;   }
    {  '|': begin
                 ComponenteLexico:=T_OR;
                 inc(control);
                 end; }
      '[': begin
                 ComponenteLexico:=T_corcheteApertura;
                 inc(control);
                 end;
      ']': begin
                 ComponenteLexico:=T_corcheteCierre;
                 inc(control);
                 end;
      end;
    end
    else
     essimboloespecial:=false;


end;

procedure ObtenerSiguienteComponenteLexico(var fuente:archivo; var control:longint; var ComponenteLexico:simbolos; var lexema:string; ts:T_Tabla);

    var
    caracter:char;

    begin
      leercar(fuente,control,caracter);
      while caracter in [#1..#32] do
      begin
        inc(control);
        leercar(fuente,control,caracter);
      end;
      if caracter=finarchivo then
      begin
        ComponenteLexico:=pesos
      end
      else
      begin
        if esid(fuente,control,lexema) then
        begin
          BuscarEnTabla(ts,lexema,ComponenteLexico);
        end
        else
        begin
          if EsConstReal(fuente,control,lexema) then
          begin
            ComponenteLexico:=T_const;
          end
          else
          if esconstcadena(fuente,control,lexema) then
            begin
              ComponenteLexico:=T_Cadena;
            end
            else if not EsSimboloEspecial(Fuente,Control,ComponenteLexico,Lexema) then
            begin
                ComponenteLexico:=Error;
                writeln('no es nada');
                readkey;
            end;
        end;
    end;
end;


END.












