unit main;

interface

uses
  SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls,
  BGRABitmap, BGRABitmapTypes;

type
  TBGRABitmap1 = class(TBGRABitmap)
    procedure ClearTransparentPixels; override;
  end;

  TForm1 = class(TForm)
    EDInputFEN: TLabeledEdit;
    BTViewPosition: TButton;
    PBChessboard: TPaintBox;
    procedure FormCreate(Sender: TObject);
    procedure BTViewPositionClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PBChessboardPaint(Sender: TObject);
  private
    { Déclarations privées }
    FVirtualScreen: TBGRABitmap;
    FPictures: TBGRABitmap1;
    procedure OnPositionChange;
    procedure ClearBoard;
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

procedure TBGRABitmap1.ClearTransparentPixels;
(* https://forum.lazarus.freepascal.org/index.php/topic,33046.msg213447.html#msg213447 *)
var
  p: PBGRAPixel;
  n: integer;
begin
  (*
  inherited ClearTransparentPixels;
  *)
  begin
    p := Data;
    for n := NbPixels - 1 downto 0 do
    begin
      (*
      if p^.alpha = 0 then
        if ((p^.red <> 0) or (p^.green <> 0) or (p^.blue <> 0)) then
          p^.alpha := 255
        else
          p^ := BGRAPixelTransparent;
      *)

      if ((p^.red = 255) and (p^.green = 0) and (p^.blue = 255)) then
        p^ := BGRAPixelTransparent
      else
        p^.alpha := 255;

      Inc(p);
    end;
    InvalidateBitmap;
  end;
end;

procedure TForm1.OnPositionChange;
var
  s: string;
  i, x, y, xx, yy: integer;
  LPiece: TBGRABitmap;
begin
  ClearBoard;
  s := 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';
  i := 1;
  x := 1;
  y := 8;
  while s[i] <> ' ' do
  begin
    case s[i] of
      '1'..'8':
        Inc(x, Ord(s[i]) - Ord('0'));
      '/':
        ;
      else
        begin
          xx := Pred(Pos(UpCase(s[i]), 'PRNBQK'));
          yy := Ord(s[i] in ['a'..'z']);
          
          LPiece := FPictures.GetPart(Rect(
            48 * xx,
            48 * yy,
            48 * Succ(xx),
            48 * Succ(yy)
          ));
          
          FVirtualScreen.PutImage(48 * Pred(x), 48 * Pred(9 - y), LPiece, {dmSet}dmDrawWithTransparency);
          
          LPiece.Free;
          
          Inc(x);
        end;
    end;
    if x > 8 then
    begin
      x := 1;
      Dec(y);
    end;
    Inc(i);
  end;
  PBChessboard.Invalidate;
end;

procedure TForm1.ClearBoard;
var
  x, y: integer;
  LColor: TBGRAPixel;
begin
  for x := 1 to 8 do for y := 1 to 8 do
  begin
    if (x + y) mod 2 = 0 then
      LColor := CSSOrange
    else
      LColor := CSSDarkOrange;
    
    FVirtualScreen.FillRect(Rect(48 * Pred(x), 48 * Pred(9 - y), 48 * x, 48 * (9 - y)), LColor);
  end;
end;

procedure TForm1.BTViewPositionClick(Sender: TObject);
begin
  OnPositionChange;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FVirtualScreen := TBGRABitmap.Create(8 * 48, 8 * 48);

  FPictures := TBGRABitmap1.Create;
  FPictures.LoadFromFile('..' + DirectorySeparator + 'magick-montage' + DirectorySeparator + 'warlord-chess-graphics-without-outline.bmp');

  ClearBoard;
  PBChessboard.Invalidate;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FPictures.Free;
  FVirtualScreen.Free;
end;

procedure TForm1.PBChessboardPaint(Sender: TObject);
begin
  FVirtualScreen.Draw(PBChessboard.Canvas, 0, 0);
end;

end.
