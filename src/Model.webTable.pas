unit Model.webTable;

interface

uses
  System.Classes,
  System.StrUtils,
  System.SysUtils,
  Model.WebTable.DataSet,
  Model.WebTable.Interfaces;

type
  TModelWebTable = class(TInterfacedObject, IModelWebTable)
  strict private
    FOrder: string;
    FColumnOrder: string;
    FNumberFixedColumnStart: Integer;
    FWebTableDataSets: TInterfaceList;
    FActionButtonList: TInterfaceList;

    function GenerateBodyHtml: string;
    function GenerateFootHtml: string;
    function GenerateHeaderHtml: string;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: IModelWebTable;

    function Order(AValue: string): IModelWebTable;
    function ColumnOrder(AValue: string): IModelWebTable;
    function Generate(AGenerateFoot: Boolean = True): string;
    function NumberFixedColumnStart(AValue: Integer): IModelWebTable;
    function AddActionButton(AValue: IModelWebTableButton): IModelWebTable;
    function AddwebTableDataSet(AColumnName: string; AKey: Boolean = False;
      AVisible: Boolean = False): IModelWebTableDataSet;
  end;

implementation

{ TModelWebTable }

function TModelWebTable.AddActionButton(
  AValue: IModelWebTableButton): IModelWebTable;
begin
  result := Self;

  FActionButtonList.Add(AValue);
end;

function TModelWebTable.AddwebTableDataSet(AColumnName: string; AKey: Boolean;
  AVisible: Boolean): IModelWebTableDataSet;
begin
  Result := TModelWebTableDataSet.New(Self, AColumnName, AKey, AVisible);

  FWebTableDataSets.Add(Result);
end;

function TModelWebTable.ColumnOrder(AValue: string): IModelWebTable;
begin
  result := Self;

  FColumnOrder := AValue;
end;

constructor TModelWebTable.Create;
begin
  inherited Create;

  FWebTableDataSets := TInterfaceList.Create;
  FActionButtonList := TInterfaceList.Create;
end;

destructor TModelWebTable.Destroy;
begin
  FWebTableDataSets.Free;
  FActionButtonList.Free;

  inherited;
end;

function TModelWebTable.Generate(AGenerateFoot: Boolean): string;
var
  LOrder: string;
  LWebTableID: string;
  LColumnOrder: string;
  LRetornoHtmlStr: string;
begin
  LWebTableID := IntToStr(Random(MaxInt));

  LRetornoHtmlStr := Format('<script src="https://code.jquery.com/jquery-3.7.1.js"></script> ' +
                            '<script src="https://cdn.datatables.net/2.1.4/js/dataTables.js"></script> '+
                            ifThen(FNumberFixedColumnStart > 0,
                            '<script src="https://cdn.datatables.net/fixedcolumns/5.0.3/js/dataTables.fixedColumns.js"></script> '+
                            '<script src="https://cdn.datatables.net/fixedcolumns/5.0.3/js/fixedColumns.dataTables.js"></script> ', '')+
                            '<table id="table%s" class="display" style="width:%s"> ',
                            [LWebTableID, '100%']);

  LRetornoHtmlStr := LRetornoHtmlStr + GenerateHeaderHtml;
  LRetornoHtmlStr := LRetornoHtmlStr + GenerateBodyHtml;

  if AGenerateFoot then
    LRetornoHtmlStr := LRetornoHtmlStr + GenerateFootHtml;

  LColumnOrder := '0';

  if StrToIntDef(FColumnOrder, 0) > 0 then
    LColumnOrder := FColumnOrder;

  LOrder := 'asc';
  if FOrder = 'desc' then
    LOrder := FOrder;

  LRetornoHtmlStr := LRetornoHtmlStr +
                     Format('</table> ' +
                            '<script> '+
                            '  new DataTable("#table%s", { '+
                            ifThen(FNumberFixedColumnStart > 0,
                              Format('fixedColumns: { start: %d },', [FNumberFixedColumnStart]), '') +
                            '    layout: { '+
                            '      bottomEnd: { '+
                            '        paging: { '+
                            '          firstLast: false '+
                            '        } '+
                            '      } '+
                            '    }, '+
                            '    order: [[%s, "%s"]], '+
                            '    scrollY: true, '+
                            '    language: { '+
                            '      "decimal": ",", '+
                            '      "emptyTable": "Nenhum registro encontrado", '+
                            '      "info": "_START_ - _END_  de _TOTAL_", '+
                            '      "infoEmpty": "Showing 0 to 0 de of entries", '+
                            '      "infoFiltered": "(filtered from _MAX_ total entries)", '+
                            '      "infoPostFix": "", '+
                            '      "thousands": ".", '+
                            '      "lengthMenu": "Mostrar _MENU_  registros por página", '+
                            '      "loadingRecords": "Loading...", '+
                            '      "processing": "", '+
                            '      "search": "Procurar: ", '+
                            '      "zeroRecords": "Nenhum registro encontrado", '+
                            '      "paginate": { '+
                            '        "first": "Primeiro", '+
                            '        "last": "Último", '+
                            '        "next": "Próximo", '+
                            '        "previous": "Anterior" '+
                            '      }, '+
                            '      "aria": { '+
                            '         "orderable":  "Ordenar por essa coluna", '+
                            '          "orderableReverse": "Inverter ordenação da coluna" '+
                            '      } '+
                            '    } '+
                            '  }); '+
                            '</script>',
                           [LWebTableID, LColumnOrder, LOrder]);

  result := LRetornoHtmlStr;
