unit JStreetView;

interface

uses
  JElement, JIframe;

type
  JW3StreetView = class(TElement)
  public
    constructor Create(parent: TElement); virtual;
    procedure SetLocation(s1,s2,s3: String);    //(lat/long/api)
    ifr : JW3IFrame;
  end;

implementation

{ JW3StreetView }

constructor JW3StreetView.Create(parent: TElement);
begin
  inherited Create('div', parent);
  ifr := JW3Iframe.Create(self);
end;

Procedure JW3StreetView.SetLocation(s1,s2,s3: String);
begin
  var s : string := 'https://www.google.com/maps/embed/v1/streetview?location=' +
                    s1 + ',' + s2 + '&key=' + s3;
//                    'AIzaSyCWiDqHr-ME74FlTd40x2yoLgVA6Qod-Tk';

  ifr.SetAttribute('src',s);
  ifr.SetProperty('width',inttostr(width-60)+'px');
  ifr.SetProperty('height',inttostr(height-60)+'px');
end;

end.
