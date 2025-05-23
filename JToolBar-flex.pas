unit JToolBar; // Keep unit name as JToolBar for now unless specified otherwise

interface

uses
  JElement-flex, JPanel; // Updated JElement to JElement-flex

type
  JW3ToolBar = class(TElement) // TElement will now refer to TElement from JElement-flex
  private
    ToolBarItems: Array of JW3Panel;
  public
    constructor Create(parent: TElement); virtual;
    Procedure AddMenu(menuText, GotoForm, color: string);
    Procedure SetActiveMenu(formname: string);
  end;

implementation

uses Globals; // For Application, window, etc. if not implicitly included

{ JW3ToolBar }

constructor JW3ToolBar.Create(parent: TElement);
begin
  inherited Create('div', parent);
  Self.SetFlexDirection('row');      // Arrange items horizontally
  Self.SetAlignItems('center');      // Vertically center items if they have different heights
  Self.SetCSS('padding', '5px');     // Add some padding around the toolbar
end;

procedure JW3ToolBar.AddMenu(menuText, GotoForm, color: string);
begin
//
  var Panel0 := JW3Panel.Create(self);
  Panel0.SetBounds(90, 26); // Set preferred size for the flex item
  Panel0.SetCSS('margin-right', '5px'); // Add spacing between items

  Panel0.SetinnerHtml(menuText);
  Panel0.setProperty('color', color);
  Panel0.setProperty('cursor','pointer');
  Panel0.SetProperty('font-size', '0.9em');

  ToolBarItems.Add(Panel0);
  Panel0.Tag := GotoForm;
  Panel0.OnClick := procedure(Sender:TObject)
    begin
      if Application.FormNames.IndexOf((Sender as JW3Panel).tag) > -1     //if form
        then Application.GoToForm((Sender as JW3Panel).tag)               //then gotoform
        else window.postMessage([self.handle.id,'click',GoToForm],'*');   //else send message
    end;
end;

procedure JW3ToolBar.SetActiveMenu(FormName: String);
begin
//
  For var i := 0 to ToolBarItems.Count -1 do begin
    ToolBarItems[i].setProperty('font-weight', 'normal');
    ToolBarItems[i].setProperty('text-decoration', 'none');
    If ToolBarItems[i].Tag = FormName then
    begin
      ToolBarItems[i].setProperty('font-weight', 'bold');
      ToolBarItems[i].setProperty('text-decoration', 'underline');
    end;
  end;
end;

end.
