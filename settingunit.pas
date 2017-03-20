unit SettingUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, AnotherUnit;

procedure BackGroundSetting();
procedure SnakeCreate();
procedure Cells();
procedure ColorChange(var p1: byte);

type

  { TOptions }

  TOptions = class(TForm)
    BackgroundOptions: TImage;
    ColorSnakeBox: TComboBox;
    StartGame: TButton;
    ColorFood: TComboBox;
    GameEasy: TRadioButton;
    GameNormal: TRadioButton;
    GameHard: TRadioButton;
    RadioGroup1: TRadioGroup;
    AutoMovie: TTimer;
    FoodCreate: TTimer;
    ColorSnikeChangeTimer: TTimer;
    MoveText1: TTimer;
    MoveText2: TTimer;
    procedure AutoMovieTimer(Sender: TObject);
    procedure ColorSnakeBoxChange(Sender: TObject);
    procedure ColorSnikeChangeTimerTimer(Sender: TObject);
    procedure ColorFoodChange(Sender: TObject);
    procedure FoodCreateTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GameEasyChange(Sender: TObject);
    procedure GameHardChange(Sender: TObject);
    procedure GameNormalChange(Sender: TObject);
    procedure MoveText1Timer(Sender: TObject);
    procedure MoveText2Timer(Sender: TObject);
    procedure StartGameClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Options: TOptions;

implementation
{$R *.lfm}
{ TOptions }

procedure BackGroundSetting(); //Процедура рисования заднего фона
begin
     with Options.BackgroundOptions.Canvas do
     begin
          brush.Color:=$F5F5F5;
          rectangle(-1,-1,Options.BackgroundOptions.clientWidth+1,Options.BackgroundOptions.clientHeight+1)
     end;
end;

procedure SnakeCreate(); //Процедура рисования змейки
begin
     SnakeDemo[4].x:=110;
     SnakeDemo[4].y:=132;
     with Options.BackgroundOptions.Canvas do
     begin
          RoundRect(snakeDemo[4].x+1, snakeDemo[4].y+1, snakeDemo[4].x+21, snakeDemo[4].y+21,7,7);
     end;
end;

procedure Cells(); //Процедура рисования ячеек. Подробно эта процедура объяснина в модуле GameUnit(процедура Cells)
var
  i,j,l,k,dx,dy:integer;
begin
     j:=0;
     k:=0;
     dx:=21;
     dy:=22;
     with Options.BackgroundOptions.Canvas do
     begin
          brush.Color:=$F5F5F5;
          pen.Color:=clgray;
          pen.Width:= 1;
          for l:=0 to 7 do  //Ячейки в cтроке
          begin
               for i:=0 to 6 do //Ячейки в столбце
               begin
                    RoundRect(1+i+j,1+k,21+i+j,21+k,7,7);
                    j:=j+dx;
               end;
               j:=0;
               k:=k+dy;
          end;
     end;
end;

procedure TOptions.StartGameClick(Sender: TObject);//Закрытие формы при нажатии кнопки применить
begin
  Options.Close;

end;

procedure TOptions.AutoMovieTimer(Sender: TObject); //Автоматическое движение змейки
var
  i: integer;
begin
   With Options.BackgroundOptions.Canvas do
   begin
        for i:=1 to 4 do//Координаты каждой следующей ячейки змейки присваиваются предыдущей
          begin
           SnakeDemo[i-1].x:= SnakeDemo[i].x;
           SnakeDemo[i-1].y:= SnakeDemo[i].y;
          end;

       Case MoveOther of //Выбираем напрвление движения
          0:
           begin
             SnakeDemo[4].y:=SnakeDemo[4].y-22;
           end;
          1:
           begin
             SnakeDemo[4].x:=SnakeDemo[4].x-22;
           end;
          2:
           begin
             SnakeDemo[4].y:=SnakeDemo[4].y+22;
            end;
          3:
           begin
             SnakeDemo[4].x:=SnakeDemo[4].x+22;
            end;
          end;


       RoundRect(SnakeDemo[4].x+1, SnakeDemo[4].y+1, SnakeDemo[4].x+21, SnakeDemo[4].y+21,7,7);//Рисуем змейку


       Pen.Width:=1;
       pen.color:=clgray;
       Brush.Color:=$F5F5F5;

       RoundRect(SnakeDemo[0].x+1,SnakeDemo[0].y+1,SnakeDemo[0].x+21, SnakeDemo[0].y+21,7,7);//Закрашиваем хвост

       inc(count);

       if count=5 then //Каждые 5 шагов змейка меняет направление
       begin
         count:=0;

         inc(MoveOther);

         if MoveOther=4 then
            MoveOther:=0;

       end;
   end;
end;

procedure TOptions.ColorSnakeBoxChange(Sender: TObject); //Процедуры выбора цвета змейки
var
   i:byte;
