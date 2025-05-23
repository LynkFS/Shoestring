unit JTabControl; // Keep unit name as JTabControl for now unless specified otherwise

interface

uses
  JElement-flex, JPanel, JButton, Globals; // Updated JElement to JElement-flex

type
  JTab = class(TElement)                      //individual tab and its body area
  public
    constructor Create(parent: TElement); virtual;
    body : TElement;
    property Caption : string read GetInnerHtml write SetInnerHtml;
    property hidden : boolean;
  end;

  JW3TabControl = class(TElement)             //tabcontrol = array of tabs
  private 
    FTabBar: JW3Panel;
    FContentArea: JW3Panel;
  public
    constructor Create(parent: TElement); virtual;
    Tabs : array of JTab;
    TabHeight : integer := 26;   //default
    TabWidth : integer := 100;   //default 100
    AutoSize : boolean := false;
    ActiveTab: integer := -1;
    procedure AddTab(Caption: String);
    procedure ReDraw;
  end;

implementation

{ JW3Tab }

constructor JTab.Create(parent: TElement);
begin
  inherited Create('div', parent);
  SetProperty('cursor','pointer');
  SetProperty('border','0px'); 
end;

{ JW3TabControl }

constructor JW3TabControl.Create(parent: TElement);
begin
  inherited Create('div', parent);
  Self.SetFlexDirection('column'); 

  FTabBar := JW3Panel.Create(Self);
  FTabBar.SetFlexDirection('row');
  FTabBar.SetCSS('width', '100%');
  FTabBar.SetCSS('height', IntToStr(TabHeight) + 'px');
  FTabBar.SetCSS('flex-shrink', '0'); 
  FTabBar.SetCSS('border-bottom', '1px solid silver');

  FContentArea := JW3Panel.Create(Self);
  FContentArea.SetCSS('width', '100%');
  FContentArea.SetFlexGrow(1); 
  FContentArea.SetCSS('overflow', 'auto'); 
  FContentArea.SetCSS('position', 'relative'); 
end;

Procedure JW3TabControl.AddTab(Caption: String);
var
  Tab: JTab;
  Body: JW3Panel; 
begin
  Tab := JTab.Create(FTabBar); 
  Tab.SetBounds(TabWidth, TabHeight); 
  Tab.SetCSS('margin-right', '2px');  
  Tab.Caption := '&nbsp;&nbsp;' + Caption; 
  Tab.Tag := IntToStr(Tabs.Count);

  Body := JW3Panel.Create(FContentArea); 
  Body.SetCSS('width', '100%');
  Body.SetCSS('height', '100%');
  Body.SetProperty('display', 'none'); 
  Body.SetFlexDirection('column');     

  Tab.Body := Body;
  Tabs.Add(Tab);

  Tab.OnClick := procedure(sender:TObject)
  var
    clickedTabTag: integer;
    i: Integer;
  begin
    clickedTabTag := StrToInt((sender as JTab).Tag);
    For i := 0 to Tabs.Count -1 do begin
      Tabs[i].setProperty('background-color', 'whitesmoke'); 
      Tabs[i].body.SetProperty('display', 'none');
    end;
    Tabs[clickedTabTag].setProperty('background-color', 'white'); 
    Tabs[clickedTabTag].body.SetProperty('display', 'flex'); 
    ActiveTab := clickedTabTag; 
  end;

  if Tabs.Count = 1 then
  begin
    ActiveTab := 0;
    Tab.setProperty('background-color', 'white');
    Body.SetProperty('display', 'flex');
  end;
end;

Procedure JW3TabControl.ReDraw;
var
  j : integer := 0;
  i : integer;
  NrVisible: integer := 0;
  TotalVisibleTabWidth: integer := 0;
begin
  Self.SetProperty('border','1px solid lightgrey'); 

  For i := 0 to Tabs.Count -1 do begin
    if not Tabs[i].hidden then
    begin
      inc(NrVisible);
      if i <> ActiveTab then
         Tabs[i].setProperty('background-color', 'whitesmoke')
      else
         Tabs[i].setProperty('background-color', 'white');

      Tabs[i].SetProperty('border-right','1px solid lightgrey');
    end;

    If Tabs[i].hidden
      then Tabs[i].handle.style.display := 'none'
      else Tabs[i].handle.style.display := 'inline-block'; 
  end;

  if (ActiveTab = -1 and NrVisible > 0) or (ActiveTab <> -1 and Tabs[ActiveTab].hidden) then
  begin
    ActiveTab := -1; 
    for i := 0 to Tabs.Count - 1 do
    begin
      if not Tabs[i].hidden then
      begin
        ActiveTab := i;
        break;
      end;
    end;
  end;

  if ActiveTab <> -1 then
  begin
    for i := 0 to Tabs.Count -1 do
    begin
      if i = ActiveTab then
      begin
        Tabs[i].setProperty('background-color', 'white');
        Tabs[i].body.SetProperty('display', 'flex');
      end
      else
      begin
        Tabs[i].setProperty('background-color', 'whitesmoke');
        Tabs[i].body.SetProperty('display', 'none');
      end;
    end;
  end;

  j := 0; 
  TotalVisibleTabWidth := 0;
  for i := 0 to Tabs.Count -1 do begin
    If not Tabs[i].hidden then begin
      if AutoSize and (NrVisible > 0) then
        Tabs[i].Width := trunc(FTabBar.FElement.clientWidth / NrVisible) 
      else
        Tabs[i].Width := TabWidth; 

      Tabs[i].SetBounds(Tabs[i].Width, Tabs[i].Height);
      TotalVisibleTabWidth := TotalVisibleTabWidth + Tabs[i].Width + 2; 
      inc(j);
    end;
  end;

  if TotalVisibleTabWidth > FTabBar.FElement.clientWidth then
  begin
    FTabBar.SetCSS('overflow-x', 'auto');
  end
  else
  begin
    FTabBar.SetCSS('overflow-x', 'hidden'); 
  end;
end;

end.
