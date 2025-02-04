unit Model.webTable.Button;

interface

uses
  Model.webTable.Interfaces;

type
  TModelWebTableButton = class(TInterfacedObject, IModelWebTableButton)
  strict private
    FNome: string;
    FColor: string;
    FIconName: string;
    FParamName: string;
    FCallBackName: string;
  public
    class function New: IModelWebTableButton;

    function Nome: string; overload;
    function Color: string; overload;
    function IconName: string; overload;
    function ParamName: string; overload;
    function CallBackName: string; overload;

    function Nome(AValue: string): IModelWebTableButton; overload;
    function Color(AValue: string): IModelWebTableButton; overload;
    function IconName(AValue: string): IModelWebTableButton; overload;
    function ParamName(AValue: string): IModelWebTableButton; overload;
    function CallBackName(AValue: string): IModelWebTableButton; overload;
  End;

implementation

{ IModelWebTableButton }

function TModelWebTableButton.CallBackName(
  AValue: string): IModelWebTableButton;
begin
  result := Self;

  FCallBackName := AValue;
end;

function TModelWebTableButton.CallBackName: string;
begin
  result := FCallBackName;
end;

function TModelWebTableButton.Color(AValue: string): IModelWebTableButton;
begin
  result := Self;

  FColor := AValue;
end;

function TModelWebTableButton.Color: string;
begin
  result := FColor;
end;

function TModelWebTableButton.IconName: string;
begin
  result := FIconName;
end;

function TModelWebTableButton.IconName(AValue: string): IModelWebTableButton;
begin
  result := Self;

  FIconName := AValue;
end;

class function TModelWebTableButton.New: IModelWebTableButton;
begin
  result := Self.Create;
end;

function TModelWebTableButton.Nome: string;
begin
  result := FNome;
end;

function TModelWebTableButton.Nome(AValue: string): IModelWebTableButton;
begin
  result := Self;

  FNome := AValue;
end;

function TModelWebTableButton.ParamName: string;
begin
  result := FParamName;
end;

function TModelWebTableButton.ParamName(AValue: string): IModelWebTableButton;
begin
  result := Self;

  FParamName := AValue;
end;

end.
