unit Form1;

interface

uses JElement, JForm, JListBox, JPanel, JButton, JProgress, JImage, JToolBar,
     JSelect, JTextArea, JVideo, JLoader, JGrid, JCanvas, JTreeView,
     JCheckBox, JRadioButton, JFieldSet, JSpinner, JIframe, JInput,
     JSplitter, JTabControl, JDBGrid, JScroller,
     JToggle, JWindow;

type

  TComponentRec = class
    name : string;
    ShowIt : procedure;
  end;

  TForm1 = class(TW3Form)
  protected
    procedure InitializeForm; override;
    procedure InitializeObject; override;
    procedure Resize; override;
    ToolBar : JW3ToolBar;
    ListBox1, ListBox2 : JW3ListBox;
    Components : Array of TComponentRec;
    DisplayDiv : JW3Panel;
    ComponentRec: TComponentRec;
  end;


implementation

uses Globals;

{ TForm1 }

procedure TForm1.InitializeForm;
begin
  inherited;
  // this is a good place to initialize components
end;

procedure TForm1.InitializeObject;
begin
  inherited;

//  PulltoRefreshAllowed := false;

//Init Logo
  var Image0 := JW3Image.Create(self);
  Image0.SetBounds(0, 0, 194, 45);
  Image0.setAttribute('src','images/logo.png');

//Init ToolBar
  ToolBar := JW3ToolBar.Create(self);
  ToolBar.SetBounds(0, 45, 0, 40);
  ToolBar.setProperty('min-width','100%');
  ToolBar.setProperty('background-color', '#699BCE');
  ToolBar.AddMenu('Components','Form1','white');
  ToolBar.AddMenu('Projects','Form2','white');
  ToolBar.SetActiveMenu('Form1');

//create kitchen sink components and add to Component array
  Components.Clear;
  DisplayDiv := JW3Panel.Create(self);
  DisplayDiv.SetBounds(20, 350, 0, 0);

//JButton
  ComponentRec := TComponentRec.Create;
  ComponentRec.Name := 'JButton';
  ComponentRec.ShowIt := procedure begin
    {--------------------------------------------------------------------------}
    { Component  JW3Button                                                     }
    { Updated:   01/09/2017                                                    }
    {--------------------------------------------------------------------------}
    var Button1 := JW3Button.Create(DisplayDiv);
    Button1.SetBounds(0, 0, 100, 50);
    Button1.Caption := 'Button';
    Button1.OnClick := procedure(sender:TObject) begin window.alert('clicked'); end;
  end;
  Components.Add(ComponentRec);

//JCanvas
  ComponentRec := TComponentRec.Create;
  ComponentRec.Name := 'JCanvas';
  ComponentRec.ShowIt := procedure begin
    {--------------------------------------------------------------------------}
    { Component  JW3Canvas                                                     }
    { Updated:   01/09/2017                                                    }
    {--------------------------------------------------------------------------}
    var Canvas1 := JW3Canvas.Create(DisplayDiv);
    Canvas1.SetBounds(0, 0, 400, 200);

    // Quadratric curves on 2d-context (ctx)
    Canvas1.ctx.beginPath();
    Canvas1.ctx.moveTo(75, 25);
    Canvas1.ctx.quadraticCurveTo(25, 25, 25, 62.5);
    Canvas1.ctx.quadraticCurveTo(25, 100, 50, 100);
    Canvas1.ctx.quadraticCurveTo(50, 120, 30, 125);
    Canvas1.ctx.quadraticCurveTo(60, 120, 65, 100);
    Canvas1.ctx.quadraticCurveTo(125, 100, 125, 62.5);
    Canvas1.ctx.quadraticCurveTo(125, 25, 75, 25);
    Canvas1.ctx.stroke();
  end;
  Components.Add(ComponentRec);

//JCheckBox single
  ComponentRec := TComponentRec.Create;
  ComponentRec.Name := 'JCheckBox (single)';
  ComponentRec.ShowIt := procedure begin
    {--------------------------------------------------------------------------}
    { Component  JW3CheckBox                                                   }
    { Updated:   01/09/2017                                                    }
    {--------------------------------------------------------------------------}
    var CheckBox1 := JW3CheckBox.Create(DisplayDiv);
    CheckBox1.SetBounds(0, 0, 200, 200);

    CheckBox1.Label := 'First and only checkbox';
    CheckBox1.Checked := true;

    CheckBox1.CheckBoxDimension := 20;      //default

  end;
  Components.Add(ComponentRec);

//JCheckBox multiple
  ComponentRec := TComponentRec.Create;
  ComponentRec.Name := 'JCheckBox (multiple)';
  ComponentRec.ShowIt := procedure begin
    {--------------------------------------------------------------------------}
    { Component  JW3CheckBox                                                   }
    { Updated:   01/09/2017                                                    }
    {--------------------------------------------------------------------------}
    var FieldSet := JW3FieldSet.Create(DisplayDiv);
    FieldSet.SetBounds(0, 0, 200, 180);
    FieldSet.Legend := 'Legend';

    //no need for CheckBoxes.SetBounds()
    var CheckBox1 := JW3CheckBox.Create(FieldSet);
    CheckBox1.Label := 'First checkbox';
    CheckBox1.Checked := true;

    var CheckBox2 := JW3CheckBox.Create(FieldSet);
    CheckBox2.Label := 'Second checkbox';
    CheckBox2.Checked := false;

    var CheckBox3 := JW3CheckBox.Create(FieldSet);
    CheckBox3.Label := 'Third checkbox';
    CheckBox3.Checked := true;

  end;
  Components.Add(ComponentRec);

