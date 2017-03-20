unit GameUnit;

{$mode objfpc}{$H+}

interface

uses

  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Menus, StdCtrls,AnotherUnit,Windows, AboutGameUnit, SettingUnit;

procedure BackGroundPlayGround();
procedure Cells();
procedure ColorChangeMain(var p2:byte);
type

  { TWindowGame }

  TWindowGame = class(TForm)
    PauseMenu: TMenuItem;
    NumberScoreLabel: TLabel;
    ScoreLabel: TLabel;
    NameGameLabel: TLabel;
    MainMenu1: TMainMenu;
    GameMenu: TMenuItem;
    MenuItem2: TMenuItem;
    NewGameMenu: TMenuItem;
    ExitGameMenu: TMenuItem;
    GameOverLabel: TLabel;
    SettingGameMenu: TMenuItem;
    AboutGameMenu: TMenuItem;
    Playground: TImage;
    Move: TTimer;
    GameOver: TTimer;
    procedure PauseMenuClick(Sender: TObject);
    procedure RandomSnake(Sender: TObject);
    procedure RandomFood(Sender: TObject);
    procedure AboutGameMenuClick(Sender: TObject);
    procedure ExitGameMenuClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure GameOverTimer(Sender: TObject);
    procedure MoveTimer(Sender: TObject);
    procedure NewGameMenuClick(Sender: TObject);
    procedure SettingGameMenuClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  WindowGame: TWindowGame;
implementation
{$R *.lfm}
{ TWindowGame }

procedure BackGroundPlayGround(); //Рисуем Фон
begin
    with WindowGame.PlayGround.Canvas do
     begin
          brush.Color:=$F5F5F5;
          rectangle(-1,-1,WindowGame.PlayGround.clientWidth+1,WindowGame.PlayGround.clientHeight+1);
     end;
end;

procedure Cells(); //Рисуем Ячейки
var
  i,j,l,k,dx,dy:integer;
begin
 j:=0;// смещение по x
 k:=0;// Смещение по у
 dx:=21; //шаг смещения  ячейки по оси х. Недостающая единичка учитываеся в других процедурах
 dy:=22; //шаг смещение  ячейки по оси у
 with WindowGame.PlayGround.Canvas do
 begin
  brush.Color:=$F5F5F5;
  pen.Color:=clgray;
  pen.Width:= 1;
  for l:=0 to 15 do  //Ячейки в столбце
  begin
   for i:=0 to 15 do //Ячейки в строке
    begin
     RoundRect(1+i+j,1+k,21+i+j,21+k,7,7);
     j:=j+dx;
    end;
   j:=0;
   k:=k+dy;
  end;
 end;
end;

procedure TWindowGame.RandomSnake(Sender: TObject); //Рандомим змейку
begin
     repeat
           Snake[1].x:=random(250);
           Snake[1].y:=random(300);
     until((snake[1].x mod 22=0) and (snake[1].y mod 22=0));

     with WindowGame.PlayGround.Canvas do
     begin
          Pen.Width:=1;
          ColorChangeMain(ColorSnake);
          RoundRect(Snake[1].x+1, Snake[1].y+1, Snake[1].x+21, Snake[1].y+21,7,7);
     end;
end;

procedure TWindowGame.PauseMenuClick(Sender: TObject);
begin
  Move.Enabled:=False;
end;

procedure ColorChangeMain(var p2:byte); //Процедура смены цвета змейки и еды
begin
With WindowGame.PlayGround.Canvas do
 case p2 of
 0:
     begin
       pen.color:=clBlack;
       Brush.Color:=clBlack;
     end;
 1:
     begin
       pen.color:=clMaroon;
       Brush.Color:=clMaroon;
     end;
 2:
     begin
       pen.color:=clGreen;
       Brush.Color:=clGreen;
     end;
 3:
     begin
       pen.color:=clOlive;
       Brush.Color:=clOlive;
     end;
  4:
     begin
       pen.color:=clNavy;
       Brush.Color:=clNavy;
     end;
   5:
     begin
       pen.color:=clPurple;
       Brush.Color:=clPurple;
     end;
   6:
     begin
       pen.color:=clGray;
       Brush.Color:=clGray;
     end;
  7:
     begin
       pen.color:=clSilver;
       Brush.Color:=clSilver;
     end;
   8:
     begin
       pen.color:=clRed;
       Brush.Color:=clRed;
     end;
    9:
     begin
       pen.color:=clLime;
       Brush.Color:=clLime;
     end;
    10:
     begin
       pen.color:=clBlue;
       Brush.Color:=clBlue;
     end;
    11:
     begin
       pen.color:=clFuchsia;
       Brush.Color:=clFuchsia;
     end;
    12:
     begin
       pen.color:=clYellow;
       Brush.Color:=clYellow;
     end;
    13:
     begin
       pen.color:=clWhite;
       Brush.Color:=clWhite;
     end;