begin
    ColorSnikeChangeTimer.Enabled:=true; //Запускаем таймер смены цвета Змейки
    i:=ColorSnakeBox.ItemIndex;
    colorSnake:=i;//Инициализирум Данную переменную для модуля GameUnit -> Таймер движения -> вызванная процедура ColorChangeMain
    FirsStart:=1;//Инициализирум Данную переменную для модуля GameUnit(Процедура FormCreate)
    ColorChange(i);//Вызов процедуры смены цвета
end;

procedure TOptions.ColorSnikeChangeTimerTimer(Sender: TObject); //Таймер смены цвета змейки в реальном времени
var
  i:byte;
begin
     With Options.BackgroundOptions.Canvas do
     for i:=1 to 4 do
         begin
              Pen.Width:=1;
              FirsStart:=1;
              ColorSnakeBoxChange(Sender); //Вызываем процедуру выбора цвета змейки
              RoundRect(SnakeDemo[i].x+1, SnakeDemo[i].y+1, SnakeDemo[i].x+21, SnakeDemo[i].y+21,7,7);
         end;
end;

procedure TOptions.ColorFoodChange(Sender: TObject); //Процедуры выбора цвета еды
var
   i:byte;
begin
    FoodCreate.Enabled:=true; //Запускаем таймер смены цвета еды
    i:=ColorFood.ItemIndex;
    colorFood1:=i;//Инициализирум Данную переменную для модуля GameUnit(Процедура RandomFood)
    ColorChange(i);//Вызов процедуры смены цвета
end;

procedure ColorChange(var p1: byte);//Процедура смены цвета еды или змейки
begin
With Options.BackgroundOptions.Canvas do
 case p1 of
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

procedure TOptions.FoodCreateTimer(Sender: TObject);//Поцедура рисования еды
var
   food_x,food_y:integer;
begin
     Food_x:=66;
     Food_y:=66;
     ColorFoodChange(Sender); //Вызываем процедуру выбора цвета еды
     with Options.BackgroundOptions.Canvas do
     begin
          Pen.Width:=1;
          RoundRect(Food_x+1,Food_y+1, Food_x+21,Food_y+21,7,7);
     end;

end;

procedure TOptions.GameEasyChange(Sender: TObject);//Выбор легкой игры
begin
  AutoMovie.Interval:=300;
  speed:=0;//Инициализируем перменную для модуля GameUnit(Процедура FormCreate)
end;

procedure TOptions.GameHardChange(Sender: TObject);
begin
  AutoMovie.Interval:=100;
  speed:=2;//Инициализируем перменную для модуля GameUnit(Процедура FormCreate)
end;

procedure TOptions.GameNormalChange(Sender: TObject);
begin
   AutoMovie.Interval:=200;
   speed:=1;//Инициализируем перменную для модуля GameUnit(Процедура FormCreate)
end;

procedure TOptions.MoveText1Timer(Sender: TObject);//Бегущая строка для первого текста
var
   x: integer;
begin
     x:=300;//Начальное положение
     TextX:=TextX-1;//Смещаем координаты текста по х
     With Options.BackgroundOptions.Canvas do
     begin
          brush.Color:=$F5F5F5;
          TextOut(x+TextX, 180, 'Нажмите "Применить" и начните начните новую игру, чтобы изменения вступили в силу.');
          if (TextX+x)=-225 then
            MoveText2.Enabled:=True;

         if (TextX+x)=-499 then
         begin
            TextX:=0;
            MoveText1.Enabled:=False;
         end;
      end;
end;

procedure TOptions.MoveText2Timer(Sender: TObject);//Бегущая строка для второго текста
var
   x: integer;
begin
     x:=300;//Начальное положение
     Text2X:=Text2X-1;//Смещаем координаты текста по х
     With Options.BackgroundOptions.Canvas do
     begin
          brush.Color:=$F5F5F5;
          TextOut(x+Text2X, 180, 'Нажмите "Применить" и начните новую игру, чтобы изменения вступили в силу.');

         if (Text2X+x)=-200 then
            MoveText1.Enabled:=True;

         if (Text2X+x)=-490 then
         begin
            Text2X:=0;
            MoveText2.Enabled:=False;
         end;
      end;
end;

procedure TOptions.FormCreate(Sender: TObject);
begin
     Options.Height:=199;//Высота формы "Настройки"
     Options.Width:=300;//Ширина формы "Настройки"
     TextX:=0;//Инициализация координаты текста по х
     MoveOther:=0;//Тоже инициализация
     BackGroundSetting();//Рисуем задний фон
     Cells();//рисуем ячейки
     SnakeCreate();//Рисуем змейку
     FoodCreate.Enabled:=False;//Останавливаем таймер смены цвета змейки в реальном времени
     ColorSnikeChangeTimer.Enabled:=False;//Останавливаем таймер смены цвета еды в реальном времени
     MoveText2.Enabled:=False;//Останавлинаваем таймер второго текста бегущей строки
end;

end.

