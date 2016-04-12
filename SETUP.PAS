
uses crt;

type
    TCfg = record
                 nazwa : string[5];
                 opcja : byte;
           end;

var
   opcja : string;
   f : file of TCfg;
   c : TCfg;

begin
textcolor(7);
textbackground(0);
clrscr;
writeln('Wybierz opcje:');
writeln('0 - wyj˜cie');
writeln('1 - bez dzwi©k¢w');
writeln('2 - dzwi©ki');
writeln;
writeln('opcja: ');
repeat
      gotoxy(8,6);
      readln(opcja);
      clrscr;
      writeln('Wybierz opcje:');
      writeln('0 - wyj˜cie');
      writeln('1 - bez dzwi©k¢w');
      writeln('2 - dzwi©ki');
      writeln;
      writeln('opcja: ');
until (opcja='0')or(opcja='1')or(opcja='2');
if opcja='0' then
begin
writeln('Zmiany nie zostaˆy dokonane.');
exit;
end;
if opcja='1' then
begin
writeln('Mo¾esz teraz uruchomi† gr©!!!');
writeln('Gra bez dzwi©k¢w.');
c.nazwa:='SETUP';
c.opcja:=1;
assign(f,'data\setup.cfg');
rewrite(f);
write(f,c);
close(f);
exit;
end;
if opcja='2' then
begin
writeln('Mo¾esz teraz uruchomi† gr©!!!');
writeln('Gra z dzwi©kami.');
c.nazwa:='SETUP';
c.opcja:=2;
assign(f,'data\setup.cfg');
rewrite(f);
write(f,c);
close(f);
exit;
end;
end.