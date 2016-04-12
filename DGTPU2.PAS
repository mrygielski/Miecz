
unit dgtpu2;

interface

uses supergfx, dgtpu, load_snd, games, dos;

var
   ffff : boolean;

procedure walka;
procedure pokaz_skrzynie_map_sound(x, y : integer);
procedure in_room;
procedure badaj_czy_nie_dostales_next_level;
procedure zamaluj_ekran;
procedure odmaluj_ekran;
procedure found_sword;
procedure gra;
procedure spanie(ile : byte);
procedure spanie_dom(ile : byte; zyc : byte);
procedure odejmij_zmeczenie;
procedure odejmij_zmeczenie_room;
procedure loadg;
procedure menu_w_grze1;
procedure menu_w_grze2;
procedure badaj_czy_walka(x, y : integer);

implementation

procedure walka;
const
     ile_wrog = 22;
     ile_przeciwnikow = 5;

type
    Twrog_walka = record
                        nazwa : string[10];
                        zycie, maxzycie : integer;
                        sila : integer;
                        ile : integer;
                        zrecznosc : integer;
                  end;
    TEkran = array[0..319, 0..199] of byte;
    Twrog = array[1..60, 1..80] of byte;

var
   losd : integer;
   farena : file of TEkran;
   arena : ^TEkran;
   wrog : array[1..ile_wrog] of ^Twrog;
   wrogowie : array[1..ile_przeciwnikow] of Twrog_walka;
   i : integer;
   nr_przeciwnika : byte;
   tmp, tura, tmp2, turawroga : integer;
   niematury, niematurywroga : boolean;
   trup : array[1..2] of boolean;
   end_ : byte;

procedure atakuj_wrogiem(nr : byte); forward;
procedure gracz_atak; forward;
procedure gracz_atak_bron; forward;
procedure gracz_atak_magia; forward;
procedure ataki; forward;

procedure load_arena_to_memory(name : string);
begin
     assign(farena,name);
     reset(farena);
     read(farena,arena^);
     close(farena);
end;

procedure draw_arena;
var
   i, j : integer;
begin
     for i:= 0 to 319 do
     for j:= 0 to 199 do putpixel(i,j,arena^[i,j])
end;

procedure load_wrog_to_memory;

var
   f : file of Twrog;
   ile : byte;

procedure load_stone(path, name : string);
begin
     inc(ile);
     assign(f,path+name);
     reset(f);
     read(f,wrog[ile]^);
     close(f);
end;

