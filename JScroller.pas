unit JScroller;

interface

uses
  JElement, JPanel;

type
  JW3Scroller = class(TElement)
  public
    constructor Create(parent: TElement); virtual;
    Container: JW3Panel;
  end;

implementation

uses
  Globals;

{ JW3Scroller }

constructor JW3Scroller.Create(parent: TElement);
begin
  inherited Create('div', parent);
  Container := JW3Panel.Create(self);

  //self.Observe;
  self.OnReadyExecute := procedure(sender: TObject)
  begin
    self.height :=self.height + GetSBWidth;         //expand by scrollbarheight (function in globals)
    Container.SetBounds(0,0,self.width,self.height);
  end;

end;


end.