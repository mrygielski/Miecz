
unit dgtpu;

interface

uses supergfx, games, load_snd, dos;

const
     versjagry = '1.2';

     cur : array[1..10, 1..11] of byte =
     ((0,0,238,238,238,0,0,0,0,0,0),
      (0,0,238,237,238,0,0,0,0,0,0),
      (0,0,238,237,238,0,0,0,0,0,0),
      (238,238,238,237,238,238,238,238,238,238,238),
      (238,237,238,237,238,237,238,237,238,237,238),
      (238,237,238,237,238,237,238,237,238,237,238),
      (238,237,238,237,238,237,238,237,238,237,238),
      (238,237,237,237,237,237,237,237,237,237,238),
      (238,237,237,237,237,237,237,237,237,237,238),
      (238,238,238,238,238,238,238,238,238,238,238));
     ile_pictures = 229;
     ile_items = 47;
     ile_skrzyn = 20;
     ile_walka = 11;
{     ile_wrog = 1;}
     maxx = 14;
     maxy = 12;
     maxlud = 21;
     ile_sound = 8;
     ile_rozm = 24;

type
    Tmap = array[1..114, 1..112] of byte;
    Troom = array[1..15, 1..13] of byte;
    Tpicture = array[1..15, 1..15] of byte;
    Titems = array[1..25, 1..25] of byte;
    Tstone = array[1..180, 1..160] of byte;
    Tramka = array[1..240] of record
                                    odchyl : shortint;
                                    col : byte;
                              end;
    Tdomki = array[1..20] of record
                                 x, y : integer;
                                 name : string[20];
                             end;
    Troom_all = array[1..20] of record
                                      name : string[20];
                                      domek : Troom;
                                end;
    Tenemy = record
                   x, y : integer;
                   nr, del, ludek, speed : byte;
                   minx, maxx, miny, maxy : byte;
                   move : boolean;
                   kier : string[1];
             end;
    Ttekst = record
                   linijka : array[1..11] of string[40];
             end;
    Tskrzynia = array[1..5, 1..4] of byte;

    Tzapis = record
                  tytul_rozmowy : string[10];
                  zdanie : array[1..5] of string[52];
            end;
    Tzz = ^Tzapis;
    Tsavetook = array[1..ile_rozm] of Tzapis;

    Tsave_game = record
                       x, y : integer; {pozycja na mapie}
                       teren : string[6]; {powierzchnia czy tunele}
                       dosw, nextdosw : longint;
                       poziom, szczescie : byte;
                       atak, ataktmp : integer;
                       obrona, obronatmp : integer;
                       zmeczenie, maxzmeczenie : shortint;
                       zrecznosc, zrecznosctmp : integer;
                       last_killed : string;
                       zyciemin, zycie, ile_killed, zycietmp : integer;
                       kier : string;
                       plecak : array[1..8] of byte;
                       skrzynia : array[1..ile_skrzyn] of Tskrzynia;
                       kasa : double;
                       del, nr_p, nrp : byte;
                       minimap : boolean;
                       g, m : word;
                       s : real;
                 end;
    Tsave_list = array[1..6] of string[31];
    Tmove = array[1..230, 1..50] of byte;
    TCfg = record
                 nazwa : string[5];
                 opcja : byte;
           end;

var
   qx, qy : integer;
   move_col : ^Tmove;
   esc_room : boolean;
   save_list : Tsave_list;
   fff : file of Tsave_list;
   fsave : file of Tsave_game;
   save : Tsave_game;

   licznik : byte;

   tempsound : array[1..ile_sound] of pointer;
   sound : array[1..ile_sound] of word;
   sounds : boolean;
   pictures : array[1..ile_pictures] of ^Tpicture;
   items : array[1..ile_items] of ^Titems;
   bigpic : array[1..3] of ^Tstone;
   ramkax, ramkay : Tramka;
   mapa : Tmap;
   room_all : Troom_all;
   mx, my, tmpx, tmpy : integer;
   open : array[1..ile_skrzyn] of boolean;
{   wrog : array[1..ile_wrog] of ^Twrog;}
   dosw, nextdosw : longint;
   poziom, szczescie : byte;
   atak, ataktmp : integer;
   doataku : array[1..5] of integer;
   obrona, obronatmp : integer;
   zmeczenie, maxzmeczenie : shortint;
   doobrony : array[1..5] of integer;
   zrecznosc, zrecznosctmp : integer;
   dozrecznosci : array[1..5] of integer;
   opis_ico, last_killed : string;
   zyciemin, zycie, ile_killed, zycietmp : integer;
   dozycia : array[1..5] of word;
   speed : byte;
   nrp : byte;
   minimap : boolean;
   nr_p : byte;
   kier : string;
   del : byte;
   i, j : integer;
   mapa_ : string;
   fdom : file of Tdomki;
   dom : Tdomki;
   f2 : file of Troom_all;
   px, py, nr_dom : integer;
   aa : integer;
   font, font2, font3 : ^Tfont2;
   f : file of Ttekst;
   tekst : array[1..5] of ^Ttekst;
   enemy : array[1..maxlud] of Tenemy;
   ilemaxlud : record
                     one, two : byte;
               end;
   plecak : array[1..8] of byte;
   skrzynia : array[1..ile_skrzyn] of Tskrzynia;
   items_typ : array[1..ile_items] of record
                                            typ : string[5];
                                            nazwa : string[40];
                                            atak, maxatak : integer;
                                            doataku, dozrecznosci : integer;
                                            obrona : integer;
                                            zycie : integer;
                                            magia : boolean;
                                            zaklecie : string[30];
                                            info : string[40];
                                      end;
   dodawaj : array[1..5] of record
                                  atak : byte;
                                  obrona : byte;
                            end;
   mmx, mmy : integer;
   niemaludka : boolean;
   kasa : double;
   pal : tpalette;
   g, m : word;
   s : real;
   gg, mm, ss : string;
   sp : array[1..4] of byte;
   inhome : boolean;
   f_took : file of Tsavetook;
   z_took : Tsavetook;
   zd : array[1..5, 1..ile_rozm] of boolean;
   od : integer;
   czy_gracz_ma_bron : boolean;
   wyjscie_do_menu : boolean;
   ex, ex2 : boolean;
   fset : file of TCfg;
   setup : TCfg;

procedure load_pictures_to_memory;
procedure load_items_to_memory;
procedure load_stone_to_memory;
{procedure load_wrog_to_memory;}
procedure load_map(name : string);
procedure save_map(name : string);
procedure draw_picture(x, y : integer; nr : byte);
procedure draw_item(x, y : integer; nr : byte);
procedure draw_bigpic(x, y : integer; var pic : Tstone);
{procedure draw_wrog(x, y : integer; nr : byte);}
procedure draw_screen(d, s, r : byte);
procedure draw_room(d, s, r, nr : byte);
procedure reset_map;
procedure draw_ramka;
procedure load_ramka;
procedure reset_ramka;
procedure load_room(name : string);
procedure draw_cursor(x, y : integer);
procedure info_items;
procedure pokaz_info_w_plecaku(x, y, d, s : integer; nr : byte);
procedure button(x, y : integer; symbol : string);
procedure show_pic(x, y : integer; nr : byte);
procedure background;
procedure put_player(x, y : integer; nr : byte);
procedure put_enemy(x, y : integer; nr_e, nr : byte);
function badaj_teren(x, y : integer) : boolean;
procedure pokaz_skrzynie(x, y : integer; o, nr : byte);
procedure pokaz_skrzynie_map(x, y : integer; o : byte);
{procedure in_room;}
procedure zaladuj_textdata;
procedure info(name : string);
procedure ustaw_enemies;
procedure page_game; {skrzynia}
procedure page_skrzynia(nrskrzyni : byte); {skrzynia}
procedure strony_info;
{procedure info_ico(x, y, d, s : integer; info : string);}
function info_ico(x, y, d, s : integer; info : string) : boolean;
procedure show_icony;
procedure show_kasa;
procedure ustaw_skrzynie_i_plecak;
procedure godzina;  {na mapie}
procedure godzina2; {plecak i skrzynia}
procedure godzina3; {w domku}
procedure godzina4; {same ramki}
procedure badaj_czy_noc;
procedure badaj_czy_nie_znalazles_kasy(x, y : integer);
procedure pokaz_rozmowe(nr_rozmowy, ilosc_zdan : byte);
procedure load_to_memory_took(name : string);
procedure pokaz_mowce(nr_, ilosc_ : byte);
procedure pokaz_statusy;
procedure show_zmeczenie;
{procedure walka;}
procedure zapis_gry(nazwa : string);
procedure odczyt_gry(nazwa : string);
procedure saveg;
procedure initsound_game;
procedure closesound_game;
procedure initsound_walka;
procedure closesound_walka;
procedure initsound_room;
procedure closesound_room;
procedure initsound_skrzynia;
procedure closesound_skrzynia;
procedure escape_game_mapa;
procedure escape_game_room;
procedure loadsetup;

implementation

procedure load_pictures_to_memory;

var
   f : file of Tpicture;
   ile : integer;

procedure load_picture(path, name : string);
begin
     inc(ile);
     assign(f,path+name);
     reset(f);
     read(f,pictures[ile]^);
     close(f);
end;