//JDBGrid
  ComponentRec := TComponentRec.Create;
  ComponentRec.Name := 'JDBGrid';
  ComponentRec.ShowIt := procedure begin
    {--------------------------------------------------------------------------}
    { Component  JW3DB                                                         }
    { Updated:   01/09/2017                                                    }
    {--------------------------------------------------------------------------}
    var Window1 := JW3Window.Create(self); //or application, or nil

    var MyButton := JW3Button.Create(DisplayDiv);

    MyButton.SetBounds(0,0,150,40);
    MyButton.Caption := 'Open DBGrid';
    MyButton.OnClick := procedure(sender:TObject)
    begin
      var DBGrid1 := JW3DBGrid.Create(Window1);
      DBGrid1.SetBounds(50, 0, 835, 400);
      DBGrid1.Server := 'https://www.lynkit.com.au/native/kitchensink/qtxdbmysql.php';
      DBGrid1.Query    := #'
        Select
           Species_No   as "ID",
           Category     as "Category",
           Common_Name  as "Common name",
           Species_Name as "Species name",
           Notes        as "Note"
        from FishFacts';
      DBGrid1.RowHeight := 40;           //optional, default = 14
      DBGrid1.ColumnWidths[5] := 300;    //optional, overrides auto sizing for 5th column
      Window1.OpenWindow;
    end;
  end;
  Components.Add(ComponentRec);

//JGrid
  ComponentRec := TComponentRec.Create;
  ComponentRec.Name := 'JGrid';
  ComponentRec.ShowIt := procedure begin
    {--------------------------------------------------------------------------}
    { Component  JW3Grid (listbox based)                                       }
    { Updated:   01/09/2017                                                    }
    {--------------------------------------------------------------------------}
    var Grid1 := JW3Grid.Create(DisplayDiv);
    Grid1.SetBounds(0, 0, 330, 250);

    Grid1.CanResize := true;          //adds column resizing

//  use case : make a grid with 3 columns and 300 rows.
//  Columns 1 and 3 contain text and column 2 contains an image.
//  Different widths and heights as well

    Grid1.AddColumn('Col 1',74);      //title, width
    Grid1.AddColumn('Col 2',134);
    Grid1.AddColumn('Col 3',84);


//  Grid1.AddCell(row, column, content)
    for var row := 1 to 300 do begin
      For var column := 1 to 3 do begin
        var S: String := 'Cell ' + inttostr(row) + '-' + inttostr(column);

        case column of
          1,3 :
            begin
              var Cell := JW3Panel.Create(Grid1);
              Cell.Text := S;
              Cell.Height := 24;
              Cell.SetProperty('font-size', '0.85em');
              Cell.tag := S;
              Cell.OnClick := procedure(sender: TObject) begin window.alert((sender as TElement).tag); end;
              Grid1.AddCell(row,column,Cell);
            end;
          2: begin
              var Cell := JW3Image.Create(Grid1);
              Cell.setAttribute('src','images/logo.png');
              Cell.Height := 45;
              Cell.tag := S;
              Cell.OnClick := procedure(sender: TObject) begin window.alert((sender as TElement).tag); end;
              Grid1.AddCell(row,column,Cell);
             end;
        end;

      end;
    end;
  end;
  Components.Add(ComponentRec);

//JIFrame
  ComponentRec := TComponentRec.Create;
  ComponentRec.Name := 'JIFrame';
  ComponentRec.ShowIt := procedure begin
    {--------------------------------------------------------------------------}
    { Component  JW3IFrame                                                     }
    { Updated:   01/09/2017                                                    }
    {--------------------------------------------------------------------------}
    var IFrame1 := JW3IFrame.Create(DisplayDiv);
    IFrame1.SetBounds(0, 0, 650, 500);
    IFrame1.setAttribute('src','https://jonlennartaasenden.wordpress.com/news/');
  end;
  Components.Add(ComponentRec);

//JImage
  ComponentRec := TComponentRec.Create;
  ComponentRec.Name := 'JImage';
  ComponentRec.ShowIt := procedure begin
    {--------------------------------------------------------------------------}
    { Component  JW3Image                                                      }
    { Updated:   01/09/2017                                                    }
    {--------------------------------------------------------------------------}
    var Image1 := JW3Image.Create(DisplayDiv);
    Image1.SetBounds(0, 0, 194, 45);
    Image1.setAttribute('src','images/logo.png');
  end;
  Components.Add(ComponentRec);

