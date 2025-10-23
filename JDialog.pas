unit JDialog;


interface

uses
  JElement, JPanel, JButton;

type
  JW3Dialog = class(TElement)
  protected
    DialogBox : JW3Panel;
    CloseButton: JW3Button;
    procedure ArrangeElements;
  public
    constructor Create(parent: TElement); virtual;
    procedure OpenDialog(DialogMessage: String);
  end;

implementation

uses Globals;

{ JW3Dialog }

constructor JW3Dialog.Create(parent: TElement);
begin
  inherited Create('div', parent);
  self.SetProperty('display','none');
  self.SetProperty('background-color', 'rgb(0,0,0)');
  self.SetProperty('background-color', 'rgba(0,0,0,0.4)');
  self.handle.style.width  := '100%';
  self.handle.style.height := '100%';

  DialogBox := JW3Panel.Create(self);
  DialogBox.SetProperty('background-color', 'whitesmoke');
  DialogBox.SetProperty('margin', '10% 5% 0% 10%');
  DialogBox.SetProperty('border', '1px solid #888');
  DialogBox.SetProperty('width', '80%');
  DialogBox.SetProperty('height', '30%');

  CloseButton := JW3Button.Create(DialogBox);
  CloseButton.SetinnerHTML('x');
  CloseButton.SetAttribute('style', #'margin: 2px 2px;
    float: right; cursor: pointer;');

  CloseButton.OnClick := procedure(sender:TObject)
  begin
    self.SetProperty('display','none');
  end;
end;

procedure JW3Dialog.OpenDialog(DialogMessage: String);
begin
  ArrangeElements;
  // todo : set title
  self.SetProperty('display','inline-block');
end;

procedure JW3Dialog.ArrangeElements;
begin
  //move all children of self, except dialogbox, to dialogbox
  //so this component can be invoked as if it is a normal form
  var d := self.handle.children;
  var TempArray : Array of variant;
  for var i := 0 to d.length -1 do
    TempArray.Add(d[i]);

  var z := 0;
  for var j := 0 to TempArray.length -1 do
    If TempArray[j].id <> DialogBox.handle.id then begin  //omit DialogBox

      // set child.top at least to CloseButton.height so as not to obscure close button
      var x := strtoInt(StrBefore(TempArray[j].style.top,'px'));
      If x <= 30 then
        TempArray[j].style.top := inttostr(x+30) + 'px';

      // set height of dialogbox depending on lowest child-bottom
      var y := strtoInt(StrBefore(TempArray[j].style.top,'px')) +
               strtoInt(StrBefore(TempArray[j].style.height,'px'));
      If y > z then z := y;

      // move all elements (if any) from self to DialogBox
      DialogBox.handle.appendChild(TempArray[j]);
    end;

  If z > 0 then
    DialogBox.handle.style.height := inttostr(z) + 'px';
end;

end.
