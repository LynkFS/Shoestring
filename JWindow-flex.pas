unit JWindow; // Keep unit name as JWindow for now unless specified otherwise

interface

uses
  JElement-flex, JPanel, JButton, Types; // Updated JElement to JElement-flex

type
  JW3Window = class(TElement) // TElement will now refer to TElement from JElement-flex
  protected
    WindowArea : JW3Panel;
    HeaderPanel: JW3Panel;
    ContentPanel: JW3Panel;
    procedure ArrangeElements;
  public
    CloseButton: JW3Button;
    constructor Create(parent: TElement); virtual;
    procedure OpenWindow;
    procedure CloseWIndow;
  end;

implementation

uses Globals;

{ JW3Window }

constructor JW3Window.Create(parent: TElement);
begin
  inherited Create('div', parent);
  Self.SetProperty('display','none'); // Initially hidden
  Self.SetJustifyContent('center'); // Center WindowArea horizontally
  Self.SetAlignItems('center');     // Center WindowArea vertically
  Self.SetProperty('background-color', 'rgba(0,0,0,0.4)'); // Semi-transparent background
  Self.handle.style.width  := '100%'; // Full viewport width
  Self.handle.style.height := '100%'; // Full viewport height

  // WindowArea: The main visible panel of the window
  WindowArea := JW3Panel.Create(self);
  WindowArea.SetFlexDirection('column'); // Stack Header, Content vertically
  WindowArea.SetProperty('background-color', 'whitesmoke');
  WindowArea.SetProperty('margin', '10% 5% 5% 10%');
  WindowArea.SetProperty('border', '1px solid #888');
  WindowArea.SetProperty('width', '80%');
  WindowArea.SetProperty('height', '30%');

  // HeaderPanel: Contains the CloseButton, aligned to the right
  HeaderPanel := JW3Panel.Create(WindowArea);
  HeaderPanel.SetFlexDirection('row');
  HeaderPanel.SetJustifyContent('flex-end');
  HeaderPanel.SetCSS('width', '100%');

  CloseButton := JW3Button.Create(HeaderPanel);
  CloseButton.SetinnerHTML('x');
  CloseButton.SetCSS('margin', '2px');
  CloseButton.SetCSS('cursor', 'pointer');

  CloseButton.OnClick := procedure(sender:TObject)
  begin
    CloseWindow;
  end;

  // ContentPanel: Where the actual window content will reside
  ContentPanel := JW3Panel.Create(WindowArea);
  ContentPanel.SetFlexDirection('column');
  ContentPanel.SetFlexGrow(1);
  ContentPanel.SetCSS('width', '100%');
  ContentPanel.SetCSS('overflow', 'auto');
end;

procedure JW3Window.OpenWindow;
begin
  ArrangeElements;
  self.SetProperty('display','flex');
end;

procedure JW3Window.CloseWindow;
begin
  self.Destroy;
end;

procedure JW3Window.ArrangeElements;
var
  childNodes: JNodeList;
  childNode: JNode;
  i: Integer;
  nodesToMove: array of JNode; // Temporary array to hold nodes to be moved
begin
  // Get all direct children of Self.FElement
  childNodes := Self.FElement.childNodes;

  // First, collect all nodes that need to be moved.
  // Iterating and modifying the childNodes list directly can lead to issues.
  SetLength(nodesToMove, 0); // Initialize dynamic array
  for i := 0 to childNodes.length - 1 do
  begin
    childNode := childNodes.item(i);
    // Check if the child is not WindowArea.FElement
    if (childNode <> WindowArea.FElement) then
    begin
      nodesToMove.Add(childNode);
    end;
  end;

  // Now, move the collected nodes to ContentPanel
  for i := 0 to Length(nodesToMove) - 1 do
  begin
    ContentPanel.FElement.appendChild(nodesToMove[i]);
  end;
end;

end.