begin
     ile:=0;
     load_stone('graphics\','lud1');
     load_stone('graphics\','lud2');
     load_stone('graphics\','lud3');
     load_stone('graphics\','lud4bb');
     load_stone('graphics\','lud5bb');
     load_stone('graphics\','lud6bb');
     load_stone('graphics\','lud7bb');
     load_stone('graphics\','wrog1');
     load_stone('graphics\','wrog2');
     load_stone('graphics\','wrog3');
     load_stone('graphics\','wrog1a');
     load_stone('graphics\','wrog2a');
     load_stone('graphics\','wrog3a');
     load_stone('graphics\','wrog1b');
     load_stone('graphics\','wrog2b');
     load_stone('graphics\','wrog3b');
     load_stone('graphics\','wrog1c');
     load_stone('graphics\','wrog2c');
     load_stone('graphics\','wrog3c');
     load_stone('graphics\','bos1');
     load_stone('graphics\','bos3');
     load_stone('graphics\','bos2');
end;

procedure draw_wrog(x, y : integer; nr : byte);
var
   i, j : integer;
begin
     for i:= 1 to 60 do
     for j:= 1 to 80 do if wrog[nr]^[i,j]<>52 then putpixel(i+x+1,j+y+2,wrog[nr]^[i,j])
end;

procedure pokaz_zycie_procent(x, y, zycie, maxzycie : integer; nazwa : string);
var
   procent : integer;
begin
     if zycie>0 then
     begin
     outtextfntxy2_center(x+70,59,3,220,1,1,nazwa,font^);
     outtextfntxy2_center(x+70,60,3,219,1,1,nazwa,font^);
     procent:=(zycie * 60 div maxzycie)-1;
     bar(x+41+procent,71,x+99,74,220);
     bar(x+41,71,x+41+procent,74,254);
     rectangle(x+40,70,x+100,75,219);
     end else
     begin
     outtextfntxy2_center(x+70,59,3,220,1,1,nazwa,font^);
     outtextfntxy2_center(x+70,60,3,219,1,1,nazwa,font^);
     bar(x+41,71,x+99,74,220);
     rectangle(x+40,70,x+100,75,219);
     end;
end;

procedure wylosoj_przeciwnika1;
var
   los : integer;
begin
     los:=random(2)+1;
     nr_przeciwnika:=los;
     if los=1 then
     begin
          wrogowie[1].nazwa:='GREMLIN';
          wrogowie[1].zycie:=20;
          wrogowie[1].maxzycie:=20;
          wrogowie[1].sila:=5;
          wrogowie[1].ile:=25;
          wrogowie[1].zrecznosc:=3;
     end;
     if los=2 then
     begin
          wrogowie[2].nazwa:='DUCH';
          wrogowie[2].zycie:=30;
          wrogowie[2].maxzycie:=30;
          wrogowie[2].sila:=3;
          wrogowie[2].ile:=23;
          wrogowie[2].zrecznosc:=2;
     end;
end;

procedure wylosoj_przeciwnika2;
var
   los : integer;
begin
     los:=random(3)+1;
     nr_przeciwnika:=los;
     if los=1 then
     begin
          wrogowie[1].nazwa:='GREMLIN';
          wrogowie[1].zycie:=20;
          wrogowie[1].maxzycie:=20;
          wrogowie[1].sila:=5;
          wrogowie[1].ile:=25;
          wrogowie[1].zrecznosc:=3;
     end;
     if los=2 then
     begin
          wrogowie[2].nazwa:='DUCH';
          wrogowie[2].zycie:=30;
          wrogowie[2].maxzycie:=30;
          wrogowie[2].sila:=3;
          wrogowie[2].ile:=23;
          wrogowie[2].zrecznosc:=2;
     end;
     if los=3 then
     begin
          wrogowie[3].nazwa:='MINOTAUR';
          wrogowie[3].zycie:=70;
          wrogowie[3].maxzycie:=70;
          wrogowie[3].sila:=25;
          wrogowie[3].ile:=28;
          wrogowie[3].zrecznosc:=4;
     end;
end;

procedure wylosoj_przeciwnika3;
var
   los : integer;
begin
     los:=random(4)+1;
     nr_przeciwnika:=los;
     if los=1 then
     begin
          wrogowie[1].nazwa:='GREMLIN';
          wrogowie[1].zycie:=20;
          wrogowie[1].maxzycie:=20;
          wrogowie[1].sila:=5;
          wrogowie[1].ile:=25;
          wrogowie[1].zrecznosc:=3;
     end;
     if los=2 then
     begin
          wrogowie[2].nazwa:='DUCH';
          wrogowie[2].zycie:=30;
          wrogowie[2].maxzycie:=30;
          wrogowie[2].sila:=3;
          wrogowie[2].ile:=23;
          wrogowie[2].zrecznosc:=2;
     end;
     if los=3 then
     begin
          wrogowie[3].nazwa:='MINOTAUR';
          wrogowie[3].zycie:=80;
          wrogowie[3].maxzycie:=80;
          wrogowie[3].sila:=35;
          wrogowie[3].ile:=28;
          wrogowie[3].zrecznosc:=4;
     end;
     if los=4 then
     begin
          wrogowie[4].nazwa:='CYKLOP';
          wrogowie[4].zycie:=100;
          wrogowie[4].maxzycie:=100;
          wrogowie[4].sila:=47;
          wrogowie[4].ile:=33;
          wrogowie[4].zrecznosc:=6;
     end;
     if los=5 then
     begin
          wrogowie[5].nazwa:='WAMPIR';
          wrogowie[5].zycie:=130;
          wrogowie[5].maxzycie:=130;
          wrogowie[5].sila:=55;
          wrogowie[5].ile:=37;
          wrogowie[5].zrecznosc:=6;
     end;
end;

procedure oczekiwanie_na_ture;
begin
     if niematury then
     begin
     tmp:=tmp+1;
     if tmp=20 then
     begin
     tura:=tura+1;
     outtextfntxy2(275,183,3,14,1,1,'TURA',font^);
     bar(250,190,317,196,11);
     rectangle(250,190,317,196,1);
     bar(251,191,251+tura,195,9);
{     line(251,192,251+tura,192,9);
     line(251,193,251+tura,193,9);
     line(251,194,251+tura,194,9);
     line(251,195,251+tura,195,9);}
     if tura=65 then begin niematury:=false; end;
     tmp:=0;
     end;
     end else
     begin
     outtextfntxy2(275,183,3,14,1,1,'TURA',font^);
     bar(250,190,317,196,11);
     rectangle(250,190,317,196,1);
     bar(251,191,251+tura,195,9);
     end;
end;

procedure oczekiwanie_na_ture_wroga(ile : integer);
begin
     if niematurywroga then
     begin
     tmp2:=tmp2+1;
     if tmp2=30 then
     begin
     turawroga:=turawroga+1;
     if turawroga=ile then
     begin
          atakuj_wrogiem(nr_przeciwnika);
          niematurywroga:=true;
          turawroga:=0;
          randomize;
          end_:=random(10);
     end;
     tmp2:=0;
     end;
     end;
end;

procedure pokaz_statusy;
begin
bar(0,179,319,199,220);
rectangle(0,179,319,199,219);
if zyciemin>0 then
outtextfntxy2(3,183,3,14,1,1,'ΩYCIE: '+numstr(zyciemin)+'/'+numstr(zycietmp),font^)
else
outtextfntxy2(3,183,3,14,1,1,'ΩYCIE: 0/'+numstr(zycietmp),font^);

bar(125,181,170,189,222);
rectangle(125,181,170,189,219);
outtextfntxy2(124,182,3,14,1,1,'    ATAK',font^);
if not czy_gracz_ma_bron then
begin
bar(80,181,125,189,4);
rectangle(80,181,125,189,219);
outtextfntxy2(81,182,3,12,1,1,'ATAK BRONI§',font^);
end else
begin
bar(80,181,125,189,222);
rectangle(80,181,125,189,219);
outtextfntxy2(81,182,3,14,1,1,'ATAK BRONI§',font^);
end;
if plecak[2]=ile_items then
begin
bar(80,189,125,197,4);
rectangle(80,189,125,197,219);
outtextfntxy2(83,190,3,12,1,1,'ATAK MAGI§',font^);
end else
begin
bar(80,189,125,197,222);
rectangle(80,189,125,197,219);
outtextfntxy2(83,190,3,14,1,1,'ATAK MAGI§',font^);
end;
     outtextfntxy2(275,183,3,14,1,1,'TURA',font^);
     bar(250,190,317,196,11);
     rectangle(250,190,317,196,1);
     bar(251,191,251+tura,195,9);
end;

procedure ataki;
begin
if mousein(mmx,mmy,125,181,170,189)and leftbutton then
begin
gracz_atak;
niematury:=true; tura:=0;
end;


{atak bronia - begin}
if not czy_gracz_ma_bron then
begin
end else
begin
if mousein(mmx,mmy,80,181,125,189)and leftbutton then
begin
gracz_atak_bron;
niematury:=true; tura:=0;
end;
end;
{atak bronia - end}
if plecak[2]=ile_items then
begin
end else
begin
if mousein(mmx,mmy,80,189,125,197)and leftbutton then
begin
gracz_atak_magia;
niematury:=true; tura:=0;
end;
end;
end;

procedure ustaw_wroga(nr : byte);
begin
     if nr=1 then draw_wrog(40,80,8);
     if nr=2 then draw_wrog(40,80,11);
     if nr=3 then draw_wrog(40,80,14);
     if nr=4 then draw_wrog(40,80,17);
     if nr=5 then draw_wrog(40,80,20);
end;

procedure atakuj_wrogiem(nr : byte);
var
   los, od : byte;
procedure odejmij(o1 : integer);
begin
     od:=random(o1)+1;
     od:=3+od;
     outtextfntxy2(255,105,3,14,1,1,'-'+numstr(od),font^);
     zyciemin:=zyciemin-(od-round(ile_procent_z(round(obrona),round(od))));
end;
begin
          draw_arena;
          if nr_przeciwnika=1 then draw_wrog(40,80,9);
          if nr_przeciwnika=2 then draw_wrog(40,80,12);
          if nr_przeciwnika=3 then draw_wrog(40,80,15);
          if nr_przeciwnika=4 then draw_wrog(40,80,18);
          if nr_przeciwnika=5 then draw_wrog(40,80,21);
          pokaz_statusy;
          if czy_gracz_ma_bron then draw_wrog(230,80,4) else draw_wrog(230,80,1);
          pokaz_zycie_procent(0,0,wrogowie[nr_przeciwnika].zycie,wrogowie[nr_przeciwnika].maxzycie,
          wrogowie[nr_przeciwnika].nazwa);
          pokaz_zycie_procent(190,0,zyciemin,zycietmp,'KAROL');
          outtextxy(250,120,1,1,39,'*',false);
          outtextxy(255,123,1,1,254,'*',false);
          outtextxy(249,124,1,1,40,'*',false);
          if sounds then play_sound(tempsound[1],sound[1],11000);
          pokazgrafike2;
          delay(300);
          randomize;
          los:=random(7)+1;
          if los=1 then begin outtextfntxy2(255,105,3,14,1,1,'MISS',font^);end;
          if los=2 then begin odejmij(wrogowie[nr_przeciwnika].sila); end;
          if los=3 then begin odejmij(wrogowie[nr_przeciwnika].sila); end;
          if los=4 then begin odejmij(wrogowie[nr_przeciwnika].sila); end;
          if los=5 then begin odejmij(wrogowie[nr_przeciwnika].sila); end;
          if los=6 then begin odejmij(wrogowie[nr_przeciwnika].sila); end;
          if los=7 then begin odejmij(wrogowie[nr_przeciwnika].sila); end;
          pokazgrafike2;
          delay(700);
          draw_arena;
          if nr_przeciwnika=1 then draw_wrog(40,80,8);
          if nr_przeciwnika=2 then draw_wrog(40,80,11);
          if nr_przeciwnika=3 then draw_wrog(40,80,14);
          if nr_przeciwnika=4 then draw_wrog(40,80,17);
          if nr_przeciwnika=5 then draw_wrog(40,80,20);
          pokaz_statusy;
     if (zyciemin<=0)then {gracz przegral}
     begin
          draw_arena;
          pokaz_statusy;
          if nr_przeciwnika=1 then draw_wrog(40,80,8);
          if nr_przeciwnika=2 then draw_wrog(40,80,11);
          if nr_przeciwnika=3 then draw_wrog(40,80,14);
          if nr_przeciwnika=4 then draw_wrog(40,80,17);
          if nr_przeciwnika=5 then draw_wrog(40,80,20);
          if czy_gracz_ma_bron then draw_wrog(230,80,3) else draw_wrog(230,80,7);
          pokaz_zycie_procent(0,0,wrogowie[nr_przeciwnika].zycie,wrogowie[nr_przeciwnika].maxzycie,
          wrogowie[nr_przeciwnika].nazwa);
          pokaz_zycie_procent(190,0,zyciemin,zycietmp,'KAROL');
          pokazgrafike2;
          delay(800);
          trup[2]:=true;{enemy}
          zyciemin:=1;
     end else if czy_gracz_ma_bron then draw_wrog(230,80,4) else draw_wrog(230,80,1);

          pokaz_zycie_procent(0,0,wrogowie[nr_przeciwnika].zycie,wrogowie[nr_przeciwnika].maxzycie,
          wrogowie[nr_przeciwnika].nazwa);
          pokaz_zycie_procent(190,0,zyciemin,zycietmp,'KAROL');
          pokazgrafike2;
end;
procedure gracz_atak_bron;
var
   los, od, od2 : byte;
procedure odejmij;
begin
{     od2:=random(10)+1;
     od:=atak+items_typ[plecak[5]].atak+random(5)+1;
     wrogowie[nr_przeciwnika].zycie:=wrogowie[nr_przeciwnika].zycie-od div 2;}
{     od2:=random(7)+1;
     od:=(atak+items_typ[plecak[5]].atak)+od2;
     wrogowie[nr_przeciwnika].zycie:=wrogowie[nr_przeciwnika].zycie-od div 2;}
     randomize;
     od2:=random(7)+1;
     od:=(atak+items_typ[plecak[5]].atak)+od2;
     wrogowie[nr_przeciwnika].zycie:=wrogowie[nr_przeciwnika].zycie-od div 2;
end;
var ls : byte;
begin
     draw_arena;
     if nr_przeciwnika=1 then draw_wrog(40,80,8);
     if nr_przeciwnika=2 then draw_wrog(40,80,11);
     if nr_przeciwnika=3 then draw_wrog(40,80,14);
     if nr_przeciwnika=4 then draw_wrog(40,80,17);
     if nr_przeciwnika=5 then draw_wrog(40,80,20);
     randomize;
     ls:=random(5)+1;
     if (ls=1) and sounds then play_sound(tempsound[1],sound[1],11000);
     if (ls=2) and sounds then play_sound(tempsound[2],sound[2],11000);
     if (ls=3) and sounds then play_sound(tempsound[1],sound[1],11000);
     if (ls=4) and sounds then play_sound(tempsound[2],sound[2],11000);
     if (ls=5) and sounds then play_sound(tempsound[2],sound[2],11000);
     pokaz_statusy;
     draw_wrog(230,80,7);
     pokaz_zycie_procent(0,0,wrogowie[nr_przeciwnika].zycie,wrogowie[nr_przeciwnika].maxzycie,
     wrogowie[nr_przeciwnika].nazwa);
     pokaz_zycie_procent(190,0,zyciemin,zycietmp,'KAROL');
     line(75+random(5),85,57+random(10),143,25);
     pokazgrafike2;
     delay(200);
     randomize;
     los:=random(7)+1;
     if zrecznosc in[0..7] then
     begin
     if los=1 then begin outtextfntxy2(42,105,3,14,1,1,'MISS',font^); end;
     end else begin odejmij; outtextfntxy2(72,118,3,14,1,1,'-'+numstr(od),font^); end;
     if los=2 then begin odejmij; outtextfntxy2(72,118,3,14,1,1,'-'+numstr(od),font^); end;
     if los=3 then begin odejmij; outtextfntxy2(72,118,3,14,1,1,'-'+numstr(od),font^); end;
     if los=4 then begin odejmij; outtextfntxy2(72,118,3,14,1,1,'-'+numstr(od),font^); end;
     if los=5 then begin odejmij; outtextfntxy2(72,118,3,14,1,1,'-'+numstr(od),font^); end;
     if los=6 then begin odejmij; outtextfntxy2(72,118,3,14,1,1,'-'+numstr(od),font^); end;
     if los=7 then begin odejmij; outtextfntxy2(72,118,3,14,1,1,'-'+numstr(od),font^); end;
     pokazgrafike2;
     delay(700);
     draw_arena;
     pokaz_statusy;
     if (wrogowie[nr_przeciwnika].zycie<=0)then
     begin
          draw_arena;
          pokaz_statusy;
          if nr_przeciwnika=1 then draw_wrog(40,80,10);
          if nr_przeciwnika=2 then draw_wrog(40,80,13);
          if nr_przeciwnika=3 then draw_wrog(40,80,16);
          if nr_przeciwnika=4 then draw_wrog(40,80,19);
          if nr_przeciwnika=5 then draw_wrog(40,80,22);
          if czy_gracz_ma_bron then draw_wrog(230,80,4) else draw_wrog(230,80,1);
          pokaz_zycie_procent(0,0,wrogowie[nr_przeciwnika].zycie,wrogowie[nr_przeciwnika].maxzycie,
          wrogowie[nr_przeciwnika].nazwa);
          pokaz_zycie_procent(190,0,zyciemin,zycietmp,'KAROL');
          pokazgrafike2;
          delay(800);
          last_killed:=wrogowie[nr_przeciwnika].nazwa;
          ile_killed:=ile_killed+1;
          trup[1]:=true;{enemy}
          kasa:=kasa+(10+random(30));
     end else
     begin
     if nr_przeciwnika=1 then draw_wrog(40,80,8);
     if nr_przeciwnika=2 then draw_wrog(40,80,11);
     if nr_przeciwnika=3 then draw_wrog(40,80,14);
     if nr_przeciwnika=4 then draw_wrog(40,80,17);
     if nr_przeciwnika=5 then draw_wrog(40,80,20);
     end;
     draw_wrog(230,80,4);
     pokaz_zycie_procent(0,0,wrogowie[nr_przeciwnika].zycie,wrogowie[nr_przeciwnika].maxzycie,
     wrogowie[nr_przeciwnika].nazwa);
     pokaz_zycie_procent(190,0,zyciemin,zycietmp,'KAROL');
     pokazgrafike2;
end;
procedure gracz_atak_magia;
var
   los, od, od2 : byte;
procedure odejmij;
begin
     od2:=random(12)+1;
     od:=(atak div 2)+od2;
     wrogowie[nr_przeciwnika].zycie:=wrogowie[nr_przeciwnika].zycie-od div 2;
end;
begin
     draw_arena;
     if nr_przeciwnika=1 then draw_wrog(40,80,8);
     if nr_przeciwnika=2 then draw_wrog(40,80,11);
     if nr_przeciwnika=3 then draw_wrog(40,80,14);
     if nr_przeciwnika=4 then draw_wrog(40,80,17);
     if nr_przeciwnika=5 then draw_wrog(40,80,20);
     pokaz_statusy;
     if plecak[5]=ile_items then draw_wrog(230,80,2) else draw_wrog(230,80,5);
     pokaz_zycie_procent(0,0,wrogowie[nr_przeciwnika].zycie,wrogowie[nr_przeciwnika].maxzycie,
     wrogowie[nr_przeciwnika].nazwa);
     pokaz_zycie_procent(190,0,zyciemin,zycietmp,'KAROL');
     line(75+random(5),85,57+random(10),143,25);
     if sounds then play_sound(tempsound[3],sound[3],11000);
     pokazgrafike2;
     delay(200);
     randomize;
     los:=random(7)+1;
     if zrecznosc in[0..7] then
     begin
     if los=1 then begin outtextfntxy2(42,105,3,14,1,1,'MISS',font^); end;
     end else begin odejmij; outtextfntxy2(72,118,3,14,1,1,'-'+numstr(od),font^); end;
     if los=2 then begin odejmij; outtextfntxy2(72,118,3,14,1,1,'-'+numstr(od),font^); end;
     if los=3 then begin odejmij; outtextfntxy2(72,118,3,14,1,1,'-'+numstr(od),font^); end;
     if los=4 then begin odejmij; outtextfntxy2(72,118,3,14,1,1,'-'+numstr(od),font^); end;
     if los=5 then begin odejmij; outtextfntxy2(72,118,3,14,1,1,'-'+numstr(od),font^); end;
     if los=6 then begin odejmij; outtextfntxy2(72,118,3,14,1,1,'-'+numstr(od),font^); end;
     if los=7 then begin odejmij; outtextfntxy2(72,118,3,14,1,1,'-'+numstr(od),font^); end;
     pokazgrafike2;
     delay(700);
     draw_arena;
     pokaz_statusy;
     if (wrogowie[nr_przeciwnika].zycie<=0)then
     begin
          draw_arena;
          pokaz_statusy;
          if nr_przeciwnika=1 then draw_wrog(40,80,10);
          if nr_przeciwnika=2 then draw_wrog(40,80,13);
          if nr_przeciwnika=3 then draw_wrog(40,80,16);
          if nr_przeciwnika=4 then draw_wrog(40,80,19);
          if nr_przeciwnika=5 then draw_wrog(40,80,22);
          if czy_gracz_ma_bron then draw_wrog(230,80,4) else draw_wrog(230,80,1);
          pokaz_zycie_procent(0,0,wrogowie[nr_przeciwnika].zycie,wrogowie[nr_przeciwnika].maxzycie,
          wrogowie[nr_przeciwnika].nazwa);
          pokaz_zycie_procent(190,0,zyciemin,zycietmp,'KAROL');
          pokazgrafike2;
          delay(800);
          last_killed:=wrogowie[nr_przeciwnika].nazwa;
          ile_killed:=ile_killed+1;
          trup[1]:=true;{enemy}
          kasa:=kasa+(10+random(30));
     end else
     begin
     if nr_przeciwnika=1 then draw_wrog(40,80,8);
     if nr_przeciwnika=2 then draw_wrog(40,80,11);
     if nr_przeciwnika=3 then draw_wrog(40,80,14);
     if nr_przeciwnika=4 then draw_wrog(40,80,17);
     if nr_przeciwnika=5 then draw_wrog(40,80,20);
     end;
     if plecak[5]=ile_items then draw_wrog(230,80,1) else draw_wrog(230,80,5);
     pokaz_zycie_procent(0,0,wrogowie[nr_przeciwnika].zycie,wrogowie[nr_przeciwnika].maxzycie,
     wrogowie[nr_przeciwnika].nazwa);
     pokaz_zycie_procent(190,0,zyciemin,zycietmp,'KAROL');
     pokazgrafike2;
end;
procedure gracz_atak;
var
   los, od, od2 : byte;
procedure odejmij;
begin
     od2:=random(7)+1;
     od:=((atak div 2)+od2);
     wrogowie[nr_przeciwnika].zycie:=(wrogowie[nr_przeciwnika].zycie-(od div 2));
end;
begin
     draw_arena;
     if nr_przeciwnika=1 then draw_wrog(40,80,8);
     if nr_przeciwnika=2 then draw_wrog(40,80,11);
     if nr_przeciwnika=3 then draw_wrog(40,80,14);
     if nr_przeciwnika=4 then draw_wrog(40,80,17);
     if nr_przeciwnika=5 then draw_wrog(40,80,20);
     pokaz_statusy;
     if czy_gracz_ma_bron then draw_wrog(230,80,4) else draw_wrog(230,80,1);
     pokaz_zycie_procent(0,0,wrogowie[nr_przeciwnika].zycie,wrogowie[nr_przeciwnika].maxzycie,
     wrogowie[nr_przeciwnika].nazwa);
     pokaz_zycie_procent(190,0,zyciemin,zycietmp,'KAROL');
     line(75+random(5),85,57+random(10),143,25);
     if sounds then play_sound(tempsound[1],sound[1],18000);
     pokazgrafike2;
     delay(200);
     randomize;
     los:=random(7)+1;
     if zrecznosc in[0..7] then
     begin
     if los=1 then begin outtextfntxy2(42,105,3,14,1,1,'MISS',font^); end;
     end else begin odejmij; outtextfntxy2(72,118,3,14,1,1,'-'+numstr(od),font^); end;
     if los=2 then begin odejmij; outtextfntxy2(72,118,3,14,1,1,'-'+numstr(od),font^); end;
     if los=3 then begin odejmij; outtextfntxy2(72,118,3,14,1,1,'-'+numstr(od),font^); end;
     if los=4 then begin odejmij; outtextfntxy2(72,118,3,14,1,1,'-'+numstr(od),font^); end;
     if los=5 then begin odejmij; outtextfntxy2(72,118,3,14,1,1,'-'+numstr(od),font^); end;
     if los=6 then begin odejmij; outtextfntxy2(72,118,3,14,1,1,'-'+numstr(od),font^); end;
     if los=7 then begin odejmij; outtextfntxy2(72,118,3,14,1,1,'-'+numstr(od),font^); end;
     pokazgrafike2;
     delay(700);
     draw_arena;
     pokaz_statusy;
     if (wrogowie[nr_przeciwnika].zycie<=0)then
     begin
          draw_arena;
          pokaz_statusy;
          if nr_przeciwnika=1 then draw_wrog(40,80,10);
          if nr_przeciwnika=2 then draw_wrog(40,80,13);
          if nr_przeciwnika=3 then draw_wrog(40,80,16);
          if nr_przeciwnika=4 then draw_wrog(40,80,19);
          if nr_przeciwnika=5 then draw_wrog(40,80,22);
          if czy_gracz_ma_bron then draw_wrog(230,80,4) else draw_wrog(230,80,1);
          pokaz_zycie_procent(0,0,wrogowie[nr_przeciwnika].zycie,wrogowie[nr_przeciwnika].maxzycie,
          wrogowie[nr_przeciwnika].nazwa);
          pokaz_zycie_procent(190,0,zyciemin,zycietmp,'KAROL');
          pokazgrafike2;
          delay(800);
          last_killed:=wrogowie[nr_przeciwnika].nazwa;
          ile_killed:=ile_killed+1;
          kasa:=kasa+(10+random(30));
          trup[1]:=true;{enemy}
     end else
     begin
     if nr_przeciwnika=1 then draw_wrog(40,80,8);
     if nr_przeciwnika=2 then draw_wrog(40,80,11);
     if nr_przeciwnika=3 then draw_wrog(40,80,14);
     if nr_przeciwnika=4 then draw_wrog(40,80,17);
     if nr_przeciwnika=5 then draw_wrog(40,80,20);
     end;
     if czy_gracz_ma_bron then draw_wrog(230,80,4) else draw_wrog(230,80,1);
     pokaz_zycie_procent(0,0,wrogowie[nr_przeciwnika].zycie,wrogowie[nr_przeciwnika].maxzycie,
     wrogowie[nr_przeciwnika].nazwa);
     pokaz_zycie_procent(190,0,zyciemin,zycietmp,'KAROL');
     pokazgrafike2;
end;

procedure escape_game_walka;
begin
     pokaz_zycie_procent(0,0,wrogowie[nr_przeciwnika].zycie,wrogowie[nr_przeciwnika].maxzycie,
     wrogowie[nr_przeciwnika].nazwa);
     pokaz_zycie_procent(190,0,zyciemin,zycietmp,'KAROL');
     if czy_gracz_ma_bron then draw_wrog(230,80,4) else draw_wrog(230,80,1);
     ustaw_wroga(nr_przeciwnika);
     pokaz_statusy;
     rectangle(70+40,85,157+40,125,220);
     bar(71+40,86,156+40,124,219);
     outtextfntxy2_center(112+40,89,3,43,1,1,'CZY NAPEWNO',font^);
     outtextfntxy2_center(112+40,90,3,14,1,1,'CZY NAPEWNO',font^);
     outtextfntxy2_center(112+40,99,3,43,1,1,'CHCESZ WYJóè?',font^);
     outtextfntxy2_center(112+40,100,3,14,1,1,'CHCESZ WYJóè?',font^);
     bar(107-10+40,114,121-10+40,122,220);
     outtextfntxy2(111-12+40,115,3,14,1,1,'TAK',font^);
     bar(107+10+40,114,121+10+40,122,220);
     outtextfntxy2(111+8+40,115,3,14,1,1,'NIE',font^);
     repeat
           mmx:=mousex;
           mmy:=mousey;
           copy_screen(mmx-10,mmy-20,35,35);
           draw_cursor(mmx,mmy);
           pokazgrafike2;
           put_screen(mmx-10,mmy-20,35,35);
           if mousein(mmx,mmy,107-13+40,114,121-13+40,122) and leftbutton then wyjscie_do_menu:=true;
     until mousein(mmx,mmy,107+7+40,114,121+7+40,122) and leftbutton or wyjscie_do_menu;
     draw_arena;
     pokaz_zycie_procent(0,0,wrogowie[nr_przeciwnika].zycie,wrogowie[nr_przeciwnika].maxzycie,
     wrogowie[nr_przeciwnika].nazwa);
     pokaz_zycie_procent(190,0,zyciemin,zycietmp,'KAROL');
     if czy_gracz_ma_bron then draw_wrog(230,80,4) else draw_wrog(230,80,1);
     ustaw_wroga(nr_przeciwnika);
     pokaz_statusy;
end;

begin
closesound_game;
new(arena);
for i:= 1 to ile_wrog do new(wrog[i]);
setcolor(254,50,0,0);
if mapa_='ziemia' then load_arena_to_memory('graphics\new');
if mapa_='tunele' then load_arena_to_memory('graphics\ziemia');
load_wrog_to_memory;
draw_arena;
if poziom in[0..4] then wylosoj_przeciwnika1;
if poziom in[5..10] then wylosoj_przeciwnika2;
if poziom in[10..15] then wylosoj_przeciwnika3;
setmousewindow(0,0,307,198);

initsound_walka;

if plecak[5]=ile_items then czy_gracz_ma_bron:=false else czy_gracz_ma_bron:=true;

info_items;

pokaz_zycie_procent(0,0,wrogowie[nr_przeciwnika].zycie,wrogowie[nr_przeciwnika].maxzycie,
wrogowie[nr_przeciwnika].nazwa);
pokaz_zycie_procent(190,0,zyciemin,zycietmp,'KAROL');
niematury:=true;
niematurywroga:=true;
tura:=0;
tmp:=0;
turawroga:=0;
tmp2:=0;
trup[1]:=false;
trup[2]:=false;
randomize;
end_:=random(20);
oczekiwanie_na_ture;
pokaz_statusy;
repeat
      mmx:=mousex;
      mmy:=mousey;
      if keydown[1] then escape_game_walka;
      if czy_gracz_ma_bron then draw_wrog(230,80,4) else draw_wrog(230,80,1);

      ustaw_wroga(nr_przeciwnika);

      if not niematury then
      begin
           pokaz_statusy;
           ataki;
      end
      else oczekiwanie_na_ture;

{      outtextxy(5,35,1,1,15,'obrazenia='+numstr(items_typ[plecak[5]].atak),false);}

      oczekiwanie_na_ture_wroga(wrogowie[nr_przeciwnika].ile+end_);

      copy_screen(mmx-10,mmy-20,35,35);
      draw_cursor(mmx,mmy);
{      outtextxy(2,10,1,1,15,'zycie='+numstr(wrogowie[nr_przeciwnika].zycie),false);}

{      outtextxy(25,2,1,1,15,numstr(turawroga),false);}
      pokazgrafike2;

      put_screen(mmx-10,mmy-20,35,35);
until trup[1] or trup[2] or wyjscie_do_menu;
closesound_walka;
initsound_game;
if trup[1] then
begin
      bar(120,90,200,120,220);
      rectangle(120,90,200,120,219);
      outtextfntxy2_center(158,97,3,43,1,1,'!!GRATULACJE!!',font^);
      outtextfntxy2_center(158,98,3,14,1,1,'!!GRATULACJE!!',font^);
      outtextfntxy2_center(158,105,3,43,1,1,'WYGRAùEó',font^);
      outtextfntxy2_center(158,106,3,14,1,1,'WYGRAùEó',font^);
      pokazgrafike2;
      delay(500);
      if wrogowie[1].zycie<0 then begin losd:=5+random(5); dosw:=dosw+losd; end;
      if wrogowie[2].zycie<0 then begin losd:=8+random(5); dosw:=dosw+losd; end;
      if wrogowie[3].zycie<0 then begin losd:=10+random(5); dosw:=dosw+losd; end;
      if wrogowie[4].zycie<0 then begin losd:=14+random(5); dosw:=dosw+losd; end;
      if wrogowie[5].zycie<0 then begin losd:=20+random(5); dosw:=dosw+losd; end;
end;
if trup[2] then
begin
      bar(120,90,200,120,220);
      rectangle(120,90,200,120,219);
      outtextfntxy2_center(158,101,3,43,1,1,'!!PRZEGRAùEó!!',font^);
      outtextfntxy2_center(158,102,3,14,1,1,'!!PRZEGRAùEó!!',font^);
      pokazgrafike2;
      delay(500);
      dosw:=dosw-(50+random(10));
end;
for i:= 1 to ile_wrog do dispose(wrog[i]);
dispose(arena);
end;

procedure pokaz_skrzynie_map_sound(x, y : integer);
var
   i : integer;
begin
      if (mx=x-8) and (my=y-6) and keydown[spacescan] then
      begin
           if sounds then play_sound(tempsound[1],sound[1],11000);
           delay(300);
      end;
end;

procedure in_room;

label rozm1, rozm2, rozm3, rozm4, rozm5, {dom - 4}
      rozm6, rozm7, {dom - 1}
      rozm8, rozm9, rozm10, {dom - 7}
      rozm11, {dom - 2}
      rozm12, rozm13, {dom - 6}
      rozm14, {dom - 5}
      rozm15; {dom - 8}

var i : integer;
    exit_room : boolean;
    key : byte;
    spp : array[1..4] of byte;
    y, y1 : integer;
    ilosc_zdan : byte;
    nr_rozmowy : byte;

function badaj_room(x, y : integer) : boolean;
begin
     if room_all[nr_dom].domek[x+1,y+1]=37 then badaj_room:=false;
     if room_all[nr_dom].domek[x+1,y+1]=35 then badaj_room:=false;
     if room_all[nr_dom].domek[x+1,y+1]in[103..115] then badaj_room:=false;
     if room_all[nr_dom].domek[x+1,y+1]in[117..146] then badaj_room:=false;
end;

procedure zamkniete(x, y : integer);
var
   i : integer;
begin
      if (px=x) and (py=y) and keydown[spacescan] then
      begin
           if sounds then play_sound(tempsound[2],sound[2],11000);
{           if not startsound(sound[1],1,false) then stopsound(1);}
           delay(300);
      end;
end;

procedure enemies_move;

var
   a : array[1..maxlud] of byte;
   licz : integer;
   i, ii : integer;
   a1, a2, a3, a4 : byte;

function badaj_gracz(x, y : integer) : boolean;
begin
     if (x=px) and (y=py) then badaj_gracz:=false;
end;

function badaj_enemy(x, y : integer) : boolean;
var
   i : integer;
begin
     for i:= ilemaxlud.one to ilemaxlud.two do
     if (x=enemy[i].x) and (y=enemy[i].y) then badaj_enemy:=false;
end;

begin
     for i:= ilemaxlud.one to ilemaxlud.two do
     begin
     if enemy[i].move then
     begin
     if enemy[i].speed=0 then
     begin
          a[i]:=random(242);
          a1:=0;
          a2:=80;
          a3:=160;
          a4:=180;
     end;
     if enemy[i].speed=1 then
     begin
          a[i]:=random(102);
          a1:=0;
          a2:=40;
          a3:=80;
          a4:=100;
     end;
     if enemy[i].speed=2 then
     begin
          a[i]:=random(50);
          a1:=0;
          a2:=15;
          a3:=30;
          a4:=45;
     end;
     if enemy[i].speed=3 then
     begin
          a[i]:=random(70);
          a1:=0;
          a2:=15;
          a3:=35;
          a4:=50;
     end;
     if enemy[i].speed=4 then
     begin
          a[i]:=random(65);
          a1:=0;
          a2:=20;
          a3:=40;
          a4:=60;
     end;
     if a[i]=a1 then if badaj_room(enemy[i].x+1,enemy[i].y) and badaj_gracz(enemy[i].x+1,enemy[i].y) and
     badaj_enemy(enemy[i].x+1,enemy[i].y) and (enemy[i].x<enemy[i].maxx) then
     begin
          enemy[i].kier:='1';
          enemy[i].x:=enemy[i].x+1;
          enemy[i].nr:=enemy[i].nr+1;
          if enemy[i].nr=2 then enemy[i].nr:=0;
     end;
     if a[i]=a2 then if badaj_room(enemy[i].x-1,enemy[i].y) and badaj_gracz(enemy[i].x-1,enemy[i].y) and
     badaj_enemy(enemy[i].x-1,enemy[i].y) and (enemy[i].x>enemy[i].minx) then
     begin
          enemy[i].kier:='2';
          enemy[i].x:=enemy[i].x-1;
          enemy[i].nr:=enemy[i].nr+1;
          if enemy[i].nr=2 then enemy[i].nr:=0;
     end;
     if a[i]=a3 then if badaj_room(enemy[i].x,enemy[i].y+1) and badaj_gracz(enemy[i].x,enemy[i].y+1) and
     badaj_enemy(enemy[i].x,enemy[i].y+1) and (enemy[i].y<enemy[i].maxy) then
     begin
          enemy[i].kier:='3';
          enemy[i].y:=enemy[i].y+1;
          enemy[i].nr:=enemy[i].nr+1;
          if enemy[i].nr=2 then enemy[i].nr:=0;
     end;
     if a[i]=a4 then if badaj_room(enemy[i].x,enemy[i].y-1) and badaj_gracz(enemy[i].x,enemy[i].y-1) and
     badaj_enemy(enemy[i].x,enemy[i].y-1) and (enemy[i].y>enemy[i].miny-1) then
     begin
          enemy[i].kier:='4';
          enemy[i].y:=enemy[i].y-1;
          enemy[i].nr:=enemy[i].nr+1;
          if enemy[i].nr=2 then enemy[i].nr:=0;
     end;
     if (i<>ii) then
     begin
          if (enemy[i].x=enemy[ii].x) then
          begin
               if enemy[i].kier='1' then enemy[i].x:=enemy[i].x-1;
               if enemy[i].kier='2' then enemy[i].x:=enemy[i].x+1;
          end;
     end;
     if enemy[i].kier='1' then enemy[i].del:=5;
     if enemy[i].kier='2' then enemy[i].del:=7;
     if enemy[i].kier='3' then enemy[i].del:=3;
     if enemy[i].kier='4' then enemy[i].del:=1;
     end;
     end;
end;

function patrz_enemies(x, y : integer) : boolean;
var i : integer;
begin
     for i:= ilemaxlud.one to ilemaxlud.two do
     begin
          if (x=enemy[i].x) and (y=enemy[i].y) then patrz_enemies:=false;
     end;
end;

begin
closesound_game;
initsound_room;
if sounds and not wyjscie_do_menu then
begin
play_sound(tempsound[1],sound[1],11000);
delay(350);
end;

inhome:=true;
load_room('data\roomdata.rom');
{startsound(sound[3],3,false);}
background;
delay(200);
loadpal('graphics\gold.pal');
nr_p:=0;
del:=5;
px:=7;
py:=12;
kier:='gora';
nr_dom:=aa;
exit_room:=false;
if nr_dom=1 then
begin
     niemaludka:=false;
     ilemaxlud.one:=1;
     ilemaxlud.two:=1;
end;
if nr_dom=2 then
begin
     niemaludka:=false;
     ilemaxlud.one:=2;
     ilemaxlud.two:=2;
end;
if nr_dom=3 then
begin
     niemaludka:=false;
     ilemaxlud.one:=3;
     ilemaxlud.two:=6;
end;
if nr_dom=4 then
begin
     niemaludka:=false;
     ilemaxlud.one:=20;
     ilemaxlud.two:=20;
end;
if nr_dom=5 then
begin
     niemaludka:=false;
     ilemaxlud.one:=16;
     ilemaxlud.two:=16;
end;
if nr_dom=6 then
begin
     niemaludka:=false;
     ilemaxlud.one:=12;
     ilemaxlud.two:=15;
end;
if nr_dom=7 then
begin
     niemaludka:=false;
     ilemaxlud.one:=7;
     ilemaxlud.two:=11;
end;
if nr_dom=8 then
begin
     niemaludka:=false;
     ilemaxlud.one:=17;
     ilemaxlud.two:=17;
end;
if nr_dom=9 then
begin
     niemaludka:=false;
     ilemaxlud.one:=19;
     ilemaxlud.two:=19;
end;
if nr_dom=10 then
begin
     niemaludka:=false;
     ilemaxlud.one:=21;
     ilemaxlud.two:=21;
end;
if nr_dom=11 then
begin
     niemaludka:=true;
end;
if nr_dom=12 then
begin
     niemaludka:=true;
end;
if nr_dom=13 then
begin
     niemaludka:=false;
     ilemaxlud.one:=18;
     ilemaxlud.two:=18;
end;
if nr_dom=14 then
begin
     niemaludka:=true;
end;

bar(231,190,315,198,219);
rectangle(231,190,315,198,220);

show_icony;

spp[1]:=0;
spp[2]:=0;
spp[3]:=0;
spp[4]:=0;
{room_all[nr_dom].domek[6,6]:=52; {122}
esc_room:=false;
wyjscie_do_menu:=false;
repeat
      if not esc_room then
      begin
      pokaz_statusy;
      godzina3;
      show_kasa;
      show_zmeczenie;
      odejmij_zmeczenie_room;


      mmx:=mousex;
      mmy:=mousey;
{      room_all[1].domek[5,5]:=122;e}

      draw_room(14,12,15,nr_dom);
{      outtextxy(10,10,1,1,15,numstr(nr_dom),false);}


      if nr_dom=2 then
      begin
      if (px=3)and(py=3) and keydown[spacescan] and (kier='gora') then
      begin
       randomize;
       key:=random(3);
       if key=0 then if sounds then play_sound(tempsound[3],sound[3],11000);
       if key=1 then if sounds then play_sound(tempsound[4],sound[4],11000);
       if key=2 then if sounds then play_sound(tempsound[5],sound[5],11000);
       delay(200);
      end;
      if (px=4)and(py=3) and keydown[spacescan] and (kier='gora') then
      begin
       randomize;
       key:=random(3);
       if key=0 then if sounds then play_sound(tempsound[3],sound[3],11000);
       if key=1 then if sounds then play_sound(tempsound[4],sound[4],11000);
       if key=2 then if sounds then play_sound(tempsound[5],sound[5],11000);
       delay(200);
      end;
      end;

      if (nr_dom=4) then
      begin
           zamkniete(0,3);
           zamkniete(2,3);
           zamkniete(4,5);
           zamkniete(14,3);
      end;

      if (nr_dom=3)then {sklep - kupowanie jedzenia i picia}
      begin
          if (px=3)and(py=2)and(keydown[spacescan])and(kier='lewo')then
{kurde}   begin
           rozm1:
           pokaz_rozmowe(1,3);
           if zd[1,1] then
           begin
                rozm2:
                pokaz_rozmowe(2,3);
                if zd[1,2] then begin delay(200);pokaz_mowce(3,5); goto rozm2; end;
                if zd[2,2] then begin delay(200);pokaz_mowce(4,3); goto rozm2; end;
                if zd[3,2] then goto rozm1;
           end;
           end;
           if zd[2,1] then
           begin
                rozm3:
                pokaz_rozmowe(5,4);
                if zd[1,5] then
                begin
                     if (5<=kasa)and(zyciemin<>zycietmp)then {kupowanie}
                     begin
                          kasa:=kasa-5;
                          zyciemin:=zyciemin+3;
                          if zyciemin>zycietmp then zyciemin:=zycietmp;
                          pokaz_statusy;
                          godzina3;
                          show_kasa;
                          goto rozm3;
                     end else goto rozm3;
                     if 5>kasa then {brak kasy}
                     begin
                          goto rozm3;
                     end;
                end;
                if zd[2,5] then
                begin
                     if (10<=kasa)and(zyciemin<>zycietmp)then {kupowanie}
                     begin
                          kasa:=kasa-6;
                          zyciemin:=zyciemin+10;
                          if zyciemin>zycietmp then zyciemin:=zycietmp;
                          pokaz_statusy;
                          godzina3;
                          show_kasa;
                          goto rozm3;
                     end else goto rozm3;
                     if 10>kasa then {brak kasy}
                     begin
                          goto rozm3;
                     end;
                end;
                if zd[3,5] then
                begin
                     if (40<=kasa)and(zyciemin<>zycietmp)then {kupowanie}
                     begin
                          kasa:=kasa-40;
                          zyciemin:=zycietmp;
                          pokaz_statusy;
                          godzina3;
                          show_kasa;
                          goto rozm3;
                     end else goto rozm3;
                     if 10>kasa then {brak kasy}
                     begin
                          goto rozm3;
                     end;
                end;
                if zd[4,5] then goto rozm1;
           end;
          if (px=7)and(py=2)and(keydown[spacescan])and(kier='prawo')then
{kurde2}  begin
                rozm4:
                pokaz_rozmowe(6,2);
                if zd[1,6] then
                begin
                     rozm5:
                     pokaz_rozmowe(7,3);
                     if zd[1,7] then
                     begin
                          if (3<=kasa)and(zyciemin<>zycietmp)then {kupowanie}
                          begin
                               kasa:=kasa-3;
                               zyciemin:=zyciemin+2;
                               if zyciemin>zycietmp then zyciemin:=zycietmp;
                               pokaz_statusy;
                               godzina3;
                               show_kasa;
                               goto rozm5;
                          end else goto rozm5;
                          if 3>kasa then {brak kasy}
                          begin
                               goto rozm5;
                          end;
                     end;
                     if zd[2,7] then
                     begin
                          if (7<=kasa)and(zyciemin<>zycietmp)then {kupowanie}
                          begin
                               kasa:=kasa-7;
                               zyciemin:=zyciemin+8;
                               if zyciemin>zycietmp then zyciemin:=zycietmp;
                               pokaz_statusy;
                               godzina3;
                               show_kasa;
                               goto rozm5;
                          end else goto rozm5;
                          if 7>kasa then {brak kasy}
                          begin
                               goto rozm5;
                          end;
                     end;
                     if zd[3,7] then goto rozm4;
                end;
{                if zd[2] then goto aozm4;}
          end;
           end;
      if nr_dom=1 then
      begin
           if (px=3)and(py=2)and(keydown[spacescan])and(kier='lewo')then
           begin
                rozm6:
                pokaz_rozmowe(8,4);
                if zd[1,8] then begin delay(200); pokaz_mowce(9,5); goto rozm6; end;
                if zd[2,8] then begin delay(200); pokaz_mowce(10,5); goto rozm6; end;
                if zd[3,8] then
                begin
                     rozm7:
                     pokaz_rozmowe(11,4);
                     if zd[1,11] then
                     begin
                          if (10<=kasa) then {kupowanie}
                          begin
                               kasa:=kasa-10;
                               spanie_dom(3,20);
                               pokaz_statusy;
                               godzina4;
                               show_kasa;
                               show_zmeczenie;
                               goto rozm7;
                          end else goto rozm7;
                     end;
                     if zd[2,11] then
                     begin
                          if (30<=kasa) then {kupowanie}
                          begin
                               kasa:=kasa-30;
                               spanie_dom(6,50);
                               pokaz_statusy;
                               godzina4;
                               show_kasa;
                               show_zmeczenie;
                               goto rozm7;
                          end else goto rozm7;
                     end;
                     if zd[3,11] then
                     begin
                          if (50<=kasa) then {kupowanie}
                          begin
                               kasa:=kasa-50;
                               spanie_dom(10,70);
                               pokaz_statusy;
                               godzina4;
                               show_kasa;
                               show_zmeczenie;
                               goto rozm7;
                          end else goto rozm7;
                     end;
                     if zd[4,11] then goto rozm6;
                end;
           end;
      end;
      if nr_dom=7 then
      begin
           if (px=10)and(py=3)and(keydown[spacescan])and(kier='gora')then
           begin
                rozm8:
                pokaz_rozmowe(12,3);
                if zd[1,12] then
                begin
                     rozm9:
                     pokaz_rozmowe(13,5);
                     if zd[1,13] then
                     begin
                          if zyciemin>1 then
                          begin
                          if ile_procent_z(20,zycietmp)<zyciemin then
                          begin
                          zyciemin:=zyciemin-round(ile_procent_z(20,zycietmp));
                          kasa:=kasa+20;
                          pokaz_statusy;
                          godzina4;
                          show_kasa;
                          delay(200);
                          goto rozm9;
                          end else goto rozm9;
                          end;
                     end;
                     if zd[2,13] then
                     begin
                          if zyciemin>1 then
                          begin
                          if ile_procent_z(30,zycietmp)<zyciemin then
                          begin
                          zyciemin:=zyciemin-round(ile_procent_z(30,zycietmp));
                          kasa:=kasa+40;
                          pokaz_statusy;
                          godzina4;
                          show_kasa;
                          delay(200);
                          goto rozm9;
                          end else goto rozm9;
                          end;
                     end;
                     if zd[3,13] then
                     begin
                          if zyciemin>1 then
                          begin
                          if ile_procent_z(50,zycietmp)<zyciemin then
                          begin
                          zyciemin:=zyciemin-round(ile_procent_z(50,zycietmp));
                          kasa:=kasa+100;
                          pokaz_statusy;
                          godzina4;
                          show_kasa;
                          delay(200);
                          goto rozm9;
                          end else goto rozm9;
                          end;
                     end;
                     if zd[4,13] then
                     begin
                          if zyciemin>1 then
                          begin
                          if ile_procent_z(90,zycietmp)<zyciemin then
                          begin
                          zyciemin:=zyciemin-round(ile_procent_z(90,zycietmp));
                          kasa:=kasa+300;
                          pokaz_statusy;
                          godzina4;
                          show_kasa;
                          delay(200);
                          goto rozm9;
                          end else goto rozm9;
                          end;
                     end;
                     if zd[5,13] then goto rozm8;
                end;
                if zd[2,12] then
                begin
                     rozm10:
                     pokaz_rozmowe(14,4);
                     if zd[1,14] then
                     begin
                          if (10<=kasa)and(zyciemin<>zycietmp)then {kupowanie}
                          begin
                               kasa:=kasa-10;
                               zyciemin:=zyciemin+10;
                               if zyciemin>zycietmp then zyciemin:=zycietmp;
                               pokaz_statusy;
                               godzina3;
                               show_kasa;
                               goto rozm10;
                          end else goto rozm10;
                     end;
                     if zd[2,14] then
                     begin
                          if (20<=kasa)and(zyciemin<>zycietmp)then {kupowanie}
                          begin
                               kasa:=kasa-20;
                               zyciemin:=zyciemin+25;
                               if zyciemin>zycietmp then zyciemin:=zycietmp;
                               pokaz_statusy;
                               godzina3;
                               show_kasa;
                               goto rozm10;
                          end else goto rozm10;
                     end;
                     if zd[3,14] then
                     begin
                          if (40<=kasa)and(zyciemin<>zycietmp)then {kupowanie}
                          begin
                               kasa:=kasa-40;
                               zyciemin:=zyciemin+50;
                               if zyciemin>zycietmp then zyciemin:=zycietmp;
                               pokaz_statusy;
                               godzina3;
                               show_kasa;
                               goto rozm10;
                          end else goto rozm10;
                     end;
                     if zd[4,14] then goto rozm8;
                end;
           end;
      end;
      if nr_dom=2 then
      begin
           if (px=8)and(py=8)and(keydown[spacescan])and(kier='gora')then
           begin
                rozm11:
                pokaz_rozmowe(15,3);
                if zd[1,15] then begin delay(200); pokaz_mowce(16,5); goto rozm11; end;
                if zd[2,15] then begin delay(200); pokaz_mowce(17,5); goto rozm11; end;
           end;
      end;
      if nr_dom=6 then
      begin
           if (px=5)and(py=2)and(keydown[spacescan])and(kier='lewo')then
           begin
                rozm12:
                pokaz_rozmowe(18,2);
                if zd[1,18] then
                begin
                     rozm13:
                     pokaz_rozmowe(19,3);
                     if zd[1,19] then
                     begin
                          if (8<=kasa)and(zyciemin<>zycietmp)then {kupowanie}
                          begin
                               kasa:=kasa-8;
                               zyciemin:=zyciemin+10;
                               if zyciemin>zycietmp then zyciemin:=zycietmp;
                               pokaz_statusy;
                               godzina3;
                               show_kasa;
                               goto rozm13;
                          end else goto rozm13;
                     end;
                     if zd[2,19] then
                     begin
                          if (15<=kasa)and(zyciemin<>zycietmp)then {kupowanie}
                          begin
                               kasa:=kasa-15;
                               zyciemin:=zyciemin+25;
                               if zyciemin>zycietmp then zyciemin:=zycietmp;
                               pokaz_statusy;
                               godzina3;
                               show_kasa;
                               goto rozm13;
                          end else goto rozm13;
                     end;
                     if zd[3,19] then goto rozm12;
                end;
           end;
      end;
      if nr_dom=5 then
      begin
           if (px=5)and(py=3)and(keydown[spacescan])and(kier='gora')then
           begin
                rozm14:
                pokaz_rozmowe(20,2);
                if zd[1,20] then begin delay(200); pokaz_mowce(21,5); goto rozm14; end;
           end;
      end;
      if nr_dom=8 then
      begin
           if (px=5)and(py=3)and(keydown[spacescan])and(kier='gora')then
           begin
                rozm15:
                pokaz_rozmowe(22,3);
                if zd[1,22] then begin delay(200); pokaz_mowce(23,5); goto rozm15; end;
                if zd[2,22] then begin delay(200); pokaz_mowce(24,5); goto rozm15; end;
           end;
      end;

{           pokaz_rozmowe(1,3);}
{           repeat
           until}

      if kier='prawo' then del:=5;
      if kier='lewo' then del:=7;
      if kier='gora' then del:=1;
      if kier='dol' then del:=3;
      if info_ico(231,171,249,188,'WYPOSAΩENIE') and leftbutton then
      begin
           background;
           for i:= 1 to ile_pictures do dispose(pictures[i]);
           for i:= 1 to ile_items do new(items[i]);
           load_items_to_memory;
           page_game;
{           delay(200);
           page_skrzynia(1);}
           for i:= 1 to ile_items do dispose(items[i]);
           for i:= 1 to ile_pictures do new(pictures[i]);
           load_pictures_to_memory;
           background;
           draw_room(14,12,15,nr_dom);
           draw_ramka;
           put_player(px*15,py*15,del+nr_p);
           bar(231,190,315,198,219);
           rectangle(231,190,315,198,220);
           show_icony;
      end;
      if info_ico(231,171-18,249,188-18,'MENU GRY') and leftbutton then
      begin
           menu_w_grze2;
      end;

      pokaz_skrzynie(2,10,1,2);
      pokaz_skrzynie(13,3,2,2);
      pokaz_skrzynie(3,5,3,7);
      pokaz_skrzynie(0,9,4,6);
      pokaz_skrzynie(3,5,5,6);
      pokaz_skrzynie(0,5,6,8);
      pokaz_skrzynie(14,9,7,9);
      pokaz_skrzynie(14,9,7,9);

{      outtextxy(180,10,1,1,12,'px='+numstr(px),false);
      outtextxy(180,20,1,1,12,'py='+numstr(py),false);}
      put_player(px*15,py*15,del+nr_p);


      copy_screen(mmx-10,mmy-20,35,35);
      outtextfntxy2_rainbow_center(274,191,3,171,1,1,opis_ico,font^);

      draw_ramka;
      if not niemaludka then enemies_move;


      if not niemaludka then
      begin
      for i:= ilemaxlud.one to ilemaxlud.two do put_enemy(enemy[i].x*15,enemy[i].y*15,enemy[i].ludek,enemy[i].del+enemy[i].nr);
      end;
      draw_cursor(mmx,mmy);
      pokazgrafike2;
      put_screen(mmx-10,mmy-20,35,35);
      bar(231,190,315,198,219);
      rectangle(231,190,315,198,220);

      if keydown[77] and badaj_room(px+1,py) and patrz_enemies(px+1,py) and (px<14) and
      not keydown[75] and not keydown[80] and not keydown[72] then
      begin
           spp[1]:=spp[1]+1;
           if spp[1]=speed then
           begin
           kier:='prawo';
           nr_p:=nr_p+1;
           if nr_p=2 then nr_p:=0;
           px:=px+1;
{           delay(speed);}
           spp[1]:=0;
           end;
      end;
      if keydown[75] and badaj_room(px-1,py) and patrz_enemies(px-1,py) and (px>0) and
      not keydown[77] and not keydown[80] and not keydown[72] then
      begin
           spp[2]:=spp[2]+1;
           if spp[2]=speed then
           begin
           kier:='lewo';
           nr_p:=nr_p+1;
           if nr_p=2 then nr_p:=0;
           px:=px-1;
{           delay(speed);}
           spp[2]:=0;
           end;
      end;
      if keydown[80] and badaj_room(px,py+1) and patrz_enemies(px,py+1) and (py<12) and
      not keydown[77] and not keydown[72] and not keydown[72] then
      begin
           spp[3]:=spp[3]+1;
           if spp[3]=speed then
           begin
           kier:='dol';
           nr_p:=nr_p+1;
           if nr_p=2 then nr_p:=0;
           py:=py+1;
{           delay(speed);}
           spp[3]:=0;
           end;
      end;
      if keydown[72] and badaj_room(px,py-1) and patrz_enemies(px,py-1) and (py>0) and
      not keydown[77] and not keydown[80] and not keydown[75] then
      begin
           spp[4]:=spp[4]+1;
           if spp[4]=speed then
           begin
           kier:='gora';
           nr_p:=nr_p+1;
           if nr_p=2 then nr_p:=0;
           py:=py-1;
{           delay(speed);}
           spp[4]:=0;
           end;
      end;
      if (px=7) and (py=12) and (keydown[spacescan]) then exit_room:=true;
      outtextfntxy2_center(274,191,3,219,1,1,opis_ico,font^);
      end;
until exit_room or esc_room or wyjscie_do_menu;
if sounds and not wyjscie_do_menu then
begin
play_sound(tempsound[1],sound[1],11000);
delay(350);
end;
kier:='dol';
if not esc_room then
begin
background;
draw_screen(maxx,maxy,15);
draw_ramka;
put_player(105,90,del+nr_p);
bar(231,190,315,198,219);
rectangle(231,190,315,198,120);
show_icony;
end;
{startsound(sound[3],3,false);}
if not esc_room then
begin
delay(300);
badaj_czy_noc;
end;
if esc_room then
begin
     badaj_czy_noc;
end;
inhome:=false;
esc_room:=false;
closesound_room;
initsound_game;
end;

procedure badaj_czy_nie_dostales_next_level;
procedure poziom_up;
begin
     background;
     if sounds then play_sound(tempsound[3],sound[3],9000);
     repeat
           mmx:=mousex;
           mmy:=mousey;
           pokaz_statusy;
           godzina4;
           show_kasa;
           show_zmeczenie;
{           odejmij_zmeczenie;}
           show_icony;
           draw_screen(maxx,maxy,15);
           draw_ramka;
           copy_screen(mmx-10,mmy-20,35,35);
           rectangle(70,85,157,125,220);
           bar(71,86,156,124,219);
           outtextfntxy2_center(108,89,3,43,1,1,'!!GRATULACJE!!',font^);
           outtextfntxy2_center(108,90,3,14,1,1,'!!GRATULACJE!!',font^);
           outtextfntxy2_center(108,98,3,43,1,1,'AWANSOWAùEó NA',font^);
           outtextfntxy2_center(108,99,3,14,1,1,'AWANSOWAùEó NA',font^);
           outtextfntxy2_center(108,105,3,43,1,1,numstr(poziom)+' POZIOM',font^);
           outtextfntxy2_center(108,106,3,14,1,1,numstr(poziom)+' POZIOM',font^);
           bar(107,114,121,122,220);
           outtextfntxy2(111,115,3,14,1,1,'OK',font^);
           bar(231,190,315,198,219);
           rectangle(231,190,315,198,220);
           draw_cursor(mmx,mmy);
           pokazgrafike2;
           put_screen(mmx-10,mmy-20,35,35);
     until mousein(mmx,mmy,107,114,121,122) and leftbutton;
end;
begin
     if poziom<16 then
     begin
     if dosw>=nextdosw then
     begin
          inc(poziom,1);
          zycietmp:=zycietmp+3;
          zyciemin:=zycietmp;
          zycie:=zyciemin;
          poziom_up;
     end;
     if poziom=1 then
     begin
          atak:=atak+2;
          szczescie:=szczescie+1;
          obrona:=obrona+1;
          zrecznosc:=zrecznosc+1;
          nextdosw:=220;
     end;
     if poziom=2 then
     begin
          atak:=atak+1;
          szczescie:=szczescie;
          obrona:=obrona+2;
          zrecznosc:=zrecznosc+1;
          nextdosw:=462;
     end;
     if poziom=3 then
     begin
          atak:=atak;
          szczescie:=szczescie+1;
          obrona:=obrona+3;
          zrecznosc:=zrecznosc;
          nextdosw:=640;
     end;
     if poziom=4 then
     begin
          atak:=atak;
          szczescie:=szczescie+1;
          obrona:=obrona;
          zrecznosc:=zrecznosc;
          nextdosw:=1122;
     end;
     if poziom=5 then
     begin
          atak:=atak+1;
          szczescie:=szczescie+1;
          obrona:=obrona;
          zrecznosc:=zrecznosc+1;
          nextdosw:=1542;
     end;
     if poziom=6 then
     begin
          atak:=atak+1;
          szczescie:=szczescie;
          obrona:=obrona;
          zrecznosc:=zrecznosc+2;
          nextdosw:=1924;
     end;
     if poziom=7 then
     begin
          atak:=atak+1;
          szczescie:=szczescie+1;
          obrona:=obrona;
          zrecznosc:=zrecznosc+1;
          nextdosw:=2752;
     end;
     if poziom=8 then
     begin
          atak:=atak+1;
          szczescie:=szczescie+1;
          obrona:=obrona;
          zrecznosc:=zrecznosc+1;
          nextdosw:=3412;
     end;
     if poziom=9 then
     begin
          atak:=atak;
          szczescie:=szczescie+1;
          obrona:=obrona;
          zrecznosc:=zrecznosc+1;
          nextdosw:=4124;
     end;
     if poziom=10 then
     begin
          atak:=atak+4;
          szczescie:=szczescie;
          obrona:=obrona+1;
          zrecznosc:=zrecznosc+1;
          nextdosw:=5462;
     end;
     if poziom=11 then
     begin
          atak:=atak+2;
          szczescie:=szczescie+1;
          obrona:=obrona+1;
          zrecznosc:=zrecznosc+2;
          nextdosw:=6402;
     end;
     if poziom=12 then
     begin
          atak:=atak+2;
          szczescie:=szczescie+1;
          obrona:=obrona;
          zrecznosc:=zrecznosc;
          nextdosw:=7952;
     end;
     if poziom=13 then
     begin
          atak:=atak+1;
          szczescie:=szczescie;
          obrona:=obrona+1;
          zrecznosc:=zrecznosc+2;
          nextdosw:=9612;
     end;
     if poziom=14 then
     begin
          atak:=atak+1;
          szczescie:=szczescie+1;
          obrona:=obrona+2;
          zrecznosc:=zrecznosc+4;
          nextdosw:=15864;
     end;
     if poziom=15 then
     begin
          atak:=atak+2;
          szczescie:=szczescie+2;
          obrona:=obrona+1;
          zrecznosc:=zrecznosc+2;
          nextdosw:=20000;
     end;
     end;
end;

procedure open_move(name : string);
var
   fmove : file of Tmove;
begin
     assign(fmove,name);
     reset(fmove);
     read(fmove,move_col^);
     close(fmove);
end;

procedure zamaluj_ekran;
procedure draw(x, y, d, s : integer);
var i, j : integer;
begin
     for i:= x to d do
     for j:= y to s do putpixel(i-1,j,move_col^[i,j])
end;
var
   i, j : integer;
begin
     new(move_col);
     open_move('data\move.dat');
     i:=0;
     j:=114;
     repeat
           i:=i+8;
           j:=j-8;
           draw_screen(maxx,maxy,15);
           put_player(105,90,del+nr_p);
           draw(3,3,i*2,197);
           draw(j*2-1,3,227,197);
           draw_ramka;
           pokazgrafike2
     until (i>57);
     dispose(move_col)
end;

procedure odmaluj_ekran;
procedure draw(x, y, d, s : integer);
var i, j : integer;
begin
     for i:= x to d do
     for j:= y to s do putpixel(i-1,j,move_col^[i,j])
end;
var
   i, j : integer;
begin
     new(move_col);
     open_move('data\move.dat');
     i:=57;
     j:=57;
     repeat
           i:=i+8;
           j:=j-8;
           draw_screen(maxx,maxy,15);
           put_player(105,90,del+nr_p);
           draw(i*2,3,227,197);
           draw(3,3,j*2,197);
           draw_ramka;
           pokazgrafike2
     until (i>113);
     dispose(move_col)
end;

procedure found_sword;
var
   licz : integer;
   koniec : boolean;
begin
     if ffff then
     begin
     closesound_game;
     if sounds then
     begin
     initsound;
     new_sound(tempsound[1],sound[1],'sounds/sound6.snd');
     new_sound(tempsound[2],sound[2],'sounds/sound4.snd');
     end;
      windows(2,3,226,197);
      licz:=0;
      koniec:=false;
      if sounds then play_sound(tempsound[1],sound[1],9000);
     repeat
     inc(licz,1);
     qx:=random(3)+1;
     qy:=random(3)+1;
     draw_screen(maxx,maxy,15);
     put_player(105+qx,90+qy,del+nr_p);
     draw_ramka;
     pokazgrafike2;delay(10);
     if licz=100 then
     begin
          loadpal('graphics\light.pal');
          draw_bigpic(30,0,bigpic[3]^);
          pokazgrafike2;
          if sounds then
          begin
          play_sound(tempsound[2],sound[2],13000);
          delay(1250);
          end;
          delay(350);
          loadpal('graphics\gold.pal');
          koniec:=true;
     end;
     until koniec;
     if sounds then
     begin
     closesound;
     dispose_sound(tempsound[1],sound[1]);
     dispose_sound(tempsound[2],sound[2]);
     end;
     initsound_game;
     ffff:=false;
     qx:=0;
     qy:=0;
     delay(200);
     if dosw>200 then
     begin
     windows(0,0,319,199);
     bar(0,0,319,199,0);
     pokazgrafike2;
     new_font2('data\small.fnt',font3^);
     loadpal('graphics\gold.pal');
     background;
     outtextfntxy2_rainbow(90,5,9,20,4,2,'GRATULACJE!!!',font3^);
     outtextfntxy2_center(133,35,3,14,1,1,'UDAùO CI SI® ZDOBYè ZAGINIONY MIECZ. DZI®KI TOBIE CAùE ZùO',font^);
     outtextfntxy2_center(133,45,3,14,1,1,'PRZESTAùO ISTNIEè,  WSZYSCY ZOSTALI ZNISZCZENI. NIE PR®DKO',font^);
     outtextfntxy2_center(133,55,3,14,1,1,'POTWORY POWR‡C§. TERAZ GDY MIECZ JEST WE WùAóCIWYCH R®KACH',font^);
     outtextfntxy2_center(151,65,3,14,1,1,'NIE NALEΩY SI® OBAWIAè NICZEGO.',font^);
     outtextfntxy2_center(250,185,6,43,1,1,'naciònij ENTER...',font3^);
     outtextfntxy2_center(250,186,6,14,1,1,'naciònij ENTER...',font3^);
     outtextfntxy2_center(152,89,5,43,1,1,'Zaginiony Miecz '+versjagry,font3^);
     outtextfntxy2_center(152,90,5,14,1,1,'Zaginiony Miecz '+versjagry,font3^);
     outtextfntxy2_center(158,109,5,43,1,1,'autor',font3^);
     outtextfntxy2_center(158,110,5,14,1,1,'autor',font3^);
     outtextfntxy2_center(156,125,5,43,1,1,'Michaà Rygielski',font3^);
     outtextfntxy2_center(156,126,5,14,1,1,'Michaà Rygielski',font3^);
     outtextfntxy2_center(156,140,5,43,1,1,'http://rpage.prv.pl',font3^);
     outtextfntxy2_center(156,141,5,14,1,1,'http://rpage.prv.pl',font3^);
     outtextfntxy2_center(153,150,5,43,1,1,'email://rpage@poczta.onet.pl',font3^);
     outtextfntxy2_center(153,151,5,14,1,1,'email://rpage@poczta.onet.pl',font3^);
     pokazgrafike;
     repeat
     until keydown[entscan];
     new_font2('data\small.fnt',font3^);
     end else
     begin
     windows(0,0,319,199);
     bar(0,0,319,199,0);
     pokazgrafike2;
     new_font2('data\small.fnt',font3^);
     loadpal('graphics\gold.pal');
     background;
     outtextfntxy2_rainbow(90,5,9,20,4,2,'KONIEC GRY!!!',font3^);
     outtextfntxy2_center(133,35,3,14,1,1,'TWOJE DOóWIADCZENIE JEST ZBYT MAùE ABYó M‡Gù ZABRAè MIECZ!',font^);
     outtextfntxy2_center(250,185,6,43,1,1,'naciònij ENTER...',font3^);
     outtextfntxy2_center(250,186,6,14,1,1,'naciònij ENTER...',font3^);
     outtextfntxy2_center(152,89,5,43,1,1,'Zaginiony Miecz '+versjagry,font3^);
     outtextfntxy2_center(152,90,5,14,1,1,'Zaginiony Miecz '+versjagry,font3^);
     outtextfntxy2_center(158,109,5,43,1,1,'autor',font3^);
     outtextfntxy2_center(158,110,5,14,1,1,'autor',font3^);
     outtextfntxy2_center(156,125,5,43,1,1,'Michaà Rygielski',font3^);
     outtextfntxy2_center(156,126,5,14,1,1,'Michaà Rygielski',font3^);
     outtextfntxy2_center(156,140,5,43,1,1,'http://rpage.prv.pl',font3^);
     outtextfntxy2_center(156,141,5,14,1,1,'http://rpage.prv.pl',font3^);
     outtextfntxy2_center(153,150,5,43,1,1,'email://rpage@poczta.onet.pl',font3^);
     outtextfntxy2_center(153,151,5,14,1,1,'email://rpage@poczta.onet.pl',font3^);
     pokazgrafike;
     repeat
     until keydown[entscan];
     new_font2('data\small.fnt',font3^);
     end;
     wyjscie_do_menu:=true;
{     dispose(font3);}
     end
end;

procedure gra;
begin
for i:= 1 to 3 do new(bigpic[i]);
for i:= 1 to ile_pictures do new(pictures[i]);
for i:= 1 to 5 do new(tekst[i]);
for i:= 1 to ile_skrzyn do open[i]:=false;
{new(cols);
for i:= 1 to 230 do
for j:= 1 to 50 do cols^[i,j]:=219+random(2);}
load_to_memory_took('data\took.dat');

ffff:=true;

{for i:= 1 to 7 do save_list[i]:='BRAK ZAPISU';
assign(f,'saves.dat');
rewrite(f);
write(f,save_list);
close(f);}

initsound_game;

load_pictures_to_memory;
load_stone_to_memory;
load_ramka;
reset_map;
load_map('data\0.map');
assign(fdom,'data\namedom.dom');
reset(fdom);
read(fdom,dom);
close(fdom);
assign(f2,'data\roomdata.rom');
reset(f2);
read(f2,room_all);
close(f2);
zaladuj_textdata;
ustaw_enemies;
background;
mx:=24;
my:=10;
speed:=7;
nrp:=15;
minimap:=false;
nr_p:=0;
del:=5;
mapa_:='ziemia';
dosw:=0;
nextdosw:=120;
poziom:=0;
atak:=0;
obrona:=0;
zrecznosc:=0;
szczescie:=0;
last_killed:='BRAK';
ile_killed:=0;
zyciemin:=100;  {min}
zycie:=100;    {max}
zycietmp:=zycie;
kasa:=200;
zmeczenie:=100;
maxzmeczenie:=100;


ustaw_skrzynie_i_plecak;
setmousewindow(0,0,307,198);
setmousepos(165,100);

bar(231,190,315,198,219);
rectangle(231,190,315,198,120);

show_icony;
show_kasa;
g:=8;
m:=10;
s:=0;

badaj_czy_noc;
sp[1]:=0;
sp[2]:=0;
sp[3]:=0;
sp[4]:=0;
inhome:=false;
esc_room:=false;
wyjscie_do_menu:=false;
repeat
      pokaz_statusy;
      godzina;
      show_kasa;
      show_zmeczenie;
      odejmij_zmeczenie;
      mmx:=mousex;
      mmy:=mousey;

{      if (mx<>tmpx) or (my<>tmpy) then
      begin
           tmpx:=mx;
           tmpy:=my;}
           draw_screen(maxx,maxy,15);
           draw_ramka;
           if kier='prawo' then del:=5;
           if kier='lewo' then del:=7;
           if kier='gora' then del:=1;
           if kier='dol' then del:=3;
           put_player(105,90,del+nr_p);
{      end;}
      if info_ico(231,171,249,188,'WYPOSAΩENIE') and leftbutton then
      begin
           background;
           for i:= 1 to ile_pictures do dispose(pictures[i]);
           for i:= 1 to ile_items do new(items[i]);
           load_items_to_memory;
           page_game;
{           delay(200);
           page_skrzynia(1);}
           for i:= 1 to ile_items do dispose(items[i]);
           for i:= 1 to ile_pictures do new(pictures[i]);
           load_pictures_to_memory;
           background;
           draw_screen(maxx,maxy,15);
           draw_ramka;
           put_player(105,90,del+nr_p);
           bar(231,190,315,198,219);
           rectangle(231,190,315,198,220);
           show_icony;
           badaj_czy_noc;
      end;
      if info_ico(231,171-18,249,188-18,'MENU GRY') and leftbutton then
      begin
           menu_w_grze1;
      end;

      copy_screen(mmx-10,mmy-20,35,35);

      draw_cursor(mmx,mmy);

      if mapa_='ziemia' then
      begin
      if {(mapa_='ziemia') and }(mx=31) and (my=12) and keydown[spacescan] then info('sypialnia');
      if {(mapa_='ziemia') and }(mx=31) and (my=17) and keydown[spacescan] then info('jadalnia');
      if {(mapa_='ziemia') and }(mx=36) and (my=17) and keydown[spacescan] then info('piwialnia');
      end;

{      outtextxy(180,5,1,1,1,'x='+numstr(mx),false);
      outtextxy(180,15,1,1,1,'y='+numstr(my),false);
      outtextxy(180,25,1,1,4,'x='+numstr(mx+8),false);
      outtextxy(180,35,1,1,4,'y='+numstr(my+6),false);}

      if (mx=28) and (my=86) and keydown[spacescan] then saveg;

      pokazgrafike2;

      put_screen(mmx-10,mmy-20,35,35);
      bar(231,190,315,198,219);
      rectangle(231,190,315,198,220);
      for aa:= 1 to 20 do
      if (dom[aa].x=mx) and (dom[aa].y=my) and (dom[aa].name=room_all[aa].name) and keydown[spacescan] and (mapa_='ziemia')
      then
      begin
           in_room;
           kier:='dol';
           draw_screen(maxx,maxy,15);
           draw_ramka;
           if kier='dol' then del:=3;
           put_player(105,90,del+nr_p);
      end;
      if keydown[77] and (mx<114-maxx) and badaj_teren(mx+1,my) and
      not keydown[75] and not keydown[80] and not keydown[72] then
      begin
           sp[1]:=sp[1]+1;
           if sp[1]=speed then
           begin
           kier:='prawo';
           nr_p:=nr_p+1;
           if nr_p=2 then nr_p:=0;
           mx:=mx+1;
           sp[1]:=0;
           badaj_czy_nie_znalazles_kasy(mx,my);
           badaj_czy_walka(mx,my);
           end;
{           delay(speed);}
      end;
      if keydown[75] and (mx>1) and badaj_teren(mx-1,my) and
      not keydown[77] and not keydown[80] and not keydown[72] then
      begin
           sp[2]:=sp[2]+1;
           if sp[2]=speed then
           begin
           kier:='lewo';
           nr_p:=nr_p+1;
           if nr_p=2 then nr_p:=0;
           mx:=mx-1;
{           delay(speed);}
           sp[2]:=0;
           badaj_czy_nie_znalazles_kasy(mx,my);
           badaj_czy_walka(mx,my);
           end;
      end;
      if keydown[80] and (my<112-maxy) and badaj_teren(mx,my+1) and
      not keydown[77] and not keydown[72] and not keydown[72] then
      begin
           sp[3]:=sp[3]+1;
           if sp[3]=speed then
           begin
           kier:='dol';
           nr_p:=nr_p+1;
           if nr_p=2 then nr_p:=0;
           my:=my+1;
           sp[3]:=0;
           badaj_czy_nie_znalazles_kasy(mx,my);
           badaj_czy_walka(mx,my);
           end;
{           delay(speed);}
      end;
      if keydown[72] and (my>1) and badaj_teren(mx,my-1) and
      not keydown[77] and not keydown[80] and not keydown[75] then
      begin
           sp[4]:=sp[4]+1;
           if sp[4]=speed then
           begin
           kier:='gora';
           nr_p:=nr_p+1;
           if nr_p=2 then nr_p:=0;
           my:=my-1;
           sp[4]:=0;
           badaj_czy_nie_znalazles_kasy(mx,my);
           badaj_czy_walka(mx,my);
           end;
{           delay(speed);}
      end;


      if (mx=97) and (my=13) and keydown[spacescan] and (mapa_='ziemia') then
      begin
           zamaluj_ekran;
           mapa_:='tunele';
           load_map('data\1.map');
           draw_screen(maxx,maxy,15);
           draw_ramka;
           put_player(105,90,del+nr_p);
           delay(200);
           loadpal('graphics\gold.pal');
           odmaluj_ekran;
      end;
      if (mx=97) and (my=13) and keydown[spacescan] and (mapa_='tunele') then
      begin
           zamaluj_ekran;
           mapa_:='ziemia';
           load_map('data\0.map');
           draw_screen(maxx,maxy,15);
           draw_ramka;
           put_player(105,90,del+nr_p);
           delay(200);
           badaj_czy_noc;
           odmaluj_ekran;
      end;

      if mapa_='tunele' then
      begin
           pokaz_skrzynie_map(19,18,8);
           pokaz_skrzynie_map(18,82,9);
           pokaz_skrzynie_map(38,83,10);
           pokaz_skrzynie_map(62,11,11);
           pokaz_skrzynie_map(102,11,12);
           pokaz_skrzynie_map(105,94,13);
           pokaz_skrzynie_map(103,96,14);
           pokaz_skrzynie_map(105,100,15);
           pokaz_skrzynie_map(72,71,16);
           pokaz_skrzynie_map(48,102,17);
           pokaz_skrzynie_map(50,102,18);
           pokaz_skrzynie_map(19,103,19);
           pokaz_skrzynie_map(32,68,20);
{           pokaz_skrzynie_map_sound(31,68);
           {zrobiÜ, æe jak ludek stoi na x=31 i y=68 to wyskakuje
           dzwiek zamkniete}            {startsound(sound[1],1,false);}
      end;
      if mapa_='ziemia' then pokaz_skrzynie_map_sound(28,54);
      if mapa_='tunele' then pokaz_skrzynie_map_sound(31,68);


      if mapa_='tunele' then
      begin
           if not ffff then if mapa_='tunele' then mapa[13,11]:=50;
           if (mx=6)and(my=5)then
           begin
           mapa[13,11]:=50;
           found_sword;
           pokaz_statusy;
           godzina4;
           show_kasa;
           show_zmeczenie;
           windows(0,0,319,199);
           end;
      end;

{if keydown[f1scan]then
begin
for i:= 1 to ile_pictures do dispose(pictures[i]);
for i:= 1 to 5 do dispose(tekst[i]);
for i:= 1 to 3 do dispose(bigpic[i]);

delay(200); walka;
for i:= 1 to 3 do new(bigpic[i]);
for i:= 1 to ile_pictures do new(pictures[i]);
for i:= 1 to 5 do new(tekst[i]);
load_pictures_to_memory;
load_stone_to_memory;
background;
draw_screen(maxx,maxy,15);
draw_ramka;
put_player(105,90,del+nr_p);
bar(231,190,315,198,219);
rectangle(231,190,315,198,220);
show_icony;
badaj_czy_noc;
badaj_czy_nie_dostales_next_level;
end;}

until {keydown[entscan] or }wyjscie_do_menu;


for i:= 1 to ile_pictures do dispose(pictures[i]);
for i:= 1 to 5 do dispose(tekst[i]);
for i:= 1 to 3 do dispose(bigpic[i]);

closesound_game;
end;

procedure spanie(ile : byte);
var
   licznik : integer;
   dod : integer;
   spanie : integer;
   czy_walka : byte;
procedure pokaz_Z(nr : byte);
begin
     if nr=1 then outtextfntxy2(120,90,3,14,1,1,'Z',font^);
     if nr=2 then outtextfntxy2(123,87,3,14,1,1,'Z',font^);
     if nr=3 then outtextfntxy2(126,84,3,14,1,1,'Z',font^);
end;
procedure walkaa;
begin
for i:= 1 to ile_pictures do dispose(pictures[i]);
for i:= 1 to 5 do dispose(tekst[i]);
for i:= 1 to 3 do dispose(bigpic[i]);

delay(200); walka;
for i:= 1 to 3 do new(bigpic[i]);
for i:= 1 to ile_pictures do new(pictures[i]);
for i:= 1 to 5 do new(tekst[i]);
load_pictures_to_memory;
load_stone_to_memory;
background;
draw_screen(maxx,maxy,15);
draw_ramka;
put_player(105,90,del+nr_p);
bar(231,190,315,198,219);
rectangle(231,190,315,198,220);
show_icony;
badaj_czy_noc;
if poziom<16 then badaj_czy_nie_dostales_next_level;
end;
begin
          licznik:=0;
          dod:=0;
          spanie:=0;
          czy_walka:=0;
          repeat
           spanie:=spanie+1;
           licznik:=licznik+1;
           if licznik=10 then begin licznik:=0; dod:=dod+1; g:=g+1; end;
           pokaz_statusy;
           godzina;
           badaj_czy_noc;
           show_kasa;
           show_zmeczenie;
           draw_screen(maxx,maxy,15);
           draw_ramka;
           if kier='prawo' then del:=5;
           if kier='lewo' then del:=7;
           if kier='gora' then del:=1;
           if kier='dol' then del:=3;
           put_player(105,90,del+nr_p);
           if spanie=5 then pokaz_Z(1);
           if spanie=10 then pokaz_Z(2);
           if spanie=15 then pokaz_Z(3);
           if spanie=20 then spanie:=0;
           pokazgrafike2;
           zmeczenie:=zmeczenie+1;
          if zmeczenie>maxzmeczenie then zmeczenie:=maxzmeczenie;
          until dod=ile;
          randomize;
          czy_walka:=random(2)+1;
          if czy_walka=2 then walkaa;
{          zmeczenie:=zmeczenie+odnowa;}
end;

procedure spanie_dom(ile : byte; zyc : byte);
var
   licznik : integer;
   dod : integer;
   spanie : integer;
procedure pokaz_Z(nr : byte);
begin
     if nr=1 then outtextfntxy2(px*15+15,py*15-3,3,14,1,1,'Z',font^);
     if nr=2 then outtextfntxy2(px*15+15+3,py*15-3-3,3,14,1,1,'Z',font^);
     if nr=3 then outtextfntxy2(px*15+15+6,py*15-3-6,3,14,1,1,'Z',font^);
end;
begin
          licznik:=0;
          dod:=0;
          spanie:=0;
          repeat
           spanie:=spanie+1;
           licznik:=licznik+1;
           if licznik=10 then begin licznik:=0; dod:=dod+1; g:=g+1; end;
           pokaz_statusy;
           godzina3;
           show_kasa;
           show_zmeczenie;
           draw_room(14,12,15,nr_dom);
           draw_ramka;
           if kier='prawo' then del:=5;
           if kier='lewo' then del:=7;
           if kier='gora' then del:=1;
           if kier='dol' then del:=3;
           put_player(px*15,py*15,del+nr_p);
           if spanie=5 then pokaz_Z(1);
           if spanie=10 then pokaz_Z(2);
           if spanie=15 then pokaz_Z(3);
           if spanie=20 then spanie:=0;

      if not niemaludka then
      begin
      for i:= ilemaxlud.one to ilemaxlud.two do put_enemy(enemy[i].x*15,enemy[i].y*15,enemy[i].ludek,enemy[i].del+enemy[i].nr);
      end;
           pokazgrafike2;
           zmeczenie:=zmeczenie+1;
          if zmeczenie>maxzmeczenie then zmeczenie:=maxzmeczenie;
          until dod=ile;
          if zyciemin<>zycietmp then
          begin
               zyciemin:=zyciemin+zyc;
               if zyciemin>=zycietmp then zyciemin:=zycietmp;
          end;

{          zmeczenie:=zmeczenie+odnowa;}
end;

procedure odejmij_zmeczenie;
procedure jestem_zmeczony;
begin
     repeat
           mmx:=mousex;
           mmy:=mousey;
           godzina4;
           draw_screen(maxx,maxy,15);
           draw_ramka;
           copy_screen(mmx-10,mmy-20,35,35);
           rectangle(70,85,157,125,220);
           bar(71,86,156,124,219);
           outtextfntxy2_center(108,89,3,43,1,1,'!!KOMUNIKAT!!',font^);
           outtextfntxy2_center(108,90,3,14,1,1,'!!KOMUNIKAT!!',font^);
           outtextfntxy2_center(108,98,3,43,1,1,'JESTEM ZBYT ZM®CZONY',font^);
           outtextfntxy2_center(108,99,3,14,1,1,'JESTEM ZBYT ZM®CZONY',font^);
           outtextfntxy2_center(108,105,3,43,1,1,'MUSZ® SI® PRZESPAè!',font^);
           outtextfntxy2_center(108,106,3,14,1,1,'MUSZ® SI® PRZESPAè!',font^);
           bar(107,114,121,122,220);
           outtextfntxy2(111,115,3,14,1,1,'OK',font^);

           draw_cursor(mmx,mmy);
           pokazgrafike2;
           put_screen(mmx-10,mmy-20,35,35);
     until mousein(mmx,mmy,107,114,121,122) and leftbutton;
     spanie(10);
end;
begin
     if zmeczenie=0 then
     begin
          jestem_zmeczony;
     end;
     inc(od,1);
     if od=80 then begin dec(zmeczenie,1); od:=0; end;
end;
procedure odejmij_zmeczenie_room;
procedure jestem_zmeczony;
begin
     repeat
           mmx:=mousex;
           mmy:=mousey;
           godzina4;
           draw_room(14,12,15,nr_dom);
           draw_ramka;
           put_player(px*15,py*15,del+nr_p);
{      if not niemaludka then enemies_move;}


      if not niemaludka then
      begin
      for i:= ilemaxlud.one to ilemaxlud.two do put_enemy(enemy[i].x*15,enemy[i].y*15,enemy[i].ludek,enemy[i].del+enemy[i].nr);
      end;
           copy_screen(mmx-10,mmy-20,35,35);
           rectangle(70,85,157,125,220);
           bar(71,86,156,124,219);
           outtextfntxy2_center(108,89,3,43,1,1,'!!KOMUNIKAT!!',font^);
           outtextfntxy2_center(108,90,3,14,1,1,'!!KOMUNIKAT!!',font^);
           outtextfntxy2_center(108,98,3,43,1,1,'JESTEM ZBYT ZM®CZONY',font^);
           outtextfntxy2_center(108,99,3,14,1,1,'JESTEM ZBYT ZM®CZONY',font^);
           outtextfntxy2_center(108,105,3,43,1,1,'MUSZ® SI® PRZESPAè!',font^);
           outtextfntxy2_center(108,106,3,14,1,1,'MUSZ® SI® PRZESPAè!',font^);
           bar(107,114,121,122,220);
           outtextfntxy2(111,115,3,14,1,1,'OK',font^);
           draw_cursor(mmx,mmy);
           pokazgrafike2;
           put_screen(mmx-10,mmy-20,35,35);
     until mousein(mmx,mmy,107,114,121,122) and leftbutton;
     spanie_dom(10,0);
end;
begin
     if zmeczenie=0 then
     begin
          jestem_zmeczony;
     end;
     inc(od,1);
     if od=80 then begin dec(zmeczenie,1); od:=0; end;
end;

procedure loadg;
var loadg : boolean;
procedure ramki;
var
   i : integer;
begin
      bar(60,50,175,140,219);    {menu}
      rectangle(60,50,175,140,220);
      outtextfntxy2_center(110,53,8,43,1,1,'WCZYTAJ GR®',font2^);
      outtextfntxy2_center(110,54,8,14,1,1,'WCZYTAJ GR®',font2^);
      for i:= 1 to 6 do
      begin
           outtextfntxy2(65,63+i*9,3,43,1,1,save_list[i],font^);
           outtextfntxy2(65,64+i*9,3,14,1,1,save_list[i],font^);
      end;
      outtextfntxy2_center(110,125,8,43,1,1,'POWR‡T',font2^);
      outtextfntxy2_center(110,126,8,14,1,1,'POWR‡T',font2^);
end;

begin
      assign(fff,'data\saves.dat');
      reset(fff);
      read(fff,save_list);
      close(fff);
      loadg:=false;
      if not inhome then
      begin
      draw_screen(maxx,maxy,15);
      draw_ramka;
      if kier='prawo' then del:=5;
      if kier='lewo' then del:=7;
      if kier='gora' then del:=1;
      if kier='dol' then del:=3;
      end else
      begin
           pokaz_statusy;
           godzina4;
           show_kasa;
           show_zmeczenie;
           draw_room(14,12,15,nr_dom);
           if kier='prawo' then del:=5;
           if kier='lewo' then del:=7;
           if kier='gora' then del:=1;
           if kier='dol' then del:=3;
           put_player(px*15,py*15,del+nr_p);
      if not niemaludka then
      begin
      for i:= ilemaxlud.one to ilemaxlud.two do put_enemy(enemy[i].x*15,enemy[i].y*15,enemy[i].ludek,enemy[i].del+enemy[i].nr);
      end;
           draw_ramka;
      end;
      ramki;
{      rectangle(63,72,173,79,15);
      rectangle(63,81,173,88,15);
      rectangle(63,90,173,97,15);
      rectangle(63,99,173,106,15);
      rectangle(63,108,173,115,15);
      rectangle(63,117,173,124,15);}
      repeat
            mmx:=mousex;
            mmy:=mousey;
            copy_screen(mmx-10,mmy-20,35,35);
            draw_cursor(mmx,mmy);

            pokazgrafike2;
            put_screen(mmx-10,mmy-20,35,35);

            if mousein(mmx,mmy,63,72,173,79) and leftbutton
            and(save_list[1]<>'BRAK ZAPISU') then
            begin
                 delay(400);loadg:=true;
                 if inhome then esc_room:=true;
                 odczyt_gry('data\00000001.sav');
                 pokaz_statusy;godzina;show_kasa;show_zmeczenie;
                 odejmij_zmeczenie;
            end;
            if mousein(mmx,mmy,63,81,173,88) and leftbutton
            and(save_list[2]<>'BRAK ZAPISU') then
            begin
                 delay(400);loadg:=true;
                 if inhome then esc_room:=true;
                 odczyt_gry('data\00000002.sav');
                 pokaz_statusy;godzina;show_kasa;show_zmeczenie;
                 odejmij_zmeczenie;
            end;
            if mousein(mmx,mmy,63,90,173,97) and leftbutton
            and(save_list[3]<>'BRAK ZAPISU') then
            begin
                 delay(400);loadg:=true;
                 if inhome then esc_room:=true;
                 odczyt_gry('data\00000003.sav');
                 pokaz_statusy;godzina;show_kasa;show_zmeczenie;
                 odejmij_zmeczenie;
            end;
            if mousein(mmx,mmy,63,99,173,106) and leftbutton
            and(save_list[4]<>'BRAK ZAPISU') then
            begin
                 delay(400);loadg:=true;
                 if inhome then esc_room:=true;
                 odczyt_gry('data\00000004.sav');
                 pokaz_statusy;godzina;show_kasa;show_zmeczenie;
                 odejmij_zmeczenie;
            end;
            if mousein(mmx,mmy,63,108,173,115) and leftbutton
            and(save_list[5]<>'BRAK ZAPISU') then
            begin
                 delay(400);loadg:=true;
                 if inhome then esc_room:=true;
                 odczyt_gry('data\00000005.sav');
                 pokaz_statusy;godzina;show_kasa;show_zmeczenie;
                 odejmij_zmeczenie;
            end;
            if mousein(mmx,mmy,63,117,173,124) and leftbutton
            and(save_list[6]<>'BRAK ZAPISU') then
            begin
                 delay(400);loadg:=true;
                 if inhome then esc_room:=true;
                 odczyt_gry('data\00000006.sav');
                 pokaz_statusy;godzina;show_kasa;show_zmeczenie;
                 odejmij_zmeczenie;
            end;

      until mousein(mmx,mmy,88,125,142,137) and leftbutton or loadg or esc_room;
      if not esc_room then delay(200);
      if loadg then
      begin
      outtextfntxy2(50,95,8,43,1,1,'WCZYTYWANIE...',font2^);
      outtextfntxy2(50,96,8,14,1,1,'WCZYTYWANIE...',font2^);
      pokazgrafike2;
      delay(300);
      load_map('data\0.map');
      end;
end;

procedure menu_w_grze1;
begin
      draw_screen(maxx,maxy,15);
      draw_ramka;
      if kier='prawo' then del:=5;
      if kier='lewo' then del:=7;
      if kier='gora' then del:=1;
      if kier='dol' then del:=3;
      put_player(105,90,del+nr_p);
      bar(60,50,175,140,219);    {menu}
      rectangle(60,50,175,140,220);
      outtextfntxy2_center(112,53,8,43,1,1,'MENU',font2^);
      outtextfntxy2_center(112,54,8,14,1,1,'MENU',font2^);

      outtextfntxy2_center(110,74,8,43,1,1,'POWR‡T',font2^);
      outtextfntxy2_center(110,86,8,43,1,1,'WCZYTAJ GR®',font2^);
      outtextfntxy2_center(110,122,8,43,1,1,'WYJóCIE',font2^);
      outtextfntxy2_center(110,75,8,14,1,1,'POWR‡T',font2^);
      outtextfntxy2_center(110,87,8,14,1,1,'WCZYTAJ GR®',font2^);
      outtextfntxy2_center(110,123,8,14,1,1,'WYJóCIE',font2^);

{      rectangle(85,74,144,86,15);
      rectangle(65,86,168,98,15);
      rectangle(67,98,166,110,15);
      rectangle(87,110,142,122,15);
      rectangle(83,122,148,134,15);}
      ex:=false;
      show_icony;
      repeat
            mmx:=mousex;
            mmy:=mousey;
            copy_screen(mmx-10,mmy-20,35,35);
            draw_cursor(mmx,mmy);
            pokazgrafike2;
            put_screen(mmx-10,mmy-20,35,35);
            if mousein(mmx,mmy,83,122,148,134)and leftbutton then
            begin
                 escape_game_mapa;
            end;
            if mousein(mmx,mmy,65,86,168,98)and leftbutton then
            begin
            delay(200);
            loadg;
            delay(200);

            ex:=true;
      draw_screen(maxx,maxy,15);
      draw_ramka;
      if kier='prawo' then del:=5;
      if kier='lewo' then del:=7;
      if kier='gora' then del:=1;
      if kier='dol' then del:=3;
      put_player(105,90,del+nr_p);
      badaj_czy_noc;
      bar(60,50,175,140,219);    {menu}
      rectangle(60,50,175,140,220);
      outtextfntxy2_center(112,53,8,43,1,1,'MENU',font2^);
      outtextfntxy2_center(112,54,8,14,1,1,'MENU',font2^);

      outtextfntxy2_center(110,74,8,43,1,1,'POWR‡T',font2^);
      outtextfntxy2_center(110,86,8,43,1,1,'WCZYTAJ GR®',font2^);
      outtextfntxy2_center(110,122,8,43,1,1,'WYJóCIE',font2^);
      outtextfntxy2_center(110,75,8,14,1,1,'POWR‡T',font2^);
      outtextfntxy2_center(110,87,8,14,1,1,'WCZYTAJ GR®',font2^);
      outtextfntxy2_center(110,123,8,14,1,1,'WYJóCIE',font2^);
            end;
      until mousein(mmx,mmy,85,74,144,86) and leftbutton or ex or wyjscie_do_menu;
      if not ex then delay(200);
      if ex then badaj_czy_noc;
{      if ex then
      begin
      outtextfntxy2(50,95,8,43,1,1,'WCZYTYWANIE...',font2^);
      outtextfntxy2(50,96,8,14,1,1,'WCZYTYWANIE...',font2^);
      pokazgrafike2;
      delay(300);
      end;}
end;

procedure menu_w_grze2;
begin
           pokaz_statusy;
           godzina4;
           show_kasa;
           show_zmeczenie;
           draw_room(14,12,15,nr_dom);
           draw_ramka;
           show_icony;
           if kier='prawo' then del:=5;
           if kier='lewo' then del:=7;
           if kier='gora' then del:=1;
           if kier='dol' then del:=3;
           put_player(px*15,py*15,del+nr_p);
      if not niemaludka then
      begin
      for i:= ilemaxlud.one to ilemaxlud.two do put_enemy(enemy[i].x*15,enemy[i].y*15,enemy[i].ludek,enemy[i].del+enemy[i].nr);
      end;

      bar(60,50,175,140,219);    {menu}
      rectangle(60,50,175,140,220);
      outtextfntxy2_center(112,53,8,43,1,1,'MENU',font2^);
      outtextfntxy2_center(112,54,8,14,1,1,'MENU',font2^);

      outtextfntxy2_center(110,74,8,43,1,1,'POWR‡T',font2^);
      outtextfntxy2_center(110,86,8,43,1,1,'WCZYTAJ GR®',font2^);
      outtextfntxy2_center(110,122,8,43,1,1,'WYJóCIE',font2^);
      outtextfntxy2_center(110,75,8,14,1,1,'POWR‡T',font2^);
      outtextfntxy2_center(110,87,8,14,1,1,'WCZYTAJ GR®',font2^);
      outtextfntxy2_center(110,123,8,14,1,1,'WYJóCIE',font2^);

{      rectangle(85,74,144,86,15);
      rectangle(65,86,168,98,15);
      rectangle(67,98,166,110,15);
      rectangle(87,110,142,122,15);
      rectangle(83,122,148,134,15);}
      ex2:=false;
      repeat
            mmx:=mousex;
            mmy:=mousey;
            copy_screen(mmx-10,mmy-20,35,35);
            draw_cursor(mmx,mmy);
            pokazgrafike2;
            put_screen(mmx-10,mmy-20,35,35);
            if mousein(mmx,mmy,83,122,148,134)and leftbutton then
            begin
                 escape_game_room;
            end;
            if mousein(mmx,mmy,65,86,168,98)and leftbutton then
            begin
            delay(200);
            loadg;
            delay(200);
            if not esc_room then
            begin
           pokaz_statusy;
           godzina4;
           show_kasa;
           show_zmeczenie;
           draw_room(14,12,15,nr_dom);
           if kier='prawo' then del:=5;
           if kier='lewo' then del:=7;
           if kier='gora' then del:=1;
           if kier='dol' then del:=3;
           put_player(px*15,py*15,del+nr_p);
      if not niemaludka then
      begin
      for i:= ilemaxlud.one to ilemaxlud.two do put_enemy(enemy[i].x*15,enemy[i].y*15,enemy[i].ludek,enemy[i].del+enemy[i].nr);
      end;
           draw_ramka;
      bar(60,50,175,140,219);    {menu}
      rectangle(60,50,175,140,220);
      outtextfntxy2_center(112,53,8,43,1,1,'MENU',font2^);
      outtextfntxy2_center(112,54,8,14,1,1,'MENU',font2^);

      outtextfntxy2_center(110,74,8,43,1,1,'POWR‡T',font2^);
      outtextfntxy2_center(110,86,8,43,1,1,'WCZYTAJ GR®',font2^);
      outtextfntxy2_center(110,122,8,43,1,1,'WYJóCIE',font2^);
      outtextfntxy2_center(110,75,8,14,1,1,'POWR‡T',font2^);
      outtextfntxy2_center(110,87,8,14,1,1,'WCZYTAJ GR®',font2^);
      outtextfntxy2_center(110,123,8,14,1,1,'WYJóCIE',font2^);
           end;
            end;
{      until mousein(mmx,mmy,85,74,144,86) and leftbutton or esc_room or ex2;}
       until mousein(mmx,mmy,85,74,144,86) and leftbutton or ex2 or wyjscie_do_menu or esc_room;
      if not esc_room then delay(200);
end;

procedure badaj_czy_walka(x, y : integer);
var
   los : word;
begin
{     if mapa[x+7,y+6]in[9..20,32,33,50,51] then}
     begin
          randomize;
          if poziom=0 then los:=random(70);
          if poziom=1 then los:=random(70);
          if poziom=2 then los:=random(60);
          if poziom=3 then los:=random(60);
          if poziom=4 then los:=random(60);
          if poziom=5 then los:=random(50);
          if poziom=6 then los:=random(50);
          if poziom=7 then los:=random(40);
          if poziom=8 then los:=random(40);
          if poziom=9 then los:=random(35);
          if poziom=10 then los:=random(35);
          if poziom=11 then los:=random(33);
          if poziom=12 then los:=random(33);
          if poziom=13 then los:=random(30);
          if poziom=14 then los:=random(30);
          if poziom=15 then los:=random(28);
          if los=11 then
          begin
for i:= 1 to ile_pictures do dispose(pictures[i]);
for i:= 1 to 5 do dispose(tekst[i]);
for i:= 1 to 3 do dispose(bigpic[i]);

delay(200); walka;
for i:= 1 to 3 do new(bigpic[i]);
for i:= 1 to ile_pictures do new(pictures[i]);
for i:= 1 to 5 do new(tekst[i]);
load_pictures_to_memory;
load_stone_to_memory;
background;
draw_screen(maxx,maxy,15);
draw_ramka;
put_player(105,90,del+nr_p);
bar(231,190,315,198,219);
rectangle(231,190,315,198,220);
show_icony;
badaj_czy_noc;
badaj_czy_nie_dostales_next_level;
          end;
     end;
end;

end.