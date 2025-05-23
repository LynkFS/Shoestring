unit JElement-flex; // Changed unit name

interface

uses Types, Globals;

type
  TMouseClickEvent   = procedure(sender:TObject);
  TResizeEvent       = procedure(sender:TObject);
  TReadyExecuteEvent = procedure(sender:TObject);

  TElement = class
  private
    procedure SetWidth(aWidth: integer);
    function  GetWidth: Integer;
    procedure SetHeight(aHeight: integer);
    function  GetHeight: Integer;

    FOnClick:  TMouseClickEvent;
    FOnResize: TResizeEvent;
    FOnReadyExecute: TReadyExecuteEvent;
    procedure _setMouseClick(const aValue: TMouseClickEvent);
    procedure _setOnResize(const aValue: TResizeEvent);
    procedure _setOnReadyExecute(const aValue: TReadyExecuteEvent);
  public
    FElement: JHTMLElement;
    handle: Variant;
    constructor Create(element: String; parent: TElement);
    destructor Destroy; override;

    Procedure SetProperty(S1: String; S2: String);
    Procedure SetAttribute(S1: String; S2: String);

    Procedure SetCSS(prop, value: String); overload;
    Procedure SetCSS(pseudo, prop, value: string); overload;
    Function  GetCSSVar(value: string) : String;

    Procedure SetBounds(awidth, aheight: integer);
    Procedure SetinnerHTML(S1: String);
    Function  GetinnerHTML : String;

    // Flex Container Properties
    procedure SetFlexDirection(ADirection: string);
    procedure SetJustifyContent(AJustify: string);
    procedure SetAlignItems(AAlign: string);
    procedure SetFlexWrap(AWrap: string);

    // Flex Item Properties
    procedure SetFlexGrow(AValue: integer);
    procedure SetFlexShrink(AValue: integer);
    procedure SetFlexBasis(AValue: string);
    procedure SetAlignSelf(AAlign: string);

    property  Width: Integer read getWidth write setWidth;
    property  Height: Integer read getHeight write setHeight;

    property  OnClick: TMouseClickEvent read FOnClick write _setMouseClick;
    procedure CBClick(eventObj: JEvent); virtual;

    property  OnReSize: TResizeEvent read FOnResize write _setOnResize;
    procedure CBResize(eventObj: JEvent); virtual;

    property  OnReadyExecute: TReadyExecuteEvent read FOnReadyExecute write _setOnReadyExecute;
    procedure CBReadyExecute(eventObj: JEvent); virtual;

    procedure Observe;
    procedure PropertyObserve;
    procedure Clear;

    procedure touch2Mouse(e: variant);

    tag, name: string;
    FParent: TElement;
end;

type
  TMutationObserver = class
  protected
    Constructor Create;virtual;
    procedure   CBMutationChange(mutationRecordsList:variant);virtual;
  public
    FHandle:    Variant;
end;

implementation

uses Globals; // Ensure Globals is here for IntToStr

{ TElement }

constructor TElement.Create(element: String; parent: TElement);
begin
  FElement := JHTMLElement(document.createElement(element));
  FElement.className := element;
  FElement.id := TW3Identifiers.GenerateUniqueObjectId();

  var FElementStyle := JElementCSSInlineStyle(FElement).style;
  FElementStyle.setProperty('visibility','visible');
  FElementStyle.setProperty('display','flex'); 
  FElementStyle.setProperty('overflow','auto');

  FParent := parent;

  If parent = nil
    then handle := document.body.appendChild(FElement)
    else begin
      handle := parent.FElement.appendChild(FElement);
    end;

  SetBounds(0,0); 

  FElement.addEventListener("click", @CBClick, false);
  window.addEventListener("resize", @CBResize, false);
  FElement.addEventListener("readyexecute", @CBReadyExecute, false);

  Observe;
end;

Procedure TElement.SetProperty(s1: String; S2: String);
begin
  var FElementStyle := JElementCSSInlineStyle(FElement).style;
  FElementStyle.setProperty(S1, S2);
end;

Procedure TElement.SetAttribute(S1: String; S2: String);
begin
  FElement.setAttribute(S1, S2);
end;

procedure TElement.SetCSS(prop, value: String);
begin
  var s0,s1 : string;
  s0 := '#' + FElement.id;
  s1 := prop + ': ' + value;
  styleSheet.insertRule(s0 + ' { ' + s1 +'}', 0);
end;

Procedure TElement.SetCSS(pseudo, prop, value: string);
begin
  var s0,s1 : string;
  s0 := '#' + FElement.id;
  s1 := prop + ': ' + value;
  styleSheet.insertRule(s0 + ':' + pseudo + ' { ' + s1 +' }', styleSheet.cssRules.length);
end;

Function TElement.GetCSSVar(value: string) : String;
begin
  Result :=
    window.getComputedStyle(document.documentElement).getPropertyValue(value);
end;

Procedure TElement.SetBounds(awidth, aheight: integer);
begin
  width  := awidth;
  height := aheight;
end;

Procedure TElement.SetinnerHTML(S1: String);
begin
  FElement.innerHTML := S1;
end;

Function TElement.GetinnerHTML : String;
begin
  Result := FElement.innerHTML;
end;

procedure TElement._setMouseClick(const aValue: TMouseClickEvent);
begin
  FOnClick := aValue;
end;

procedure TElement.CBClick(eventObj: JEvent);
begin
  eventObj.stopPropagation;
  if Assigned(FOnClick) then
    FOnClick(Self);
