unit JApplication;

interface

uses
  JElement, JForm;

type
  JW3Application = class(TElement)
  public
    FormNames: Array of String;
    FormsClasses: Array of TFormClass;       //TFormClass = class of JW3Form;
    FormsInstances: Array of TW3Form;
    constructor Create(parent: TElement); virtual;
    procedure CreateForm(FormName: String; aClassType: TFormClass);
    procedure GoToForm(FormName: String);
  end;

implementation

uses Globals;

{ JW3Application }

constructor JW3Application.Create(parent: TElement);
begin
  inherited Create('div', parent);

  setProperty('width','100%');
  setProperty('height','100%');
  setProperty('background-color','white');

end;

procedure JW3Application.CreateForm(FormName: String; aClassType: TFormClass);
begin
//
  FormNames.Add(FormName);
  FormsClasses.Add(aClassType);
  FormsInstances.Add(nil);
//
end;

procedure JW3Application.GoToForm(FormName: String);
begin
//
  For var i := 0 to FormNames.Count -1 do begin

    If FormsInstances[i] <> nil then
      FormsInstances[i].SetProperty('display','none');

    If FormNames[i] = FormName then begin
      If FormsInstances[i] = nil       //form has never been displayed yet
        then FormsInstances[i] := FormsClasses[i].Create(self)
        else FormsInstances[i].SetProperty('display','inline-block');

      (FormsInstances[i] as FormsClasses[i]).InitializeForm;    //ClearForm;
      (FormsInstances[i] as FormsClasses[i]).InitializeObject;  //ShowForm;
    end;
  end;
end;

end.

///////////////////////////////////////////////////////////////////////////

unit JApplication;

interface

uses
  JElement, JForm;

type
  JW3Application = class(TElement)
  public
    FormNames: Array of String;
    FormsClasses: Array of TFormClass;       //TFormClass = class of JW3Form;
    FormsInstances: Array of TW3Form;
    constructor Create(parent: TElement); virtual;
    procedure CreateForm(FormName: String; aClassType: TFormClass);
    procedure GoToForm(FormName: String);
    prevAnim, nextAnim : array of variant;
    currentForm : integer := -1;
  end;

implementation

uses Globals;

{ JW3Application }

constructor JW3Application.Create(parent: TElement);
begin
  inherited Create('div', parent);

  setProperty('width','100%');
  setProperty('height','100%');
  setProperty('background-color','white');

  prevAnim := [
    class transform = 'translateX(0%)'; easing = 'ease-in-out'; end,
    class transform = 'translateX(-100%)'; end ];

  nextAnim := [
    class transform = 'translateX(100%)'; easing = 'ease-in-out'; end,
    class transform = 'translateX(0%)'; end ];

end;

procedure JW3Application.CreateForm(FormName: String; aClassType: TFormClass);
begin
//
  FormNames.Add(FormName);
  FormsClasses.Add(aClassType);
  FormsInstances.Add(nil);
//
end;

procedure JW3Application.GoToForm(FormName: String);
begin
//
  //check all forms
  For var i := 0 to FormNames.Count -1 do begin

    //hide all created forms except for the current one
    If FormsInstances[i] <> nil then
      If i <> currentForm then
        FormsInstances[i].SetProperty('display','none');

    //found new form : either create it or unhide it
    If FormNames[i] = FormName then begin
      If FormsInstances[i] = nil       //form has never been displayed yet
        then FormsInstances[i] := FormsClasses[i].Create(self)
        else FormsInstances[i].SetProperty('display','inline-block');

      //if there is an active form, which is different from the new form
      //then slide the active form to the left and eventually hide it
      If currentForm <> -1 then
      begin
        If i <> currentForm then
        begin
          var Anim1 := FormsInstances[currentForm].handle.animate(prevAnim, 600);
          Anim1.onfinish := lambda
            if FormNames[currentForm] <> FormName then
              FormsInstances[currentForm].SetProperty('display','none');
          end;
        end;
      end;

      //if the new form is not the same as the current form
      //then slide the new form in from the right and update currentForm
      If i <> currentForm then
      begin
        var Anim2 := FormsInstances[i].handle.animate(nextAnim, 600);
        Anim2.onfinish := lambda
          For var j := 0 to FormNames.Count -1 do begin
            If FormNames[j] = FormName then
              currentForm := j;
          end;
        end;
      end;

      //execute the 2 initprocs of the new form
      (FormsInstances[i] as FormsClasses[i]).InitializeForm;    //ClearForm;
      (FormsInstances[i] as FormsClasses[i]).InitializeObject;  //ShowForm;
    end;
  end;
end;

end.
