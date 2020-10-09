unit JWindow;

interface

uses
  JElement, JPanel, JButton;

type
  JW3Window = class(TElement)
  protected
    WindowArea : JW3Panel;
    procedure ArrangeElements;
  public
    CloseButton: JW3Button;
    constructor Create(parent: TElement); virtual;
    procedure OpenWindow;
    procedure CloseWIndow;
  end;

implementation

uses Globals;

{ JW3Window }

constructor JW3Window.Create(parent: TElement);
begin
  inherited Create('div', parent);
  self.SetProperty('display','none');
  self.SetProperty('background-color', 'rgb(255,255,255)');
  self.SetProperty('background-color', 'rgba(0,0,0,0.4)');
  self.handle.style.width  := '100%';
  self.handle.style.height := '100%';

  WindowArea := JW3Panel.Create(self);
  WindowArea.SetProperty('background-color', 'whitesmoke');
  WindowArea.SetProperty('margin', '10% 5% 5% 10%');
  WindowArea.SetProperty('border', '1px solid #888');
  WindowArea.SetProperty('width', '80%');
  WindowArea.SetProperty('height', '30%');

  CloseButton := JW3Button.Create(WindowArea);
  CloseButton.SetinnerHTML('x');
  CloseButton.SetAttribute('style', #'margin: 2px 2px;
    float: right; cursor: pointer;');

  CloseButton.OnClick := procedure(sender:TObject)
  begin
    CloseWindow;
  end;
end;

procedure JW3Window.OpenWindow;
begin
  ArrangeElements;
  self.SetProperty('display','inline-block');
end;

procedure JW3Window.CloseWindow;
begin
  //self.SetProperty('display','none');
  //Felement.parentNode.removeChild(Felement);
  self.Destroy;
end;

procedure JW3Window.ArrangeElements;
begin
  //move all children of self, except WindowArea, to WindowArea
  //so this component can be invoked as if it is a normal form
  var d := self.handle.children;
  var TempArray : Array of variant;
  for var i := 0 to d.length -1 do
    TempArray.Add(d[i]);

  var z := 0;
  for var j := 0 to TempArray.length -1 do
    If TempArray[j].id <> WindowArea.handle.id then begin  //omit WindowArea

      // set child.top at least to CloseButton.height so as not to obscure close button
      var x := strtoInt(StrBefore(TempArray[j].style.top,'px'));
      If x <= 30 then
        TempArray[j].style.top := inttostr(x+30) + 'px';

      // set height of WindowArea depending on lowest child-bottom
      var y := strtoInt(StrBefore(TempArray[j].style.top,'px')) +
               strtoInt(StrBefore(TempArray[j].style.height,'px')) +
               strtoInt(StrBefore(WindowArea.handle.style.marginBottom,'px'));
      If y > z then z := y;

      // move all elements (if any) from self to WindowArea
      WindowArea.handle.appendChild(TempArray[j]);
    end;

  If z > 0 then
    WindowArea.handle.style.height := inttostr(z+20) + 'px';
end;

end.
