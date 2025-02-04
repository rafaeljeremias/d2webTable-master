unit Model.webTable.DataSet;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Variants,
  Model.webTable.Data,
  Model.webTable.Utils,
  Model.webTable.Interfaces;

type
  TModelWebTableDataSet = class(TInterfacedObject, IModelWebTableDataSet)
  strict private
    [weak]
    FParent: IModelWebTable;
    FColumnName: string;
    FKey: Boolean;
    FVisible: Boolean;
    FListItens: TInterfaceList;
  public
    constructor Create(AParent:  IModelWebTable; AColumnName: string;
      AKey: Boolean; AVisible: Boolean);
    destructor Destroy; override;
    class function New(AParent: IModelWebTable; AColumnName: string;
      AKey: Boolean; AVisible: Boolean): IModelWebTableDataSet;

    function Key: Boolean;
    function Visible: Boolean;
    function Generate(AIndex: Integer): string;
    function ColumnName: string;
    function &End: IModelWebTable;
    function RecordCount: Integer;
    function AddwebTableData(AText: Variant; AColorBackground: EnumWebTableColors = wcNone;
      AColor: EnumWebTableColors = wcNone; AOpacityColor: string = '1'; AOpacityBackgroundColor: string = '1';
      AStyleText: EnumWebTableStyleText = wstNone): IModelWebTableDataSet;
  End;

implementation

{ TModelWebTableDataSet }

function TModelWebTableDataSet.AddwebTableData(AText: Variant;
  AColorBackground, AColor: EnumWebTableColors; AOpacityColor: string;
  AOpacityBackgroundColor: string; AStyleText: EnumWebTableStyleText): IModelWebTableDataSet;
begin
  Result := Self;

  var webTableData := TModelWebTableData.New(AText, AColor, AColorBackground,
    AOpacityColor, AOpacityBackgroundColor, AStyleText);

  FListItens.Add(webTableData);
end;

function TModelWebTableDataSet.ColumnName: string;
begin
  result := FColumnName;
end;

constructor TModelWebTableDataSet.Create(AParent: IModelWebTable;
  AColumnName: string; AKey: Boolean; AVisible: Boolean);
begin
  inherited Create;

  FKey := AKey;
  FParent := AParent;
  FVisible := AVisible;
  FColumnName := AColumnName;
  FListItens := TInterfaceList.Create;
end;

destructor TModelWebTableDataSet.Destroy;
begin
  FListItens.Free;

  inherited;
end;

function TModelWebTableDataSet.&End: IModelWebTable;
begin
  result := FParent;
end;

function TModelWebTableDataSet.Generate(AIndex: Integer): string;
var
  LStyleColor: string;
begin
  var DataStr := EmptyStr;
  LStyleColor := EmptyStr;

  if FListItens.Count > 0 then
  begin
    var LWebTableData := FListItens[AIndex] as TModelWebTableData;

    if LWebTableData.Color <> wcNone then
      LStyleColor := 'color:'+ EnumColorsToRgbColorsStr(LWebTableData.Color, LWebTableData.OpacityColor);

    if LWebTableData.ColorBackground <> wcNone then
    begin
      LStyleColor := LStyleColor +';'+
        'background:'+ EnumColorsToRgbColorsStr(LWebTableData.ColorBackground, LWebTableData.OpacityBackgroundColor);
    end;

    if LStyleColor <> '' then
      LStyleColor := 'style="'+ LStyleColor +'"';

    DataStr := DataStr +'<td '+ LStyleColor +'>'+
      EnumStyleTextToTagHtml(LWebTableData.StyleText) +
      VarToStr(LWebTableData.Text) +
      EnumStyleTextToTagHtml(LWebTableData.StyleText) +
      '</td> ';
  end;

  Result := DataStr;
end;

function TModelWebTableDataSet.Key: Boolean;
begin
  result := FKey;
end;

class function TModelWebTableDataSet.New(AParent: IModelWebTable;
  AColumnName: string; AKey: Boolean; AVisible: Boolean): IModelWebTableDataSet;
begin
  result := Self.Create(AParent, AColumnName, AKey, AVisible);
end;

function TModelWebTableDataSet.RecordCount: Integer;
begin
  result := FListItens.Count;
end;

function TModelWebTableDataSet.Visible: Boolean;
begin
  result := FVisible;
end;

end.
