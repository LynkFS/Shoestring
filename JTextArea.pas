unit JTextArea;

interface

uses
  JElement;

type
  JW3TextArea = class(TElement)
  public
    constructor Create(parent: TElement); virtual;
    property Text : string read GetInnerHtml write SetInnerHtml;
  end;

implementation

uses Globals;

{ JW3TextArea }

constructor JW3TextArea.Create(parent: TElement);
begin
  inherited Create('textarea', parent);
end;

end.