end;
 end;

procedure TWindowGame.RandomFood(Sender: TObject); //Рандомим еду
var i,o:byte;
begin
randomize;
    repeat
      o:=0;
    begin
        FoodX:=random(350);
        FoodY:=random(350);
         for i:=1 to length do
           if ((foodx=snake[i].x) and (foody=snake[i].y)) then
             o:=1;


    end;
    until(((FoodX mod 22=0) and (FoodY mod 22=0)) and (o=0));

     with WindowGame.PlayGround.Canvas do
     begin
          Pen.Width:=1;
          ColorChangeMain(colorFood1);
          RoundRect(FoodX+1, FoodY+1, FoodX+21, FoodY+21,7,7);//Учтеные единички самые единички
     end;


end;


procedure TWindowGame.FormKeyDown(Sender: TObject; var Key: Word; //управление движением змейки
  Shift: TShiftState);
begin
   if (Key=VK_Left) and (MoveRight=False) then
    begin
       MoveDirection:=1;//Инициалицая направления для Таймера MoveTimer в модуле GameUnit
       Move.Enabled:=true;//запуск таймера движения
     end else
     if (Key=VK_Right) and (MoveLeft=False)  then
    begin
       MoveDirection:=2;//Инициалицая направления для Таймера MoveTimer в модуле GameUnit
       Move.Enabled:=true;//запуск таймера движения
   end else
    if (Key=VK_Up) and (MoveDown=false) then
    begin
       MoveDirection:=3;//Инициалицая направления для Таймера MoveTimer в модуле GameUnit
       Move.Enabled:=true;//запуск таймера движения
   end else
    if (Key=VK_Down) and (MoveUp=false) then
    begin
       MoveDirection:=4;//Инициалицая направления для Таймера MoveTimer в модуле GameUnit
       Move.Enabled:=true;//запуск таймера движения
   end;
 end;

procedure TWindowGame.GameOverTimer(Sender: TObject); //Таймер конца игры
var
  i:integer;
  begin
  //Проверка: не вышла ли голова за границы сетки?
    if (snake[length].x<0) or (snake[length].y<0) or (snake[length].x>373-22)or (snake[length].y>=373-22) then
       begin
        with WindowGame.PlayGround.Canvas do
        begin
           //Закрашиваем голову, вышедшую за границы, цветом фона
             Pen.Width:=0;
             pen.color:=$F5F5F5;
             Brush.Color:=$F5F5F5;

             RoundRect(Snake[length].x+1,Snake[length].y+1,Snake[length].x+21, Snake[length].y+21,7,7);
             Move.Enabled:=False;//Останавливаем таймер движения
             GameOverLabel.Caption:='Game Over';
        end;
       end;
    //Проверка: не пересеклась ли голова с хвостом?
    for i:=1 to length-2 do
      begin
        if (snake[length].x=snake[i].x) and (snake[length].y=snake[i].y) then
                begin
                   Move.Enabled:=False;//Останавливаем таймер движения
                   GameOverLabel.Caption:='Game Over';
                end;
      end;

   end;

procedure TWindowGame.MoveTimer(Sender: TObject); //Таймер Движения змейки
var
  i: integer;