end;

function TModelWebTable.GenerateBodyHtml: string;
var
  LRecordCount: Integer;
  LRetornoHtmlStr: string;
  LWebTableSet: IModelWebTableDataSet;
begin
  LRetornoHtmlStr := '<tbody> ';

  if FwebTableDataSets.Count > 0 then
  begin
    LRecordCount := (FwebTableDataSets[0] as IModelWebTableDataSet).RecordCount;

    if LRecordCount > 0 then
    begin
      for var X := 0 to Pred(LRecordCount) do
      begin
        LRetornoHtmlStr := LRetornoHtmlStr +'<tr>';

        for var I := 0 to Pred(FwebTableDataSets.Count) do
        begin
          LWebTableSet := (FwebTableDataSets[I] as IModelWebTableDataSet);

          if LWebTableSet.Visible then
            LRetornoHtmlStr := LRetornoHtmlStr + LWebTableSet.Generate(X);
        end;

        if FActionButtonList.Count > 0 then
        begin
          for var I := 0 to Pred(FWebTableDataSets.Count) do
          begin
            LWebTableSet := (FWebTableDataSets[I] as IModelWebTableDataSet);

            if LWebTableSet.Key then
            begin
              for var LActionButton in FActionButtonList do
              begin
                with LActionButton as IModelWebTableButton do
                begin
                  LRetornoHtmlStr := LRetornoHtmlStr +
                    Format('<td class="text-center"> '+
                      '  <button id="bEdit" type="button" class="btn btn-sm btn-%s" '+
                      '    onclick="{{CallBack=%s(%s='+ LWebTableSet.Generate(X) +')}}">'+
                      '      <span class="fa fa-%s"></span> '+
                      '  </button> '+
                      '</td>',
                      [Color,
                       CallBackName,
                       ParamName,
                       IconName]);
                end;
              end;
            end;
          end;
        end;

        LRetornoHtmlStr := LRetornoHtmlStr + '</tr> ';
      end;
    end;
  end;

  LRetornoHtmlStr := LRetornoHtmlStr + '</tbody> ';

  result := LRetornoHtmlStr;
end;

function TModelWebTable.GenerateFootHtml: string;
var
  LRetornoHtmlStr: string;
  LWebTableSet: IModelWebTableDataSet;
begin
  LRetornoHtmlStr := '<tfoot> <tr> ';

  for var I := 0 to Pred(FwebTableDataSets.Count) do
  begin
    LWebTableSet := (FwebTableDataSets[I] as IModelWebTableDataSet);

    if LWebTableSet.Visible then
      LRetornoHtmlStr := LRetornoHtmlStr +'<th>'+ LWebTableSet.ColumnName +'</th>';
  end;

  if FActionButtonList.Count > 0 then
    LRetornoHtmlStr := LRetornoHtmlStr +'<th></th>';

  LRetornoHtmlStr := LRetornoHtmlStr + '</tr> </tfoot> ';

  result := LRetornoHtmlStr;
end;

function TModelWebTable.GenerateHeaderHtml: string;
var
  LRetornoHtmlStr: string;
  LWebTableSet: IModelWebTableDataSet;
begin
  LRetornoHtmlStr := '<thead> <tr> ';

  for var I := 0 to Pred(FwebTableDataSets.Count) do
  begin
    LWebTableSet := (FwebTableDataSets[I] as IModelWebTableDataSet);

    if LWebTableSet.Visible then
      LRetornoHtmlStr := LRetornoHtmlStr +'<th>'+ LWebTableSet.ColumnName +'</th>';
  end;

  if FActionButtonList.Count > 0 then
    LRetornoHtmlStr := LRetornoHtmlStr +'<th>Ações</th>';

  LRetornoHtmlStr := LRetornoHtmlStr + '</tr> </thead> ';

  result := LRetornoHtmlStr;
end;

class function TModelWebTable.New: IModelWebTable;
begin
  result := Self.Create;
end;

function TModelWebTable.NumberFixedColumnStart(AValue: Integer): IModelWebTable;
begin
  result := Self;

  FNumberFixedColumnStart := AValue;
end;

function TModelWebTable.Order(AValue: string): IModelWebTable;
begin
  result := Self;

  FOrder := AValue;
end;

end.
