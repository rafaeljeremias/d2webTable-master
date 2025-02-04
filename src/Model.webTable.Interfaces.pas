unit Model.webTable.Interfaces;

interface

type
  EnumWebTableColors = (wcNone, wcDark, wcDanger, wcInfo, wcLight, wcPrimary, wcSecondary, wcSuccess, wcTransparent, wcWarning);

  EnumWebTableStyleText = (wstNone, stBold, stStrong, stItalic, stEmphasized, stMarked, stSmaller, stDeleted,
    stInserted, stSubscript, stSuperscript);

  IModelWebTable = Interface;

  IModelWebTableButton = Interface
    ['{2182A9B2-03CB-4340-B37B-CC84555299D0}']
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

  IModelWebTableData = Interface
    ['{CA5DC7A9-A4E3-4AAB-9D2F-69307F41BBB2}']
    function Text: string; overload;
    function OpacityColor: string; overload;
    function Color: EnumWebTableColors; overload;
    function OpacityBackgroundColor: string; overload;
    function StyleText: EnumWebTableStyleText; overload;
    function ColorBackground: EnumWebTableColors; overload;

    function Text(AValue: string): IModelWebTableData; overload;
    function OpacityColor(AValue: string): IModelWebTableData; overload;
    function Color(AValue: EnumWebTableColors): IModelWebTableData; overload;
    function OpacityBackgroundColor(AValue: string): IModelWebTableData; overload;
    function StyleText(AValue: EnumWebTableStyleText): IModelWebTableData; overload;
    function ColorBackground(AValue: EnumWebTableColors): IModelWebTableData; overload;
  End;

  IModelWebTableDataSet = Interface
    ['{2F7B7108-CA7A-4DEC-B055-5E0C999677F7}']
    function Key: Boolean;
    function Visible: Boolean;
    function ColumnName: string;
    function RecordCount: Integer;
    function &End: IModelWebTable;
    function Generate(AIndex: Integer): string;
    function AddwebTableData(AText: Variant; AColorBackground: EnumWebTableColors = wcNone;
      AColor: EnumWebTableColors = wcNone; AOpacityColor: string = '1'; AOpacityBackgroundColor: string = '1';
      AStyleText: EnumWebTableStyleText = wstNone): IModelWebTableDataSet;
  End;

  IModelWebTable = Interface
    ['{41B0B264-F2D8-49FD-BAE1-6622EB84D25D}']
    function Order(AValue: string): IModelWebTable;
    function ColumnOrder(AValue: string): IModelWebTable;
    function Generate(AGenerateFoot: Boolean = True): string;
    function NumberFixedColumnStart(AValue: Integer): IModelWebTable;
    function AddActionButton(AValue: IModelWebTableButton): IModelWebTable;
    function AddWebTableDataSet(AColumnName: string; AKey: Boolean = False;
      AVisible: Boolean = True): IModelWebTableDataSet;
  End;

implementation

end.
