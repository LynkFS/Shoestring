unit JGrid; // Keep unit name as JGrid for now unless specified otherwise

interface

uses
  JElement-flex, JListBox, JPanel; // Updated JElement to JElement-flex

type
  JW3Grid = class(TElement) // TElement will now refer to TElement from JElement-flex
  private
    FHeaderRowPanel: JW3Panel;
    Item: JW3Panel;
    ItemHeight: integer;
    ColumnCount : integer;
    ColumnWidths : array of integer;
    Columns : array of JW3Panel;
    Procedure HandleColumnResize(columnTitle: JW3Panel);
  public
    ListBox: JW3ListBox;
    constructor Create(parent: TElement); virtual;
    procedure AddColumn(title: string; colwidth: integer);
    procedure AddCell(row, column: integer; cell: TElement);
    CanResize : boolean := false;
  end;

implementation

uses Globals; // For touch2Mouse, StrToInt, IntToStr etc.

{ JW3Grid }

constructor JW3Grid.Create(parent: TElement);
begin
  inherited Create('div', parent);
  Self.SetFlexDirection('column');

  ColumnCount := 0;

  FHeaderRowPanel := JW3Panel.Create(Self);
  FHeaderRowPanel.SetFlexDirection('row');
  FHeaderRowPanel.SetCSS('width', '100%');
  FHeaderRowPanel.SetCSS('border-bottom', '1px solid black');

  ListBox := JW3ListBox.Create(self);
  ListBox.SetCSS('width', '100%');
  ListBox.SetFlexGrow(1);
  ListBox.SetCSS('overflow', 'auto');

  self.OnReadyExecute := procedure(sender: TObject)
  begin
    // Empty or remove as Flexbox handles sizing.
  end;
end;

procedure JW3Grid.AddColumn(title: string; colwidth: integer);
var
  TitleTextPanel: JW3Panel;
begin
  ColumnWidths.Add(colwidth);

  var columnTitle := JW3Panel.Create(FHeaderRowPanel);
  columnTitle.SetBounds(colwidth, 24); // Width acts as flex-basis for columnTitle
  columnTitle.SetProperty('border','1px solid grey');
  columnTitle.SetProperty('background-color','lightgrey');
  columnTitle.SetFlexDirection('row');
  columnTitle.SetAlignItems('center');
  columnTitle.SetJustifyContent('space-between');
  columnTitle.SetinnerHTML(''); // Clear innerHTML of columnTitle itself

  TitleTextPanel := JW3Panel.Create(columnTitle);
  TitleTextPanel.SetinnerHTML(title);
  TitleTextPanel.SetFlexGrow(1);
  TitleTextPanel.SetCSS('overflow', 'hidden');
  TitleTextPanel.SetCSS('text-overflow', 'ellipsis');
  TitleTextPanel.SetCSS('white-space', 'nowrap');

  if CanResize then HandleColumnResize(columnTitle);

  Inc(ColumnCount);
end;

procedure JW3Grid.AddCell(row, column: integer; cell: TElement);
begin
  If Column = 1 then begin
    Item := JW3Panel.Create(ListBox);
    Item.SetFlexDirection('row');
    Item.SetCSS('width', '100%');
    Item.SetProperty('border-bottom','none');
    ItemHeight := Cell.Height;
  end;

  If Cell.Height > ItemHeight then ItemHeight := Cell.Height;

  Cell.SetProperty('width',inttostr(ColumnWidths[column-1])+'px'); // Width acts as flex-basis
  Cell.SetCSS('flex-shrink', '0');
  Cell.setProperty('border', '1px solid lightgrey');
  Cell.SetCSS('overflow', 'hidden');
  Cell.SetCSS('text-overflow', 'ellipsis');
  Cell.SetCSS('white-space', 'nowrap');

  Item.FElement.appendchild(Cell.FElement);

  If Column = ColumnCount then
  begin
    var c := Item.handle.children;
    for var i := 0 to c.length -1 do begin
      JHTMLElement(c[i]).style.height  := inttostr(Itemheight+6)+'px';
    end;
    Item.SetProperty('height',inttostr(ItemHeight+10)+'px');
    ListBox.Add(Item);
  end;
end;

procedure JW3Grid.HandleColumnReSize(columnTitle: JW3Panel);
var
  ReSizer: JW3Panel;
  saveX: Integer;
  i, j: Integer; // Loop variables
  c, d: JNodeList; // DOM node lists
begin
  styleSheet.insertRule('#' + columnTitle.FElement.id + ' { user-select:none}', 0);
  styleSheet.insertRule('#' + columnTitle.FElement.id + ' { -webkit-user-select:none}', 0);
  styleSheet.insertRule('#' + columnTitle.FElement.id + ' { -moz-user-select:none}', 0);
  styleSheet.insertRule('#' + columnTitle.FElement.id + ' { -ms-user-select:none}', 0);

  styleSheet.insertRule('#' + ListBox.FElement.id + ' { user-select:none}', 0);
  styleSheet.insertRule('#' + ListBox.FElement.id + ' { -webkit-user-select:none}', 0);
  styleSheet.insertRule('#' + ListBox.FElement.id + ' { -moz-user-select:none}', 0);
  styleSheet.insertRule('#' + ListBox.FElement.id + ' { -ms-user-select:none}', 0);

  ReSizer := JW3Panel.Create(columnTitle);
  ReSizer.SetProperty('background-color','gold');
  ReSizer.SetBounds(4, 22); 
  ReSizer.SetCSS('flex-shrink', '0'); 
  ReSizer.SetProperty('cursor','w-resize');
  ReSizer.tag := IntToStr(ColumnCount);

  ReSizer.handle.ontouchstart := lambda(e: variant) touch2Mouse(e); end;
  ReSizer.handle.ontouchmove  := ReSizer.handle.ontouchstart;
  ReSizer.handle.ontouchend   := ReSizer.handle.ontouchstart;

  ReSizer.handle.onmousedown := procedure(e: variant)
  begin
    saveX := e.clientX;
    self.handle.onmousemove := procedure(e: variant)
    begin
      columnTitle.handle.style.zIndex := '999';
      columnTitle.Width := columnTitle.Width - (saveX - e.clientX);
      saveX := e.clientX;
    end;
  end;

  Columns.Add(columnTitle); 

  columnTitle.handle.onmouseup := procedure
  var
    resizedColumnIndex: Integer;
  begin
    resizedColumnIndex := StrToInt(ReSizer.Tag);
    ColumnWidths[resizedColumnIndex] := columnTitle.Width;

    c := ListBox.handle.children;
    for i := 0 to c.length -1 do begin
      d := JHTMLElement(c[i]).childNodes; 
      for j := 0 to d.length -1 do begin
        if j = resizedColumnIndex then begin
          JHTMLElement(d[j]).style.width := inttostr(ColumnWidths[resizedColumnIndex]) + 'px';
        end;
      end;
    end;
    columnTitle.handle.style.zIndex := '0';

    self.handle.onmousemove := procedure begin end;
  end;
end;

end.
