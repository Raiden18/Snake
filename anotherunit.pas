//Тут просто объявлены переменные
unit AnotherUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;


  type
    Coordinate=record
    x,y:integer;
  end;
var
   Snake: array [0..225] of Coordinate;
   SnakeDemo: array [0..4] of Coordinate;
   ColorSnake, ColorFood1, FirsStart,MoveOther,length,MoveDirection:byte;
   count, TextX, Text2X,FoodX,FoodY,speed: integer;
   MoveUp,MoveDown,MoveRight,MoveLeft:Boolean;
   implementation

end.

