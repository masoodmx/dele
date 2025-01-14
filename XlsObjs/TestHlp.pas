unit TestHlp;

interface

uses
  Classes;

type
  THlpTest = class

  public
    class function GetAppPath(): string;

    class function GetXMLTestFileName(): string;

    class procedure CreateXMLFile();
  end;

implementation

uses
  SysUtils;

const  

  XML_DATA =
'<?xml version = "1.0" encoding = "UTF-8"?>' + #13#10 +
'<RangeFormats>'+ #13#10 +
'<!--  Define colors which you''d like to use  -->' +
'	<Colors>'+ #13#10 +
'<!-- ItemID = "Colors name" Value= textcolor or hexadecimal $00FFFF  -->' +
'		<Color ItemID="Color1" Value="$00158860" />'+ #13#10 +
'		<Color ItemID="Color2" Value="$00F18800" />'+ #13#10 +
'		<Color ItemID="Color3" Value="clRed" />'+ #13#10 +
'		<Color ItemID="Color4" Value="clLime" />'+ #13#10 +
'	</Colors>'+ #13#10 +

'<!--  Define borders which you''d like to use  -->' +
'	<Borders>'+ #13#10 +
'<!-- ItemID = "Border name" Color="Color from Colors section" -->' +
'<!-- Style :' +
'  xlContinuous = $00000001;' +
'  xlDash = $FFFFEFED;' +
'  xlDashDot = $00000004;' +
'  xlDashDotDot = $00000005;' +
'  xlDot = $FFFFEFEA;' +
'  xlDouble = $FFFFEFE9;' +
'  xlSlantDashDot = $0000000D;' +
'  xlLineStyleNone = $FFFFEFD2; -->' +

'<!-- Weight : ' +
'  xlHairline = $00000001;' +
'  xlMedium = $FFFFEFD6;' +
'  xlThick = $00000004;' +
'  xlThin = $00000002;  -->' +
'		<Border ItemID="Border1" Color="Color3" Style="1" Weight="$00000001" />'+ #13#10 +
'		<Border ItemID="Border2" Color="Color3" Style="$FFFFEFED" Weight="$FFFFEFD6" />'+ #13#10 +
'		<Border ItemID="Border3" Color="Color4" Style="$FFFFEFE9" Weight="$00000004" />'+ #13#10 +
'	</Borders>'+ #13#10 +
'<!--  Define fonts which you''d like to use  -->' +
'	<Fonts>'+ #13#10 +
'		<Font ItemID="Font1" Name="Tahoma" Color="Color1" Size="12" Bold="True" Italic="False" />'+ #13#10 +
'	</Fonts>'+ #13#10 +
'<!--  Define range''s formats which you''d like to use  -->' +
'	<Ranges>'+ #13#10 +
'		<Range ItemID="Range1">'+ #13#10 +
'			<RangeName>E3:F4</RangeName>'+ #13#10 +
'			<InteriorColor>Color1</InteriorColor>'+ #13#10 +
'			<RangeFont>Font1</RangeFont>'+ #13#10 +
'<!--  XlBordersIndex/Item :' +
'  xlInsideHorizontal = $0000000C;' +
'  xlInsideVertical = $0000000B;' +
'  xlDiagonalDown = $00000005;' +
'  xlDiagonalUp = $00000006;' +
'  xlEdgeBottom = $00000009;' +
'  xlEdgeLeft = $00000007;' +
'  xlEdgeRight = $0000000A;' +
'  xlEdgeTop = $00000008; -->' +
'			<RangeBorders>'+ #13#10 +
'				<RangeBorder Item="7">Border1</RangeBorder>'+ #13#10 +
'				<RangeBorder Item="9">Border2</RangeBorder>'+ #13#10 +
'			</RangeBorders>'+ #13#10 +
'<!--  Row and Col width/height WIDTH_HIDE    = -1; WIDTH_AUTOFIT = -2;  WIDTH_DEFAULT = 0; -->' + #13#10 +
'			<RangeRowHeight>-1</RangeRowHeight>'+ #13#10 +
'			<RangeColWidth>0</RangeColWidth>'+ #13#10 +
'		</Range>'+ #13#10 +

'		<Range ItemID="Range2">'+ #13#10 +
'			<RangeName>A1:A2</RangeName>'+ #13#10 +
'			<InteriorColor>Color2</InteriorColor>'+ #13#10 +
'			<RangeFont>Font1</RangeFont>'+ #13#10 +
'			<RangeBorders>'+ #13#10 +
'				<RangeBorder Item="5">Border1</RangeBorder>'+ #13#10 +
'				<RangeBorder Item="7">Border2</RangeBorder>'+ #13#10 +
'				<RangeBorder Item="9">Border3</RangeBorder>'+ #13#10 +
'				<RangeBorder Item="12">Border2</RangeBorder>'+ #13#10 +
'			</RangeBorders>'+ #13#10 +
'			<RangeRowHeight>10</RangeRowHeight>'+ #13#10 +
'			<RangeColWidth>20</RangeColWidth>'+ #13#10 +
'		</Range>'+ #13#10 +
'	</Ranges>'+ #13#10 +
'</RangeFormats>';


{ THlpTest }

class procedure THlpTest.CreateXMLFile;
var
  FL: TFileStream;
  name: string;
begin
  name := GetXMLTestFileName();
  if FileExists( name ) then
    DeleteFile(name);

  FL := TFileStream.Create( name, fmCreate );
  try
    if FL.Size > 0 then
      FL.Size := 0;
    FL.Write( XML_DATA[ 1 ], Length( XML_DATA ) );
  finally
    FL.Free;
  end;
end;

class function THlpTest.GetAppPath: string;
begin
  Result := ExtractFilePath( ParamStr( 0 ) );
end;

class function THlpTest.GetXMLTestFileName: string;
begin
  Result := ExtractFilePath( ParamStr( 0 ) ) + 'XlsFormatTest.xml';
end;

end.
