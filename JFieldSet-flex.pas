unit JFieldSet; // Keep unit name as JFieldSet for now unless specified otherwise

interface

uses
  JElement-flex; // Updated JElement to JElement-flex

type
  JW3FieldSet = class(TElement) // TElement will now refer to TElement from JElement-flex
  private 
    fTitle : String; 
  public
    constructor Create(parent: TElement); virtual;
    property Legend : String read fTitle write fTitle; 
    Title : TElement; 
  end;

implementation

uses Globals;

{ JW3FieldSet }

constructor JW3FieldSet.Create(parent: TElement);
begin
  inherited Create('fieldset', parent);
  SetProperty('border','1px solid silver'); 

  Self.SetFlexDirection('column');    
  Self.SetAlignItems('stretch');      
  Self.SetCSS('padding', '10px');     
  Self.SetCSS('margin-bottom', '10px'); 

  self.OnReadyExecute := procedure(sender: TObject)
  begin
    If self.Legend <> '' then 
    begin
      if not Assigned(Title) then 
      begin
        Title := TElement.Create('legend',self); 
      end;
      Title.handle.innerHTML := self.Legend; 
    end;
  end;
end;

end.
