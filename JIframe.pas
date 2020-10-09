unit JIframe;

interface

uses
  JElement;

type
  JW3IFrame = class(TElement)
  public
    constructor Create(parent: TElement); virtual;
  end;

implementation

{ JW3IFrame }

constructor JW3IFrame.Create(parent: TElement);
begin
  inherited Create('iframe', parent);

  SetProperty('frameBorder','0px');
  SetProperty('border-radius','.25em');
  SetProperty('box-shadow',#'0 2px 2px 0 rgba(0, 0, 0, 0.14),
                             0 1px 5px 0 rgba(0, 0, 0, 0.12),
                             0 3px 1px -2px rgba(0, 0, 0, 0.2)');

end;

end.