begin
     ile:=0;
     load_picture('graphics\','1'); {01}
     load_picture('graphics\','2'); {02}
     load_picture('graphics\','3'); {03}
     load_picture('graphics\','4'); {04}
     load_picture('graphics\','5'); {05}
     load_picture('graphics\','6'); {06}
     load_picture('graphics\','7'); {07}
     load_picture('graphics\','8'); {08}
     load_picture('graphics\','grass1');       {09}
     load_picture('graphics\','grass2');       {10}
     load_picture('graphics\','grass3');       {11}
     load_picture('graphics\','grass0');       {12}
     load_picture('graphics\','grass1a');      {13}
     load_picture('graphics\','grass1aa');     {14}
     load_picture('graphics\','grass1b');      {15}
     load_picture('graphics\','grass1bb');     {16}
     load_picture('graphics\','grass1c');      {17}
     load_picture('graphics\','grass1cc');     {18}
     load_picture('graphics\','grass1d');      {19}
     load_picture('graphics\','grass1dd');     {20}
     load_picture('graphics\','tree1');        {21}
     load_picture('graphics\','tree2');        {22}
     load_picture('graphics\','tree3');        {23}
     load_picture('graphics\','tree4');        {24}
     load_picture('graphics\','tree5');        {25}
     load_picture('graphics\','woda1');        {26}
     load_picture('graphics\','woda2');        {27}
     load_picture('graphics\','woda3');        {28}
     load_picture('graphics\','woda4');        {29}
     load_picture('graphics\','woda5');        {30}
     load_picture('graphics\','woda6');        {31}
     load_picture('graphics\','woda5_');       {32}
     load_picture('graphics\','woda6_');       {33}
     load_picture('graphics\','1p');    {34}
     load_picture('graphics\','a');    {35}
     load_picture('graphics\','b');    {36}
     load_picture('graphics\','c');    {37}
     load_picture('graphics\','d');    {38}
     load_picture('graphics\','2p');    {39}
     load_picture('graphics\','1g');       {40}
     load_picture('graphics\','2g');       {41}
     load_picture('graphics\','3g');       {42}
     load_picture('graphics\','4g');       {43}
     load_picture('graphics\','5g');       {44}
     load_picture('graphics\','6g');       {45}
     load_picture('graphics\','7g');       {46}
     load_picture('graphics\','8g');       {47}
     load_picture('graphics\','9');       {48}
     load_picture('graphics\','10');      {49}
     load_picture('graphics\','00');      {50}
     load_picture('graphics\','0');       {51}
     load_picture('graphics\','ag');       {52}
     load_picture('graphics\','aa');      {53}
     load_picture('graphics\','bb');      {54}
     load_picture('graphics\','f');       {55}
     load_picture('graphics\','j');       {56}
     load_picture('graphics\','l');       {57}
     load_picture('graphics\','n');       {58}
     load_picture('graphics\','p');       {59}
     load_picture('graphics\','w');       {60}
     load_picture('graphics\','x');       {61}
     load_picture('graphics\','right');   {62}
     load_picture('graphics\','left');    {63}
     load_picture('graphics\','up');      {64}
     load_picture('graphics\','down');    {65}
     load_picture('graphics\','black');   {66}
     load_picture('graphics\','ff');      {67}
     load_picture('graphics\','1m');      {68}
     load_picture('graphics\','2m');      {69}
     load_picture('graphics\','3m');      {70}
     load_picture('graphics\','4m');      {71}
     load_picture('graphics\','5m');      {72}
     load_picture('graphics\','6m');      {73}
     load_picture('graphics\','7m');      {74}
     load_picture('graphics\','8m');      {75}
     load_picture('graphics\','10m');     {76}
     load_picture('graphics\','11m');     {77}
     load_picture('graphics\','12m');     {78}
     load_picture('graphics\','13m');     {79}
     load_picture('graphics\','14m');     {80}
     load_picture('graphics\','15m');     {81}
     load_picture('graphics\','16m');     {82}
     load_picture('graphics\','17m');     {83}
     load_picture('graphics\','18m');     {84}
     load_picture('graphics\','19m');     {85}
     load_picture('graphics\','20m');     {86}
     load_picture('graphics\','21m');     {87}
     load_picture('graphics\','22m');     {88}
     load_picture('graphics\','fff');     {89}
     load_picture('graphics\','beczka');       {90}
     load_picture('graphics\','studnia');      {91}
     load_picture('graphics\','dom1_');  {92}
     load_picture('graphics\','dom1__'); {93}
     load_picture('graphics\','dom2_');  {94}
     load_picture('graphics\','dom2__'); {95}
     load_picture('graphics\','dom3_');  {96}
     load_picture('graphics\','dom3__'); {97}
     load_picture('graphics\','dom4_');  {98}
     load_picture('graphics\','dom4__'); {99}
     load_picture('graphics\','dom4___');{100}
     load_picture('graphics\','dom5_');  {101}
     load_picture('graphics\','dom5__'); {102}
     load_picture('graphics\','e');    {103}
     load_picture('graphics\','f');    {104}
     load_picture('graphics\','znak');   {105}
     load_picture('graphics\','1h');        {106}
     load_picture('graphics\','2h');        {107}
     load_picture('graphics\','3h');        {108}
     load_picture('graphics\','4h');        {109}
     load_picture('graphics\','5h');        {110}
     load_picture('graphics\','6h');        {111}
     load_picture('graphics\','7h');        {112}
     load_picture('graphics\','8h');        {113}
     load_picture('graphics\','9h');        {114}
     load_picture('graphics\','10h');       {115}
     load_picture('graphics\','1n');        {116}
     load_picture('graphics\','2n');        {117}
     load_picture('graphics\','3n');        {118}
     load_picture('graphics\','4n');        {119}
     load_picture('graphics\','5n');        {120}
     load_picture('graphics\','6n');        {121}
     load_picture('graphics\','7n');        {122}
     load_picture('graphics\','8n');        {123}
     load_picture('graphics\','9n');        {124}
     load_picture('graphics\','10n');       {125}
     load_picture('graphics\','11n');       {126}
     load_picture('graphics\','12n');       {127}
     load_picture('graphics\','13n');       {128}
     load_picture('graphics\','14n');       {129}
     load_picture('graphics\','15n');       {130}
     load_picture('graphics\','16n');       {131}
     load_picture('graphics\','17n');       {132}
     load_picture('graphics\','18n');       {133}
     load_picture('graphics\','19n');       {134}
     load_picture('graphics\','20n');       {135}
     load_picture('graphics\','21n');       {136}
     load_picture('graphics\','22n');       {137}
     load_picture('graphics\','23n');       {138}
     load_picture('graphics\','24n');       {139}
     load_picture('graphics\','25n');       {140}
     load_picture('graphics\','26n');       {141}
     load_picture('graphics\','27n');       {142}
     load_picture('graphics\','28n');       {143}
     load_picture('graphics\','29n');       {144}
     load_picture('graphics\','30n');       {145}
     load_picture('graphics\','31n');       {146}
     load_picture('graphics\','lud1a');{147}
     load_picture('graphics\','lud1b');{148}
     load_picture('graphics\','lud1c');{149}
     load_picture('graphics\','lud1d');{150}
     load_picture('graphics\','lud1e');{151}
     load_picture('graphics\','lud1f');{152}
     load_picture('graphics\','lud1g');{153}
     load_picture('graphics\','lud1h');{154}
     load_picture('graphics\','lud2a');{155}
     load_picture('graphics\','lud2b');{156}
     load_picture('graphics\','lud2c');{157}
     load_picture('graphics\','lud2d');{158}
     load_picture('graphics\','lud2e');{159}
     load_picture('graphics\','lud2f');{160}
     load_picture('graphics\','lud2g');{161}
     load_picture('graphics\','lud2h');{162}
     load_picture('graphics\','lud3a');{163}
     load_picture('graphics\','lud3b');{164}
     load_picture('graphics\','lud3c');{165}
     load_picture('graphics\','lud3d');{166}
     load_picture('graphics\','lud3e');{167}
     load_picture('graphics\','lud3f');{168}
     load_picture('graphics\','lud3g');{169}
     load_picture('graphics\','lud3h');{170}
     load_picture('graphics\','lud4a');{171}
     load_picture('graphics\','lud4b');{172}
     load_picture('graphics\','lud4c');{173}
     load_picture('graphics\','lud4d');{174}
     load_picture('graphics\','lud4e');{175}
     load_picture('graphics\','lud4f');{176}
     load_picture('graphics\','lud4g');{177}
     load_picture('graphics\','lud4h');{178}
     load_picture('graphics\','lud5a');{179}
     load_picture('graphics\','lud5b');{180}
     load_picture('graphics\','lud5c');{181}
     load_picture('graphics\','lud5d');{182}
     load_picture('graphics\','lud5e');{183}
     load_picture('graphics\','lud5f');{184}
     load_picture('graphics\','lud5g');{185}
     load_picture('graphics\','lud5h');{186}
     load_picture('graphics\','lud6a');{187}
     load_picture('graphics\','lud6b');{188}
     load_picture('graphics\','lud6c');{189}
     load_picture('graphics\','lud6d');{190}
     load_picture('graphics\','lud6e');{191}
     load_picture('graphics\','lud6f');{192}
     load_picture('graphics\','lud6g');{193}
     load_picture('graphics\','lud6h');{194}
     load_picture('graphics\','lud7a');{195}
     load_picture('graphics\','lud7b');{196}
     load_picture('graphics\','lud7c');{197}
     load_picture('graphics\','lud7d');{198}
     load_picture('graphics\','lud7e');{199}
     load_picture('graphics\','lud7f');{200}
     load_picture('graphics\','lud7g');{201}
     load_picture('graphics\','lud7h');{202}
     load_picture('graphics\','lud8a');{203}
     load_picture('graphics\','lud8b');{204}
     load_picture('graphics\','lud8c');{205}
     load_picture('graphics\','lud8d');{206}
     load_picture('graphics\','lud8e');{207}
     load_picture('graphics\','lud8f');{208}
     load_picture('graphics\','lud8g');{209}
     load_picture('graphics\','lud8h');{210}
     load_picture('graphics\','lud9a');{211}
     load_picture('graphics\','lud9b');{212}
     load_picture('graphics\','lud9c');{213}
     load_picture('graphics\','lud9d');{214}
     load_picture('graphics\','lud9e');{215}
     load_picture('graphics\','lud9f');{216}
     load_picture('graphics\','lud9g');{217}
     load_picture('graphics\','lud9h');{218}
     load_picture('graphics\','lud10a');{219}
     load_picture('graphics\','lud10b');{220}
     load_picture('graphics\','lud10c');{221}
     load_picture('graphics\','lud10d');{222}
     load_picture('graphics\','lud10e');{223}
     load_picture('graphics\','lud10f');{224}
     load_picture('graphics\','lud10g');{225}
     load_picture('graphics\','lud10h');{226}
     load_picture('graphics\','flaga2');   {227}
     load_picture('graphics\','flaga');         {228}
     load_picture('graphics\','lost');     {229}
end;

procedure load_items_to_memory;

var
   f : file of Titems;
   i, j, ile : integer;

procedure load_item(path, name : string);
begin
     inc(ile);
     assign(f,path+name);
     reset(f);
     read(f,items[ile]^);
     close(f);
end;

begin
     ile:=0;
     load_item('graphics\','1i'); {01}
     load_item('graphics\','2i'); {02}
     load_item('graphics\','3i'); {03}
     load_item('graphics\','4i'); {04}
     load_item('graphics\','5i'); {05}
     load_item('graphics\','6i'); {06}
     load_item('graphics\','7i'); {07}
     load_item('graphics\','8i'); {08}
     load_item('graphics\','9i'); {09}
     load_item('graphics\','10i');{10}
     load_item('graphics\','11i');{11}
     load_item('graphics\','12i');{12}
     load_item('graphics\','13i');{13}
     load_item('graphics\','14i');{14}
     load_item('graphics\','15i');{15}
     load_item('graphics\','16i');{16}
     load_item('graphics\','17i');{17}
     load_item('graphics\','18i');{18}
     load_item('graphics\','19i');{19}
     load_item('graphics\','20i');{20}
     load_item('graphics\','21i');{21}
     load_item('graphics\','22i');{22}
     load_item('graphics\','23i');{23}
     load_item('graphics\','24i');{24}
     load_item('graphics\','25i');{25}
     load_item('graphics\','26i');{26}
     load_item('graphics\','27i');{27}
     load_item('graphics\','28i');{28}
     load_item('graphics\','29i');{29}
     load_item('graphics\','30i');{30}
     load_item('graphics\','31i');{31}
     load_item('graphics\','32i');{32}
     load_item('graphics\','33i');{33}
     load_item('graphics\','34i');{34}
     load_item('graphics\','35i');{35}
     load_item('graphics\','36i');{36}
     load_item('graphics\','37i');{37}
     load_item('graphics\','38i');{38}
     load_item('graphics\','39i');{39}
     load_item('graphics\','40i');{40}
     load_item('graphics\','41i');{41}
     load_item('graphics\','42i');{42}
     load_item('graphics\','43i');{43}
     load_item('graphics\','44i');{44}
     load_item('graphics\','45i');{45}
     load_item('graphics\','46i');{46}
     for i:= 1 to 25 do
     for j:= 1 to 25 do items[ile+1]^[i,j]:=22;
end;

procedure load_stone_to_memory;

var
   f : file of Tstone;
   ile : byte;

procedure load_stone(path, name : string);
begin
     inc(ile);
     assign(f,path+name);
     reset(f);
     read(f,bigpic[ile]^);
     close(f);
end;

begin
     ile:=0;
     load_stone('graphics\','kamien');
     load_stone('graphics\','ludek');
     load_stone('graphics\','piorun');
end;

procedure load_map(name : string);
var
   f : file of Tmap;
begin
     assign(f,name);
     reset(f);
     read(f,mapa);
     close(f);
end;

procedure save_map(name : string);
var
   f : file of Tmap;
begin
     assign(f,name);
     rewrite(f);
     write(f,mapa);
     close(f);
end;

procedure draw_picture(x, y : integer; nr : byte);
var
   i, j : integer;
begin
     for i:= 1 to 15 do
     for j:= 1 to 15 do if pictures[nr]^[i,j]<>52 then putpixel(i+x+1,j+y+2,pictures[nr]^[i,j])
end;

procedure draw_item(x, y : integer; nr : byte);
var
   i, j : integer;
begin
     for i:= 1 to 25 do
     for j:= 1 to 25 do if items[nr]^[i,j]<>52 then putpixel(i+x+1,j+y+2,items[nr]^[i,j])
end;

procedure draw_bigpic(x, y : integer; var pic : Tstone);
var
   i, j : integer;
begin
     for i:= 1 to 180 do
     for j:= 1 to 160 do if pic[i,j]<>31 then putpixel(i+x+1,j+y+2,pic[i,j])
end;

procedure draw_screen(d, s, r : byte);
var
   x, y : integer;
begin
     for x:= 0 to d do
     for y:= 0 to s do
     begin
          draw_picture(x*r+qx,y*r+qy,mapa[x+mx,y+my]);
     end;
end;

procedure draw_room(d, s, r, nr : byte);
var
   x, y : integer;
begin
     for x:= 0 to d do
     for y:= 0 to s do
     begin
          draw_picture(x*r,y*r,room_all[nr].domek[x+1,y+1]);
          if (nr=2) and (open[1]=true) then room_all[nr].domek[3,10]:=122;
          if (nr=2) and (open[2]=true) then room_all[nr].domek[14,3]:=122;
          if (nr=7) and (open[3]=true) then room_all[nr].domek[4,5]:=122;
          if (nr=6) and (open[4]=true) then room_all[nr].domek[1,9]:=122;
          if (nr=6) and (open[5]=true) then room_all[nr].domek[4,5]:=122;
          if (nr=8) and (open[6]=true) then room_all[nr].domek[1,5]:=122;
     end;
end;

procedure reset_map;
var
   x, y : integer;
begin
     for x:= 1 to 100 do
     for y:= 1 to 100 do mapa[x,y]:=8+random(3)+1
end;

procedure draw_ramka;
var
   i: integer;
begin
     for i:= 1 to (maxy*15)+15 do
     begin
          putpixel(1+ramkax[i].odchyl,i+2,ramkax[i].col);
          putpixel(1+ramkax[i].odchyl,i+3,ramkax[i].col);
          putpixel(1+ramkax[i].odchyl,i+4,ramkax[i].col);
          putpixel((maxx*15)+13+ramkax[i].odchyl,i+2,ramkax[i].col);
          putpixel((maxx*15)+13+ramkax[i].odchyl,i+3,ramkax[i].col);
          putpixel((maxx*15)+13+ramkax[i].odchyl,i+4,ramkax[i].col)
     end;
     for i:= 1 to (maxx*15)+15 do
     begin
          putpixel(i,2+ramkay[i].odchyl,ramkay[i].col);
          putpixel(i+1,2+ramkay[i].odchyl,ramkay[i].col);
          putpixel(i+2,2+ramkay[i].odchyl,ramkay[i].col);
          putpixel(i,(maxy*15)+14+ramkay[i].odchyl,ramkay[i].col);
          putpixel(i+1,(maxy*15)+14+ramkay[i].odchyl,ramkay[i].col);
          putpixel(i+2,(maxy*15)+14+ramkay[i].odchyl,ramkay[i].col)
     end;
end;

procedure load_ramka;
var
   f : file of Tramka;
begin
     assign(f,'data\ramka.cfg');
     reset(f);
     read(f,ramkax,ramkay);
     close(f)
end;

procedure reset_ramka;
var
   f : file of Tramka;
   i : integer;
begin
     randomize;
     for i:= 1 to (maxy*15)+15 do
     begin
          ramkax[i].odchyl:=random(5);
          ramkax[i].col:=219+random(5)
     end;
     for i:= 1 to (maxx*15)+15 do
     begin
          ramkay[i].odchyl:=random(5);
          ramkay[i].col:=219+random(5)
     end;
     assign(f,'data\ramka.cfg');
     rewrite(f);
     write(f,ramkax,ramkay);
     close(f)
end;

procedure load_room(name : string);
var
   f2 : file of Troom_all;
begin
     assign(f2,name);
     reset(f2);
     read(f2,room_all);
     close(f2);
end;

procedure draw_cursor(x, y : integer);
var
   i, j : integer;
begin
     for i:= 1 to 11 do
     for j:= 1 to 10 do if cur[j,i]<>0 then putpixel(i+x,j+y,cur[j,i]);
end;

procedure info_items;
begin
     items_typ[1].typ:='reka';
     items_typ[1].nazwa:='PIERóCIE„ MAGA';
     items_typ[1].atak:=2;
     items_typ[1].maxatak:=4;
     items_typ[1].magia:=true;
     items_typ[1].zycie:=5;
     items_typ[1].zaklecie:='BùYSKAWICA';
     items_typ[2].typ:='reka';
     items_typ[2].nazwa:='PIERóCIE„ ROPUCHY';
     items_typ[2].atak:=3;
     items_typ[2].maxatak:=5;
     items_typ[2].magia:=true;
     items_typ[2].zaklecie:='SPOWOLNIENIE';
     items_typ[3].typ:='noga';
     items_typ[3].nazwa:='SREBRNE BUTY';
     items_typ[3].atak:=0;
     items_typ[3].maxatak:=0;
     items_typ[3].obrona:=2;
     items_typ[3].magia:=false;
     items_typ[3].dozrecznosci:=2;
     items_typ[4].typ:='glowa';
     items_typ[4].nazwa:='CZASZKA BALLA';
     items_typ[4].obrona:=4;
     items_typ[4].magia:=true;
     items_typ[4].zaklecie:='OGNISTY POCISK';
     items_typ[4].zycie:=11;
     items_typ[5].typ:='armor';
     items_typ[5].nazwa:='ZBROJA Z GRANITU';
     items_typ[5].atak:=1;
     items_typ[5].obrona:=3;
     items_typ[5].magia:=false;
     items_typ[6].typ:='bron';
     items_typ[6].nazwa:='SZTYLET';
     items_typ[6].atak:=2;
     items_typ[6].maxatak:=3;
     items_typ[6].magia:=false;
     items_typ[6].doataku:=4;
     items_typ[7].typ:='bron';
     items_typ[7].nazwa:='SAJMINAR';
     items_typ[7].atak:=5;
     items_typ[7].maxatak:=5;
     items_typ[7].magia:=false;
     items_typ[8].typ:='inne';
     items_typ[8].nazwa:='KLUCZ';
     items_typ[8].magia:=false;
     items_typ[9].typ:='bron';
     items_typ[9].nazwa:='SZTYLET WIEDçMY';
     items_typ[9].atak:=6;
     items_typ[9].maxatak:=8;
     items_typ[9].magia:=false;
     items_typ[10].typ:='glowa';
     items_typ[10].nazwa:='KAPTUR';
     items_typ[10].obrona:=1;
     items_typ[10].magia:=false;
     items_typ[11].typ:='glowa';
     items_typ[11].nazwa:='HEùM';
     items_typ[11].obrona:=3;
     items_typ[11].magia:=false;
     items_typ[11].zycie:=3;
     items_typ[12].typ:='armor';
     items_typ[12].nazwa:='PIKOWANA ZBROJA';
     items_typ[12].obrona:=5;
     items_typ[12].magia:=false;
     items_typ[13].typ:='armor';
     items_typ[13].nazwa:='ZBROJA';
     items_typ[13].obrona:=1;
     items_typ[13].magia:=false;
     items_typ[14].typ:='noga';
     items_typ[14].nazwa:='BUTY';
     items_typ[14].obrona:=1;
     items_typ[14].dozrecznosci:=2;
     items_typ[14].magia:=false;
     items_typ[15].typ:='bron';
     items_typ[15].nazwa:='TOP‡R';
     items_typ[15].atak:=2;
     items_typ[15].maxatak:=3;
     items_typ[15].magia:=false;
     items_typ[16].typ:='bron';
     items_typ[16].nazwa:='ùUK ELFA';
     items_typ[16].atak:=4;
     items_typ[16].maxatak:=5;
     items_typ[13].magia:=false;
     items_typ[17].typ:='noga';
     items_typ[17].nazwa:='BUTY SùABEJ JAKOóCI';
     items_typ[17].obrona:=1;
     items_typ[17].magia:=false;
     items_typ[18].typ:='glowa';
     items_typ[18].nazwa:='HEùM MROCZNEGO GNOMA';
     items_typ[18].obrona:=4;
     items_typ[18].magia:=false;
     items_typ[19].zycie:=6;
     items_typ[19].typ:='armor';
     items_typ[19].nazwa:='ZBROJA WYSOKIEJ JAKOóCI';
     items_typ[19].obrona:=5;
     items_typ[19].magia:=false;
     items_typ[20].typ:='armor';
     items_typ[20].nazwa:='ZBROJA C®TKOWANA';
     items_typ[20].obrona:=3;
     items_typ[20].magia:=false;
     items_typ[21].typ:='bron';
     items_typ[21].nazwa:='TOP‡R BARBARZY„CY';
     items_typ[21].atak:=7;
     items_typ[21].maxatak:=9;
     items_typ[21].magia:=false;
     items_typ[22].typ:='bron';
     items_typ[22].nazwa:='POSZARPANY MIECZ';
     items_typ[22].atak:=8;
     items_typ[22].maxatak:=10;
     items_typ[22].doataku:=2;
     items_typ[22].magia:=false;
     items_typ[23].typ:='armor';
     items_typ[23].nazwa:='ODPORNA BLUZA';
     items_typ[23].obrona:=3;
     items_typ[23].magia:=false;
     items_typ[24].typ:='inne';
     items_typ[24].nazwa:='SZKIELET RYBY';
     items_typ[24].magia:=false;
     items_typ[25].typ:='inne';
     items_typ[25].nazwa:='FLAGA';
     items_typ[25].magia:=false;
     items_typ[26].typ:='inne';
     items_typ[26].nazwa:='BUKIET KWIAT‡W';
     items_typ[26].magia:=false;
     items_typ[27].typ:='reka';
     items_typ[27].nazwa:='PIERóCIE„ WIATRU';
     items_typ[27].atak:=4;
     items_typ[27].maxatak:=8;
     items_typ[27].magia:=true;
     items_typ[27].zaklecie:='PODMUCH WIATRU';
     items_typ[28].typ:='reka';
     items_typ[28].nazwa:='OKO W®ΩA';
     items_typ[28].atak:=10;
     items_typ[28].maxatak:=18;
     items_typ[28].obrona:=-2;
     items_typ[28].doataku:=5;
     items_typ[28].dozrecznosci:=2;
     items_typ[28].zycie:=8;
     items_typ[28].magia:=true;
     items_typ[28].zaklecie:='DIABELNY CIOS';
     items_typ[29].typ:='reka';
     items_typ[29].nazwa:='PIERóCIE„ REGENERACJI';
     items_typ[29].atak:=0;
     items_typ[29].maxatak:=0;
     items_typ[29].zycie:=10;
     items_typ[29].magia:=true;
     items_typ[29].zaklecie:='1 DO ENERGI PODCZAS WALKI';
     items_typ[30].typ:='reka';
     items_typ[30].nazwa:='PIERóCIE„ MEDYTACJI';
     items_typ[30].atak:=4;
     items_typ[30].maxatak:=4;
     items_typ[30].magia:=false;
     items_typ[31].typ:='armor';
     items_typ[31].nazwa:='ZROJA ZE SK‡RY CZARNEGO SMOKA';
     items_typ[31].obrona:=7;
     items_typ[31].doataku:=4;
     items_typ[31].dozrecznosci:=1;
     items_typ[31].magia:=true;
     items_typ[31].zaklecie:='WZMOCNIENIE';
     items_typ[32].typ:='glowa';
     items_typ[32].nazwa:='HEùM ZE SK‡RY CZARNEGO SMOKA';
     items_typ[32].obrona:=5;
     items_typ[32].doataku:=-1;
     items_typ[32].dozrecznosci:=10;
     items_typ[32].magia:=false;
     items_typ[33].typ:='armor';
     items_typ[33].nazwa:='TYTANOWA ZBROJA';
     items_typ[33].obrona:=21;
     items_typ[33].zycie:=20;
     items_typ[33].doataku:=0;
     items_typ[33].dozrecznosci:=-6;
     items_typ[33].magia:=true;
     items_typ[33].zaklecie:='OSùABIENIE';
     items_typ[34].typ:='bron';
     items_typ[34].nazwa:='BUùAWA';
     items_typ[34].atak:=9;
     items_typ[34].maxatak:=15;
     items_typ[34].dozrecznosci:=-3;
     items_typ[34].magia:=false;
     items_typ[35].typ:='armor';
     items_typ[35].nazwa:='WILCZA SK‡RA';
     items_typ[35].obrona:=6;
     items_typ[35].magia:=false;
     items_typ[36].typ:='bron';
     items_typ[36].nazwa:='SZTYLET';
     items_typ[36].atak:=6;
     items_typ[36].maxatak:=8;
     items_typ[36].magia:=false;
     items_typ[37].typ:='bron';
     items_typ[37].nazwa:='LASKA MERLINA';
     items_typ[37].atak:=9;
     items_typ[37].maxatak:=11;
     items_typ[37].obrona:=3;
     items_typ[37].zycie:=1;
     items_typ[37].magia:=true;
     items_typ[37].zaklecie:='LODOWY PODMYCH';
     items_typ[38].typ:='bron';
     items_typ[38].nazwa:='TOPOREK';
     items_typ[38].atak:=7;
     items_typ[38].maxatak:=12;
     items_typ[38].doataku:=15;
     items_typ[38].magia:=false;
     items_typ[39].typ:='armor';
     items_typ[39].nazwa:='SK‡RA OSTATNIEGO SMOKA';
     items_typ[39].obrona:=32;
     items_typ[39].magia:=false;
     items_typ[39].zycie:=20;
     items_typ[39].doataku:=4;
     items_typ[40].typ:='noga';
     items_typ[40].nazwa:='ZAKL®TE BUTY';
     items_typ[40].obrona:=12;
     items_typ[40].magia:=false;
     items_typ[40].zycie:=2;
     items_typ[40].dozrecznosci:=8;
     items_typ[40].doataku:=1;
     items_typ[41].typ:='bron';
     items_typ[41].nazwa:='DUΩY MIECZ';
     items_typ[41].atak:=20;
     items_typ[41].maxatak:=23;
     items_typ[41].magia:=false;
     items_typ[41].dozrecznosci:=-3;
     items_typ[42].typ:='armor';
     items_typ[42].nazwa:='KAMIENNA ZBROJA';
     items_typ[42].obrona:=54;
     items_typ[42].magia:=false;
     items_typ[42].dozrecznosci:=-8;
     items_typ[43].typ:='bron';
     items_typ[43].nazwa:='KOWALSKI MùOT';
     items_typ[43].atak:=21;
     items_typ[43].maxatak:=38;
     items_typ[43].magia:=false;
     items_typ[43].dozrecznosci:=-2;
     items_typ[44].typ:='armor';
     items_typ[44].nazwa:='ZBROJA PALLADYNA';
     items_typ[44].obrona:=11;
     items_typ[44].magia:=false;
     items_typ[44].dozrecznosci:=2;
     items_typ[45].typ:='glowa';
     items_typ[45].nazwa:='HEùM HERALDA';
     items_typ[45].obrona:=23;
     items_typ[45].magia:=true;
     items_typ[45].zaklecie:='SPOWOJNIENIE';
     items_typ[45].dozrecznosci:=1;
     items_typ[46].typ:='inne';
     items_typ[46].nazwa:='NAP‡J ODNAWIAJ§CY';
     items_typ[46].info:='PRAWY PRZYCISK MYSZKI ABY URZYè';
end;

procedure pokaz_info_w_plecaku(x, y, d, s : integer; nr : byte);
var
   a : word;
begin
     if mousein(mmx,mmy,x,y,d,s) then
     begin
          if plecak[nr]=ile_items then bar(11,130,159,189,20);
          {BRON}
          if items_typ[plecak[nr]].typ='bron' then
          begin
               outtextfntxy2_rainbow(15,135,3,70,1,1,items_typ[plecak[nr]].nazwa,font^);
               outtextfntxy2_rainbow(15,145,3,20,1,1,'ATAK= OD '+numstr(items_typ[plecak[nr]].atak)+' DO '
               +numstr(items_typ[plecak[nr]].maxatak),font^);
               outtextfntxy2_rainbow(15,151,3,43,1,1,'DO OBRONY= '+numstr(items_typ[plecak[nr]].obrona),font^);
               outtextfntxy2_rainbow(15,157,3,43,1,1,'DO ATAKU= '+numstr(items_typ[plecak[nr]].doataku),font^);
               outtextfntxy2_rainbow(15,163,3,43,1,1,'DO ZRECZNOóCI= '+numstr(items_typ[plecak[nr]].dozrecznosci),font^);
               outtextfntxy2_rainbow(15,169,3,43,1,1,'DO ΩYCIA= '+numstr(items_typ[plecak[nr]].zycie),font^);
               if items_typ[plecak[nr]].magia=true then
               begin
               outtextfntxy2_rainbow(15,175,3,56,1,1,'MAGICZNY PRZEDMIOT',font^);
               outtextfntxy2_rainbow(15,181,3,20,1,1,'ZAKL®CIE= '+items_typ[plecak[nr]].zaklecie,font^);
               end;
          end;
          {GLOWA}
          if items_typ[plecak[nr]].typ='glowa' then
          begin
               outtextfntxy2_rainbow(15,135,3,70,1,1,items_typ[plecak[nr]].nazwa,font^);
               outtextfntxy2_rainbow(15,145,3,20,1,1,'OBRONA= '+numstr(items_typ[plecak[nr]].obrona),font^);
               outtextfntxy2_rainbow(15,151,3,43,1,1,'DO ATAKU= '+numstr(items_typ[plecak[nr]].doataku),font^);
               outtextfntxy2_rainbow(15,157,3,43,1,1,'DO ZRECZNOóCI= '+numstr(items_typ[plecak[nr]].dozrecznosci),font^);
               outtextfntxy2_rainbow(15,163,3,43,1,1,'DO ΩYCIA= '+numstr(items_typ[plecak[nr]].zycie),font^);
               if items_typ[plecak[nr]].magia=true then
               begin
               outtextfntxy2_rainbow(15,169,3,56,1,1,'MAGICZNY PRZEDMIOT',font^);
               outtextfntxy2_rainbow(15,175,3,20,1,1,'ZAKL®CIE= '+items_typ[plecak[nr]].zaklecie,font^);
               end;
          end;
          {ARMOR}
          if items_typ[plecak[nr]].typ='armor' then
          begin
               outtextfntxy2_rainbow(15,135,3,70,1,1,items_typ[plecak[nr]].nazwa,font^);
               outtextfntxy2_rainbow(15,145,3,20,1,1,'OBRONA= '+numstr(items_typ[plecak[nr]].obrona),font^);
               outtextfntxy2_rainbow(15,151,3,43,1,1,'DO ATAKU= '+numstr(items_typ[plecak[nr]].doataku),font^);
               outtextfntxy2_rainbow(15,157,3,43,1,1,'DO ZRECZNOóCI= '+numstr(items_typ[plecak[nr]].dozrecznosci),font^);
               outtextfntxy2_rainbow(15,163,3,43,1,1,'DO ΩYCIA= '+numstr(items_typ[plecak[nr]].zycie),font^);
               if items_typ[plecak[nr]].magia=true then
               begin
               outtextfntxy2_rainbow(15,169,3,56,1,1,'MAGICZNY PRZEDMIOT',font^);
               outtextfntxy2_rainbow(15,175,3,20,1,1,'ZAKL®CIE= '+items_typ[plecak[nr]].zaklecie,font^);
               end;
          end;
          {REKA}
          if items_typ[plecak[nr]].typ='reka' then
          begin
               outtextfntxy2_rainbow(15,135,3,70,1,1,items_typ[plecak[nr]].nazwa,font^);
               outtextfntxy2_rainbow(15,145,3,43,1,1,'DO OBRONY= '+numstr(items_typ[plecak[nr]].obrona),font^);
               outtextfntxy2_rainbow(15,151,3,43,1,1,'DO ATAKU= '+numstr(items_typ[plecak[nr]].doataku),font^);
               outtextfntxy2_rainbow(15,157,3,43,1,1,'DO ZRECZNOóCI= '+numstr(items_typ[plecak[nr]].dozrecznosci),font^);
               outtextfntxy2_rainbow(15,163,3,43,1,1,'DO ΩYCIA= '+numstr(items_typ[plecak[nr]].zycie),font^);
               if items_typ[plecak[nr]].magia=true then
               begin
               outtextfntxy2_rainbow(15,169,3,56,1,1,'MAGICZNY PRZEDMIOT',font^);
               outtextfntxy2_rainbow(15,175,3,20,1,1,'ZAKL®CIE= '+items_typ[plecak[nr]].zaklecie,font^);
               end;
          end;
          {NOGA}
          if items_typ[plecak[nr]].typ='noga' then
          begin
               outtextfntxy2_rainbow(15,135,3,70,1,1,items_typ[plecak[nr]].nazwa,font^);
               outtextfntxy2_rainbow(15,145,3,20,1,1,'OBRONA= '+numstr(items_typ[plecak[nr]].obrona),font^);
               outtextfntxy2_rainbow(15,151,3,43,1,1,'DO ATAKU= '+numstr(items_typ[plecak[nr]].doataku),font^);
               outtextfntxy2_rainbow(15,157,3,43,1,1,'DO ZRECZNOóCI= '+numstr(items_typ[plecak[nr]].dozrecznosci),font^);
               outtextfntxy2_rainbow(15,163,3,43,1,1,'DO ΩYCIA= '+numstr(items_typ[plecak[nr]].zycie),font^);
               if items_typ[plecak[nr]].magia=true then
               begin
               outtextfntxy2_rainbow(15,169,3,56,1,1,'MAGICZNY PRZEDMIOT',font^);
               outtextfntxy2_rainbow(15,175,3,20,1,1,'ZAKL®CIE= '+items_typ[plecak[nr]].zaklecie,font^);
               end;
          end;
          {INNE}
          if items_typ[plecak[nr]].typ='inne' then
          begin
               outtextfntxy2_rainbow(15,135,3,70,1,1,items_typ[plecak[nr]].nazwa,font^);
               outtextfntxy2_rainbow(15,147,3,20,1,1,items_typ[plecak[nr]].info,font^);
          end;
          if (items_typ[plecak[nr]].typ='inne') and (items_typ[plecak[nr]].nazwa='NAP‡J ODNAWIAJ§CY')
          and rightbutton then
          begin
               if zyciemin<>zycietmp then
               begin
                    if sounds then play_sound(tempsound[4],sound[4],11000);
                    delay(300);
                    zyciemin:=zyciemin+5;
                    if zyciemin>=zycietmp then zyciemin:=zycietmp;
                    plecak[nr]:=ile_items;
               end;
          end;
     end;
{     outtextxy(20,1,1,1,random(255),'ZRECZNOSC='+numstr(zrecznosctmp),false);
     outtextxy(20,10,1,1,random(255),'ZYCIE='+numstr(zycietmp),false);}
end;

procedure button(x, y : integer; symbol : string);
begin
     rectangle(x,y,x+10,y+15,251);
     bar(x+1,y+1,x+9,y+14,248);
     outtextxy(x,y+3,1,1,251,symbol,false);
     outtextxy(x,y+4,1,1,251,symbol,false);
end;

procedure show_pic(x, y : integer; nr : byte);
var
   i, j : integer;
begin
     bar(x+1,y+1,x+14,y+14,251);
     draw_picture(x-2,y-2,nr);
     rectangle(x,y,x+15,y+15,251);
end;

procedure background;
var
   x, y : integer;
begin
{     for x:= 1 to 29 do setcolor(120+x,0,0,x);}
     setcolor(220,0,30,0);
     for x:= 1 to 64 do setcolor(150+x,0,x+10,0);
     for x:= 0 to 319 do
     for y:= 0 to 199 do putpixel(319-x,y,150+(x+10+random(12)+y) div 10);
end;

procedure put_player(x, y : integer; nr : byte);
begin
     if nr=1 then draw_picture(x,y,1);
     if nr=2 then draw_picture(x,y,2);
     if nr=3 then draw_picture(x,y,3);
     if nr=4 then draw_picture(x,y,4);
     if nr=5 then draw_picture(x,y,5);
     if nr=6 then draw_picture(x,y,6);
     if nr=7 then draw_picture(x,y,7);
     if nr=8 then draw_picture(x,y,8);
end;

procedure put_enemy(x, y : integer; nr_e, nr : byte);
begin
     if nr_e=1 then
     begin
     if nr=1 then draw_picture(x,y,147);
     if nr=2 then draw_picture(x,y,148);
     if nr=3 then draw_picture(x,y,149);
     if nr=4 then draw_picture(x,y,150);
     if nr=5 then draw_picture(x,y,151);
     if nr=6 then draw_picture(x,y,152);
     if nr=7 then draw_picture(x,y,153);
     if nr=8 then draw_picture(x,y,154);
     end;
     if nr_e=2 then
     begin
     if nr=1 then draw_picture(x,y,155);
     if nr=2 then draw_picture(x,y,156);
     if nr=3 then draw_picture(x,y,157);
     if nr=4 then draw_picture(x,y,158);
     if nr=5 then draw_picture(x,y,159);
     if nr=6 then draw_picture(x,y,160);
     if nr=7 then draw_picture(x,y,161);
     if nr=8 then draw_picture(x,y,162);
     end;
     if nr_e=3 then
     begin
     if nr=1 then draw_picture(x,y,163);
     if nr=2 then draw_picture(x,y,164);
     if nr=3 then draw_picture(x,y,165);
     if nr=4 then draw_picture(x,y,166);
     if nr=5 then draw_picture(x,y,167);
     if nr=6 then draw_picture(x,y,168);
     if nr=7 then draw_picture(x,y,169);
     if nr=8 then draw_picture(x,y,170);
     end;
     if nr_e=4 then
     begin
     if nr=1 then draw_picture(x,y,171);
     if nr=2 then draw_picture(x,y,172);
     if nr=3 then draw_picture(x,y,173);
     if nr=4 then draw_picture(x,y,174);
     if nr=5 then draw_picture(x,y,175);
     if nr=6 then draw_picture(x,y,176);
     if nr=7 then draw_picture(x,y,177);
     if nr=8 then draw_picture(x,y,178);
     end;
     if nr_e=5 then
     begin
     if nr=1 then draw_picture(x,y,179);
     if nr=2 then draw_picture(x,y,180);
     if nr=3 then draw_picture(x,y,181);
     if nr=4 then draw_picture(x,y,182);
     if nr=5 then draw_picture(x,y,183);
     if nr=6 then draw_picture(x,y,184);
     if nr=7 then draw_picture(x,y,185);
     if nr=8 then draw_picture(x,y,186);
     end;
     if nr_e=6 then
     begin
     if nr=1 then draw_picture(x,y,187);
     if nr=2 then draw_picture(x,y,188);
     if nr=3 then draw_picture(x,y,189);
     if nr=4 then draw_picture(x,y,190);
     if nr=5 then draw_picture(x,y,191);
     if nr=6 then draw_picture(x,y,192);
     if nr=7 then draw_picture(x,y,193);
     if nr=8 then draw_picture(x,y,194);
     end;
     if nr_e=7 then
     begin
     if nr=1 then draw_picture(x,y,195);
     if nr=2 then draw_picture(x,y,196);
     if nr=3 then draw_picture(x,y,197);
     if nr=4 then draw_picture(x,y,198);
     if nr=5 then draw_picture(x,y,199);
     if nr=6 then draw_picture(x,y,200);
     if nr=7 then draw_picture(x,y,201);
     if nr=8 then draw_picture(x,y,202);
     end;
     if nr_e=8 then
     begin
     if nr=1 then draw_picture(x,y,203);
     if nr=2 then draw_picture(x,y,204);
     if nr=3 then draw_picture(x,y,205);
     if nr=4 then draw_picture(x,y,206);
     if nr=5 then draw_picture(x,y,207);
     if nr=6 then draw_picture(x,y,208);
     if nr=7 then draw_picture(x,y,209);
     if nr=8 then draw_picture(x,y,210);
     end;
     if nr_e=9 then
     begin
     if nr=1 then draw_picture(x,y,211);
     if nr=2 then draw_picture(x,y,212);
     if nr=3 then draw_picture(x,y,213);
     if nr=4 then draw_picture(x,y,214);
     if nr=5 then draw_picture(x,y,215);
     if nr=6 then draw_picture(x,y,216);
     if nr=7 then draw_picture(x,y,217);
     if nr=8 then draw_picture(x,y,218);
     end;
     if nr_e=10 then
     begin
     if nr=1 then draw_picture(x,y,219);
     if nr=2 then draw_picture(x,y,220);
     if nr=3 then draw_picture(x,y,221);
     if nr=4 then draw_picture(x,y,222);
     if nr=5 then draw_picture(x,y,223);
     if nr=6 then draw_picture(x,y,224);
     if nr=7 then draw_picture(x,y,225);
     if nr=8 then draw_picture(x,y,226);
     end;
end;

function badaj_teren(x, y : integer) : boolean;
begin
     if mapa[x+7,y+6]in[21..31] then badaj_teren:=false;
     if mapa[x+7,y+6]in[34..38] then badaj_teren:=false;
     if mapa[x+7,y+6]in[40..49] then badaj_teren:=false;
     if mapa[x+7,y+6]in[52..89] then badaj_teren:=false;
     if mapa[x+7,y+6]in[90..126] then badaj_teren:=false;
     if mapa[x+7,y+6]=228 then badaj_teren:=false;
end;

procedure pokaz_skrzynie(x, y : integer; o, nr : byte);
var
   i : integer;
begin
      if (px=x) and (py=y) and keydown[spacescan] and (nr_dom=nr) then
      begin
{           open[7]:=true;
{           if open[o]=false thenstartsound(sound[2],2,false);}
{           open[o]:=true;}
           background;
           for i:= 1 to ile_pictures do dispose(pictures[i]);
           for i:= 1 to ile_items do new(items[i]);
           load_items_to_memory;page_skrzynia(o);
           for i:= 1 to ile_items do dispose(items[i]);
           for i:= 1 to ile_pictures do new(pictures[i]);
           load_pictures_to_memory; background;
           draw_room(14,12,15,nr_dom); draw_ramka;
           put_player(px*15,py*15,del+nr_p); bar(231,190,315,198,219);
           rectangle(231,190,315,198,120); show_icony;
      end;
end;

procedure pokaz_skrzynie_map(x, y : integer; o : byte);
var
   i : integer;
begin
      if (mx=x-8) and (my=y-6) and keydown[spacescan] then
      begin
           delay(300);
{           if open[o]=false then startsound(sound[2],2,false);}
           mapa[x-1,y-1]:=122;
           if not open[o] then if sounds then play_sound(tempsound[5],sound[5],11000);
           open[o]:=true;
           background;
           for i:= 1 to ile_pictures do dispose(pictures[i]);
           for i:= 1 to ile_items do new(items[i]);
           load_items_to_memory; page_skrzynia(o);
           for i:= 1 to ile_items do dispose(items[i]);
           for i:= 1 to ile_pictures do new(pictures[i]);
           load_pictures_to_memory; background;
           draw_screen(maxx,maxy,15);
           draw_ramka;
           put_player(105,90,del+nr_p); bar(231,190,315,198,219);
           rectangle(231,190,315,198,120); show_icony;
           badaj_czy_noc;
      end;
end;

procedure zaladuj_textdata;
begin
     assign(f,'data\text.dat');
     reset(f);
     for i:= 1 to 5 do read(f,tekst[i]^);
     close(f);
end;

procedure info(name : string);
procedure text(x, y : integer; tekst : string);
begin
     outtextfntxy2(x-1,y-1,3,24,1,1,tekst,font^);
     outtextfntxy2(x,y,3,15,1,1,tekst,font^);
end;
procedure open_textdata(x, y : integer; nr : byte);
var
   i : integer;
begin
     for i:= 1 to 11 do
     begin
          text(x,i*10+y-10,tekst[nr]^.linijka[i]);
     end;
end;
begin
     if name='jadalnia' then
     begin
          delay(100);
          draw_bigpic(25,18,bigpic[1]^);
          open_textdata(42,50,2);
          pokazgrafike2;
          repeat
          until keydown[spacescan];
          draw_screen(maxx,maxy,15);
          draw_ramka;
          put_player(105,90,del+nr_p);
          delay(200);
     end;
     if name='sypialnia' then
     begin
          delay(100);
          draw_bigpic(25,18,bigpic[1]^);
          open_textdata(42,50,1);
          pokazgrafike2;
          repeat
          until keydown[spacescan];
          draw_screen(maxx,maxy,15);
          draw_ramka;
          put_player(105,90,del+nr_p);
          delay(200);
     end;
     if name='piwialnia' then
     begin
          delay(100);
          draw_bigpic(25,18,bigpic[1]^);
          open_textdata(42,50,3);
          pokazgrafike2;
          repeat
          until keydown[spacescan];
          draw_screen(maxx,maxy,15);
          draw_ramka;
          put_player(105,90,del+nr_p);
          delay(200);
     end;
end;

procedure ustaw_enemies;
begin
     {domek 1}
     enemy[1].x:=2; enemy[1].y:=2;
     enemy[1].kier:='3'; enemy[1].nr:=0;
     enemy[1].del:=5; enemy[1].ludek:=3;
     enemy[1].move:=false; enemy[1].speed:=0;
     {domek 2}
     enemy[2].x:=8; enemy[2].y:=7; enemy[2].kier:='3';
     enemy[2].nr:=0; enemy[2].del:=4; enemy[2].ludek:=4;
     enemy[2].move:=false; enemy[2].speed:=0;
     {domek 3}
     enemy[3].x:=2; enemy[3].y:=2; enemy[3].kier:='3';
     enemy[3].nr:=0; enemy[3].del:=5; enemy[3].ludek:=3;
     enemy[3].move:=false; enemy[3].speed:=3; enemy[4].x:=8;
     enemy[4].y:=2; enemy[4].kier:='3'; enemy[4].nr:=0;
     enemy[4].del:=7; enemy[4].ludek:=5; enemy[4].move:=false;
     enemy[4].speed:=3;
     enemy[5].x:=5; enemy[5].y:=5;
     enemy[5].kier:='3'; enemy[5].nr:=0;
     enemy[5].del:=5; enemy[5].ludek:=6;
     enemy[5].move:=true; enemy[5].speed:=3;
     enemy[5].minx:=0; enemy[5].maxx:=10; enemy[5].miny:=5;
     enemy[5].maxy:=11;
     enemy[6].x:=2; enemy[6].y:=9; enemy[6].kier:='3';
     enemy[6].nr:=0; enemy[6].del:=5; enemy[6].ludek:=6;
     enemy[6].move:=true; enemy[6].speed:=2; enemy[6].minx:=0;
     enemy[6].maxx:=14; enemy[6].miny:=5; enemy[6].maxy:=11;
     {domek 7}
     enemy[7].x:=10; enemy[7].y:=2; enemy[7].kier:='3';
     enemy[7].nr:=0; enemy[7].del:=4; enemy[7].ludek:=3;
     enemy[7].move:=false;
     enemy[8].x:=3; enemy[8].y:=8; enemy[8].kier:='3';
     enemy[8].nr:=0; enemy[8].del:=4; enemy[8].ludek:=6;
     enemy[8].move:=true; enemy[8].speed:=2; enemy[8].minx:=0;
     enemy[8].maxx:=14; enemy[8].miny:=2; enemy[8].maxy:=11;
     enemy[9].x:=6; enemy[9].y:=4; enemy[9].kier:='3';
     enemy[9].nr:=0; enemy[9].del:=4; enemy[9].ludek:=6;
     enemy[9].move:=true; enemy[9].speed:=3; enemy[9].minx:=0;
     enemy[9].maxx:=14; enemy[9].miny:=2; enemy[9].maxy:=11;
     enemy[10].x:=2; enemy[10].y:=4; enemy[10].kier:='3';
     enemy[10].nr:=0; enemy[10].del:=4; enemy[10].ludek:=6;
     enemy[10].move:=true; enemy[10].speed:=0; enemy[10].minx:=0;
     enemy[10].maxx:=14; enemy[10].miny:=2; enemy[10].maxy:=11;
     enemy[11].x:=12; enemy[11].y:=8; enemy[11].kier:='3';
     enemy[11].nr:=0; enemy[11].del:=4; enemy[11].ludek:=6;
     enemy[11].move:=true; enemy[11].speed:=4; enemy[11].minx:=0;
     enemy[11].maxx:=14; enemy[11].miny:=2; enemy[11].maxy:=11;
     {domek 6}
     enemy[12].x:=4; enemy[12].y:=2; enemy[12].kier:='3';
     enemy[12].nr:=0; enemy[12].del:=5; enemy[12].ludek:=5;
     enemy[12].move:=false;
     enemy[13].x:=12; enemy[13].y:=8; enemy[13].kier:='3';
     enemy[13].nr:=0; enemy[13].del:=4; enemy[13].ludek:=6;
     enemy[13].move:=true; enemy[13].speed:=4; enemy[13].minx:=0;
     enemy[13].maxx:=14; enemy[13].miny:=2; enemy[13].maxy:=11;
     enemy[14].x:=5; enemy[14].y:=4; enemy[14].kier:='3';
     enemy[14].nr:=0; enemy[14].del:=2; enemy[14].ludek:=6;
     enemy[14].move:=true; enemy[14].speed:=2; enemy[14].minx:=0;
     enemy[14].maxx:=14; enemy[14].miny:=2; enemy[14].maxy:=11;
     enemy[15].x:=3; enemy[15].y:=10; enemy[15].kier:='3';
     enemy[15].nr:=0; enemy[15].del:=2; enemy[15].ludek:=6;
     enemy[15].move:=true; enemy[15].speed:=3; enemy[15].minx:=0;
     enemy[15].maxx:=14; enemy[15].miny:=2; enemy[15].maxy:=11;
     {domek 5}
     enemy[16].x:=5; enemy[16].y:=2; enemy[16].kier:='3';
     enemy[16].nr:=0; enemy[16].del:=3; enemy[16].ludek:=3;
     enemy[16].move:=false;
     {domek 8}
     enemy[17].x:=5; enemy[17].y:=2; enemy[17].kier:='3';
     enemy[17].nr:=0; enemy[17].del:=4; enemy[17].ludek:=8;
     enemy[17].move:=false; enemy[17].speed:=0; enemy[17].minx:=0;
     enemy[17].maxx:=14; enemy[17].miny:=2; enemy[17].maxy:=11;
     {domek 13}
     enemy[18].x:=5; enemy[18].y:=2; enemy[18].kier:='3';
     enemy[18].nr:=0; enemy[18].del:=5; enemy[18].ludek:=10;
     enemy[18].move:=true; enemy[18].speed:=0; enemy[18].minx:=0;
     enemy[18].maxx:=14; enemy[18].miny:=2; enemy[18].maxy:=11;
     {domek 9}
     enemy[19].x:=5; enemy[19].y:=2; enemy[19].kier:='3';
     enemy[19].nr:=0; enemy[19].del:=5; enemy[19].ludek:=8;
     enemy[19].move:=true; enemy[19].speed:=0; enemy[19].minx:=0;
     enemy[19].maxx:=14; enemy[19].miny:=2; enemy[19].maxy:=11;
     {domek 4}
     enemy[20].x:=8; enemy[20].y:=5; enemy[20].kier:='3';
     enemy[20].nr:=0; enemy[20].del:=3; enemy[20].ludek:=9;
     enemy[20].move:=true; enemy[20].speed:=0; enemy[20].minx:=0;
     enemy[20].maxx:=14; enemy[20].miny:=2; enemy[20].maxy:=11;
     {domek 10}
     enemy[21].x:=8; enemy[21].y:=5; enemy[21].kier:='3';
     enemy[21].nr:=0; enemy[21].del:=3; enemy[21].ludek:=7;
     enemy[21].move:=true; enemy[21].speed:=0; enemy[21].minx:=0;
     enemy[21].maxx:=14; enemy[21].miny:=2; enemy[21].maxy:=11;
end;

procedure page_game; {skrzynia}

var
   i, j : integer;
   temp : Titems;
   nrskrzyni, nritem, nrtemp : byte;
   lap : boolean;
   ax, ay : integer;
   trzyma, exit : boolean;

procedure kwadracik(x, y : integer);
begin
     bar(x,y,x+26,y+26,22);
     rectangle(x,y,x+26,y+26,23);
end;

procedure draw_plecak;
var
   i, j : integer;
begin
     draw_item(184,18,plecak[1]);
     draw_item(274,48,plecak[2]);
     draw_item(217,58,plecak[3]);
     draw_item(164,158,plecak[4]);
     draw_item(164,98,plecak[5]);
     draw_item(279,106,plecak[6]);
     draw_item(279,132,plecak[7]);
     draw_item(279,158,plecak[8]);
end;

procedure draw_temp(x, y : integer; nr : byte);
var
   i, j : integer;
begin
     for i:= 1 to 25 do
     for j:= 1 to 25 do if temp[i,j]<>52 then putpixel(i+x+1,j+y+2,temp[i,j])
end;

procedure ramki(typ : string);
var
   i : integer;
begin
     if typ='nic' then
     begin
          rectangle(185,20,211,46,23);
          rectangle(275,50,301,76,23);
          rectangle(218,60,244,86,23);
          rectangle(165,160,191,186,23);
          rectangle(165,100,191,126,23);
          rectangle(280,108,306,134,23);
          rectangle(280,134,306,160,23);
          rectangle(280,160,306,186,23);
     end;
     if typ='glowa' then
     begin
          rectangle(185,20,211,46,12);
          rectangle(275,50,301,76,23);
          rectangle(218,60,244,86,23);
          rectangle(165,160,191,186,23);
          rectangle(165,100,191,126,23);
          rectangle(280,108,306,134,12);
          rectangle(280,134,306,160,12);
          rectangle(280,160,306,186,12);
     end;
     if typ='reka' then
     begin
          rectangle(185,20,211,46,23);
          rectangle(275,50,301,76,12);
          rectangle(218,60,244,86,23);
          rectangle(165,160,191,186,23);
          rectangle(165,100,191,126,23);
          rectangle(280,108,306,134,12);
          rectangle(280,134,306,160,12);
          rectangle(280,160,306,186,12);
     end;
     if typ='armor' then
     begin
          rectangle(185,20,211,46,23);
          rectangle(275,50,301,76,23);
          rectangle(218,60,244,86,12);
          rectangle(165,160,191,186,23);
          rectangle(165,100,191,126,23);
          rectangle(280,108,306,134,12);
          rectangle(280,134,306,160,12);
          rectangle(280,160,306,186,12);
     end;
     if typ='bron' then
     begin
          rectangle(185,20,211,46,23);
          rectangle(275,50,301,76,23);
          rectangle(218,60,244,86,23);
          rectangle(165,160,191,186,23);
          rectangle(165,100,191,126,12);
          rectangle(280,108,306,134,12);
          rectangle(280,134,306,160,12);
          rectangle(280,160,306,186,12);
     end;
     if typ='noga' then
     begin
          rectangle(185,20,211,46,23);
          rectangle(275,50,301,76,23);
          rectangle(218,60,244,86,23);
          rectangle(165,160,191,186,12);
          rectangle(165,100,191,126,23);
          rectangle(280,108,306,134,12);
          rectangle(280,134,306,160,12);
          rectangle(280,160,306,186,12);
     end;
     if typ='inne' then
     begin
          rectangle(185,20,211,46,23);
          rectangle(275,50,301,76,23);
          rectangle(218,60,244,86,23);
          rectangle(165,160,191,186,23);
          rectangle(165,100,191,126,23);
          rectangle(280,108,306,134,12);
          rectangle(280,134,306,160,12);
          rectangle(280,160,306,186,12);
     end;
end;

procedure plecak_nr(x, y, d, s : integer; nr : byte);
var
   i, j : integer;
begin
     if mousein(mmx,mmy,x,y,d,s) and (leftbutton) then
     begin
{          startsound(sound[7],7,false);}
          if plecak[nr]<>ile_items then
          begin
               if sounds then play_sound(tempsound[2],sound[2],11000);
               delay(200);
               trzyma:=true;
               nritem:=plecak[nr];
               for i:= 1 to 25 do
               for j:= 1 to 25 do temp[j,i]:=items[plecak[nr]]^[j,i];
               plecak[nr]:=ile_items;
               lap:=true;
          end;
          if items_typ[nritem].typ='reka' then ramki('reka');
          if items_typ[nritem].typ='noga' then ramki('noga');
          if items_typ[nritem].typ='armor' then ramki('armor');
          if items_typ[nritem].typ='glowa' then ramki('glowa');
          if items_typ[nritem].typ='bron' then ramki('bron');
          if items_typ[nritem].typ='inne' then ramki('inne');
          if zycie<zyciemin then zyciemin:=zycie;
     end;
end;

procedure plecak_kladz(x, y, d, s : integer; nr : byte; typ : string);
var
   i, j : integer;
begin
     if (items_typ[nritem].typ=typ) and mousein(mmx,mmy,x,y,d,s) and (leftbutton) then
     begin
{          startsound(sound[8],8,false);}
          if plecak[nr]=ile_items then
          begin
               if sounds then play_sound(tempsound[1],sound[1],11000);
               delay(200);
               trzyma:=false;
               plecak[nr]:=nritem;
               lap:=false;
               if items_typ[nritem].typ='reka' then ramki('nic');
               if items_typ[nritem].typ='noga' then ramki('nic');
               if items_typ[nritem].typ='armor' then ramki('nic');
               if items_typ[nritem].typ='glowa' then ramki('nic');
               if items_typ[nritem].typ='bron' then ramki('nic');
               if items_typ[nritem].typ='inne' then ramki('nic');
          end else
          begin
               if sounds then play_sound(tempsound[1],sound[1],11000);
               delay(200);
               trzyma:=true;
               for i:= 1 to 25 do
               for j:= 1 to 25 do temp[j,i]:=items[plecak[nr]]^[j,i];
               nrtemp:=plecak[nr];
               plecak[nr]:=ile_items;
               draw_plecak;
               plecak[nr]:=nritem;
               nritem:=nrtemp;
               if items_typ[nritem].typ='reka' then ramki('reka');
               if items_typ[nritem].typ='noga' then ramki('noga');
               if items_typ[nritem].typ='armor' then ramki('armor');
               if items_typ[nritem].typ='glowa' then ramki('glowa');
               if items_typ[nritem].typ='bron' then ramki('bron');
               if items_typ[nritem].typ='inne' then ramki('inne');
          end;
     end;
end;

procedure plecak_kladz2(x, y, d, s : integer; nr : byte);
var
   i, j : integer;
begin
     if mousein(mmx,mmy,x,y,d,s) and (leftbutton) then
     begin
{          startsound(sound[8],8,false);}
          if plecak[nr]=ile_items then
          begin
               if sounds then play_sound(tempsound[1],sound[1],11000);
               delay(200);
               trzyma:=false;
               plecak[nr]:=nritem;
               lap:=false;
               if items_typ[nritem].typ='reka' then ramki('reka');
               if items_typ[nritem].typ='noga' then ramki('noga');
               if items_typ[nritem].typ='armor' then ramki('armor');
               if items_typ[nritem].typ='glowa' then ramki('glowa');
               if items_typ[nritem].typ='bron' then ramki('bron');
               if items_typ[nritem].typ='inne' then ramki('inne');
          end else
{          if plecak[nr]<>ile_items then}
          begin
               if sounds then play_sound(tempsound[1],sound[1],11000);
               delay(200);
               trzyma:=true;
               for i:= 1 to 25 do
               for j:= 1 to 25 do temp[j,i]:=items[plecak[nr]]^[j,i];
               nrtemp:=plecak[nr];
               plecak[nr]:=ile_items;
               draw_plecak;
               plecak[nr]:=nritem;
               nritem:=nrtemp;
               if items_typ[nritem].typ='reka' then ramki('reka');
               if items_typ[nritem].typ='noga' then ramki('noga');
               if items_typ[nritem].typ='armor' then ramki('armor');
               if items_typ[nritem].typ='glowa' then ramki('glowa');
               if items_typ[nritem].typ='bron' then ramki('bron');
               if items_typ[nritem].typ='inne' then ramki('inne');
          end;
     end;
end;

procedure clear_info;
var
   i, j : integer;
begin
     bar(160,15,310,190,20);
     bar(10,15,160,190,20);
     rectangle(160,15,310,190,19);
     rectangle(10,15,160,190,19);
     draw_bigpic(142,18,bigpic[2]^);
     kwadracik(185,20);
     kwadracik(275,50);
     kwadracik(218,60);
     kwadracik(165,160);
     kwadracik(165,100);
     kwadracik(280,108);
     kwadracik(280,134);
     kwadracik(280,160);
end;

begin
     closesound_game;
     initsound_skrzynia;
     nrskrzyni:=1;

     {skrzynia}
     bar(10,15,310,190,20);
     rectangle(10,15,310,190,19);

     {ludek}
     draw_bigpic(142,18,bigpic[2]^);

     kwadracik(185,20);
     kwadracik(275,50);
     kwadracik(218,60);
     kwadracik(165,160);
     kwadracik(165,100);
     kwadracik(280,108);
     kwadracik(280,134);
     kwadracik(280,160);

     setmousewindow(0,0,307,198);
     lap:=false;
     nritem:=0;
     nrtemp:=0;
     info_items;
     bar(280,190,310,198,20);
     rectangle(280,190,310,198,19);
     outtextfntxy2_rainbow(282,192,3,68,1,1,'WYJóCIE',font^);
     exit:=false;
     trzyma:=false;
     loadpal('graphics\gold.pal');
     repeat
           godzina2;
{           outtextfntxy2_rainbow(1,1,3,68,1,1,'TRZYMA='+numstrboolean(trzyma),font^);}
           mmx:=mousex;
           mmy:=mousey;
           draw_plecak;
           copy_screen(mmx-10,mmy-20,35,35);

           if plecak[5]=ile_items then czy_gracz_ma_bron:=false else czy_gracz_ma_bron:=true;

           for i:= 1 to 5 do
           begin
           if plecak[i]<>ile_items then doobrony[i]:=items_typ[plecak[i]].obrona
           else doobrony[i]:=0;
           if plecak[i]<>ile_items then dozrecznosci[i]:=items_typ[plecak[i]].dozrecznosci
           else dozrecznosci[i]:=0;
           if plecak[i]<>ile_items then doataku[i]:=items_typ[plecak[i]].doataku
           else doataku[i]:=0;
           if plecak[i]<>ile_items then dozycia[i]:=items_typ[plecak[i]].zycie
           else dozycia[i]:=0;
           end;

           zycietmp:=zycie+dozycia[1]+dozycia[2]+dozycia[3]+dozycia[4]+dozycia[5];
           zrecznosctmp:=zrecznosc+dozrecznosci[1]+dozrecznosci[2]+dozrecznosci[3]+dozrecznosci[4]+dozrecznosci[5];
           ataktmp:=atak+doataku[1]+doataku[2]+doataku[3]+doataku[4]+doataku[5];
           obronatmp:=obrona+doobrony[1]+doobrony[2]+doobrony[3]+doobrony[4]+doobrony[5];


           outtextfntxy2_rainbow(15,18,3,20,1,1,'STATUSY: ',font^);
{           outtextfntxy2_rainbow(15,28,3,55,1,1,'ΩYCIE= '+numstr(zycie+dozycia[1]+dozycia[2]+dozycia[3]
                                                               +dozycia[4]+dozycia[5]),font^);}
           outtextfntxy2_rainbow(15,28,3,55,1,1,'ΩYCIE= '+numstr(zyciemin)+'/'+numstr(zycietmp),font^);
           outtextfntxy2_rainbow(15,34,3,55,1,1,'OBRONA= '+numstr(obronatmp),font^);
           outtextfntxy2_rainbow(15,40,3,55,1,1,'ZRECZNOóè= '+numstr(zrecznosctmp),font^);
           outtextfntxy2_rainbow(15,46,3,55,1,1,'ATAK= '+numstr(ataktmp),font^);
           outtextfntxy2_rainbow(15,52,3,55,1,1,'POZIOM= '+numstr(poziom),font^);
           outtextfntxy2_rainbow(15,58,3,55,1,1,'DOóWIADCZENIE= '+numstr(dosw),font^);
           outtextfntxy2_rainbow(15,64,3,55,1,1,'SZCZ®óCIE= '+numstr(szczescie),font^);
           outtextfntxy2_rainbow(15,68+6,3,20,1,1,'NAST®PNY POZIOM:',font^);
           if poziom<15 then outtextfntxy2_rainbow(15,78+6,3,55,1,1,'POZIOM= '+numstr(poziom+1),font^) else
           outtextfntxy2_rainbow(15,78+6,3,55,1,1,'POZIOM= ---',font^);
{           if poziom<16 then
           outtextfntxy2_rainbow(15,78+6,3,55,1,1,'POZIOM= '+numstr(poziom+1),font^);
           if poziom=15 then outtextfntxy2_rainbow(15,78+6,3,55,1,1,'POZIOM= -',font^);}
           outtextfntxy2_rainbow(15,84+6,3,55,1,1,'DOóWIADCZENIE= '+numstr(nextdosw),font^);

           outtextfntxy2_rainbow(15,94+6,3,20,1,1,'PRZECIWINICY:',font^);
           outtextfntxy2_rainbow(15,104+6,3,55,1,1,'OSTATNIO ZABITY= '+last_killed,font^);
           outtextfntxy2_rainbow(15,110+6,3,55,1,1,'ILOóè ZABITYCH= '+numstr(ile_killed),font^);
           if lap then draw_temp(mmx-10,mmy-20,2);
           if not lap then ramki('nic');

           draw_cursor(mmx,mmy);
           pokazgrafike2;

{           outtextfntxy(15,18,3,20,1,1,'STATUSY: ',font^);
{           outtextfntxy(15,28,3,20,1,1,'ΩYCIE= '+numstr(zycie+dozycia[1]+dozycia[2]+dozycia[3]+dozycia[4]+dozycia[5]),font^);}
{           outtextfntxy(15,28,3,20,1,1,'ΩYCIE= '+numstr(zyciemin)+' MAX '+numstr(zycietmp),font^);
           outtextfntxy(15,34,3,20,1,1,'OBRONA= '+numstr(obronatmp),font^);
           outtextfntxy(15,40,3,20,1,1,'ZRECZNOóè= '+numstr(zrecznosctmp),font^);
           outtextfntxy(15,46,3,20,1,1,'ATAK= '+numstr(ataktmp),font^);
           outtextfntxy(15,52,3,20,1,1,'POZIOM= '+numstr(poziom),font^);
           outtextfntxy(15,58,3,20,1,1,'DOóWIADCZENIE= '+numstr(dosw),font^);
           outtextfntxy(15,68,3,20,1,1,'NAST®PNY POZIOM:',font^);
           outtextfntxy(15,78,3,20,1,1,'POZIOM= '+numstr(poziom+1),font^);
           outtextfntxy(15,84,3,20,1,1,'DOóWIADCZENIE= '+numstr(nextdosw),font^);

           outtextfntxy(15,94,3,20,1,1,'PRZECIWINICY:',font^);
           outtextfntxy(15,104,3,20,1,1,'OSTATNIO ZABITY= '+last_killed,font^);
           outtextfntxy(15,110,3,20,1,1,'ILOóè ZABITYCH= '+numstr(ile_killed),font^);}
           outtextfntxy2(15,28,3,20,1,1,'ΩYCIE= '+numstr(zyciemin)+'/'+numstr(zycietmp),font^);
           outtextfntxy2(15,34,3,20,1,1,'OBRONA= '+numstr(obronatmp),font^);
           outtextfntxy2(15,40,3,20,1,1,'ZRECZNOóè= '+numstr(zrecznosctmp),font^);
           outtextfntxy2(15,46,3,20,1,1,'ATAK= '+numstr(ataktmp),font^);
           outtextfntxy2(15,52,3,20,1,1,'POZIOM= '+numstr(poziom),font^);
           outtextfntxy2(15,58,3,20,1,1,'DOóWIADCZENIE= '+numstr(dosw),font^);
           outtextfntxy2(15,64,3,20,1,1,'SZCZ®óCIE= '+numstr(szczescie),font^);
           outtextfntxy2(15,68+6,3,20,1,1,'NAST®PNY POZIOM:',font^);
           if poziom<15 then outtextfntxy2(15,78+6,3,20,1,1,'POZIOM= '+numstr(poziom+1),font^) else
           outtextfntxy2(15,78+6,3,20,1,1,'POZIOM= ---',font^);
           outtextfntxy2(15,84+6,3,20,1,1,'DOóWIADCZENIE= '+numstr(nextdosw),font^);

           outtextfntxy2(15,94+6,3,20,1,1,'PRZECIWINICY:',font^);
           outtextfntxy2(15,104+6,3,55,1,1,'OSTATNIO ZABITY= '+last_killed,font^);
           outtextfntxy2(15,110+6,3,55,1,1,'ILOóè ZABITYCH= '+numstr(ile_killed),font^);

           put_screen(mmx-10,mmy-20,35,35);

           bar(11,130,159,189,20);
           if (ax<>mmx) or (ay<>mmy) then
           begin
                ax:=mmx;
                ay:=mmy;
           end;

           if not lap then {pobieranie}
           begin
           {plecak}

           pokaz_info_w_plecaku(186,21,210,45,1);
           pokaz_info_w_plecaku(276,51,300,75,2);
           pokaz_info_w_plecaku(219,60,243,85,3);
           pokaz_info_w_plecaku(166,160,190,185,4);
           pokaz_info_w_plecaku(166,101,190,125,5);
           pokaz_info_w_plecaku(281,109,305,134,6);
           pokaz_info_w_plecaku(281,135,305,159,7);
           pokaz_info_w_plecaku(281,160,305,185,8);


           plecak_nr(186,21,210,45,1);
           plecak_nr(276,51,300,75,2);
           plecak_nr(219,60,243,85,3);
           plecak_nr(166,160,190,185,4);
           plecak_nr(166,101,190,125,5);
           plecak_nr(281,109,305,134,6);
           plecak_nr(281,135,305,159,7);
           plecak_nr(281,160,305,185,8);
           end;
           if lap then {kladzenie}
           begin
           {plecak}
           pokaz_info_w_plecaku(186,21,210,45,1);
           pokaz_info_w_plecaku(276,51,300,75,2);
           pokaz_info_w_plecaku(219,60,243,85,3);
           pokaz_info_w_plecaku(166,160,190,185,4);
           pokaz_info_w_plecaku(166,101,190,125,5);
           pokaz_info_w_plecaku(281,109,305,134,6);
           pokaz_info_w_plecaku(281,135,305,159,7);
           pokaz_info_w_plecaku(281,160,305,185,8);
           plecak_kladz(186,21,210,45,1,'glowa');
           plecak_kladz(276,51,300,75,2,'reka');
           plecak_kladz(219,60,243,85,3,'armor');
           plecak_kladz(166,160,190,185,4,'noga');
           plecak_kladz(166,101,190,125,5,'bron');
           plecak_kladz2(281,109,305,134,6);
           plecak_kladz2(281,135,305,159,7);
           plecak_kladz2(281,160,305,185,8);
           end;

           if not trzyma and mousein(mmx+5,mmy,280,190,310,198) and leftbutton
           then exit:=true;

     until exit;
     closesound_skrzynia;
     initsound_game;
end;

procedure page_skrzynia(nrskrzyni : byte); {skrzynia}

var
   i, j : integer;
   temp : Titems;
   nritem, nrtemp : byte;
   lap : boolean;
   trzyma, exit : boolean;

procedure kwadracik(x, y : integer);
begin
     bar(x,y,x+26,y+26,22);
     rectangle(x,y,x+26,y+26,23);
end;

procedure draw_skrzynia(nr : byte);
var
   i, j : integer;
begin
     for i:= 1 to 5 do
     for j:= 1 to 4 do draw_item(i*26-7,j*26-3,skrzynia[nr][i,j]);
end;

procedure draw_plecak;
var
   i, j : integer;
begin
     draw_item(184,18,plecak[1]);
     draw_item(274,48,plecak[2]);
     draw_item(217,58,plecak[3]);
     draw_item(164,158,plecak[4]);
     draw_item(164,98,plecak[5]);
     draw_item(279,106,plecak[6]);
     draw_item(279,132,plecak[7]);
     draw_item(279,158,plecak[8]);
end;

procedure draw_temp(x, y : integer; nr : byte);
var
   i, j : integer;
begin
     for i:= 1 to 25 do
     for j:= 1 to 25 do if temp[i,j]<>52 then putpixel(i+x+1,j+y+2,temp[i,j])
end;

procedure ramki(typ : string);
var
   i : integer;
begin
     if typ='nic' then
     begin
          rectangle(185,20,211,46,23);
          rectangle(275,50,301,76,23);
          rectangle(218,60,244,86,23);
          rectangle(165,160,191,186,23);
          rectangle(165,100,191,126,23);
          rectangle(280,108,306,134,23);
          rectangle(280,134,306,160,23);
          rectangle(280,160,306,186,23);
          rectangle(20,25,150,129,23);
          for i:= 0 to 2 do line(20,51+i*26,150,51+i*26,23);
          for i:= 0 to 3 do line(46+i*26,25,46+i*26,129,23);
     end;
     if typ='glowa' then
     begin
          rectangle(185,20,211,46,12);
          rectangle(275,50,301,76,23);
          rectangle(218,60,244,86,23);
          rectangle(165,160,191,186,23);
          rectangle(165,100,191,126,23);
          rectangle(280,108,306,134,12);
          rectangle(280,134,306,160,12);
          rectangle(280,160,306,186,12);
          rectangle(20,25,150,129,12);
          for i:= 0 to 2 do line(20,51+i*26,150,51+i*26,12);
          for i:= 0 to 3 do line(46+i*26,25,46+i*26,129,12);
     end;
     if typ='reka' then
     begin
          rectangle(185,20,211,46,23);
          rectangle(275,50,301,76,12);
          rectangle(218,60,244,86,23);
          rectangle(165,160,191,186,23);
          rectangle(165,100,191,126,23);
          rectangle(280,108,306,134,12);
          rectangle(280,134,306,160,12);
          rectangle(280,160,306,186,12);
          rectangle(20,25,150,129,12);
          for i:= 0 to 2 do line(20,51+i*26,150,51+i*26,12);
          for i:= 0 to 3 do line(46+i*26,25,46+i*26,129,12);
     end;
     if typ='armor' then
     begin
          rectangle(185,20,211,46,23);
          rectangle(275,50,301,76,23);
          rectangle(218,60,244,86,12);
          rectangle(165,160,191,186,23);
          rectangle(165,100,191,126,23);
          rectangle(280,108,306,134,12);
          rectangle(280,134,306,160,12);
          rectangle(280,160,306,186,12);
          rectangle(20,25,150,129,12);
          for i:= 0 to 2 do line(20,51+i*26,150,51+i*26,12);
          for i:= 0 to 3 do line(46+i*26,25,46+i*26,129,12);
     end;
     if typ='bron' then
     begin
          rectangle(185,20,211,46,23);
          rectangle(275,50,301,76,23);
          rectangle(218,60,244,86,23);
          rectangle(165,160,191,186,23);
          rectangle(165,100,191,126,12);
          rectangle(280,108,306,134,12);
          rectangle(280,134,306,160,12);
          rectangle(280,160,306,186,12);
          rectangle(20,25,150,129,12);
          for i:= 0 to 2 do line(20,51+i*26,150,51+i*26,12);
          for i:= 0 to 3 do line(46+i*26,25,46+i*26,129,12);
     end;
     if typ='noga' then
     begin
          rectangle(185,20,211,46,23);
          rectangle(275,50,301,76,23);
          rectangle(218,60,244,86,23);
          rectangle(165,160,191,186,12);
          rectangle(165,100,191,126,23);
          rectangle(280,108,306,134,12);
          rectangle(280,134,306,160,12);
          rectangle(280,160,306,186,12);
          rectangle(20,25,150,129,12);
          for i:= 0 to 2 do line(20,51+i*26,150,51+i*26,12);
          for i:= 0 to 3 do line(46+i*26,25,46+i*26,129,12);
     end;
     if typ='inne' then
     begin
          rectangle(185,20,211,46,23);
          rectangle(275,50,301,76,23);
          rectangle(218,60,244,86,23);
          rectangle(165,160,191,186,23);
          rectangle(165,100,191,126,23);
          rectangle(280,108,306,134,12);
          rectangle(280,134,306,160,12);
          rectangle(280,160,306,186,12);
          rectangle(20,25,150,129,12);
          for i:= 0 to 2 do line(20,51+i*26,150,51+i*26,12);
          for i:= 0 to 3 do line(46+i*26,25,46+i*26,129,12);
     end;
end;

procedure plecak_nr(x, y, d, s : integer; nr : byte);
var
   i, j : integer;
begin
     if mousein(mmx,mmy,x,y,d,s) and (leftbutton) then
     begin
{          startsound(sound[7],7,false);}
          if plecak[nr]<>ile_items then
          begin
               if sounds then play_sound(tempsound[2],sound[2],11000);
               delay(200);
               trzyma:=true;
               nritem:=plecak[nr];
               for i:= 1 to 25 do
               for j:= 1 to 25 do temp[j,i]:=items[plecak[nr]]^[j,i];
               plecak[nr]:=ile_items;
               lap:=true;
          end;
          if items_typ[nritem].typ='reka' then ramki('reka');
          if items_typ[nritem].typ='noga' then ramki('noga');
          if items_typ[nritem].typ='armor' then ramki('armor');
          if items_typ[nritem].typ='glowa' then ramki('glowa');
          if items_typ[nritem].typ='bron' then ramki('bron');
          if items_typ[nritem].typ='inne' then ramki('inne');
          if zycie<zyciemin then zyciemin:=zycie;
     end;
end;

procedure plecak_kladz(x, y, d, s : integer; nr : byte; typ : string);
var
   i, j : integer;
begin
     if (items_typ[nritem].typ=typ) and mousein(mmx,mmy,x,y,d,s) and (leftbutton) then
     begin
{          startsound(sound[8],8,false);}
          if plecak[nr]=ile_items then
          begin
               if sounds then play_sound(tempsound[1],sound[1],11000);
               delay(200);
               trzyma:=false;
               plecak[nr]:=nritem;
               lap:=false;
               if items_typ[nritem].typ='reka' then ramki('nic');
               if items_typ[nritem].typ='noga' then ramki('nic');
               if items_typ[nritem].typ='armor' then ramki('nic');
               if items_typ[nritem].typ='glowa' then ramki('nic');
               if items_typ[nritem].typ='bron' then ramki('nic');
               if items_typ[nritem].typ='inne' then ramki('nic');
          end else
{          if plecak[nr]<>ile_items then}
          begin
               if sounds then play_sound(tempsound[1],sound[1],11000);
               delay(200);
               trzyma:=true;
               for i:= 1 to 25 do
               for j:= 1 to 25 do temp[j,i]:=items[plecak[nr]]^[j,i];
               nrtemp:=plecak[nr];
               plecak[nr]:=ile_items;
               draw_skrzynia(nrskrzyni);
               draw_plecak;
               plecak[nr]:=nritem;
               nritem:=nrtemp;
               if items_typ[nritem].typ='reka' then ramki('reka');
               if items_typ[nritem].typ='noga' then ramki('noga');
               if items_typ[nritem].typ='armor' then ramki('armor');
               if items_typ[nritem].typ='glowa' then ramki('glowa');
               if items_typ[nritem].typ='bron' then ramki('bron');
               if items_typ[nritem].typ='inne' then ramki('inne');
          end;
     end;
end;

procedure plecak_kladz2(x, y, d, s : integer; nr : byte);
var
   i, j : integer;
begin
     if mousein(mmx,mmy,x,y,d,s) and (leftbutton) then
     begin
{          startsound(sound[8],8,false);}
          if plecak[nr]=ile_items then
          begin
               if sounds then play_sound(tempsound[1],sound[1],11000);
               delay(200);
               trzyma:=false;
               plecak[nr]:=nritem;
               lap:=false;
               if items_typ[nritem].typ='reka' then ramki('reka');
               if items_typ[nritem].typ='noga' then ramki('noga');
               if items_typ[nritem].typ='armor' then ramki('armor');
               if items_typ[nritem].typ='glowa' then ramki('glowa');
               if items_typ[nritem].typ='bron' then ramki('bron');
               if items_typ[nritem].typ='inne' then ramki('inne');
          end else
{          if plecak[nr]<>ile_items then}
          begin
               if sounds then play_sound(tempsound[1],sound[1],11000);
               delay(200);
               trzyma:=true;
               for i:= 1 to 25 do
               for j:= 1 to 25 do temp[j,i]:=items[plecak[nr]]^[j,i];
               nrtemp:=plecak[nr];
               plecak[nr]:=ile_items;
               draw_skrzynia(nrskrzyni);
               draw_plecak;
               plecak[nr]:=nritem;
               nritem:=nrtemp;
               if items_typ[nritem].typ='reka' then ramki('reka');
               if items_typ[nritem].typ='noga' then ramki('noga');
               if items_typ[nritem].typ='armor' then ramki('armor');
               if items_typ[nritem].typ='glowa' then ramki('glowa');
               if items_typ[nritem].typ='bron' then ramki('bron');
               if items_typ[nritem].typ='inne' then ramki('inne');
          end;
     end;
end;

procedure clear_info;
var
   i, j : integer;
begin
     bar(160,15,310,190,20);
     bar(10,15,160,190,20);
     rectangle(160,15,310,190,19);
     rectangle(10,15,160,190,19);
     draw_bigpic(142,18,bigpic[2]^);
     kwadracik(185,20);
     kwadracik(275,50);
     kwadracik(218,60);
     kwadracik(165,160);
     kwadracik(165,100);
     kwadracik(280,108);
     kwadracik(280,134);
     kwadracik(280,160);
     for i:= 1 to 5 do
     for j:= 1 to 4 do kwadracik(i*26-6,j*26-1);
end;

begin
     closesound_game;
     initsound_skrzynia;
     open[7]:=true;
           if sounds then
           begin
           play_sound(tempsound[3],sound[3],11000);
           end;
     open[nrskrzyni]:=true;
     {skrzynia}
     bar(10,15,160,190,20);
     rectangle(10,15,160,190,19);

     for i:= 1 to 5 do
     for j:= 1 to 4 do kwadracik(i*26-6,j*26-1);
{     for i:= 1 to 5 do
     for j:= 1 to 4 do skrzynia[nrskrzyni][i,j]:=ile_items;}

     {ludek}
     bar(160,15,310,190,20);
     rectangle(160,15,310,190,19);
     draw_bigpic(142,18,bigpic[2]^);

     kwadracik(185,20);
     kwadracik(275,50);
     kwadracik(218,60);
     kwadracik(165,160);
     kwadracik(165,100);
     kwadracik(280,108);
     kwadracik(280,134);
     kwadracik(280,160);

     setmousewindow(0,0,307,198);
     lap:=false;
     nritem:=0;
     nrtemp:=0;
     info_items;
     bar(280,190,310,198,20);
     rectangle(280,190,310,198,19);
     outtextfntxy2_rainbow(282,192,3,68,1,1,'WYJóCIE',font^);
     exit:=false;
     trzyma:=false;
     loadpal('graphics\gold.pal');
     repeat
           godzina2;
           mmx:=mousex;
           mmy:=mousey;
           draw_skrzynia(nrskrzyni);
           draw_plecak;
           for i:= 1 to 5 do
           begin
           if plecak[i]<>ile_items then doobrony[i]:=items_typ[plecak[i]].obrona
           else doobrony[i]:=0;
           if plecak[i]<>ile_items then dozrecznosci[i]:=items_typ[plecak[i]].dozrecznosci
           else dozrecznosci[i]:=0;
           if plecak[i]<>ile_items then doataku[i]:=items_typ[plecak[i]].doataku
           else doataku[i]:=0;
           if plecak[i]<>ile_items then dozycia[i]:=items_typ[plecak[i]].zycie
           else dozycia[i]:=0;
           end;

           zycietmp:=zycie+dozycia[1]+dozycia[2]+dozycia[3]+dozycia[4]+dozycia[5];
           zrecznosctmp:=zrecznosc+dozrecznosci[1]+dozrecznosci[2]+dozrecznosci[3]+dozrecznosci[4]+dozrecznosci[5];
           ataktmp:=atak+doataku[1]+doataku[2]+doataku[3]+doataku[4]+doataku[5];
           obronatmp:=obrona+doobrony[1]+doobrony[2]+doobrony[3]+doobrony[4]+doobrony[5];
           copy_screen(mmx-10,mmy-20,35,35);
           outtextfntxy2_rainbow(245,24,3,55,1,1,'ΩYCIE= '+numstr(zyciemin)+'/'+numstr(zycietmp),font^);
           outtextfntxy2_rainbow(245,30,3,55,1,1,'OBRONA= '+numstr(obronatmp),font^);
           outtextfntxy2_rainbow(245,36,3,55,1,1,'ZRECZNOóè= '+numstr(zrecznosctmp),font^);
           outtextfntxy2_rainbow(245,42,3,55,1,1,'ATAK= '+numstr(ataktmp),font^);
           if lap then draw_temp(mmx-10,mmy-20,2);
           if not lap then ramki('nic');

           draw_cursor(mmx,mmy);

           pokazgrafike2;
           outtextfntxy2(245,24,3,20,1,1,'ΩYCIE= '+numstr(zyciemin)+'/'+numstr(zycietmp),font^);
           outtextfntxy2(245,30,3,20,1,1,'OBRONA= '+numstr(obronatmp),font^);
           outtextfntxy2(245,36,3,20,1,1,'ZRECZNOóè= '+numstr(zrecznosctmp),font^);
           outtextfntxy2(245,42,3,20,1,1,'ATAK= '+numstr(ataktmp),font^);

           put_screen(mmx-10,mmy-20,35,35);

           if mousein(mmx,mmy,21,26,149,128) then
           begin
                mmx:=((mmx+5) div 26)*26;
                mmy:=((mmy) div 26)*26;
                bar(11,130,159,189,20);
                if skrzynia[nrskrzyni][mmx div 26,mmy div 26]=ile_items then bar(11,130,159,189,20);
                {BRON}
                if items_typ[skrzynia[nrskrzyni][mmx div 26,mmy div 26]].typ='bron' then
                begin
                outtextfntxy2_rainbow(15,135,3,70,1,1,items_typ[skrzynia[nrskrzyni][mmx div 26,mmy div 26]].nazwa,font^);
                outtextfntxy2_rainbow(15,145,3,20,1,1,'ATAK= OD '+numstr(items_typ[skrzynia[nrskrzyni][mmx div 26,
                mmy div 26]].atak)+' DO '+numstr(items_typ[skrzynia[nrskrzyni][mmx div 26,mmy div 26]].maxatak),font^);
                outtextfntxy2_rainbow(15,151,3,43,1,1,'DO OBRONY= '+numstr(items_typ[skrzynia[nrskrzyni][mmx div 26,
                mmy div 26]].obrona),font^);
                outtextfntxy2_rainbow(15,157,3,43,1,1,'DO ATAKU= '+numstr(items_typ[skrzynia[nrskrzyni][mmx div 26,
                mmy div 26]].doataku),font^);
                outtextfntxy2_rainbow(15,163,3,43,1,1,'DO ZRECZNOóCI= '+numstr(items_typ[skrzynia[nrskrzyni][mmx div 26,
                mmy div 26]].dozrecznosci),font^);
                outtextfntxy2_rainbow(15,169,3,43,1,1,'DO ΩYCIA= '+numstr(items_typ[skrzynia[nrskrzyni][mmx div 26,
                mmy div 26]].zycie),font^);
                if items_typ[skrzynia[nrskrzyni][mmx div 26,mmy div 26]].magia=true then
                begin
                outtextfntxy2_rainbow(15,175,3,56,1,1,'MAGICZNY PRZEDMIOT',font^);
                outtextfntxy2_rainbow(15,181,3,20,1,1,'ZAKL®CIE= '+items_typ[skrzynia[nrskrzyni][mmx div 26,
                mmy div 26]].zaklecie,font^);
                end;
                end;
                {GLOWA}
                if items_typ[skrzynia[nrskrzyni][mmx div 26,mmy div 26]].typ='glowa' then
                begin
                outtextfntxy2_rainbow(15,135,3,70,1,1,items_typ[skrzynia[nrskrzyni][mmx div 26,mmy div 26]].nazwa,font^);
                outtextfntxy2_rainbow(15,145,3,20,1,1,'OBRONA= '+numstr(items_typ[skrzynia[nrskrzyni][mmx div 26,
                mmy div 26]].obrona),font^);
                outtextfntxy2_rainbow(15,151,3,43,1,1,'DO ATAKU= '+numstr(items_typ[skrzynia[nrskrzyni][mmx div 26,
                mmy div 26]].doataku),font^);
                outtextfntxy2_rainbow(15,157,3,43,1,1,'DO ZRECZNOóCI= '+numstr(items_typ[skrzynia[nrskrzyni][mmx div 26,
                mmy div 26]].dozrecznosci),font^);
                outtextfntxy2_rainbow(15,163,3,43,1,1,'DO ΩYCIA= '+numstr(items_typ[skrzynia[nrskrzyni][mmx div 26,
                mmy div 26]].zycie),font^);
                if items_typ[skrzynia[nrskrzyni][mmx div 26,mmy div 26]].magia=true then
                begin
                outtextfntxy2_rainbow(15,169,3,56,1,1,'MAGICZNY PRZEDMIOT',font^);
                outtextfntxy2_rainbow(15,175,3,20,1,1,'ZAKL®CIE= '+items_typ[skrzynia[nrskrzyni][mmx div 26,
                mmy div 26]].zaklecie,font^);
                end;
                end;
                {ARMOR}
                if items_typ[skrzynia[nrskrzyni][mmx div 26,mmy div 26]].typ='armor' then
                begin
                outtextfntxy2_rainbow(15,135,3,70,1,1,items_typ[skrzynia[nrskrzyni][mmx div 26,mmy div 26]].nazwa,font^);
                outtextfntxy2_rainbow(15,145,3,20,1,1,'OBRONA= '+numstr(items_typ[skrzynia[nrskrzyni][mmx div 26,
                mmy div 26]].obrona),font^);
                outtextfntxy2_rainbow(15,151,3,43,1,1,'DO ATAKU= '+numstr(items_typ[skrzynia[nrskrzyni][mmx div 26,
                mmy div 26]].doataku),font^);
                outtextfntxy2_rainbow(15,157,3,43,1,1,'DO ZRECZNOóCI= '+numstr(items_typ[skrzynia[nrskrzyni][mmx div 26,
                mmy div 26]].dozrecznosci),font^);
                outtextfntxy2_rainbow(15,163,3,43,1,1,'DO ΩYCIA= '+numstr(items_typ[skrzynia[nrskrzyni][mmx div 26,
                mmy div 26]].zycie),font^);
                if items_typ[skrzynia[nrskrzyni][mmx div 26,mmy div 26]].magia=true then
                begin
                outtextfntxy2_rainbow(15,169,3,56,1,1,'MAGICZNY PRZEDMIOT',font^);
                outtextfntxy2_rainbow(15,175,3,20,1,1,'ZAKL®CIE= '+items_typ[skrzynia[nrskrzyni][mmx div 26,
                mmy div 26]].zaklecie,font^);
                end;
                end;
                {REKA}
                if items_typ[skrzynia[nrskrzyni][mmx div 26,mmy div 26]].typ='reka' then
                begin
                outtextfntxy2_rainbow(15,135,3,70,1,1,items_typ[skrzynia[nrskrzyni][mmx div 26,mmy div 26]].nazwa,font^);
                outtextfntxy2_rainbow(15,145,3,43,1,1,'DO OBRONY= '+numstr(items_typ[skrzynia[nrskrzyni][mmx div 26,
                mmy div 26]].obrona),font^);
                outtextfntxy2_rainbow(15,151,3,43,1,1,'DO ATAKU= '+numstr(items_typ[skrzynia[nrskrzyni][mmx div 26,
                mmy div 26]].doataku),font^);
                outtextfntxy2_rainbow(15,157,3,43,1,1,'DO ZRECZNOóCI= '+numstr(items_typ[skrzynia[nrskrzyni][mmx div 26,
                mmy div 26]].dozrecznosci),font^);
                outtextfntxy2_rainbow(15,163,3,43,1,1,'DO ΩYCIA= '+numstr(items_typ[skrzynia[nrskrzyni][mmx div 26,
                mmy div 26]].zycie),font^);
                if items_typ[skrzynia[nrskrzyni][mmx div 26,mmy div 26]].magia=true then
                begin
                outtextfntxy2_rainbow(15,169,3,56,1,1,'MAGICZNY PRZEDMIOT',font^);
                outtextfntxy2_rainbow(15,175,3,20,1,1,'ZAKL®CIE= '+items_typ[skrzynia[nrskrzyni][mmx div 26,
                mmy div 26]].zaklecie,font^);
                end;
                end;
                {NOGA}
                if items_typ[skrzynia[nrskrzyni][mmx div 26,mmy div 26]].typ='noga' then
                begin
                outtextfntxy2_rainbow(15,135,3,70,1,1,items_typ[skrzynia[nrskrzyni][mmx div 26,mmy div 26]].nazwa,font^);
                outtextfntxy2_rainbow(15,145,3,20,1,1,'OBRONA= '+numstr(items_typ[skrzynia[nrskrzyni][mmx div 26,
                mmy div 26]].obrona),font^);
                outtextfntxy2_rainbow(15,151,3,43,1,1,'DO ATAKU= '+numstr(items_typ[skrzynia[nrskrzyni][mmx div 26,
                mmy div 26]].doataku),font^);
                outtextfntxy2_rainbow(15,157,3,43,1,1,'DO ZRECZNOóCI= '+numstr(items_typ[skrzynia[nrskrzyni][mmx div 26,
                mmy div 26]].dozrecznosci),font^);
                outtextfntxy2_rainbow(15,163,3,43,1,1,'DO ΩYCIA= '+numstr(items_typ[skrzynia[nrskrzyni][mmx div 26,
                mmy div 26]].zycie),font^);
                if items_typ[skrzynia[nrskrzyni][mmx div 26,mmy div 26]].magia=true then
                begin
                outtextfntxy2_rainbow(15,169,3,56,1,1,'MAGICZNY PRZEDMIOT',font^);
                outtextfntxy2_rainbow(15,175,3,20,1,1,'ZAKL®CIE= '+items_typ[skrzynia[nrskrzyni][mmx div 26,
                mmy div 26]].zaklecie,font^);
                end;
                end;
                {INNE}
                if items_typ[skrzynia[nrskrzyni][mmx div 26,mmy div 26]].typ='inne' then
                begin
                outtextfntxy2_rainbow(15,135,3,70,1,1,items_typ[skrzynia[nrskrzyni][mmx div 26,mmy div 26]].nazwa,font^);
                outtextfntxy2_rainbow(15,147,3,20,1,1,items_typ[skrzynia[nrskrzyni][mmx div 26,mmy div 26]].info,font^);
                end;
                if (items_typ[skrzynia[nrskrzyni][mmx div 26,mmy div 26]].typ='inne') and
                (items_typ[skrzynia[nrskrzyni][mmx div 26,mmy div 26]].nazwa='NAP‡J ODNAWIAJ§CY')
                and rightbutton then
                begin
                     if zyciemin<>zycietmp then
                     begin
                     if sounds then play_sound(tempsound[4],sound[4],11000);
                     zyciemin:=zyciemin+5;
                     if zyciemin>=zycietmp then zyciemin:=zycietmp;
                     skrzynia[nrskrzyni][mmx div 26,mmy div 26]:=ile_items;
                     end;
                end;
           end else bar(11,130,159,189,20);

           if not lap then {pobieranie}
           begin

           {plecak}
           pokaz_info_w_plecaku(186,21,210,45,1);
           pokaz_info_w_plecaku(276,51,300,75,2);
           pokaz_info_w_plecaku(219,60,243,85,3);
           pokaz_info_w_plecaku(166,160,190,185,4);
           pokaz_info_w_plecaku(166,101,190,125,5);
           pokaz_info_w_plecaku(281,109,305,134,6);
           pokaz_info_w_plecaku(281,135,305,159,7);
           pokaz_info_w_plecaku(281,160,305,185,8);

           plecak_nr(186,21,210,45,1);
           plecak_nr(276,51,300,75,2);
           plecak_nr(219,60,243,85,3);
           plecak_nr(166,160,190,185,4);
           plecak_nr(166,101,190,125,5);
           plecak_nr(281,109,305,134,6);
           plecak_nr(281,135,305,159,7);
           plecak_nr(281,160,305,185,8);
           {skrzynia}

           if mousein(mmx,mmy,21,26,149,128) and (leftbutton) then
           begin
{                startsound(sound[7],7,false);}
                mmx:=((mmx+5) div 26)*26;
                mmy:=((mmy) div 26)*26;
                if skrzynia[nrskrzyni][mmx div 26,mmy div 26]<>ile_items then
                begin
                     if sounds then play_sound(tempsound[2],sound[2],11000);
                     delay(200);
                     trzyma:=true;
                     nritem:=skrzynia[nrskrzyni][mmx div 26,mmy div 26];
                     for i:= 1 to 25 do
                     for j:= 1 to 25 do temp[j,i]:=items[skrzynia[nrskrzyni][mmx div 26,mmy div 26]]^[j,i];
                     skrzynia[nrskrzyni][mmx div 26,mmy div 26]:=ile_items;
                     lap:=true;
                end;
                if items_typ[nritem].typ='reka' then ramki('reka');
                if items_typ[nritem].typ='noga' then ramki('noga');
                if items_typ[nritem].typ='armor' then ramki('armor');
                if items_typ[nritem].typ='glowa' then ramki('glowa');
                if items_typ[nritem].typ='bron' then ramki('bron');
                if items_typ[nritem].typ='inne' then ramki('inne');
           end;
           end;
           if lap then {kladzenie}
           begin
           {plecak}
           pokaz_info_w_plecaku(186,21,210,45,1);
           pokaz_info_w_plecaku(276,51,300,75,2);
           pokaz_info_w_plecaku(219,60,243,85,3);
           pokaz_info_w_plecaku(166,160,190,185,4);
           pokaz_info_w_plecaku(166,101,190,125,5);
           pokaz_info_w_plecaku(281,109,305,134,6);
           pokaz_info_w_plecaku(281,135,305,159,7);
           pokaz_info_w_plecaku(281,160,305,185,8);
           plecak_kladz(186,21,210,45,1,'glowa');
           plecak_kladz(276,51,300,75,2,'reka');
           plecak_kladz(219,60,243,85,3,'armor');
           plecak_kladz(166,160,190,185,4,'noga');
           plecak_kladz(166,101,190,125,5,'bron');
           plecak_kladz2(281,109,305,134,6);
           plecak_kladz2(281,135,305,159,7);
           plecak_kladz2(281,160,305,185,8);
           {skrzynia}
           if mousein(mmx,mmy,21,26,149,128) and (leftbutton) then
           begin
{                startsound(sound[8],8,false);}
                mmx:=((mmx+5) div 26)*26;
                mmy:=((mmy) div 26)*26;
                if skrzynia[nrskrzyni][mmx div 26,mmy div 26]<>ile_items then
                begin
                     if sounds then play_sound(tempsound[1],sound[1],11000);
                     delay(200);
                     trzyma:=true;
                     for i:= 1 to 25 do
                     for j:= 1 to 25 do temp[j,i]:=items[skrzynia[nrskrzyni][mmx div 26,mmy div 26]]^[j,i];
                     nrtemp:=skrzynia[nrskrzyni][mmx div 26,mmy div 26];
                     skrzynia[nrskrzyni][mmx div 26,mmy div 26]:=ile_items;
                     draw_skrzynia(nrskrzyni);
                     skrzynia[nrskrzyni][mmx div 26,mmy div 26]:=nritem;
                     nritem:=nrtemp;
                     if items_typ[nritem].typ='reka' then ramki('reka');
                     if items_typ[nritem].typ='noga' then ramki('noga');
                     if items_typ[nritem].typ='armor' then ramki('armor');
                     if items_typ[nritem].typ='glowa' then ramki('glowa');
                     if items_typ[nritem].typ='bron' then ramki('bron');
                     if items_typ[nritem].typ='inne' then ramki('inne');
                end;
                if skrzynia[nrskrzyni][mmx div 26,mmy div 26]=ile_items then
                begin
                     delay(200);
                     trzyma:=false;
                     skrzynia[nrskrzyni][mmx div 26,mmy div 26]:=nritem;
                     lap:=false;
                     if items_typ[nritem].typ='reka' then ramki('nic');
                     if items_typ[nritem].typ='noga' then ramki('nic');
                     if items_typ[nritem].typ='armor' then ramki('nic');
                     if items_typ[nritem].typ='glowa' then ramki('nic');
                     if items_typ[nritem].typ='bron' then ramki('nic');
                     if items_typ[nritem].typ='inne' then ramki('nic');
                end;
                end;
           end;

           if not trzyma and mousein(mmx+5,mmy,280,190,310,198) and leftbutton
           then exit:=true;

     until exit;
     closesound_skrzynia;
     if not inhome then initsound_game;
     if inhome then initsound_room;
end;

procedure strony_info;
begin
for i:= 1 to ile_items do new(items[i]);
load_items_to_memory;
{keydown[1]:=true; {<--- p¢´niej skasowaÜ}
page_game;

delay(200);
page_skrzynia(1);
for i:= 1 to ile_items do dispose(items[i]);
end;

function info_ico(x, y, d, s : integer; info : string) : boolean;
begin
     if mousein(mmx+5,mmy,x,y,d,s) then
     begin
          opis_ico:=info;
          info_ico:=true;
          rectangle(x,y,d,s,43);
          outtextfntxy2_rainbow_center(270,191,3,171,1,1,opis_ico,font^);
     end
     else
     begin
{          bar(231,190,315,198,219);
          rectangle(231,190,315,198,120);}
          opis_ico:='';
          info_ico:=false;
          outtextfntxy2_rainbow_center(270,191,3,171,1,1,opis_ico,font^);
          rectangle(x,y,d,s,220);
     end;
end;

procedure show_icony;
begin
     bar(231,171-18,249,188-18,219);
     rectangle(231,171-18,249,188-18,220);
     outtextfntxy2(233,159,3,0,1,1,'MENU',font^);
     bar(231,171,249,188,219);
     rectangle(231,171,249,188,220);
     circle(240,175,2,0);
     circle(240,175,1,0);
     putpixel(240,175,0);
     line(240,175,240,183,0);
     line(240,183,238,186,0);
     line(240,183,242,186,0);
     line(240,178,236,181,0);
     line(240,178,244,181,0);
end;

procedure show_kasa;
begin
     rectangle(233,7,313,18,220);
     bar(234,8,312,17,219);
     outtextfntxy2(237,9,3,43,1,1,'$',font^);
     outtextfntxy2(237,10,3,14,1,1,'$',font^);
     outtextfntxy2(308-length(numstrreal(kasa,0))*4+2,9,3,43,1,1,numstrreal(kasa,0),font^);
     outtextfntxy2(308-length(numstrreal(kasa,0))*4+2,10,3,14,1,1,numstrreal(kasa,0),font^);
end;

procedure ustaw_skrzynie_i_plecak;
begin
     plecak[1]:=10; {glowa}
     plecak[2]:=ile_items; {reka}
     plecak[3]:=13; {armor}
     plecak[4]:=ile_items; {noga}
     plecak[5]:=6; {bron}
     plecak[6]:=46; {inne}
     plecak[7]:=ile_items; {inne}
     plecak[8]:=ile_items; {inne}

     skrzynia[1][1,1]:=ile_items;skrzynia[1][2,1]:=ile_items;skrzynia[1][3,1]:=ile_items;
     skrzynia[1][4,1]:=ile_items;skrzynia[1][5,1]:=ile_items;
     skrzynia[1][1,2]:=46;
     skrzynia[1][2,2]:=ile_items;skrzynia[1][3,2]:=ile_items;
     skrzynia[1][4,2]:=ile_items;skrzynia[1][5,2]:=ile_items;
     skrzynia[1][1,3]:=ile_items;skrzynia[1][2,3]:=ile_items;
     skrzynia[1][3,3]:=ile_items;skrzynia[1][4,3]:=ile_items;
     skrzynia[1][5,3]:=46;
     skrzynia[1][1,4]:=ile_items;skrzynia[1][2,4]:=ile_items;skrzynia[1][3,4]:=ile_items;
     skrzynia[1][4,4]:=ile_items;skrzynia[1][5,4]:=ile_items;

     skrzynia[2][1,1]:=20;
     skrzynia[2][2,1]:=18;
     skrzynia[2][3,1]:=ile_items;skrzynia[2][4,1]:=ile_items;skrzynia[2][5,1]:=ile_items;
     skrzynia[2][1,2]:=ile_items;skrzynia[2][2,2]:=ile_items;skrzynia[2][3,2]:=ile_items;
     skrzynia[2][4,2]:=ile_items;skrzynia[2][5,2]:=ile_items;skrzynia[2][1,3]:=ile_items;
     skrzynia[2][2,3]:=ile_items;skrzynia[2][3,3]:=ile_items;skrzynia[2][4,3]:=ile_items;
     skrzynia[2][5,3]:=ile_items;skrzynia[2][1,4]:=ile_items;skrzynia[2][2,4]:=ile_items;
     skrzynia[2][3,4]:=ile_items;skrzynia[2][4,4]:=ile_items;skrzynia[2][5,4]:=ile_items;

     skrzynia[3][1,1]:=ile_items;skrzynia[3][2,1]:=ile_items;
     skrzynia[3][3,1]:=ile_items;skrzynia[3][4,1]:=6;skrzynia[3][5,1]:=ile_items;
     skrzynia[3][1,2]:=12;skrzynia[3][2,2]:=ile_items;skrzynia[3][3,2]:=ile_items;
     skrzynia[3][4,2]:=ile_items;skrzynia[3][5,2]:=7;skrzynia[3][1,3]:=ile_items;
     skrzynia[3][2,3]:=ile_items;skrzynia[3][3,3]:=ile_items;skrzynia[3][4,3]:=ile_items;
     skrzynia[3][5,3]:=ile_items;skrzynia[3][1,4]:=ile_items;skrzynia[3][2,4]:=ile_items;
     skrzynia[3][3,4]:=ile_items;skrzynia[3][4,4]:=ile_items;skrzynia[3][5,4]:=46;

     skrzynia[4][1,1]:=1;skrzynia[4][2,1]:=ile_items;
     skrzynia[4][3,1]:=ile_items;skrzynia[4][4,1]:=ile_items;skrzynia[4][5,1]:=ile_items;
     skrzynia[4][1,2]:=ile_items;skrzynia[4][2,2]:=ile_items;skrzynia[4][3,2]:=ile_items;
     skrzynia[4][4,2]:=ile_items;skrzynia[4][5,2]:=ile_items;skrzynia[4][1,3]:=ile_items;
     skrzynia[4][2,3]:=ile_items;skrzynia[4][3,3]:=3;skrzynia[4][4,3]:=ile_items;
     skrzynia[4][5,3]:=ile_items;skrzynia[4][1,4]:=32;skrzynia[4][2,4]:=ile_items;
     skrzynia[4][3,4]:=ile_items;skrzynia[4][4,4]:=ile_items;skrzynia[4][5,4]:=ile_items;

     skrzynia[5][1,1]:=ile_items;skrzynia[5][2,1]:=ile_items;
     skrzynia[5][3,1]:=ile_items;skrzynia[5][4,1]:=ile_items;skrzynia[5][5,1]:=ile_items;
     skrzynia[5][1,2]:=ile_items;skrzynia[5][2,2]:=ile_items;skrzynia[5][3,2]:=ile_items;
     skrzynia[5][4,2]:=ile_items;skrzynia[5][5,2]:=ile_items;skrzynia[5][1,3]:=ile_items;
     skrzynia[5][2,3]:=37;skrzynia[5][3,3]:=ile_items;skrzynia[5][4,3]:=ile_items;
     skrzynia[5][5,3]:=ile_items;skrzynia[5][1,4]:=ile_items;skrzynia[5][2,4]:=34;
     skrzynia[5][3,4]:=ile_items;skrzynia[5][4,4]:=ile_items;skrzynia[5][5,4]:=46;

     skrzynia[6][1,1]:=ile_items;skrzynia[6][2,1]:=ile_items;
     skrzynia[6][3,1]:=46;skrzynia[6][4,1]:=27;skrzynia[6][5,1]:=ile_items;
     skrzynia[6][1,2]:=15;skrzynia[6][2,2]:=14;skrzynia[6][3,2]:=ile_items;
     skrzynia[6][4,2]:=ile_items;skrzynia[6][5,2]:=ile_items;skrzynia[6][1,3]:=ile_items;
     skrzynia[6][2,3]:=ile_items;skrzynia[6][3,3]:=ile_items;skrzynia[6][4,3]:=ile_items;
     skrzynia[6][5,3]:=19;skrzynia[6][1,4]:=ile_items;skrzynia[6][2,4]:=ile_items;
     skrzynia[6][3,4]:=46;skrzynia[6][4,4]:=ile_items;skrzynia[6][5,4]:=ile_items;

     skrzynia[7][1,1]:=ile_items;skrzynia[7][2,1]:=ile_items;
     skrzynia[7][3,1]:=ile_items;skrzynia[7][4,1]:=ile_items;skrzynia[7][5,1]:=ile_items;
     skrzynia[7][1,2]:=ile_items;skrzynia[7][2,2]:=ile_items;skrzynia[7][3,2]:=ile_items;
     skrzynia[7][4,2]:=ile_items;skrzynia[7][5,2]:=29;skrzynia[7][1,3]:=ile_items;
     skrzynia[7][2,3]:=ile_items;skrzynia[7][3,3]:=30;skrzynia[7][4,3]:=ile_items;
     skrzynia[7][5,3]:=ile_items;skrzynia[7][1,4]:=ile_items;skrzynia[7][2,4]:=ile_items;
     skrzynia[7][3,4]:=ile_items;skrzynia[7][4,4]:=ile_items;skrzynia[7][5,4]:=ile_items;

     {tunele}
     skrzynia[8][1,1]:=ile_items;skrzynia[8][2,1]:=ile_items;
     skrzynia[8][3,1]:=42;skrzynia[8][4,1]:=ile_items;skrzynia[8][5,1]:=ile_items;
     skrzynia[8][1,2]:=ile_items;skrzynia[8][2,2]:=ile_items;skrzynia[8][3,2]:=ile_items;
     skrzynia[8][4,2]:=ile_items;skrzynia[8][5,2]:=ile_items;skrzynia[8][1,3]:=ile_items;
     skrzynia[8][2,3]:=ile_items;skrzynia[8][3,3]:=ile_items;skrzynia[8][4,3]:=ile_items;
     skrzynia[8][5,3]:=ile_items;skrzynia[8][1,4]:=ile_items;skrzynia[8][2,4]:=ile_items;
     skrzynia[8][3,4]:=ile_items;skrzynia[8][4,4]:=ile_items;skrzynia[8][5,4]:=ile_items;

     skrzynia[9][1,1]:=ile_items;skrzynia[9][2,1]:=ile_items;
     skrzynia[9][3,1]:=ile_items;skrzynia[9][4,1]:=ile_items;skrzynia[9][5,1]:=ile_items;
     skrzynia[9][1,2]:=41;skrzynia[9][2,2]:=ile_items;skrzynia[9][3,2]:=ile_items;
     skrzynia[9][4,2]:=ile_items;skrzynia[9][5,2]:=ile_items;skrzynia[9][1,3]:=ile_items;
     skrzynia[9][2,3]:=ile_items;skrzynia[9][3,3]:=40;skrzynia[9][4,3]:=ile_items;
     skrzynia[9][5,3]:=ile_items;skrzynia[9][1,4]:=ile_items;skrzynia[9][2,4]:=ile_items;
     skrzynia[9][3,4]:=ile_items;skrzynia[9][4,4]:=ile_items;skrzynia[9][5,4]:=ile_items;

     skrzynia[10][1,1]:=ile_items;skrzynia[10][2,1]:=ile_items;
     skrzynia[10][3,1]:=ile_items;skrzynia[10][4,1]:=ile_items;skrzynia[10][5,1]:=ile_items;
     skrzynia[10][1,2]:=ile_items;skrzynia[10][2,2]:=ile_items;skrzynia[10][3,2]:=ile_items;
     skrzynia[10][4,2]:=ile_items;skrzynia[10][5,2]:=ile_items;skrzynia[10][1,3]:=ile_items;
     skrzynia[10][2,3]:=ile_items;skrzynia[10][3,3]:=39;skrzynia[10][4,3]:=ile_items;
     skrzynia[10][5,3]:=ile_items;skrzynia[10][1,4]:=ile_items;skrzynia[10][2,4]:=46;
     skrzynia[10][3,4]:=ile_items;skrzynia[10][4,4]:=ile_items;skrzynia[10][5,4]:=46;

     skrzynia[11][1,1]:=ile_items;skrzynia[11][2,1]:=36;
     skrzynia[11][3,1]:=ile_items;skrzynia[11][4,1]:=ile_items;skrzynia[11][5,1]:=ile_items;
     skrzynia[11][1,2]:=ile_items;skrzynia[11][2,2]:=ile_items;skrzynia[11][3,2]:=ile_items;
     skrzynia[11][4,2]:=ile_items;skrzynia[11][5,2]:=ile_items;skrzynia[11][1,3]:=ile_items;
     skrzynia[11][2,3]:=ile_items;skrzynia[11][3,3]:=ile_items;skrzynia[11][4,3]:=ile_items;
     skrzynia[11][5,3]:=ile_items;skrzynia[11][1,4]:=ile_items;skrzynia[11][2,4]:=ile_items;
     skrzynia[11][3,4]:=ile_items;skrzynia[11][4,4]:=ile_items;skrzynia[11][5,4]:=ile_items;

     skrzynia[12][1,1]:=ile_items;skrzynia[12][2,1]:=ile_items;
     skrzynia[12][3,1]:=ile_items;skrzynia[12][4,1]:=ile_items;skrzynia[12][5,1]:=ile_items;
     skrzynia[12][1,2]:=ile_items;skrzynia[12][2,2]:=ile_items;skrzynia[12][3,2]:=ile_items;
     skrzynia[12][4,2]:=ile_items;skrzynia[12][5,2]:=ile_items;skrzynia[12][1,3]:=ile_items;
     skrzynia[12][2,3]:=ile_items;skrzynia[12][3,3]:=ile_items;skrzynia[12][4,3]:=ile_items;
     skrzynia[12][5,3]:=ile_items;skrzynia[12][1,4]:=ile_items;skrzynia[12][2,4]:=ile_items;
     skrzynia[12][3,4]:=23;skrzynia[12][4,4]:=ile_items;skrzynia[12][5,4]:=ile_items;

     skrzynia[13][1,1]:=46;skrzynia[13][2,1]:=ile_items;
     skrzynia[13][3,1]:=ile_items;skrzynia[13][4,1]:=ile_items;skrzynia[13][5,1]:=46;
     skrzynia[13][1,2]:=ile_items;skrzynia[13][2,2]:=ile_items;skrzynia[13][3,2]:=46;
     skrzynia[13][4,2]:=46;skrzynia[13][5,2]:=15;skrzynia[13][1,3]:=ile_items;
     skrzynia[13][2,3]:=ile_items;skrzynia[13][3,3]:=ile_items;skrzynia[13][4,3]:=ile_items;
     skrzynia[13][5,3]:=ile_items;skrzynia[13][1,4]:=ile_items;skrzynia[13][2,4]:=ile_items;
     skrzynia[13][3,4]:=17;skrzynia[13][4,4]:=ile_items;skrzynia[13][5,4]:=ile_items;

     skrzynia[14][1,1]:=4;skrzynia[14][2,1]:=ile_items;
     skrzynia[14][3,1]:=2;skrzynia[14][4,1]:=ile_items;skrzynia[14][5,1]:=46;
     skrzynia[14][1,2]:=ile_items;skrzynia[14][2,2]:=ile_items;skrzynia[14][3,2]:=46;
     skrzynia[14][4,2]:=ile_items;skrzynia[14][5,2]:=ile_items;skrzynia[14][1,3]:=46;
     skrzynia[14][2,3]:=ile_items;skrzynia[14][3,3]:=ile_items;skrzynia[14][4,3]:=ile_items;
     skrzynia[14][5,3]:=ile_items;skrzynia[14][1,4]:=ile_items;skrzynia[14][2,4]:=ile_items;
     skrzynia[14][3,4]:=ile_items;skrzynia[14][4,4]:=ile_items;skrzynia[14][5,4]:=ile_items;

     skrzynia[15][1,1]:=ile_items;skrzynia[15][2,1]:=ile_items;
     skrzynia[15][3,1]:=46;skrzynia[15][4,1]:=ile_items;skrzynia[15][5,1]:=ile_items;
     skrzynia[15][1,2]:=ile_items;skrzynia[15][2,2]:=ile_items;skrzynia[15][3,2]:=46;
     skrzynia[15][4,2]:=ile_items;skrzynia[15][5,2]:=6;skrzynia[15][1,3]:=46;
     skrzynia[15][2,3]:=ile_items;skrzynia[15][3,3]:=ile_items;skrzynia[15][4,3]:=ile_items;
     skrzynia[15][5,3]:=ile_items;skrzynia[15][1,4]:=ile_items;skrzynia[15][2,4]:=ile_items;
     skrzynia[15][3,4]:=ile_items;skrzynia[15][4,4]:=ile_items;skrzynia[15][5,4]:=ile_items;

     skrzynia[16][1,1]:=ile_items;skrzynia[16][2,1]:=ile_items;
     skrzynia[16][3,1]:=ile_items;skrzynia[16][4,1]:=ile_items;skrzynia[16][5,1]:=ile_items;
     skrzynia[16][1,2]:=ile_items;skrzynia[16][2,2]:=ile_items;skrzynia[16][3,2]:=ile_items;
     skrzynia[16][4,2]:=ile_items;skrzynia[16][5,2]:=ile_items;skrzynia[16][1,3]:=ile_items;
     skrzynia[16][2,3]:=9;skrzynia[16][3,3]:=ile_items;skrzynia[16][4,3]:=ile_items;
     skrzynia[16][5,3]:=ile_items;skrzynia[16][1,4]:=ile_items;skrzynia[16][2,4]:=ile_items;
     skrzynia[16][3,4]:=ile_items;skrzynia[16][4,4]:=ile_items;skrzynia[16][5,4]:=ile_items;

     skrzynia[17][1,1]:=ile_items;skrzynia[17][2,1]:=ile_items;
     skrzynia[17][3,1]:=ile_items;skrzynia[17][4,1]:=ile_items;skrzynia[17][5,1]:=ile_items;
     skrzynia[17][1,2]:=ile_items;skrzynia[17][2,2]:=ile_items;skrzynia[17][3,2]:=46;
     skrzynia[17][4,2]:=ile_items;skrzynia[17][5,2]:=16;skrzynia[17][1,3]:=ile_items;
     skrzynia[17][2,3]:=ile_items;skrzynia[17][3,3]:=ile_items;skrzynia[17][4,3]:=46;
     skrzynia[17][5,3]:=ile_items;skrzynia[17][1,4]:=ile_items;skrzynia[17][2,4]:=10;
     skrzynia[17][3,4]:=ile_items;skrzynia[17][4,4]:=ile_items;skrzynia[17][5,4]:=ile_items;

     skrzynia[18][1,1]:=ile_items;skrzynia[18][2,1]:=46;
     skrzynia[18][3,1]:=46;skrzynia[18][4,1]:=ile_items;skrzynia[18][5,1]:=ile_items;
     skrzynia[18][1,2]:=ile_items;skrzynia[18][2,2]:=ile_items;skrzynia[18][3,2]:=46;
     skrzynia[18][4,2]:=ile_items;skrzynia[18][5,2]:=46;skrzynia[18][1,3]:=ile_items;
     skrzynia[18][2,3]:=ile_items;skrzynia[18][3,3]:=ile_items;skrzynia[18][4,3]:=46;
     skrzynia[18][5,3]:=ile_items;skrzynia[18][1,4]:=ile_items;skrzynia[18][2,4]:=ile_items;
     skrzynia[18][3,4]:=ile_items;skrzynia[18][4,4]:=46;skrzynia[18][5,4]:=ile_items;

     skrzynia[19][1,1]:=ile_items;skrzynia[19][2,1]:=46;
     skrzynia[19][3,1]:=ile_items;skrzynia[19][4,1]:=ile_items;skrzynia[19][5,1]:=ile_items;
     skrzynia[19][1,2]:=ile_items;skrzynia[19][2,2]:=ile_items;skrzynia[19][3,2]:=11;
     skrzynia[19][4,2]:=ile_items;skrzynia[19][5,2]:=ile_items;skrzynia[19][1,3]:=ile_items;
     skrzynia[19][2,3]:=ile_items;skrzynia[19][3,3]:=ile_items;skrzynia[19][4,3]:=ile_items;
     skrzynia[19][5,3]:=ile_items;skrzynia[19][1,4]:=ile_items;skrzynia[19][2,4]:=ile_items;
     skrzynia[19][3,4]:=15;skrzynia[19][4,4]:=ile_items;skrzynia[19][5,4]:=ile_items;

     skrzynia[20][1,1]:=ile_items;skrzynia[20][2,1]:=ile_items;
     skrzynia[20][3,1]:=ile_items;skrzynia[20][4,1]:=ile_items;skrzynia[20][5,1]:=ile_items;
     skrzynia[20][1,2]:=27;skrzynia[20][2,2]:=22;skrzynia[20][3,2]:=ile_items;
     skrzynia[20][4,2]:=ile_items;skrzynia[20][5,2]:=ile_items;skrzynia[20][1,3]:=ile_items;
     skrzynia[20][2,3]:=ile_items;skrzynia[20][3,3]:=ile_items;skrzynia[20][4,3]:=ile_items;
     skrzynia[20][5,3]:=ile_items;skrzynia[20][1,4]:=ile_items;skrzynia[20][2,4]:=46;
     skrzynia[20][3,4]:=ile_items;skrzynia[20][4,4]:=ile_items;skrzynia[20][5,4]:=ile_items;
end;

procedure godzina;
begin
     s:=s+5;

     if g<10 then gg:='0' else gg:='';
     if m<10 then mm:='0' else mm:='';
     if s<10 then ss:='0' else ss:='';

     if s>60 then begin s:=0; m:=m+1; end;
     if m=60 then
     begin
          m:=0;
          g:=g+1;
          if(mapa_='ziemia')and(inhome=false) then
          begin
{          if g=19 then loadpal('graphics\noc1.pal');
          if g=20 then loadpal('graphics\noc2.pal');
          if g=21 then loadpal('graphics\noc3.pal');
          if g=22 then loadpal('graphics\noc4.pal');
          if g=23 then loadpal('graphics\noc5.pal');
          if g=0 then loadpal('graphics\noc6.pal');
          if g=1 then loadpal('graphics\noc7.pal');
          if g=2 then loadpal('graphics\noc6.pal');
          if g=3 then loadpal('graphics\noc5.pal');
          if g=4 then loadpal('graphics\noc4.pal');
          if g=5 then loadpal('graphics\noc3.pal');
          if g=6 then loadpal('graphics\noc2.pal');
          if g=7 then loadpal('graphics\noc1.pal');
          if g=8 then loadpal('graphics\gold.pal');}
          badaj_czy_noc;
          end;
     end;
     if g=24 then begin g:=0; end;


     rectangle(233,18,313,29,220);
     bar(234,19,312,28,219);
     outtextfntxy2(237,20,3,43,1,1,'GODZINA: ',font^);
     outtextfntxy2(270,20,3,43,1,1,gg+numstr(g)+':'
     +mm+numstr(m){+'.'+ss+numstrreal(s,0)},font^);
     outtextfntxy2(237,21,3,14,1,1,'GODZINA: ',font^);
     outtextfntxy2(270,21,3,14,1,1,gg+numstr(g)+':'
     +mm+numstr(m){+'.'+ss+numstrreal(s,0)},font^);
end;

procedure godzina2;
begin
     s:=s+5;

     if g<10 then gg:='0' else gg:='';
     if m<10 then mm:='0' else mm:='';
     if s<10 then ss:='0' else ss:='';

     if s>60 then begin s:=0; m:=m+1; end;
     if m=60 then
     begin
          m:=0;
          g:=g+1;
     end;
     if g=24 then begin g:=0; end;
end;

procedure godzina3;
begin
     s:=s+5;

     if g<10 then gg:='0' else gg:='';
     if m<10 then mm:='0' else mm:='';
     if s<10 then ss:='0' else ss:='';

     if s>60 then begin s:=0; m:=m+1; end;
     if m=60 then
     begin
          m:=0;
          g:=g+1;
     end;
     if g=24 then begin g:=0; end;


     rectangle(233,18,313,29,220);
     bar(234,19,312,28,219);
     outtextfntxy2(237,20,3,43,1,1,'GODZINA: ',font^);
     outtextfntxy2(270,20,3,43,1,1,gg+numstr(g)+':'
     +mm+numstr(m){+'.'+ss+numstrreal(s,1)},font^);
     outtextfntxy2(237,21,3,14,1,1,'GODZINA: ',font^);
     outtextfntxy2(270,21,3,14,1,1,gg+numstr(g)+':'
     +mm+numstr(m){+'.'+ss+numstrreal(s,1)},font^);
end;

procedure godzina4;
begin
     rectangle(233,18,313,29,220);
     bar(234,19,312,28,219);
     outtextfntxy2(237,20,3,43,1,1,'GODZINA: ',font^);
     outtextfntxy2(270,20,3,43,1,1,gg+numstr(g)+':'
     +mm+numstr(m){+'.'+ss+numstrreal(s,1)},font^);
     outtextfntxy2(237,21,3,14,1,1,'GODZINA: ',font^);
     outtextfntxy2(270,21,3,14,1,1,gg+numstr(g)+':'
     +mm+numstr(m){+'.'+ss+numstrreal(s,1)},font^);
end;

procedure badaj_czy_noc;
begin
     if mapa_='ziemia' then
     begin
     if g=0 then loadpal('graphics\noc6.pal');
     if g=1 then loadpal('graphics\noc7.pal');
     if g=2 then loadpal('graphics\noc6.pal');
     if g=3 then loadpal('graphics\noc5.pal');
     if g=4 then loadpal('graphics\noc4.pal');
     if g=5 then loadpal('graphics\noc3.pal');
     if g=6 then loadpal('graphics\noc2.pal');
     if g=7 then loadpal('graphics\noc1.pal');
     if g=8 then loadpal('graphics\gold.pal');
     if g=9 then loadpal('graphics\gold.pal');
     if g=10 then loadpal('graphics\gold.pal');
     if g=11 then loadpal('graphics\gold.pal');
     if g=12 then loadpal('graphics\gold.pal');
     if g=13 then loadpal('graphics\gold.pal');
     if g=14 then loadpal('graphics\gold.pal');
     if g=15 then loadpal('graphics\gold.pal');
     if g=16 then loadpal('graphics\gold.pal');
     if g=17 then loadpal('graphics\gold.pal');
     if g=18 then loadpal('graphics\gold.pal');
     if g=19 then loadpal('graphics\noc1.pal');
     if g=20 then loadpal('graphics\noc2.pal');
     if g=21 then loadpal('graphics\noc3.pal');
     if g=22 then loadpal('graphics\noc4.pal');
     if g=23 then loadpal('graphics\noc5.pal');
     end;
     if mapa_='tunele' then
     begin
          loadpal('graphics\gold.pal');
     end;
end;

procedure badaj_czy_nie_znalazles_kasy(x, y : integer);
var
   los : word;
   k : byte;
begin
     if mapa[x+7,y+6]in[9..20,32,33,50,51] then
     begin
          if szczescie=0 then los:=random(1000);
          if szczescie=1 then los:=random(900);
          if szczescie=2 then los:=random(770);
          if szczescie=3 then los:=random(650);
          if szczescie=4 then los:=random(500);
          if szczescie=5 then los:=random(450);
          if szczescie=6 then los:=random(400);
          if szczescie=7 then los:=random(350);
          if szczescie=8 then los:=random(330);
          if szczescie=9 then los:=random(300);
          if szczescie=10 then los:=random(270);
          if szczescie=11 then los:=random(250);
          if szczescie=12 then los:=random(200);
          if szczescie=13 then los:=random(170);
          if szczescie=14 then los:=random(150);
          if szczescie=15 then los:=random(130);
          if los=22 then
          begin
               randomize;
               k:=80+random(50);
               draw_screen(maxx,maxy,15);
               draw_ramka;
               put_player(105,90,del+nr_p);
               rectangle(70,85,157,125,220);
               bar(71,86,156,124,219);
               outtextfntxy2_center(112,89,3,43,1,1,'!!GRATULACJE!!',font^);
               outtextfntxy2_center(112,90,3,14,1,1,'!!GRATULACJE!!',font^);
               outtextfntxy2_center(112,102,3,43,1,1,'ZNALAZùEó '+numstrreal(k,0)+' $',font^);
               outtextfntxy2_center(112,103,3,14,1,1,'ZNALAZùEó '+numstrreal(k,0)+' $',font^);
               bar(107,114,121,122,220);
               outtextfntxy2(111,115,3,14,1,1,'OK',font^);
               if sounds then play_sound(tempsound[2],sound[2],11000);
{               startsound(sound[9],9,false);}
               repeat
                     mmx:=mousex;
                     mmy:=mousey;
                     godzina;
                     copy_screen(mmx-10,mmy-20,35,35);
                     draw_cursor(mmx,mmy);
                     pokazgrafike2;
                     put_screen(mmx-10,mmy-20,35,35);
               until mousein(mmx,mmy,107,114,121,122) and leftbutton;
               kasa:=kasa+k;
          end;
     end;
end;

procedure load_to_memory_took(name : string);
begin
     assign(f_took,name);
     reset(f_took);
     read(f_took,z_took);
     close(f_took);
end;

procedure pokaz_mowce(nr_, ilosc_ : byte);
var i : integer;
    yy:integer;
begin
     draw_room(14,12,15,nr_dom);
     put_player(px*15,py*15,del+nr_p);
     if not niemaludka then
     begin
     for i:= ilemaxlud.one to ilemaxlud.two do put_enemy(enemy[i].x*15,enemy[i].y*15,enemy[i].ludek,enemy[i].del+enemy[i].nr);
     end;
     yy:=(ilosc_*6)+6;
     bar(2,197-yy,226,197,219);
     line(2,197-yy,226,197-yy,220);
     outtextfntxy2(10,193-yy,3,43,1,1,z_took[nr_].tytul_rozmowy,font^);
     outtextfntxy2(10,194-yy,3,14,1,1,z_took[nr_].tytul_rozmowy,font^);
     for i:= 1 to ilosc_ do
     begin
          outtextfntxy2{_center}(12,194-yy+i*6,3,43,1,1,z_took[nr_].zdanie[i],font^);
     end;
     draw_ramka;
     pokazgrafike2;
     repeat
     until keydown[entscan];
end;

procedure pokaz_rozmowe(nr_rozmowy, ilosc_zdan : byte);
var
   y1, y : integer;
   koniec : boolean;
   yy : integer;
begin
     draw_room(14,12,15,nr_dom);
     if not niemaludka then
     begin
     for i:= ilemaxlud.one to ilemaxlud.two do put_enemy(enemy[i].x*15,enemy[i].y*15,enemy[i].ludek,enemy[i].del+enemy[i].nr);
     end;
     y:=0;
     y1:=0;
     delay(200);
     koniec:=false;
     for i:= 1 to ile_rozm do
     begin
     zd[1,i]:=false;
     zd[2,i]:=false;
     zd[3,i]:=false;
     zd[4,i]:=false;
     zd[5,i]:=false;
     end;
     yy:=(ilosc_zdan*6)+6;
     bar(2,197-yy,226,197,219);
     line(2,197-yy,226,197-yy,220);
     outtextfntxy2(10,193-yy,3,43,1,1,z_took[nr_rozmowy].tytul_rozmowy,font^);
     outtextfntxy2(10,194-yy,3,14,1,1,z_took[nr_rozmowy].tytul_rozmowy,font^);
     for i:= 1 to ilosc_zdan do
     begin
          outtextfntxy2(12,194-yy+i*6,3,43,1,1,z_took[nr_rozmowy].zdanie[i],font^);
     end;
     draw_ramka;
     repeat
           outtextfntxy2(7,y*6+197-ilosc_zdan*6-3,3,14,1,1,#16,font^);
{           godzina3;
{           draw_room(14,12,15,nr_dom);}
           put_player(px*15,py*15,del+nr_p);
           pokazgrafike2;
           outtextfntxy2(7,y*6+197-ilosc_zdan*6-3,3,219,1,1,#16,font^);
           if keydown[downscan] then
           begin
                inc(y1,1);
                if y1=30 then
                begin
                     if y<ilosc_zdan-1 then y:=y+1;
                     y1:=0;
                end;
           end;
           if keydown[upscan] then
           begin
                inc(y1,1);
                if y1=30 then
                begin
                     if y>0 then y:=y-1;
                     y1:=0;
                end;
           end;
           if (y=0)and(keydown[entscan])then koniec:=true;
           if (y=1)and(keydown[entscan])then koniec:=true;
           if (y=2)and(keydown[entscan])then koniec:=true;
           if (y=3)and(keydown[entscan])then koniec:=true;
           if (y=4)and(keydown[entscan])then koniec:=true;
           if (y=ilosc_zdan-1) and keydown[entscan] then koniec:=true;
     until koniec;
     if y=0 then zd[1,nr_rozmowy]:=true;
     if y=1 then zd[2,nr_rozmowy]:=true;
     if y=2 then zd[3,nr_rozmowy]:=true;
     if y=3 then zd[4,nr_rozmowy]:=true;
     if y=4 then zd[5,nr_rozmowy]:=true;
end;

procedure pokaz_statusy;
begin
     rectangle(233,29,313,40,220);
     bar(234,29,312,39,219);
     outtextfntxy2(237,31,3,43,1,1,'ΩYCIE= '+numstr(zyciemin)+'/'+numstr(zycietmp),font^);
     outtextfntxy2(237,32,3,14,1,1,'ΩYCIE= '+numstr(zyciemin)+'/'+numstr(zycietmp),font^);
end;

procedure show_zmeczenie;
begin
     rectangle(233,40,313,50,220);
     bar(234,41,312,49,219);
     outtextfntxy2(237,41,3,43,1,1,'ZM®CZENIE: '+numstr(zmeczenie)+'/'+numstr(maxzmeczenie),font^);
     outtextfntxy2(237,42,3,14,1,1,'ZM®CZENIE: '+numstr(zmeczenie)+'/'+numstr(maxzmeczenie),font^);
end;

procedure zapis_gry(nazwa : string);
begin
assign(fsave,nazwa);
rewrite(fsave);
save.x:=mx;
save.y:=my;
save.teren:=mapa_;
save.dosw:=dosw;
save.nextdosw:=nextdosw;
save.poziom:=poziom;
save.szczescie:=szczescie;
save.atak:=atak;
save.ataktmp:=ataktmp;
save.obrona:=obrona;
save.obronatmp:=obronatmp;
save.zmeczenie:=zmeczenie;
save.maxzmeczenie:=maxzmeczenie;
save.zrecznosc:=zrecznosc;
save.zrecznosctmp:=zrecznosctmp;
save.last_killed:=last_killed;
save.zyciemin:=zyciemin;
save.zycie:=zycie;
save.ile_killed:=ile_killed;
save.zycietmp:=zycietmp;
save.kier:=kier;
for licznik:= 1 to 8 do save.plecak[licznik]:=plecak[licznik];
for licznik:= 1 to ile_skrzyn do save.skrzynia[licznik]:=skrzynia[licznik];
save.kasa:=kasa;
save.nr_p:=nr_p;
save.del:=del;
save.nrp:=nrp;
save.minimap:=minimap;
save.g:=g;
save.m:=m;
save.s:=s;

write(fsave,save);
close(fsave);
end;

procedure odczyt_gry(nazwa : string);
begin
assign(fsave,nazwa);
reset(fsave);
read(fsave,save);
close(fsave);

mx:=save.x;
my:=save.y;
mapa_:=save.teren;
dosw:=save.dosw;
nextdosw:=save.nextdosw;
poziom:=save.poziom;
szczescie:=save.szczescie;
atak:=save.atak;
ataktmp:=save.ataktmp;
obrona:=save.obrona;
obronatmp:=save.obronatmp;
zmeczenie:=save.zmeczenie;
maxzmeczenie:=save.maxzmeczenie;
zrecznosc:=save.zrecznosc;
zrecznosctmp:=save.zrecznosctmp;
last_killed:=save.last_killed;
zyciemin:=save.zyciemin;
zycie:=save.zycie;
ile_killed:=save.ile_killed;
zycietmp:=save.zycietmp;
kier:=save.kier;
for licznik:= 1 to 8 do plecak[licznik]:=save.plecak[licznik];
for licznik:= 1 to ile_skrzyn do skrzynia[licznik]:=save.skrzynia[licznik];
kasa:=save.kasa;
nr_p:=save.nr_p;
del:=save.del;
nrp:=save.nrp;
minimap:=save.minimap;
g:=save.g;
m:=save.m;
s:=save.s;
end;

procedure saveg;
var
   dzien, mies, rok, dd : word;
   godz, min, sec, ss : word;
   ddzien, dmies, dgodz, dmin : string;
procedure ramki;
var
   i : integer;
begin
      bar(60,50,175,140,219);    {menu}
      rectangle(60,50,175,140,220);
      outtextfntxy2_center(110,53,8,43,1,1,'ZAPISZ GR®',font2^);
      outtextfntxy2_center(110,54,8,14,1,1,'ZAPISZ GR®',font2^);
      for i:= 1 to 6 do
      begin
           outtextfntxy2(65,63+i*9,3,43,1,1,save_list[i],font^);
           outtextfntxy2(65,64+i*9,3,14,1,1,save_list[i],font^);
      end;
      outtextfntxy2_center(110,125,8,43,1,1,'POWR‡T',font2^);
      outtextfntxy2_center(110,126,8,14,1,1,'POWR‡T',font2^);
end;
procedure info;
begin
      bar(80,80,155,110,219);
      rectangle(80,80,155,110,220);
      outtextfntxy2_center(112,83,8,43,1,1,'GRA',font2^);
      outtextfntxy2_center(112,84,8,14,1,1,'GRA',font2^);
      outtextfntxy2_center(112,93,8,43,1,1,'ZAPISANA',font2^);
      outtextfntxy2_center(112,94,8,14,1,1,'ZAPISANA',font2^);
end;
begin
      assign(fff,'data\saves.dat');
      reset(fff);
      read(fff,save_list);
      close(fff);
      draw_screen(maxx,maxy,15);
      draw_ramka;
      if kier='prawo' then del:=5;
      if kier='lewo' then del:=7;
      if kier='gora' then del:=1;
      if kier='dol' then del:=3;

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

            if mousein(mmx,mmy,63,72,173,79) and leftbutton then
            begin
                 zapis_gry('data\00000001.sav');
                 draw_cursor(mmx,mmy);
                 info;
                 pokazgrafike2;
                 delay(400);
                 getdate(rok,mies,dzien,dd);
                 gettime(godz,min,sec,ss);
                 if dzien<10 then ddzien:='0' else ddzien:='';
                 if mies<10 then dmies:='0' else dmies:='';

                 if min<10 then dmin:='0' else dmin:='';
                 if godz<10 then dgodz:='0' else dgodz:='';
{                 if min>10 then dmin:='0' else dmin:='';
                 if godz>10 then dgodz:='0' else dgodz:='';}
                 save_list[1]:=ddzien+numstr(dzien)+'.'+dmies+numstr(mies)+'.'+numstr(rok)
                 +' - '+dgodz+numstr(godz)+':'+dmin+numstr(min)
                 +' ( '+numstr(poziom)+' )';
                 ramki;
            end;
            if mousein(mmx,mmy,63,81,173,88) and leftbutton then
            begin
                 zapis_gry('data\00000002.sav');
                 draw_cursor(mmx,mmy);
                 info;
                 pokazgrafike2;
                 delay(400);
                 getdate(rok,mies,dzien,dd);
                 gettime(godz,min,sec,ss);
                 if dzien<10 then ddzien:='0' else ddzien:='';
                 if mies<10 then dmies:='0' else dmies:='';

                 if min<10 then dmin:='0' else dmin:='';
                 if godz<10 then dgodz:='0' else dgodz:='';
{                 if min>10 then dmin:='0' else dmin:='';
                 if godz>10 then dgodz:='0' else dgodz:='';}
                 save_list[2]:=ddzien+numstr(dzien)+'.'+dmies+numstr(mies)+'.'+numstr(rok)
                 +' - '+dgodz+numstr(godz)+':'+dmin+numstr(min)
                 +' ( '+numstr(poziom)+' )';
                 ramki;
            end;
            if mousein(mmx,mmy,63,90,173,97) and leftbutton then
            begin
                 zapis_gry('data\00000003.sav');
                 draw_cursor(mmx,mmy);
                 info;
                 pokazgrafike2;
                 delay(400);
                 getdate(rok,mies,dzien,dd);
                 gettime(godz,min,sec,ss);
                 if dzien<10 then ddzien:='0' else ddzien:='';
                 if mies<10 then dmies:='0' else dmies:='';

                 if min<10 then dmin:='0' else dmin:='';
                 if godz<10 then dgodz:='0' else dgodz:='';
{                 if min>10 then dmin:='0' else dmin:='';
                 if godz>10 then dgodz:='0' else dgodz:='';}
                 save_list[3]:=ddzien+numstr(dzien)+'.'+dmies+numstr(mies)+'.'+numstr(rok)
                 +' - '+dgodz+numstr(godz)+':'+dmin+numstr(min)
                 +' ( '+numstr(poziom)+' )';
                 ramki;
            end;
            if mousein(mmx,mmy,63,99,173,106) and leftbutton then
            begin
                 zapis_gry('data\00000004.sav');
                 draw_cursor(mmx,mmy);
                 info;
                 pokazgrafike2;
                 delay(400);
                 getdate(rok,mies,dzien,dd);
                 gettime(godz,min,sec,ss);
                 if dzien<10 then ddzien:='0' else ddzien:='';
                 if mies<10 then dmies:='0' else dmies:='';

                 if min<10 then dmin:='0' else dmin:='';
                 if godz<10 then dgodz:='0' else dgodz:='';
{                 if min>10 then dmin:='0' else dmin:='';
                 if godz>10 then dgodz:='0' else dgodz:='';}
                 save_list[4]:=ddzien+numstr(dzien)+'.'+dmies+numstr(mies)+'.'+numstr(rok)
                 +' - '+dgodz+numstr(godz)+':'+dmin+numstr(min)
                 +' ( '+numstr(poziom)+' )';
                 ramki;
            end;
            if mousein(mmx,mmy,63,108,173,115) and leftbutton then
            begin
                 zapis_gry('data\00000005.sav');
                 draw_cursor(mmx,mmy);
                 info;
                 pokazgrafike2;
                 delay(400);
                 getdate(rok,mies,dzien,dd);
                 gettime(godz,min,sec,ss);
                 if dzien<10 then ddzien:='0' else ddzien:='';
                 if mies<10 then dmies:='0' else dmies:='';

                 if min<10 then dmin:='0' else dmin:='';
                 if godz<10 then dgodz:='0' else dgodz:='';
{                 if min>10 then dmin:='0' else dmin:='';
                 if godz>10 then dgodz:='0' else dgodz:='';}
                 save_list[5]:=ddzien+numstr(dzien)+'.'+dmies+numstr(mies)+'.'+numstr(rok)
                 +' - '+dgodz+numstr(godz)+':'+dmin+numstr(min)
                 +' ( '+numstr(poziom)+' )';
                 ramki;
            end;
            if mousein(mmx,mmy,63,117,173,124) and leftbutton then
            begin
                 zapis_gry('data\00000006.sav');
                 draw_cursor(mmx,mmy);
                 info;
                 pokazgrafike2;
                 delay(400);
                 getdate(rok,mies,dzien,dd);
                 gettime(godz,min,sec,ss);
                 if dzien<10 then ddzien:='0' else ddzien:='';
                 if mies<10 then dmies:='0' else dmies:='';

                 if min<10 then dmin:='0' else dmin:='';
                 if godz<10 then dgodz:='0' else dgodz:='';
{                 if min>10 then dmin:='0' else dmin:='';
                 if godz>10 then dgodz:='0' else dgodz:='';}
                 save_list[6]:=ddzien+numstr(dzien)+'.'+dmies+numstr(mies)+'.'+numstr(rok)
                 +' - '+dgodz+numstr(godz)+':'+dmin+numstr(min)
                 +' ( '+numstr(poziom)+' )';
                 ramki;
            end;

      until mousein(mmx,mmy,88,125,142,137) and leftbutton;
      delay(200);
{      for i:= 1 to 7 do save_list[i]:='BRAK ZAPISU';}
      assign(fff,'data\saves.dat');
      rewrite(fff);
      write(fff,save_list);
      close(fff);
end;

procedure reset_sound;
var i : integer;
begin
for i:= 1 to ile_sound do tempsound[i]:=pointer(0);
for i:= 1 to ile_sound do sound[i]:=word(0);
end;

procedure initsound_game;
begin
if sounds then
begin
initsound;
reset_sound;
new_sound(tempsound[1],sound[1],'sounds/sound7.snd');
new_sound(tempsound[2],sound[2],'sounds/sound1.snd');
new_sound(tempsound[3],sound[3],'sounds/sound13.snd');
new_sound(tempsound[4],sound[4],'sounds/sound5.snd');
end;
end;

procedure closesound_game;
begin
if sounds then
begin
dispose_sound(tempsound[1],sound[1]);
dispose_sound(tempsound[2],sound[2]);
dispose_sound(tempsound[3],sound[3]);
dispose_sound(tempsound[4],sound[4]);
closesound;
end;
end;

procedure initsound_walka;
begin
if sounds then
begin
initsound;
reset_sound;
new_sound(tempsound[1],sound[1],'sounds/sound15.snd');
new_sound(tempsound[2],sound[2],'sounds/sound16.snd');
new_sound(tempsound[3],sound[3],'sounds/sound8.snd');
end;
end;

procedure closesound_walka;
begin
if sounds then
begin
dispose_sound(tempsound[1],sound[1]);
dispose_sound(tempsound[2],sound[2]);
dispose_sound(tempsound[3],sound[3]);
closesound;
end;
end;

procedure initsound_room;
begin
if sounds then
begin
initsound;
reset_sound;
new_sound(tempsound[1],sound[1],'sounds/sound5.snd');
new_sound(tempsound[2],sound[2],'sounds/sound7.snd');
new_sound(tempsound[3],sound[3],'sounds/sound9.snd');
new_sound(tempsound[4],sound[4],'sounds/sound10.snd');
new_sound(tempsound[5],sound[5],'sounds/sound11.snd');
end;
end;

procedure closesound_room;
begin
if sounds then
begin
dispose_sound(tempsound[1],sound[1]);
dispose_sound(tempsound[2],sound[2]);
dispose_sound(tempsound[3],sound[3]);
dispose_sound(tempsound[4],sound[4]);
dispose_sound(tempsound[5],sound[5]);
closesound;
end;
end;

procedure initsound_skrzynia;
begin
if sounds then
begin
initsound;
reset_sound;
new_sound(tempsound[1],sound[1],'sounds/sound2.snd');
new_sound(tempsound[2],sound[2],'sounds/sound14.snd');
new_sound(tempsound[3],sound[3],'sounds/sound3.snd');
new_sound(tempsound[4],sound[4],'sounds/sound12.snd');
end;
end;

procedure closesound_skrzynia;
begin
if sounds then
begin
dispose_sound(tempsound[1],sound[1]);
dispose_sound(tempsound[2],sound[2]);
dispose_sound(tempsound[3],sound[3]);
dispose_sound(tempsound[4],sound[4]);
closesound;
end;
end;

procedure escape_game_mapa;
begin
     draw_screen(maxx,maxy,15);
     draw_ramka;
     put_player(105,90,del+nr_p);
     rectangle(70,85,157,125,220);
     bar(71,86,156,124,219);
     outtextfntxy2_center(112,89,3,43,1,1,'CZY NAPEWNO',font^);
     outtextfntxy2_center(112,90,3,14,1,1,'CZY NAPEWNO',font^);
     outtextfntxy2_center(112,99,3,43,1,1,'CHCESZ WYJóè?',font^);
     outtextfntxy2_center(112,100,3,14,1,1,'CHCESZ WYJóè?',font^);
     bar(107-10,114,121-10,122,220);
     outtextfntxy2(111-12,115,3,14,1,1,'TAK',font^);
     bar(107+10,114,121+10,122,220);
     outtextfntxy2(111+8,115,3,14,1,1,'NIE',font^);
     repeat
           mmx:=mousex;
           mmy:=mousey;
           godzina4;
           copy_screen(mmx-10,mmy-20,35,35);
           draw_cursor(mmx,mmy);
           pokazgrafike2;
           put_screen(mmx-10,mmy-20,35,35);
           if mousein(mmx,mmy,107-13,114,121-13,122) and leftbutton then wyjscie_do_menu:=true;
           if mousein(mmx,mmy,107+7,114,121+7,122) and leftbutton then ex:=true;
     until mousein(mmx,mmy,107+7,114,121+7,122) and leftbutton or wyjscie_do_menu;
     draw_screen(maxx,maxy,15);
     draw_ramka;
end;

procedure escape_game_room;
begin
     godzina4;
     draw_room(14,12,15,nr_dom);
     draw_ramka;
     put_player(px*15,py*15,del+nr_p);
     if not niemaludka then
     begin
     for i:= ilemaxlud.one to ilemaxlud.two do put_enemy(enemy[i].x*15,enemy[i].y*15,enemy[i].ludek,enemy[i].del+enemy[i].nr);
     end;
     rectangle(70,85,157,125,220);
     bar(71,86,156,124,219);
     outtextfntxy2_center(112,89,3,43,1,1,'CZY NAPEWNO',font^);
     outtextfntxy2_center(112,90,3,14,1,1,'CZY NAPEWNO',font^);
     outtextfntxy2_center(112,99,3,43,1,1,'CHCESZ WYJóè?',font^);
     outtextfntxy2_center(112,100,3,14,1,1,'CHCESZ WYJóè?',font^);
     bar(107-10,114,121-10,122,220);
     outtextfntxy2(111-12,115,3,14,1,1,'TAK',font^);
     bar(107+10,114,121+10,122,220);
     outtextfntxy2(111+8,115,3,14,1,1,'NIE',font^);
     repeat
           mmx:=mousex;
           mmy:=mousey;
           godzina4;
           copy_screen(mmx-10,mmy-20,35,35);
           draw_cursor(mmx,mmy);
           pokazgrafike2;
           put_screen(mmx-10,mmy-20,35,35);
           if mousein(mmx,mmy,107-13,114,121-13,122) and leftbutton then wyjscie_do_menu:=true;
           if mousein(mmx,mmy,107+7,114,121+7,122) and leftbutton then ex2:=true;
     until mousein(mmx,mmy,107+7,114,121+7,122) and leftbutton or wyjscie_do_menu;
end;

procedure loadsetup;
begin
     assign(fset,'data\setup.cfg');
     reset(fset);
     read(fset,setup);
     close(fset);
     if setup.opcja=1 then sounds:=false;
     if setup.opcja=2 then sounds:=true;
end;

end.