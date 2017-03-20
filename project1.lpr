program project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, GameUnit, SettingUnit, AnotherUnit, AboutGameUnit
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TWindowGame, WindowGame);
  Application.CreateForm(TOptions, Options);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

