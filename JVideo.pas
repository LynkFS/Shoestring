unit JVideo;

interface

uses
  JElement;

type
  JW3Video = class(TElement)
  public
    constructor Create(parent: TElement); virtual;
  end;

implementation

{ JW3Video }

constructor JW3Video.Create(parent: TElement);
begin
  inherited Create('video', parent);
end;

end.