end;

procedure TElement._setOnResize(const aValue: TResizeEvent);
begin
  FOnResize := aValue;
end;

procedure TElement.CBResize(eventObj: JEvent);
begin
  if Assigned(FOnResize) then
    FOnResize(Self);
end;

procedure TElement._setOnReadyExecute(const aValue: TReadyExecuteEvent);
begin
  FOnReadyExecute := aValue;
end;

procedure TElement.CBReadyExecute(eventObj: JEvent);
begin
  if Assigned(FOnReadyExecute) then
    FOnReadyExecute(Self);
end;

{ Flex Container Methods }

procedure TElement.SetFlexDirection(ADirection: string);
begin
  Self.SetProperty('flex-direction', ADirection);
end;

procedure TElement.SetJustifyContent(AJustify: string);
begin
  Self.SetProperty('justify-content', AJustify);
end;

procedure TElement.SetAlignItems(AAlign: string);
begin
  Self.SetProperty('align-items', AAlign);
end;

procedure TElement.SetFlexWrap(AWrap: string);
begin
  Self.SetProperty('flex-wrap', AWrap);
end;

{ Flex Item Methods }

procedure TElement.SetFlexGrow(AValue: integer);
begin
  Self.SetProperty('flex-grow', IntToStr(AValue));
end;

procedure TElement.SetFlexShrink(AValue: integer);
begin
  Self.SetProperty('flex-shrink', IntToStr(AValue));
end;

procedure TElement.SetFlexBasis(AValue: string);
begin
  Self.SetProperty('flex-basis', AValue);
end;

procedure TElement.SetAlignSelf(AAlign: string);
begin
  Self.SetProperty('align-self', AAlign);
end;

procedure TElement.SetWidth(aWidth: Integer);
begin
  var FElementStyle := JElementCSSInlineStyle(FElement).style;
  if aWidth = screenwidth
    then FElementStyle.setProperty('width','calc(100%)')
    else FElementStyle.setProperty('width',inttostr(aWidth)+'px');
end;

function  TElement.GetWidth: Integer;
begin
  var FElementStyle := JElementCSSInlineStyle(FElement).style;
  var S : string := FElementStyle.getPropertyValue('width');
  if StrEndsWith(S,'px') then SetLength(S, S.Length-2);
  Result := StrToIntDef(S,0); 
end;

procedure TElement.SetHeight(aHeight: Integer);
begin
  var FElementStyle := JElementCSSInlineStyle(FElement).style;
  FElementStyle.setProperty('height',inttostr(aHeight)+'px');
end;

function  TElement.GetHeight: Integer;
begin
  var FElementStyle := JElementCSSInlineStyle(FElement).style;
  var S : string := FElementStyle.getPropertyValue('height');
  if StrEndsWith(S,'px') then SetLength(S, S.Length-2);
  Result := StrToIntDef(S,0); 
end;

procedure TElement.Clear;
begin
  While assigned(FElement.firstChild) do
    FElement.removeChild(FElement.firstChild);
end;

destructor TElement.Destroy;
begin
  If assigned(FElement.parentNode) then
    Felement.parentNode.removeChild(Felement);
end;

procedure TElement.touch2Mouse(e: variant);
begin
  var theTouch := e.changedTouches[0];
  var mouseEv : variant;

  case e.type of
    "touchstart": mouseEv := "mousedown";
    "touchend":   mouseEv := "mouseup";
    "touchmove":  mouseEv := "mousemove";
    else exit;
  end;

  var mouseEvent := document.createEvent("MouseEvent");
  mouseEvent.initMouseEvent(mouseEv, true, true, window, 1, theTouch.screenX, theTouch.screenY, theTouch.clientX, theTouch.clientY, false, false, false, false, 0, null);
  theTouch.target.dispatchEvent(mouseEvent);

  e.preventDefault();
end;

procedure TElement.PropertyObserve;
begin
  var options : JMutationObserverInit;
  asm @options = Object.create(@options); end;
  options.attributes := true;
  options.attributeOldValue := true;

  var callback : JMutationCallback := procedure(mutations: array of JMutationRecord; observer: JMutationObserver)
  begin
    DisPatchEvent('PropertyChange',handle.id,'click',nil);
  end;

  var MyObserver : JMutationObserver;
  asm @MyObserver = Object.create(@MyObserver); end;
  MyObserver := JMutationObserver.Create(callback);

  MyObserver.observe(self.FElement, options);
end;

procedure TElement.Observe;
begin
  var MyObserver := TMutationObserver.Create;
  var v: variant := new JObject;
  v.attributes := true;
  v.attributeOldValue := true;
  MyObserver.FHandle.observe(handle, v);
end;

{ TMutationObserver }

Constructor TMutationObserver.Create;
var
  mRef: procedure (data:Variant);
  mhandle:  variant;
begin
  inherited Create;
  mRef:=@CBMutationChange;
  asm
    @mHandle = new MutationObserver(function (_a_d) {@mRef(_a_d);});
  end;
  Fhandle:=mHandle;
end;

procedure TMutationObserver.CBMutationChange(mutationRecordsList:variant);
var
  LEvent: Variant;
begin
  FHandle.disconnect();
  asm @LEvent = new Event('readyexecute'); end;
  mutationRecordsList[length(mutationRecordsList)-1].target.dispatchEvent(LEvent);
end;

initialization
  ScreenWidth := Window.innerWidth;
  ScreenHeight := Window.innerHeight;
end.