begin
   With WindowGame.PlayGround.Canvas do
   begin
        for i:=1 to length do//Координаты каждой следующей ячейки змейки присваиваются предыдущей
          begin
           Snake[i-1].x:= Snake[i].x;
           Snake[i-1].y:= Snake[i].y;
          end;


       case MoveDirection of
          1://Движение влево
            begin
               Snake[length].x:=Snake[length].x-22;
               MoveLeft:=true;
               MoveRight:=false;
               MoveUp:=false;
               MoveDown:=false;
            end;
          2: //Движение вправо
            begin
               Snake[length].x:=Snake[length].x+22;
               MoveLeft:=false;
               MoveRight:=true;
               MoveUp:=false;
               MoveDown:=false;
            end;
          3://Движение вверх
            begin
               Snake[length].y:=Snake[length].y-22;
               MoveLeft:=false;
               MoveRight:=false;
               MoveUp:=true;
               MoveDown:=false;
            end;
          4://Движение вниз
          begin
               Snake[length].y:=Snake[length].y+22;
               MoveLeft:=false;
               MoveRight:=false;
               MoveUp:=false;
               MoveDown:=true;
          end;
       end;

       GameOver.Enabled:=true; //Запускаем таймер конца игры.

       Pen.Width:=1;//Толщина границы змейки
       pen.color:=clgray;
       Brush.Color:=$F5F5F5;
       RoundRect(Snake[0].x+1,Snake[0].y+1,Snake[0].x+21, Snake[0].y+21,7,7);//Закрашиваем цветом фона ячеку, следующая за концом змейки


       ColorChangeMain(ColorSnake);//Процедура выбора цвета змейки, переменная СolorSnake инициальзируется или в CreateForm, или в SettingUnit;
       RoundRect(Snake[length].x+1, Snake[length].y+1, Snake[length].x+21, Snake[length].y+21,7,7);//Рисуем змейку

       if ((Snake[length].x=FoodX) and (Snake[length].y=FoodY)) then //Рост змейки
       begin
            inc(Length); //Увеличивает длину змейки
            snake[Length].x:= snake[Length-1].x;
            snake[Length].y:= snake[Length-1].y;
            RandomFood(sender);//Вызываем процедура рандома еды
            NumberScoreLabel.Caption:=FloatToStr(length);//Пишем счет на форме
       end;


   end;
end;

procedure TWindowGame.NewGameMenuClick(Sender: TObject); //Новая игра
begin
     FormCreate(Sender);
end;

procedure TWindowGame.SettingGameMenuClick(Sender: TObject);//Вызов формы "Настройки"
begin
  Options.Show;
end;

procedure TWindowGame.Timer1Timer(Sender: TObject);
begin
  randomfood(sender);
end;

procedure TWindowGame.ExitGameMenuClick(Sender: TObject); //Выход из игры
begin
   WindowGame.Close;
end;

procedure TWindowGame.AboutGameMenuClick(Sender: TObject); //Вызов формы "Справка"
begin
  form1.show;
end;

procedure TWindowGame.FormCreate(Sender: TObject);
begin
     WindowGame.Height:=373;//Высота основной формы
     WindowGame.Width:=WindowGame.Height+60;//Ширина основной формы
     length:=1;//Начальная длина змейки

     if FirsStart=0 then//Настройки игры при первом запуске
     begin
      ColorSnake:=6;//Цвет змейки, См процедуру ColorSnakeChange
      ColorFood1:=1;//Цвет еды, См процедуру ColorFoodChange
      Speed:=1;//стандартная скорость
     end;

     case speed of//Выбор скрости. Инициализируется или в FormCreate(тут) или в модуле SettingUnit в процедурах GameEasyChange или GameNormalChange или GameHardChange
     0:Move.Interval:=300;//Высокая сложность
     1:Move.Interval:=200;//Средняя сложность
     2:Move.Interval:=100;//Низкая сложность
     end;

     NumberScoreLabel.Caption:='1';//Начальный счет
     GameOverLabel.Caption:='';
     BackGroundPlayGround();//Рисуем задний фон
     Cells();//Рисуем ячейки
     Randomize;
     RandomSnake(Sender);//Рандомим змейку
     RandomFood(sender);//Рандомим еду

     Move.Enabled:=False;
     GameOver.Enabled:=False;

     MoveLeft:=false;
     MoveRight:=false;
     MoveUp:=false;
     MoveDown:=false;
end;

end.