//
  var Colours : Array of String;
  Colours.Clear;
  Colours.Add('White');
  Colours.Add('AliceBlue');
  Colours.Add('AntiqueWhite');
  Colours.Add('Aqua');
  Colours.Add('Aquamarine');
  Colours.Add('Azure');
  Colours.Add('Beige');
  Colours.Add('Bisque');
  Colours.Add('Black');
  Colours.Add('BlanchedAlmond');
  Colours.Add('Blue');
  Colours.Add('BlueViolet');
  Colours.Add('Brown');
  Colours.Add('BurlyWood');
  Colours.Add('CadetBlue');
  Colours.Add('Chartreuse');
  Colours.Add('Chocolate');
  Colours.Add('Coral');
  Colours.Add('CornflowerBlue');
  Colours.Add('Cornsilk');
  Colours.Add('Crimson');
  Colours.Add('Cyan');
  Colours.Add('DarkBlue');
  Colours.Add('DarkCyan');
  Colours.Add('DarkGoldenRod');
  Colours.Add('DarkGray');
  Colours.Add('DarkGrey');
  Colours.Add('DarkGreen');
  Colours.Add('DarkKhaki');
  Colours.Add('DarkMagenta');
  Colours.Add('DarkOliveGreen');
  Colours.Add('Darkorange');
  Colours.Add('DarkOrchid');
  Colours.Add('DarkRed');
  Colours.Add('DarkSalmon');
  Colours.Add('DarkSeaGreen');
  Colours.Add('DarkSlateBlue');
  Colours.Add('DarkSlateGray');
  Colours.Add('DarkSlateGrey');
  Colours.Add('DarkTurquoise');
  Colours.Add('DarkViolet');
  Colours.Add('DeepPink');
  Colours.Add('DeepSkyBlue');
  Colours.Add('DimGray');
  Colours.Add('DimGrey');
  Colours.Add('DodgerBlue');
  Colours.Add('FireBrick');
  Colours.Add('FloralWhite');
  Colours.Add('ForestGreen');
  Colours.Add('Fuchsia');
  Colours.Add('Gainsboro');
  Colours.Add('GhostWhite');
  Colours.Add('Gold');
  Colours.Add('GoldenRod');
  Colours.Add('Gray');
  Colours.Add('Grey');
  Colours.Add('Green');
  Colours.Add('GreenYellow');
  Colours.Add('HoneyDew');
  Colours.Add('HotPink');
  Colours.Add('IndianRed');
  Colours.Add('Indigo');
  Colours.Add('Ivory');
  Colours.Add('Khaki');
  Colours.Add('Lavender');
  Colours.Add('LavenderBlush');
  Colours.Add('LawnGreen');
  Colours.Add('LemonChiffon');
  Colours.Add('LightBlue');
  Colours.Add('LightCoral');
  Colours.Add('LightCyan');
  Colours.Add('LightGoldenRodYellow');
  Colours.Add('LightGray');
  Colours.Add('LightGrey');
  Colours.Add('LightGreen');
  Colours.Add('LightPink');
  Colours.Add('LightSalmon');
  Colours.Add('LightSeaGreen');
  Colours.Add('LightSkyBlue');
  Colours.Add('LightSlateGray');
  Colours.Add('LightSlateGrey');
  Colours.Add('LightSteelBlue');
  Colours.Add('LightYellow');
  Colours.Add('Lime');
  Colours.Add('LimeGreen');
  Colours.Add('Linen');
  Colours.Add('Magenta');
  Colours.Add('Maroon');
  Colours.Add('MediumAquaMarine');
  Colours.Add('MediumBlue');
  Colours.Add('MediumOrchid');
  Colours.Add('MediumPurple');
  Colours.Add('MediumSeaGreen');
  Colours.Add('MediumSlateBlue');
  Colours.Add('MediumSpringGreen');
  Colours.Add('MediumTurquoise');
  Colours.Add('MediumVioletRed');
  Colours.Add('MidnightBlue');
  Colours.Add('MintCream');
  Colours.Add('MistyRose');
  Colours.Add('Moccasin');
  Colours.Add('NavajoWhite');
  Colours.Add('Navy');
  Colours.Add('OldLace');
  Colours.Add('Olive');
  Colours.Add('OliveDrab');
  Colours.Add('Orange');
  Colours.Add('OrangeRed');
  Colours.Add('Orchid');
  Colours.Add('PaleGoldenRod');
  Colours.Add('PaleGreen');
  Colours.Add('PaleTurquoise');
  Colours.Add('PaleVioletRed');
  Colours.Add('PapayaWhip');
  Colours.Add('PeachPuff');
  Colours.Add('Peru');
  Colours.Add('Pink');
  Colours.Add('Plum');
  Colours.Add('PowderBlue');
  Colours.Add('Purple');
  Colours.Add('Red');
  Colours.Add('RosyBrown');
  Colours.Add('RoyalBlue');
  Colours.Add('SaddleBrown');
  Colours.Add('Salmon');
  Colours.Add('SandyBrown');
  Colours.Add('SeaGreen');
  Colours.Add('SeaShell');
  Colours.Add('Sienna');
  Colours.Add('Silver');
  Colours.Add('SkyBlue');
  Colours.Add('SlateBlue');
  Colours.Add('SlateGray');
  Colours.Add('SlateGrey');
  Colours.Add('Snow');
  Colours.Add('SpringGreen');
  Colours.Add('SteelBlue');
  Colours.Add('Tan');
  Colours.Add('Teal');
  Colours.Add('Thistle');
  Colours.Add('Tomato');
  Colours.Add('Turquoise');
  Colours.Add('Violet');
  Colours.Add('Wheat');
  Colours.Add('WhiteSmoke');
  Colours.Add('Yellow');
  Colours.Add('YellowGreen');

