unit JButton;

interface

uses
  JElement;

type
  JW3Button = class(TElement)
  public
    constructor Create(parent: TElement); virtual;
    property Caption : string read GetInnerHtml write SetInnerHtml;
  end;

implementation

uses Globals;

{ JW3Button }

constructor JW3Button.Create(parent: TElement);
begin
  inherited Create('button', parent);
  SetProperty('color','white');
  SetProperty('border','0px');
  SetProperty('border-radius', '4px');
  SetProperty('cursor','pointer');
  SetProperty('box-shadow',#'0 -1px 1px 0 rgba(0, 0, 0, 0.25) inset,
                             0  1px 1px 0 rgba(0, 0, 0, 0.10) inset;)');

  //SetCss('background-color' , '#0099FF');             //'#699BCE'
  //SetCss('hover', 'background-color' , '#0077FF');

  SetCss(          'background-color' , getCSSVar('--button-colorbase'));
  SetCss('hover',  'background-color' , getCSSVar('--button-colorhover'));
  SetCss('active', 'background-color' , getCSSVar('--button-coloractive'));
  SetCss('focus',  'outline' ,          getCSSVar('--button-borderfocus'));

end;

end.

////////////////////

get a handle to a stylesheet, or create one on the fly

      //stylesheet
      var style := browserapi.document.createElement("STYLE");
      browserapi.document.head.appendChild(style);
      var styleSheet := style.sheet;

set a css variable ("--variable-width") and insert into the stylesheet
css variable names can be any string but have to start with --

      //set initial css variable (width)
      var s1 := #'
      :root {
        --variable-width: 500px;
      }';
      styleSheet.insertRule(s1, 0);


retrieve and display css width variable

          browserapi.window.alert(
            browserapi.window.getComputedStyle(browserapi.document.documentElement)
            .getPropertyValue('--variable-width'));

set css variable to some value

          browserapi.document.documentElement.style['--variable-width'] :=
            Memo1.handle.getBoundingClientRect().width;

use this variable in a 'calc'ulation

          Memo1.handle.style['height'] := 'calc(var(--variable-width) * 0.6)';