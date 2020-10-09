unit JAnchor;


interface

uses
  JElement, JImage;

type
  JW3Anchor = partial class(TElement)
  public
    constructor Create(parent: TElement); virtual;
    placeholder: JW3Image;
  end;

implementation

{ JW3Anchor }

constructor JW3Anchor.Create(parent: TElement);
begin
  inherited Create('a', parent);
  placeholder := JW3Image.Create(self);
end;

end.
