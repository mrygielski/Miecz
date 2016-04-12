
{po zako‰czeniu gry usun•Ü procedury FREEMEM = OK}

{******* Bù®DY W GRY *********}
{poprawiÜ pojawianie si© ramek po pobierzniu przedmiot¢w z plecaka - OK}
{naprawiÜ opisy ikonek - OK}
{naprawiÜ rozmowe sprzedawczyni dom nr 2 - OK}
{DODAè ROZMOWE DO DOMKU NR - 8 - OK}
{naprawiÜ znajdowanie kasy!!!!!!!!!!!!! - OK}
{zrobiÜ zapisywanie gry!!!!! - OK}
{!!!!naprawiÜ wychodzenie ze skrzyni w domku, bada noc?! - OK}
{!!naprawiÜ wychodzenie z domku podczas odczytu gry!!! - OK}
{zrobiÜ aby wyskoczyào okienko jak gdy dostaje poziom - OK}
{naprawiÜ walka, zrobiÜ wi©ksz• iloòÜ wrog¢w - OK}
{dodaÜ wi©cej przeciwnik¢w!!! - OK}
{x23 y62 sprawdzic skrzynie!!! - OK}
{zrobiÜ dzwieki!!!! - OK}
{!!naprawiÜ spanie - OK}
{jak spi na dworzu to atak - OK}
{zrobiÜ dzwi©ki - OK}

{wolna pamieÜ 185 z font}
{wolna pamieÜ 212 z font2}

uses crt, supergfx, games, dgtpu, dgtpu2, load_snd, dos, smix;

procedure load_logo(x, y : integer);
var xx,yy:integer;
    F:File of byte;
    b:Byte;
begin
     assign(f,'graphics\logo');
     reset(f);
     for xx:=0 to 119 do
     for yy:=0 to 49 do
     begin
          read(f,b);
          if b<>255 then putpixel(xx+x,yy+y,b);
     end;
     close(f);
end;

procedure load_poch(x, y : integer);
var xx,yy:integer;
    F:File of byte;
    b:Byte;
begin
     assign(f,'graphics\pochod');
     reset(f);
     for xx:=0 to 29 do
     for yy:=0 to 49 do
     begin
          read(f,b);
          if (b<>17)and(b<>18)and(b<>255) then putpixel(xx+x,yy+y,b);
      end;
     close(f);
end;

procedure openregilogo(x, y : integer; name : string);


var
   f : file of byte;
   b : byte;
   ax, ay : integer;
   rx, ry : byte;
   c : byte;
begin
     assign(f,name);
     reset(f);
     read(f,rx);
     read(f,ry);
     c:=0;
     for ay:= 0 to ry-1 do
     for ax:= 0 to rx-1 do
     begin
          read(f,b);
          c:=c+1;
          putpixel(ax+x,ay+y-1,b);
          line(ax+x,ay+y-1,ax+x,200,b);
          if c=40 then begin pokazgrafike2; c:=0; end;
     end;
     close(f);
end;

procedure game_info;
begin
bar(100,70,220,170,0);
outtextfntxy2_center(152,89,5,113,1,1,'Zaginiony Miecz '+versjagry,font3^);
outtextfntxy2_center(152,90,5,115,1,1,'Zaginiony Miecz '+versjagry,font3^);
outtextfntxy2_center(158,109,5,113,1,1,'autor',font3^);
outtextfntxy2_center(158,110,5,115,1,1,'autor',font3^);
outtextfntxy2_center(156,125,5,113,1,1,'Michaà Rygielski',font3^);
outtextfntxy2_center(156,126,5,115,1,1,'Michaà Rygielski',font3^);
outtextfntxy2_center(156,140,5,113,1,1,'http://rpage.prv.pl',font3^);
outtextfntxy2_center(156,141,5,115,1,1,'http://rpage.prv.pl',font3^);
outtextfntxy2_center(153,150,5,113,1,1,'email://rpage@poczta.onet.pl',font3^);
outtextfntxy2_center(153,151,5,115,1,1,'email://rpage@poczta.onet.pl',font3^);
outtextfntxy2_center(155,164,8,113,1,1,'POWR‡T',font2^);
outtextfntxy2_center(155,165,8,115,1,1,'POWR‡T',font2^);
repeat
      mmx:=mousex;
      mmy:=mousey;
      line(55,69,75,69,30);
      line(55,68,75,68,30);
      line(55,67,75,67,30);
      fire(40,30,90,69);
      line(55+190,69,75+190,69,30);
      line(55+190,68,75+190,68,30);
      line(55+190,67,75+190,67,30);
      fire(40+190,30,90+190,69);
      copy_screen(mmx-10,mmy-20,35,35);
      draw_cursor(mmx,mmy);
      pokazgrafike2;
      put_screen(mmx-10,mmy-20,35,35);