//JListBox - Objects
  ComponentRec := TComponentRec.Create;
  ComponentRec.Name := 'JListBox - ObjectList';
  ComponentRec.ShowIt := procedure begin
    {--------------------------------------------------------------------------}
    { Component  JW3ListBox                                                    }
    { Updated:   01/09/2017                                                    }
    {--------------------------------------------------------------------------}
    ListBox1 := JW3ListBox.Create(DisplayDiv);
    ListBox1.SetBounds(0, 0, 200, 1000);
    ListBox1.setProperty('background-color', 'white');
    ListBox1.SetProperty('border','2px double whitesmoke');
    //ListBox1.RowHeight := 25;
    //ListBox1.Editable := true;

    var Canvas := JW3Canvas.Create(ListBox1);
    //temporary invisible canvas element to convert colour-names to colour-hex codes
    //setting fillStyle acceps colour name      : Cvs.ctx.fillStyle := 'teal';
    //reading fillStyle gives result in hex     : console.log(Cvs.ctx.fillStyle) : #008080
    //perfect for converting colour names to hex code
    //see function below to find the relative brightness of a colour (hex-code)

    //http://www.nbdtech.com/Blog/archive/2008/04/27/Calculating-the-Perceived-Brightness-of-a-Color.aspx
    //https://forums.smartmobilestudio.com/topic/4717-parseint-question/?tab=comments#comment-23477
    function computeBrightness(color: Variant): Float;
    var R, G, B: Integer;
    begin
      function parseInt(s: Variant{String}; radix: integer = 0): integer; external "parseInt";
      if(color.length=7) then color := color.substring(1);
      R := parseInt(color.substring(0,2), 16);
      G := parseInt(color.substring(2,4), 16);
      B := parseInt(color.substring(4,6), 16);
      Result := sqrt(R * R * 0.241 + G * G * 0.691 + B * B * 0.068);
    end;

    function Brightness(colour: String): Float;
    begin
      Result := computeBrightness(colour);
    end;

    For var i := 0 to Colours.Count -1 do begin
      var Item := JW3Input.Create(ListBox1);          //or JW3Panel or ...
      Item.setProperty('border', '1px solid silver');
      Item.setProperty('background-color', Colours[i]);
      Item.Text := Colours[i];
      Item.Tag  := Colours[i];

      //calculate brightness and set text colour accordingly
      Canvas.ctx.fillStyle := Colours[i];
      if Brightness(Canvas.ctx.fillStyle) < 150   //130   //170
        then Item.setProperty('color', 'white')
        else Item.setProperty('color', 'black');

      //Item.Text := Item.Text + ' ' + floattostr(Brightness(Canvas.ctx.fillStyle));

      Item.OnClick := lambda(Sender:TObject) window.alert((Sender as TElement).tag); end;
      //either set Item.height (specific per Item) or set ListBox.RowHeight (for all Items)
      Item.Height := 25;
      ListBox1.Add(Item);
    end;

  end;
  Components.Add(ComponentRec);

//JListBox - strings
  ComponentRec := TComponentRec.Create;
  ComponentRec.Name := 'JListBox - StringList';
  ComponentRec.ShowIt := procedure begin
    {--------------------------------------------------------------------------}
    { Component  JW3ListBox                                                    }
    { Updated:   01/09/2017                                                    }
    {--------------------------------------------------------------------------}
    ListBox2 := JW3ListBox.Create(DisplayDiv);
    ListBox2.SetBounds(0, 0, 200, 1000);
    ListBox2.setProperty('background-color', 'white');
    ListBox2.SetProperty('border','2px double whitesmoke');
    ListBox2.RowHeight := 25;
    ListBox2.Editable := true;

    For var i := 0 to Colours.Count -1 do begin
      ListBox2.Add(Colours[i]);
    end;
  end;
  Components.Add(ComponentRec);

//JLoader
  ComponentRec := TComponentRec.Create;
  ComponentRec.Name := 'JLoader';
  ComponentRec.ShowIt := procedure begin
    {--------------------------------------------------------------------------}
    { Component  JW3Loader (spinner)                                           }
    { Updated:   01/09/2017                                                    }
    {--------------------------------------------------------------------------}
    var Loader1 := JW3Loader.Create(DisplayDiv);
    Loader1.SetBounds(0, 0, 60, 60);
  end;
  Components.Add(ComponentRec);

//JPanel
  ComponentRec := TComponentRec.Create;
  ComponentRec.Name := 'JPanel';
  ComponentRec.ShowIt := procedure begin
    {--------------------------------------------------------------------------}
    { Component  JW3Panel                                                      }
    { Updated:   01/09/2017                                                    }
    {--------------------------------------------------------------------------}
    var Panel1 := JW3Panel.Create(DisplayDiv);
    Panel1.SetBounds(0, 0, 100, 100);
    Panel1.setProperty('background-color', 'gold');
    Panel1.SetProperty('border','1px double silver');
  end;
  Components.Add(ComponentRec);

//JProgress
  ComponentRec := TComponentRec.Create;
  ComponentRec.Name := 'JProgress';
  ComponentRec.ShowIt := procedure begin
    {------------------------------------------------------------------------------}
    { Component  JW3Progress                                                       }
    { Updated:   01/09/2017                                                        }
    {------------------------------------------------------------------------------}
    var Progress1 := JW3Progress.Create(DisplayDiv);
    Progress1.SetBounds(0, 0, 300, 12);
    Progress1.setProperty('background-color', 'lightgrey');
    Progress1.ProgressBar.setProperty('background-color', 'salmon');
    Progress1.Perc := 25;
    window.setInterval(lambda
      Progress1.Perc := Progress1.Perc + 1;
      If Progress1.Perc > 100 then window.clearInterval();
    end, 30);
  end;
  Components.Add(ComponentRec);

//JRadioButton
  ComponentRec := TComponentRec.Create;
  ComponentRec.Name := 'JRadioButtons';
  ComponentRec.ShowIt := procedure begin
    {--------------------------------------------------------------------------}
    { Component  JW3RadioButton                                                }
    { Updated:   01/09/2017                                                    }
    {--------------------------------------------------------------------------}
    var FieldSet := JW3FieldSet.Create(DisplayDiv);
    FieldSet.SetBounds(0, 0, 200, 180);
    //FieldSet.Legend := 'Legend';

    //no need for RadioButtones.SetBounds()
    var RadioButton1 := JW3RadioButton.Create(FieldSet);
    RadioButton1.Label := 'First RadioButton';

    var RadioButton2 := JW3RadioButton.Create(FieldSet);
    RadioButton2.Label := 'Second RadioButton';
    RadioButton2.Checked := true;

    var RadioButton3 := JW3RadioButton.Create(FieldSet);
    RadioButton3.Label := 'Third RadioButton';

  end;
  Components.Add(ComponentRec);

