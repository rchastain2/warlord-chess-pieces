program txt2bmp;

uses
  Classes, SysUtils,
  BGRABitmap, BGRABitmapTypes;

var
  LWhiteBitmap, LBlackBitmap: TBGRABitmap;
  LWhiteName, LBlackName: TFileName;
  LWhitePixel, LBlackPixel: TBGRAPixel;
  LLetter: string;
  LFile: text;
  LLine: string;
  LPicture, x, y: integer;

begin
  AssignFile(LFile, '../warlord.txt');
  Reset(LFile);

  for LPicture := 0 to 5 do
  begin
    ReadLn(LFile, LLine);

    if LLine = 'knight' then
      LLetter := 'n'
    else
      LLetter := Copy(LLine, 1, 1);

    LWhiteName := Format('w%s.png', [LLetter]);
    LBlackName := Format('b%s.png', [LLetter]);

    LWhiteBitmap := TBGRABitmap.Create(48, 48, {CSSMagenta}BGRAPixelTransparent);
    LBlackBitmap := TBGRABitmap.Create(48, 48, {CSSMagenta}BGRAPixelTransparent);

    for y := 0 to 47 do
    begin
      ReadLn(LFile, LLine);

      for x := 0 to 47 do
        case LLine[Succ(x)] of
          '0':
          begin
            // Conserver la couleur magenta.
          end;
          '1':
            begin
            (*
              LWhiteBitmap.SetPixel(x, y, CSSWhite);
              LBlackBitmap.SetPixel(x, y, CSSWhite);
            *)
            end;
          '2':
            begin
              LWhiteBitmap.SetPixel(x, y, CSSGray);
              LBlackBitmap.SetPixel(x, y, CSSGray);
            end;
          '3':
            begin
              LWhiteBitmap.SetPixel(x, y, CSSIvory);
              LBlackBitmap.SetPixel(x, y, CSSBlack);
            end;
        end;
    end;

    LWhiteBitmap.SaveToFile(LWhiteName);
    LWhiteBitmap.Free;
    LBlackBitmap.SaveToFile(LBlackName);
    LBlackBitmap.Free;
  end;

  CloseFile(LFile);
end.