until mousein(mmx,mmy,130,163,190,178)and(leftbutton);
bar(100,70,220,179,0);
bar(80,130,247,170,0);
outtextfntxy2_center(155,89,8,113,1,1,'NOWA GRA',font2^);
outtextfntxy2_center(155,90,8,115,1,1,'NOWA GRA',font2^);
outtextfntxy2_center(155,109,8,113,1,1,'O GRZE',font2^);
outtextfntxy2_center(155,110,8,115,1,1,'O GRZE',font2^);
outtextfntxy2_center(155,129,8,113,1,1,'KONIEC',font2^);
outtextfntxy2_center(155,130,8,115,1,1,'KONIEC',font2^);
outtextfntxy2_center(135,190,3,251,1,1,'ZAGINIONY MIECZ '+versjagry+' BY MICHAù /REGI/ RYGIELSKI ROK 2002',font^);
end;

procedure draw_menu;
begin
if paramstr(1)<>'/sp' then
begin
ellipse(160,60,157,50,251);
rectangle(2,60,317,180,251);
bar(3,60,316,179,0);
putpixel(0,0,249);
flood(160,1,249);
end;
load_poch(50,70);
load_poch(50+190,70);
{polygon(50,70,80,70,65,120,65,120,244);
polygon(50+190,70,80+190,70,65+190,120,65+190,120,244);}
outtextfntxy2_center(155,89,8,113,1,1,'NOWA GRA',font2^);
outtextfntxy2_center(155,90,8,115,1,1,'NOWA GRA',font2^);
outtextfntxy2_center(155,109,8,113,1,1,'O GRZE',font2^);
outtextfntxy2_center(155,110,8,115,1,1,'O GRZE',font2^);
outtextfntxy2_center(155,129,8,113,1,1,'KONIEC',font2^);
outtextfntxy2_center(155,130,8,115,1,1,'KONIEC',font2^);
outtextfntxy2_center(135,190,3,251,1,1,'ZAGINIONY MIECZ '+versjagry+' BY MICHAù /REGI/ RYGIELSKI ROK 2002',font^);
{RECTANGLE(100,20,220,70,0);}
load_logo(100,20);
for i:= 1 to 32 do setcolor(i,i * 2,i,0);
end;

procedure isnt_files;
procedure czy_jest(name, path : string);
begin
     if is_file(name+path) then write('.') else
     begin
          writeln;
          writeln('ERROR FILE= '+name+path);
          halt;
     end;
end;
begin
if not is_file('data\setup.cfg') then
begin
     writeln('Najpierw uruchom SETUP.EXE!');
     halt;
end;
textbackground(0);
textcolor(7);
Asm
   Mov Cx,0F00H
   Mov Ah,1
   Int 10H
End;
writeln;
writeln('ZAGINIONU MIECZ v'+versjagry+' by MICHAù /REGi/ RYGIELSKI');
writeln('-----------------------------------------------');
writeln;
if not initmouse then
begin
     writeln('INICJACJA MYSZY= FALSE');
     halt;