//JScroller
  ComponentRec := TComponentRec.Create;
  ComponentRec.Name := 'JImgScroller';
  ComponentRec.ShowIt := procedure begin
    {--------------------------------------------------------------------------}
    { Component  JW3Scroller                                                   }
    { Updated:   01/09/2018                                                    }
    {--------------------------------------------------------------------------}
    var Scroller1 := JW3Scroller.Create(DisplayDiv);
    Scroller1.SetBounds(0, 0, 500, 50);
    Scroller1.setProperty('background-color', 'gold');
    Scroller1.SetProperty('border','1px double grey');
    //Scroller1.Container.setCSS('-webkit-scrollbar','display','none');

    For var i := 0 to 30 do begin
      var img1 : JW3Image := JW3Image.Create(Scroller1.Container);
      case i of
        0: img1.setAttribute('src','images/mysql.jpg');
        1: img1.setAttribute('src','images/oracle.jpg');
        else img1.setAttribute('src','images/file.jpg');  //generic.jpg');
      end;
      img1.setBounds(i*50,0,50,50);
      case i of
        0: img1.handle.name := 'MySQL';
        1: img1.handle.name := 'Oracle';
        else img1.handle.name := 'File ' + inttostr(i-1);  //better use data-
      end;
      img1.handle.ondblclick := procedure(e:variant) begin window.alert(e.target.name); end;
    end;
  end;
  Components.Add(ComponentRec);

//JSelect
  ComponentRec := TComponentRec.Create;
  ComponentRec.Name := 'JSelect (text)';
  ComponentRec.ShowIt := procedure begin
    {--------------------------------------------------------------------------}
    { Component  JW3Select (combobox)                                          }
    { Updated:   01/09/2017                                                    }
    {--------------------------------------------------------------------------}
    var Select1 := JW3Select.Create(DisplayDiv);
    Select1.SetBounds(0, 0, 200, 200);
    Select1.setProperty('background-color', 'white');
    For var i := 1 to 15 do begin
      var Item1 := JW3Panel.Create(Select1);
      Item1.setProperty('background-color', 'whitesmoke');
      Item1.Height := 20;
      Item1.Text := 'Item ' + IntToStr(i);
      Item1.tag := 'Item ' + inttostr(i);
      Select1.Add(Item1);
    end;

  end;
  Components.Add(ComponentRec);

//JSelect
  ComponentRec := TComponentRec.Create;
  ComponentRec.Name := 'JSelect (images)';
  ComponentRec.ShowIt := procedure begin
    {--------------------------------------------------------------------------}
    { Component  JW3Select (combobox)                                          }
    { Updated:   01/09/2017                                                    }
    {--------------------------------------------------------------------------}
    var Select1 := JW3Select.Create(DisplayDiv);
    Select1.SetBounds(0, 0, 200, 200);
    Select1.setProperty('background-color', 'white');
    For var i := 1 to 15 do begin
      var Image1 := JW3Image.Create(Select1);
      Image1.Height := 35;
      Image1.setAttribute('src','images/logo.png');
      Image1.tag := 'Item ' + inttostr(i);
      Select1.Add(Image1);
    end;

  end;
  Components.Add(ComponentRec);

//JSpinner
  ComponentRec := TComponentRec.Create;
  ComponentRec.Name := 'JSpinner';
  ComponentRec.ShowIt := procedure begin
    {--------------------------------------------------------------------------}
    { Component  JW3Spinner                                                    }
    { Updated:   01/09/2017                                                    }
    {--------------------------------------------------------------------------}
    var Spinner1 := JW3Spinner.Create(DisplayDiv);
    Spinner1.SetBounds(20, 0, 40, 40);
  end;
  Components.Add(ComponentRec);

//JSplitter
  ComponentRec := TComponentRec.Create;
  ComponentRec.Name := 'JSplitter';
  ComponentRec.ShowIt := procedure begin
    {--------------------------------------------------------------------------}
    { Component  JW3Splitter                                                   }
    { Updated:   01/09/2017                                                    }
    {--------------------------------------------------------------------------}
    var Splitter1 := JW3Splitter.Create(DisplayDiv);
    Splitter1.SetBounds(0, 0, 300, 200);
    Splitter1.PanelLeft.setProperty('background-color', 'white');
    Splitter1.PanelRight.setProperty('background-color', 'whitesmoke');
    Splitter1.SetProperty('border','1px solid silver');

    var Button1 := JW3Button.Create(Splitter1.PanelLeft);
    Button1.Caption := 'Left';
    Button1.SetBounds(20,20,60,30);
    var Button2 := JW3Button.Create(Splitter1.PanelRight);
    Button2.Caption := 'Right';
    Button2.SetBounds(20,20,60,30);
  end;
  Components.Add(ComponentRec);

