unit Pantallas;

//{$codepage UTF8}
interface

Uses crt;

Var n,p:string;
    compilacion:boolean;

Procedure pantallaIngreseNombre;
Procedure pantalla2(n:string; r:string; compilacion:boolean);
procedure Mensaje(U,U1:byte;msj:string);
procedure Color(T,F:byte);

procedure recuadroInicio;
procedure recuadroFinal;

implementation

procedure Color(T,F:byte);
 begin
     Textcolor(T);
     Textbackground(F);
 end;

procedure Mensaje(U,U1:byte;msj:string);
 begin
     gotoxy(U,U1);
     write(msj);
 end;

Procedure pantallaIngreseNombre;
 begin
     TextColor(green);
     Mensaje(40,13,'Escriba el nombre del programa:');
     TextColor(white);
 end;

Procedure ruta;
 begin
     gotoxy(70,4);
     readln(n);
     gotoxy(70,7);
     readln(p);
 end;

Procedure pantalla2(n:string; r:string; compilacion:boolean);
 begin
     color(white,black);
     Mensaje(40,9,'Programa: ');
     Mensaje(50,9,n);
 end;



procedure recuadroInicio;
 Var
   i:byte;
   x:byte;
Begin
    x:=40;
textcolor(white);
gotoxy(x,1);
Writeln('   ____ _          ____           ');
gotoxy(x,2);
Writeln('  / ___| |__   ___|  _ \ __ _ ___ ');
gotoxy(x,3);
Writeln(' | |   | `_ \ / _ \ |_) / _` / __|');
gotoxy(x,4);
Writeln(' | |___| | | |  __/  __/ (_| \__ \');
gotoxy(x,5);
Writeln('  \____|_| |_|\___|_|   \__,_|___/');
for i:=8 to 20 do
    begin
    gotoxy(30,i); write('|');
    gotoxy(88,i); write('|');
    end;
for i:=31 to 87 do
    begin
    gotoxy(i,7);write('_');
    gotoxy(i,20); Write('_');
    end;
gotoxy(35,7);
write('Basso Bentancour Dalcol Haffner Wulfsohn');
 end;


procedure recuadroFinal;
 Var
   i:byte;
Begin
clrscr;
textcolor(white);
for i:=8 to 20 do
    begin
    gotoxy(30,i); write('|');
    gotoxy(88,i); write('|');
    end;
for i:=31 to 87 do
    begin
    gotoxy(i,7);write('_');
    gotoxy(i,20); Write('_');
    end;
if compilacion=true then
    begin
     TextColor(Green);
     Mensaje(44,13,'  ____ ____ ____ ____ ____ ');
     Mensaje(44,14,' ||E |||X |||I |||T |||0 ||');
     Mensaje(44,15,' ||__|||__|||__|||__|||__||');
     Mensaje(44,16,' |/__\|/__\|/__\|/__\|/__\|');
     TextColor(white);
    end
else
    begin
     TextColor(Red);
     Mensaje(44,13,'  ____ ____ ____ ____ ____ ');
     Mensaje(44,14,' ||E |||R |||R |||0 |||R ||');
     Mensaje(44,15,' ||__|||__|||__|||__|||__||');
     Mensaje(44,16,' |/__\|/__\|/__\|/__\|/__\|');
     TextColor(White);
    end;
gotoxy(35,7);
write('Basso Bentancour Dalcol Haffner Wulfsohn');
 end;


END.