end else writeln('INICJACJA MYSZY= TRUE');
writeln('SPRAWDZANIE PLIK‡W= ');
     czy_jest('graphics\','1'); {01}
     czy_jest('graphics\','2'); {02}
     czy_jest('graphics\','3'); {03}
     czy_jest('graphics\','4'); {04}
     czy_jest('graphics\','5'); {05}
     czy_jest('graphics\','6'); {06}
     czy_jest('graphics\','7'); {07}
     czy_jest('graphics\','8'); {08}
     czy_jest('graphics\','grass1');       {09}
     czy_jest('graphics\','grass2');       {10}
     czy_jest('graphics\','grass3');       {11}
     czy_jest('graphics\','grass0');       {12}
     czy_jest('graphics\','grass1a');      {13}
     czy_jest('graphics\','grass1aa');     {14}
     czy_jest('graphics\','grass1b');      {15}
     czy_jest('graphics\','grass1bb');     {16}
     czy_jest('graphics\','grass1c');      {17}
     czy_jest('graphics\','grass1cc');     {18}
     czy_jest('graphics\','grass1d');      {19}
     czy_jest('graphics\','grass1dd');     {20}
     czy_jest('graphics\','tree1');        {21}
     czy_jest('graphics\','tree2');        {22}
     czy_jest('graphics\','tree3');        {23}
     czy_jest('graphics\','tree4');        {24}
     czy_jest('graphics\','tree5');        {25}
     czy_jest('graphics\','woda1');        {26}
     czy_jest('graphics\','woda2');        {27}
     czy_jest('graphics\','woda3');        {28}
     czy_jest('graphics\','woda4');        {29}
     czy_jest('graphics\','woda5');        {30}
     czy_jest('graphics\','woda6');        {31}
     czy_jest('graphics\','woda5_');       {32}
     czy_jest('graphics\','woda6_');       {33}
     czy_jest('graphics\','1p');    {34}
     czy_jest('graphics\','a');    {35}
     czy_jest('graphics\','b');    {36}
     czy_jest('graphics\','c');    {37}
     czy_jest('graphics\','d');    {38}
     czy_jest('graphics\','2p');    {39}
     czy_jest('graphics\','1g');       {40}
     czy_jest('graphics\','2g');       {41}
     czy_jest('graphics\','3g');       {42}
     czy_jest('graphics\','4g');       {43}
     czy_jest('graphics\','5g');       {44}
     czy_jest('graphics\','6g');       {45}
     czy_jest('graphics\','7g');       {46}
     czy_jest('graphics\','8g');       {47}
     czy_jest('graphics\','9');       {48}
     czy_jest('graphics\','10');      {49}
     czy_jest('graphics\','00');      {50}
     czy_jest('graphics\','0');       {51}
     czy_jest('graphics\','ag');       {52}
     czy_jest('graphics\','aa');      {53}
     czy_jest('graphics\','bb');      {54}
     czy_jest('graphics\','f');       {55}
     czy_jest('graphics\','j');       {56}
     czy_jest('graphics\','l');       {57}
     czy_jest('graphics\','n');       {58}
     czy_jest('graphics\','p');       {59}
     czy_jest('graphics\','w');       {60}
     czy_jest('graphics\','x');       {61}
     czy_jest('graphics\','right');   {62}
     czy_jest('graphics\','left');    {63}
     czy_jest('graphics\','up');      {64}
     czy_jest('graphics\','down');    {65}
     czy_jest('graphics\','black');   {66}
     czy_jest('graphics\','ff');      {67}
     czy_jest('graphics\','1m');      {68}
     czy_jest('graphics\','2m');      {69}
     czy_jest('graphics\','3m');      {70}
     czy_jest('graphics\','4m');      {71}
     czy_jest('graphics\','5m');      {72}
     czy_jest('graphics\','6m');      {73}
     czy_jest('graphics\','7m');      {74}
     czy_jest('graphics\','8m');      {75}
     czy_jest('graphics\','10m');     {76}
     czy_jest('graphics\','11m');     {77}
     czy_jest('graphics\','12m');     {78}
     czy_jest('graphics\','13m');     {79}
     czy_jest('graphics\','14m');     {80}
     czy_jest('graphics\','15m');     {81}
     czy_jest('graphics\','16m');     {82}
     czy_jest('graphics\','17m');     {83}
     czy_jest('graphics\','18m');     {84}
     czy_jest('graphics\','19m');     {85}
     czy_jest('graphics\','20m');     {86}
     czy_jest('graphics\','21m');     {87}
     czy_jest('graphics\','22m');     {88}
     czy_jest('graphics\','fff');     {89}
     czy_jest('graphics\','beczka');       {90}
     czy_jest('graphics\','studnia');      {91}
     czy_jest('graphics\','dom1_');  {92}
     czy_jest('graphics\','dom1__'); {93}
     czy_jest('graphics\','dom2_');  {94}
     czy_jest('graphics\','dom2__'); {95}
     czy_jest('graphics\','dom3_');  {96}
     czy_jest('graphics\','dom3__'); {97}
     czy_jest('graphics\','dom4_');  {98}
     czy_jest('graphics\','dom4__'); {99}
     czy_jest('graphics\','dom4___');{100}
     czy_jest('graphics\','dom5_');  {101}
     czy_jest('graphics\','dom5__'); {102}
     czy_jest('graphics\','e');    {103}
     czy_jest('graphics\','f');    {104}
     czy_jest('graphics\','znak');   {105}
     czy_jest('graphics\','1h');        {106}
     czy_jest('graphics\','2h');        {107}
     czy_jest('graphics\','3h');        {108}
     czy_jest('graphics\','4h');        {109}
     czy_jest('graphics\','5h');        {110}
     czy_jest('graphics\','6h');        {111}
     czy_jest('graphics\','7h');        {112}
     czy_jest('graphics\','8h');        {113}
     czy_jest('graphics\','9h');        {114}
     czy_jest('graphics\','10h');       {115}
     czy_jest('graphics\','1n');        {116}
     czy_jest('graphics\','2n');        {117}
     czy_jest('graphics\','3n');        {118}
     czy_jest('graphics\','4n');        {119}
     czy_jest('graphics\','5n');        {120}
     czy_jest('graphics\','6n');        {121}
     czy_jest('graphics\','7n');        {122}
     czy_jest('graphics\','8n');        {123}
     czy_jest('graphics\','9n');        {124}
     czy_jest('graphics\','10n');       {125}
     czy_jest('graphics\','11n');       {126}
     czy_jest('graphics\','12n');       {127}
     czy_jest('graphics\','13n');       {128}
     czy_jest('graphics\','14n');       {129}
     czy_jest('graphics\','15n');       {130}
     czy_jest('graphics\','16n');       {131}
     czy_jest('graphics\','17n');       {132}
     czy_jest('graphics\','18n');       {133}
     czy_jest('graphics\','19n');       {134}
     czy_jest('graphics\','20n');       {135}
     czy_jest('graphics\','21n');       {136}
     czy_jest('graphics\','22n');       {137}
     czy_jest('graphics\','23n');       {138}
     czy_jest('graphics\','24n');       {139}
     czy_jest('graphics\','25n');       {140}
     czy_jest('graphics\','26n');       {141}
     czy_jest('graphics\','27n');       {142}
     czy_jest('graphics\','28n');       {143}
     czy_jest('graphics\','29n');       {144}
     czy_jest('graphics\','30n');       {145}
     czy_jest('graphics\','31n');       {146}
     czy_jest('graphics\','lud1a');{147}
     czy_jest('graphics\','lud1b');{148}
     czy_jest('graphics\','lud1c');{149}
     czy_jest('graphics\','lud1d');{150}
     czy_jest('graphics\','lud1e');{151}
     czy_jest('graphics\','lud1f');{152}
     czy_jest('graphics\','lud1g');{153}
     czy_jest('graphics\','lud1h');{154}
     czy_jest('graphics\','lud2a');{155}
     czy_jest('graphics\','lud2b');{156}
     czy_jest('graphics\','lud2c');{157}
     czy_jest('graphics\','lud2d');{158}
     czy_jest('graphics\','lud2e');{159}
     czy_jest('graphics\','lud2f');{160}
     czy_jest('graphics\','lud2g');{161}
     czy_jest('graphics\','lud2h');{162}
     czy_jest('graphics\','lud3a');{163}
     czy_jest('graphics\','lud3b');{164}
     czy_jest('graphics\','lud3c');{165}
     czy_jest('graphics\','lud3d');{166}
     czy_jest('graphics\','lud3e');{167}
     czy_jest('graphics\','lud3f');{168}
     czy_jest('graphics\','lud3g');{169}
     czy_jest('graphics\','lud3h');{170}
     czy_jest('graphics\','lud4a');{171}
     czy_jest('graphics\','lud4b');{172}
     czy_jest('graphics\','lud4c');{173}
     czy_jest('graphics\','lud4d');{174}
     czy_jest('graphics\','lud4e');{175}
     czy_jest('graphics\','lud4f');{176}
     czy_jest('graphics\','lud4g');{177}
     czy_jest('graphics\','lud4h');{178}
     czy_jest('graphics\','lud5a');{179}
     czy_jest('graphics\','lud5b');{180}
     czy_jest('graphics\','lud5c');{181}
     czy_jest('graphics\','lud5d');{182}
     czy_jest('graphics\','lud5e');{183}
     czy_jest('graphics\','lud5f');{184}
     czy_jest('graphics\','lud5g');{185}
     czy_jest('graphics\','lud5h');{186}
     czy_jest('graphics\','lud6a');{187}
     czy_jest('graphics\','lud6b');{188}
     czy_jest('graphics\','lud6c');{189}
     czy_jest('graphics\','lud6d');{190}
     czy_jest('graphics\','lud6e');{191}
     czy_jest('graphics\','lud6f');{192}
     czy_jest('graphics\','lud6g');{193}
     czy_jest('graphics\','lud6h');{194}
     czy_jest('graphics\','lud7a');{195}
     czy_jest('graphics\','lud7b');{196}
     czy_jest('graphics\','lud7c');{197}
     czy_jest('graphics\','lud7d');{198}
     czy_jest('graphics\','lud7e');{199}
     czy_jest('graphics\','lud7f');{200}
     czy_jest('graphics\','lud7g');{201}
     czy_jest('graphics\','lud7h');{202}
     czy_jest('graphics\','lud8a');{203}
     czy_jest('graphics\','lud8b');{204}
     czy_jest('graphics\','lud8c');{205}
     czy_jest('graphics\','lud8d');{206}
     czy_jest('graphics\','lud8e');{207}
     czy_jest('graphics\','lud8f');{208}
     czy_jest('graphics\','lud8g');{209}
     czy_jest('graphics\','lud8h');{210}
     czy_jest('graphics\','lud9a');{211}
     czy_jest('graphics\','lud9b');{212}
     czy_jest('graphics\','lud9c');{213}
     czy_jest('graphics\','lud9d');{214}
     czy_jest('graphics\','lud9e');{215}
     czy_jest('graphics\','lud9f');{216}
     czy_jest('graphics\','lud9g');{217}
     czy_jest('graphics\','lud9h');{218}
     czy_jest('graphics\','lud10a');{219}
     czy_jest('graphics\','lud10b');{220}
     czy_jest('graphics\','lud10c');{221}
     czy_jest('graphics\','lud10d');{222}
     czy_jest('graphics\','lud10e');{223}
     czy_jest('graphics\','lud10f');{224}
     czy_jest('graphics\','lud10g');{225}
     czy_jest('graphics\','lud10h');{226}
     czy_jest('graphics\','flaga2');   {227}
     czy_jest('graphics\','flaga');         {228}
     czy_jest('graphics\','lost');     {229}
     czy_jest('graphics\','1i'); {01}
     czy_jest('graphics\','2i'); {02}
     czy_jest('graphics\','3i'); {03}
     czy_jest('graphics\','4i'); {04}
     czy_jest('graphics\','5i'); {05}
     czy_jest('graphics\','6i'); {06}
     czy_jest('graphics\','7i'); {07}
     czy_jest('graphics\','8i'); {08}
     czy_jest('graphics\','9i'); {09}
     czy_jest('graphics\','10i');{10}
     czy_jest('graphics\','11i');{11}
     czy_jest('graphics\','12i');{12}
     czy_jest('graphics\','13i');{13}
     czy_jest('graphics\','14i');{14}
     czy_jest('graphics\','15i');{15}
     czy_jest('graphics\','16i');{16}
     czy_jest('graphics\','17i');{17}
     czy_jest('graphics\','18i');{18}
     czy_jest('graphics\','19i');{19}
     czy_jest('graphics\','20i');{20}
     czy_jest('graphics\','21i');{21}
     czy_jest('graphics\','22i');{22}
     czy_jest('graphics\','23i');{23}
     czy_jest('graphics\','24i');{24}
     czy_jest('graphics\','25i');{25}
     czy_jest('graphics\','26i');{26}
     czy_jest('graphics\','27i');{27}
     czy_jest('graphics\','28i');{28}
     czy_jest('graphics\','29i');{29}
     czy_jest('graphics\','30i');{30}
     czy_jest('graphics\','31i');{31}
     czy_jest('graphics\','32i');{32}
     czy_jest('graphics\','33i');{33}
     czy_jest('graphics\','34i');{34}
     czy_jest('graphics\','35i');{35}
     czy_jest('graphics\','36i');{36}
     czy_jest('graphics\','37i');{37}
     czy_jest('graphics\','38i');{38}
     czy_jest('graphics\','39i');{39}
     czy_jest('graphics\','40i');{40}
     czy_jest('graphics\','41i');{41}
     czy_jest('graphics\','42i');{42}
     czy_jest('graphics\','43i');{43}
     czy_jest('graphics\','44i');{44}
     czy_jest('graphics\','45i');{45}
     czy_jest('graphics\','46i');{46}
     czy_jest('graphics\','kamien');
     czy_jest('graphics\','ludek');
     czy_jest('graphics\','piorun');
     czy_jest('graphics\','gold.pal');
     czy_jest('graphics\','noc1.pal');
     czy_jest('graphics\','noc2.pal');
     czy_jest('graphics\','noc2.pal');
     czy_jest('graphics\','noc4.pal');
     czy_jest('graphics\','noc6.pal');
     czy_jest('graphics\','noc6.pal');
     czy_jest('graphics\','noc7.pal');
     czy_jest('graphics\','lud1');
     czy_jest('graphics\','lud2');
     czy_jest('graphics\','lud3');
     czy_jest('graphics\','lud4bb');
     czy_jest('graphics\','lud5bb');
     czy_jest('graphics\','lud6bb');
     czy_jest('graphics\','lud7bb');
     czy_jest('graphics\','wrog1');
     czy_jest('graphics\','wrog2');
     czy_jest('graphics\','wrog3');
     czy_jest('graphics\','wrog1a');
     czy_jest('graphics\','wrog2a');
     czy_jest('graphics\','wrog3a');
     czy_jest('graphics\','wrog1b');
     czy_jest('graphics\','wrog2b');
     czy_jest('graphics\','wrog3b');
     czy_jest('graphics\','wrog1c');
     czy_jest('graphics\','wrog2c');
     czy_jest('graphics\','wrog3c');
     czy_jest('graphics\','bos1');
     czy_jest('graphics\','bos3');
     czy_jest('graphics\','bos2');
     czy_jest('data\','ramka.cfg');
     czy_jest('data\','text.dat');
     czy_jest('data\','0.map');
     czy_jest('data\','1.map');
     czy_jest('data\','big.fnt');
     czy_jest('data\','new.fnt');
     czy_jest('data\','small.fnt');
     czy_jest('data\','namedom.dom');
     czy_jest('data\','roomdata.rom');
     czy_jest('data\','saves.dat');
     czy_jest('data\','took.dat');
     czy_jest('data\','move.dat');
     czy_jest('sounds\','sound1.snd');
     czy_jest('sounds\','sound2.snd');
     czy_jest('sounds\','sound3.snd');
     czy_jest('sounds\','sound4.snd');
     czy_jest('sounds\','sound5.snd');
     czy_jest('sounds\','sound6.snd');
     czy_jest('sounds\','sound7.snd');
     czy_jest('sounds\','sound8.snd');
     czy_jest('sounds\','sound9.snd');
     czy_jest('sounds\','sound10.snd');
     czy_jest('sounds\','sound11.snd');
     czy_jest('sounds\','sound12.snd');
     czy_jest('sounds\','sound13.snd');
     czy_jest('sounds\','sound14.snd');
     czy_jest('sounds\','sound15.snd');
     czy_jest('sounds\','sound16.snd');
     write('OK');
     delay(200);
end;

begin
isnt_files;
loadsetup;
delay(300);
initgfx13h;
initnewkeyint;
new(font);new(font2);new(font3);
new_font2('data\new.fnt',font^);
new_font2('data\big.fnt',font2^);
new_font2('data\small.fnt',font3^);
if paramstr(1)<>'/sp' then
begin
outtextfntxy2(125,3,5,20,1,1,'RRAGE.PRV.PL',font3^);
outtextfntxy2(125,4,5,21,1,1,'RRAGE.PRV.PL',font3^);
outtextfntxy2(125,5,5,22,1,1,'RRAGE.PRV.PL',font3^);
openregilogo(70,40,'graphics\regi.gfx');
delay(500);
bar(0,0,319,199,0);
pokazgrafike2;
end;
loadpal('graphics\gold.pal');
setmousewindow(0,0,307,198);
setmousepos(165,100);
{bar(20,20,300,180,0);
bar(60,70,65,120,144);}

draw_menu;

{sounds:=true;}

repeat
      mmx:=mousex;
      mmy:=mousey;
      line(55,69,75,69,30);
      line(55,68,75,68,30);
      line(56,67,74,67,30);
      line(56,66,74,66,30);
      line(57,65,73,65,30);
      fire(40,50,90,69);
      line(55+190,69,75+190,69,30);
      line(55+190,68,75+190,68,30);
      line(56+190,67,74+190,67,30);
      line(56+190,66,74+190,66,30);
      line(57+190,65,73+190,65,30);
      fire(40+190,50,90+190,69);
      copy_screen(mmx-10,mmy-20,35,35);
      draw_cursor(mmx,mmy);
      pokazgrafike2;
      put_screen(mmx-10,mmy-20,35,35);

      if mousein(mmx,mmy,122,89,200,103)and(leftbutton) then
      begin
           dispose(font3);
           bar(0,0,319,199,0);
           outtextfntxy2_center(155,95,8,43,1,1,'ùADOWANIE...',font2^);
           outtextfntxy2_center(155,96,8,44,1,1,'ùADOWANIE...',font2^);
           pokazgrafike2;
           delay(500);
           gra;
           cls(0);
           new(font3);
           new_font2('data\small.fnt',font3^);
           draw_menu;
           pokazgrafike2;
           loadpal('graphics\gold.pal');
           for i:= 1 to 32 do setcolor(i,i * 2,i,0);
      end;
      if mousein(mmx,mmy,130,109,190,123)and(leftbutton) then game_info;

until mousein(mmx,mmy,130,129,190,143)and(leftbutton);
{gra;}
dispose(font);dispose(font2);
dispose(font3);
{dispose(cols);}
setoldkeyint;
closegfx13h;
Asm
   Mov Cx,0F10H
   Mov Ah,1
   Int 10H
End;
writeln(#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9);
writeln('ZAGINIONY MIECZ v'+versjagry+' by MICHAù /REGi/ RYGIELSKI');
writeln(#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9);
writeln('http://rpage.prv.pl');
writeln('email:rpage@poczta.onet.pl');
writeln('      regi007@poczta.onet.pl');
end.