//JTabControl
  ComponentRec := TComponentRec.Create;
  ComponentRec.Name := 'JTabControl';
  ComponentRec.ShowIt := procedure begin
    {--------------------------------------------------------------------------}
    { Component  JW3TabControl                                                      }
    { Updated:   01/06/2018                                                    }
    {--------------------------------------------------------------------------}
    var TabControl1 := JW3TabControl.Create(DisplayDiv);
    TabControl1.SetBounds(0, 0, 500, 270);

    TabControl1.handle.style.backgroundColor := 'whitesmoke';
    TabControl1.handle.style.border := '1px solid grey';
    TabControl1.TabHeight := 25;         //default = 26
    TabControl1.TabWidth  := 110;        //default = 100

    TabControl1.AddTab('Tab-1');
    TabControl1.AddTab('Tab-2');
    TabControl1.AddTab('Tab-3');
    TabControl1.AddTab('Tab-4');
    TabControl1.AddTab('Tab-5');

    //Tab-1
    var CB1,CB2,CB3,CB4,CB5,CB6,CB7 : JW3CheckBox;

    var Button1 := JW3Button.Create(TabControl1.Tabs[0].Body);
    Button1.SetBounds(10, 40, 100, 30);
    Button1.Caption := 'ReDraw';
    Button1.OnClick := procedure(sender:TObject)
    begin
      If CB1.Checked then TabControl1.Tabs[0].hidden := false
                     else TabControl1.Tabs[0].hidden := true;
      If CB2.Checked then TabControl1.Tabs[1].hidden := false
                     else TabControl1.Tabs[1].hidden := true;
      If CB3.Checked then TabControl1.Tabs[2].hidden := false
                     else TabControl1.Tabs[2].hidden := true;
      If CB4.Checked then TabControl1.Tabs[3].hidden := false
                     else TabControl1.Tabs[3].hidden := true;
      If CB5.Checked then TabControl1.Tabs[4].hidden := false
                     else TabControl1.Tabs[4].hidden := true;
      If CB6.Checked then TabControl1.AddTab('Tab-6');
      If CB7.Checked then TabControl1.AutoSize := true
                     else TabControl1.AutoSize := false;
      TabControl1.ReDraw;
    end;

    CB1 := JW3CheckBox.Create(TabControl1.Tabs[0].body);
    CB1.SetBounds(150, 40, 200, 25);
    CB1.Checked := true; CB1.Label := 'Tab-1';
    CB2 := JW3CheckBox.Create(TabControl1.Tabs[0].body);
    CB2.SetBounds(150, 70, 200, 25);
    CB2.Checked := true; CB2.Label := 'Tab-2';
    CB3 := JW3CheckBox.Create(TabControl1.Tabs[0].body);
    CB3.SetBounds(150, 100, 200, 25);
    CB3.Checked := true; CB3.Label := 'Tab-3';
    CB4 := JW3CheckBox.Create(TabControl1.Tabs[0].body);
    CB4.SetBounds(150, 130, 200, 25);
    CB4.Checked := false; CB4.Label := 'Tab-4';
    CB5 := JW3CheckBox.Create(TabControl1.Tabs[0].body);
    CB5.SetBounds(150, 160, 200, 25);
    CB5.Checked := true; CB5.Label := 'Tab-5';
    CB6 := JW3CheckBox.Create(TabControl1.Tabs[0].body);
    CB6.SetBounds(150, 190, 200, 25);
    CB6.Checked := false; CB6.Label := 'Add Tab-6';
    CB7 := JW3CheckBox.Create(TabControl1.Tabs[0].body);
    CB7.SetBounds(250, 190, 200, 25);
    CB7.Checked := false; CB7.Label := 'Auto-size';

    //Tab-2
    var Image1 := JW3Image.Create(TabControl1.Tabs[1].Body);
    Image1.SetBounds(10, 40, 194, 45);
    Image1.SetAttribute('src','images/logo.png');

    //Tab-3
    var TabControl2 := JW3TabControl.Create(TabControl1.Tabs[2].Body);
    TabControl2.SetBounds(10, 10, 474, 198);
    TabControl2.handle.style.backgroundColor := 'whitesmoke';
    TabControl2.handle.style.border := '1px solid grey';

      TabControl2.AddTab('Tab-1');
      TabControl2.AddTab('Tab-2');

      var Image2 := JW3Image.Create(TabControl2.Tabs[0].Body);
      Image2.SetBounds(10, 10, 800, 800);
      Image2.SetAttribute('src','images/earth.jpg');

      var Button2 := JW3Button.Create(TabControl2.Tabs[1].Body);
      Button2.SetBounds(10, 40, 100, 30);
      Button2.Caption := 'Button2';
      Button2.OnClick := procedure(sender:TObject) begin console.log('clicked'); end;

    //Tab-4
    TabControl1.Tabs[3].hidden := true;    //make fourth tab invisible

    //Tab-5                                //include a form (form3)
//    If Application.FormsInstances[2] = nil then begin   //create form if it hasn't been used yet
//       Application.FormsInstances[2] := Application.FormsClasses[2].Create(self);
//      (Application.FormsInstances[2] as TForm3).InitializeObject;
//    end;
//    TabControl1.Tabs[4].body.handle.appendChild((Application.FormsInstances[2] as TForm3).handle);

  end;
  Components.Add(ComponentRec);

//JTextArea
  ComponentRec := TComponentRec.Create;
  ComponentRec.Name := 'JTextArea';
  ComponentRec.ShowIt := procedure begin
    {--------------------------------------------------------------------------}
    { Component  JW3TextArea (memo)                                            }
    { Updated:   01/09/2017                                                    }
    {--------------------------------------------------------------------------}
    var Memo1 := JW3TextArea.Create(DisplayDiv);
    Memo1.SetBounds(0, 0, 300, 100);
    Memo1.setProperty('background-color', 'whitesmoke');
    Memo1.SetProperty('border','1px double grey');
    Memo1.Text := 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. ' +
                  'Vestibulum a ipsum leo. Vestibulum a ante ipsum primis in ' +
                  'faucibus orci luctus et ultrices posuere cubilia Curae; Phasellus ' +
                  'tincidunt pretium enim, mollis finibus lacus aliquam sed. Sed ' +
                  'molestie mi eu rhoncus aliquet. Ut ac aliquam quam. Pellentesque ' +
                  'at vulputate urna.';
  end;
  Components.Add(ComponentRec);

//JToggle
  ComponentRec := TComponentRec.Create;
  ComponentRec.Name := 'JToggle';
  ComponentRec.ShowIt := procedure begin
    {--------------------------------------------------------------------------}
    { Component  JW3Toggle                                                     }
    { Updated:   23/04/2019                                                    }
    {--------------------------------------------------------------------------}
    var Toggle1 := JW3Toggle.Create(DisplayDiv);
    Toggle1.SetBounds(0, 0, 100, 24);
    Toggle1.Left.OnClick := procedure(Sender:TObject) begin
      console.log('clicked left');
    end;
    Toggle1.Right.OnClick := procedure(Sender:TObject) begin
      console.log('clicked right');
    end;
    Toggle1.Middle.OnClick := procedure(Sender:TObject) begin
      console.log('clicked middle');
    end;
  end;
  Components.Add(ComponentRec);

//JToolBar
  ComponentRec := TComponentRec.Create;
  ComponentRec.Name := 'JToolBar';
  ComponentRec.ShowIt := procedure begin
    {--------------------------------------------------------------------------}
    { Component  JW3ToolBar                                                    }
    { Updated:   01/09/2017                                                    }
    {--------------------------------------------------------------------------}
    var ToolBar1 := JW3ToolBar.Create(DisplayDiv);
    ToolBar1.SetBounds(0, 0, 500, 40);
    ToolBar1.setProperty('background-color', '#699BCE');
    ToolBar1.AddMenu('Fish-Facts','Form3','white');
    ToolBar1.AddMenu('VR image',  'Form4','white');
    ToolBar1.AddMenu('StreetView','Form5','white');

  end;
  Components.Add(ComponentRec);

//JTreeView
  ComponentRec := TComponentRec.Create;
  ComponentRec.Name := 'JTreeView';
  ComponentRec.ShowIt := procedure begin
    {--------------------------------------------------------------------------}
    { Component  JW3TreeView                                                   }
    { Updated:   01/09/2017                                                    }
    {--------------------------------------------------------------------------}
    var TreeView1 := JW3TreeView.Create(DisplayDiv);
    TreeView1.SetBounds(0, 0, 250, 200);

    TreeView1.Subject := 'Job roles';

    TreeView1.Add('ceo','','chief executive officer');       //root
    TreeView1.Add('cto', 'ceo','chief technology officer');
    TreeView1.Add('dev1', 'cto','developer 1');
    TreeView1.Add('dev2', 'cto','developer 2');
    TreeView1.Add('dev3', 'cto','developer 3');
    TreeView1.Add('assistent', 'dev2','assistant developer 2');
    TreeView1.Add('cfo', 'ceo','chief financial officer');
    TreeView1.Add('accountant', 'cfo','bean counter');
    TreeView1.Add('cmo', 'ceo','chief marketing officer');
/*
TreeView1.Subject := 'Projects';

TreeView1.Add('/', '', '/');       //root
TreeView1.Add('Contest_Demos', '/', 'Contest_Demos');
TreeView1.Add('Snippets', '/', 'Snippets');

TreeView1.Add('Afternoon_Walk', 'Contest_Demos', 'Afternoon_Walk');
TreeView1.Add('Biotopia', 'Contest_Demos', 'Biotopia');

TreeView1.Add('Afternoon_Walk.spr', 'Afternoon_Walk', 'Afternoon_Walk.spr');
TreeView1.Add('Afternoon_Walk.sproj', 'Afternoon_Walk', 'Afternoon_Walk.sproj');
TreeView1.Add('G2App.pas', 'Afternoon_Walk', 'G2App.pas');
TreeView1.Add('g2template.pas', 'Afternoon_Walk', 'g2template.pas');
TreeView1.Add('Gen2Web', 'Afternoon_Walk', 'Gen2Web');
TreeView1.Add('Shaders.pas', 'Afternoon_Walk', 'Shaders.pas');

TreeView1.Add('G2DataManager.pas', 'Gen2Web', 'G2DataManager.pas');
TreeView1.Add('G2Math.pas', 'Gen2Web', 'G2Math.pas');
TreeView1.Add('G2MeshData.pas', 'Gen2Web', 'G2MeshData.pas');
TreeView1.Add('G2MeshG2M.pas', 'Gen2Web', 'G2MeshG2M.pas');
TreeView1.Add('G2Shaders.pas', 'Gen2Web', 'G2Shaders.pas');
TreeView1.Add('G2Types.pas', 'Gen2Web', 'G2Types.pas');
TreeView1.Add('G2Utils.pas', 'Gen2Web', 'G2Utils.pas');
TreeView1.Add('G2Web.pas', 'Gen2Web', 'G2Web.pas');
TreeView1.Add('BinaryFile.pas', 'Biotopia', 'BinaryFile.pas');
TreeView1.Add('Biotopia.dsk', 'Biotopia', 'Biotopia.dsk');
TreeView1.Add('Biotopia.spr', 'Biotopia', 'Biotopia.spr');
TreeView1.Add('Biotopia.sproj', 'Biotopia', 'Biotopia.sproj');
TreeView1.Add('Biotopia.stat', 'Biotopia', 'Biotopia.stat');

TreeView1.Add('Calc_Cirle.xml', 'Snippets', 'Calc_Cirle.xml');
TreeView1.Add('Calc_Ellipse.xml', 'Snippets', 'Calc_Ellipse.xml');
TreeView1.Add('Create_a_form.xml', 'Snippets', 'Create_a_form.xml');
*/
  end;
  Components.Add(ComponentRec);

//JVideo
  ComponentRec := TComponentRec.Create;
  ComponentRec.Name := 'JVideo';
  ComponentRec.ShowIt := procedure begin
    {--------------------------------------------------------------------------}
    { Component  JW3Video                                                      }
    { Updated:   01/09/2017                                                    }
    {--------------------------------------------------------------------------}
    var Video1 := JW3Video.Create(DisplayDiv);
    Video1.SetBounds(0, 0, 400, 300);
    Video1.setAttribute('src','videos/looprake.mp4');
    Video1.SetAttribute('type','video/mp4');
    Video1.SetAttribute('controls','true');
//    Video1.SetAttribute('autoplay','true');
    Video1.setProperty('width', '400px');
    Video1.setProperty('height', '300px');
    Video1.SetProperty('object-fit','fill');
  end;
  Components.Add(ComponentRec);

//JInput
  ComponentRec := TComponentRec.Create;
  ComponentRec.Name := 'JInput (styled natively)';
  ComponentRec.ShowIt := procedure begin
    {--------------------------------------------------------------------------}
    { Component  JW3Input (combobox)                                           }
    { Updated:   01/09/2017                                                    }
    {--------------------------------------------------------------------------}
    var Input1 := JW3Input.Create(DisplayDiv);
    Input1.SetBounds(0, 0, 200, 40);
    Input1.SetProperty('border','2px solid whitesmoke');
//
      var MySelect := JW3Select.Create(self);
      //save this id on the form
      self.handle.setAttribute('data-select',MySelect.handle.id);

      MySelect.SetBounds(17, 290, 200, 200);
      MySelect.setProperty('background-color', 'white');

      var Types : Array of String;
      Types.Clear;
      Types.Add('button');
      Types.Add('checkbox');
      Types.Add('color');
      Types.Add('date');
      Types.Add('datetime-local');
      Types.Add('email');
      Types.Add('file');
      Types.Add('hidden');
      Types.Add('image');
      Types.Add('month');
      Types.Add('number');
      Types.Add('password');
      Types.Add('radio');
      Types.Add('range');
      Types.Add('reset');
      Types.Add('search');
      Types.Add('submit');
      Types.Add('tel');
      Types.Add('text');
      Types.Add('time');
      Types.Add('url');
      Types.Add('week');

      For var i := 0 to Types.Count -1 do begin
        var Item1 := JW3Panel.Create(MySelect);
        Item1.setProperty('background-color', 'whitesmoke');
        Item1.Height := 20;
        Item1.Text := Types[i];
        Item1.tag := Types[i];
        Item1.Handle.addEventListener('click',procedure()
        begin
          Input1.SetAttribute('type',MySelect.Value);

          case Myselect.Value of
            'button'   : Input1.SetAttribute('value','input type = ' + MySelect.Value);
            'color'    : Input1.SetAttribute('value','#ff0000');
            'email'    : Input1.SetAttribute('placeholder','user@host.com');
            'file'     : Input1.SetAttribute('accept','.jpg, .jpeg, .png');
            'hidden'   : Input1.SetAttribute('value','should not see this');
            'image'    : Input1.SetAttribute('src','images/logo.png');
            'number'   : Input1.SetAttribute('value','123456');
            'password' : Input1.SetAttribute('required','true');
            'radio'    : Input1.SetAttribute('checked','true');
            'reset'    : Input1.SetAttribute('value','reset form');
            'search'   : Input1.SetAttribute('placeholder','search...');
            'submit'   : Input1.SetAttribute('value','submit form');
            'tel'      : Input1.SetAttribute('placeholder','+61(0)x 9999 9999');
            'text'     : Input1.SetAttribute('value','input type = ' + MySelect.Value);
            'url'      : Input1.SetAttribute('placeholder','https://www.lynkfs.com');
          end;
          MySelect.handle.style.display := 'none';
        end);
        MySelect.Add(Item1);
      end;
//
  end;
  Components.Add(ComponentRec);



///////////////////////////////////////////////////////
//
//populate the menu (listbox) with all component names
//when clicked, execute the saved ShowIt procedure
//
  ListBox1 := JW3ListBox.Create(self);
  ListBox1.SetBounds(17, 85, 200, 200);
  ListBox1.setProperty('background-color', 'white');
  ListBox1.SetProperty('border','2px double whitesmoke');

  For var i := 0 to Components.Count -1 do begin
    var Panel0 := JW3Panel.Create(ListBox1);
    Panel0.setProperty('background-color', 'whitesmoke');
    //Panel0.setProperty('border','1px solid whitesmoke');
    Panel0.SetBounds(2,2,170,22);
    Panel0.SetProperty('cursor','pointer');
    Panel0.Text := Components[i].Name;
    Panel0.SetProperty('font-size', '0.85em');
    Panel0.tag := inttostr(i);
    Panel0.OnClick := procedure(Sender:TObject)
      begin
        //clear DisplayDiv
        While assigned(DisplayDiv.FElement.firstChild) do
          DisplayDiv.FElement.removeChild(DisplayDiv.FElement.firstChild);
        //optionally clear select element, see JInput
        if document.getElementById(self.handle.getAttribute('data-select')) <> null then
          document.getElementById(self.handle.getAttribute('data-select')).style.display := 'none';
        //execute component
        Components[strtoint((Sender as JW3Panel).tag)].ShowIt;
        //adjust height and width of DisplayDiv to componentheight and -width
        DisplayDiv.Height := StrToInt(StrBefore(DisplayDiv.handle.children[0].style.height, 'px')) + 30;
        DisplayDiv.Width  := StrToInt(StrBefore(DisplayDiv.handle.children[0].style.width, 'px')) + 30;
      end;

    ListBox1.Add(Panel0);
  end;

end;

procedure TForm1.Resize;
begin
  inherited;
end;

end.

