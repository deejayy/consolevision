{$O-}
{$APPTYPE CONSOLE}
{*******************************************************}
{                                                       }
{       ConsoleVision Main Unit                         }
{                                                       }
{       Copyright (C) 2000-04 DeeJayy                   }
{                                                       }
{*******************************************************}
{                     DELPHI 4.0+                       }
{         Copyright (C) 2004      DeeJayy               }
{                                                       }
{*******************************************************}

unit cvext;

interface

uses

  crt, crtplus, windows;

type

  obj = ( oButton, oListBox, oMemo, oEdit, oShortCut, oComboBox, oDriveComboBox,
          oLabel, oCheckBox, oProgressBar, oTrackBar, oGroupBox, oSpinEdit,
          oRadioButton, oFileListBox, oTimer, oStrings );

  pApplet = ^tApplet;
  tApplet = object
    components: array of pointer;
    count, left, top, width, height: integer;
    exitkey: word;
    exitstate: longword;
    constructor init;
    procedure   add( component: pointer );
    destructor  done;
  end;

  tProc = procedure;
  tFocusProc = procedure( var applet: pApplet; direction: integer );
  tCmpFunc = function( fd1, fd2: tWin32FindData ): longint;

  pRoot = ^tRoot;

  pStrings = ^tStrings;
  tStrings = object
    key: obj;
    parent: pRoot;
    count: integer;
    items: array of string;
    constructor init;
    procedure   add( s: string );
    procedure   delete( i: integer );
    procedure   insert( s: string; before: integer );
    procedure   clear;
    destructor  done;
  end;

  tRoot = object
    key: obj;
    parent: pApplet;
    left, top, width, height: longint;
    visible, focused: boolean;
    color, bgcolor, activecolor: byte;
    text: shortstring;
    strings: pStrings;
    exec: tProc;
    onpaint: tProc;
    onkbd: procedure( keycode: _KEY_EVENT_RECORD );
    ondone: tProc;
    onfocus: tFocusProc;
    constructor init;
    procedure   paint;
    procedure   handleevent( inputrec: tInputRecord );
    procedure   selfkbd( keycode: _KEY_EVENT_RECORD );
    destructor  done;
  end;

  pTimer = ^tTimer;
  tTimer = object( tRoot )
    thhandle: longword;
    thid: longword;
    interval: longint;
    constructor init;
    procedure   start;
    procedure   stop;
    procedure   thread;
    destructor  done;
  end;

  pButton = ^tButton;
  tButton = object( tRoot )
    constructor init;
    procedure   paint;
    procedure   handleevent( inputrec: tInputRecord );
    procedure   selfkbd( keycode: _KEY_EVENT_RECORD );
    destructor  done;
  end;

  pListBox = ^tListBox;
  tListBox = object( tRoot )
    cursorpos, firstitem, count: longint;
    crcolora, crcolori: byte;
    constructor init;
    procedure   paint;
    procedure   handleevent( inputrec: tInputRecord );
    procedure   selfkbd( keycode: _KEY_EVENT_RECORD );
    procedure   setcrpos( rel_curpos_index, rel_f_item_index: integer );
    procedure   add( s: string; repaint: boolean );
    procedure   insertitem( item: string; insbefore: integer; repaint: boolean );
    procedure   clear;
    destructor  done;
  end;

  pEdit = ^tEdit;
  tEdit = object( tRoot )
    cursorpos, maxlength, firstchar, selstart, selend: integer;
    selcolor, selbgcolor: integer;
    blankchar: char;
    constructor init;
    procedure   paint;
    procedure   setcrpos( index: integer );
    procedure   handleevent( inputrec: tInputRecord );
    procedure   selfkbd( keycode: _KEY_EVENT_RECORD );
    destructor  done;
  end;

  pMemo = ^tMemo;
  tMemo = object( tRoot )
    readonly: boolean;
    cursorpos, count: integer;
    constructor init;
    procedure   paint;
    procedure   add( s: string; repaint: boolean );
    procedure   loadfromfile( filename: string );
    procedure   setcrpos( rel_curpos_index: integer );
    procedure   handleevent( inputrec: tInputRecord );
    procedure   selfkbd( keycode: _KEY_EVENT_RECORD );
    destructor  done;
  end;

  pShortCut = ^tShortCut;
  tShortCut = object( tRoot )
    shortcuts: array of tshortcutrec;
    constructor init;
    procedure   paint;
    procedure   handleevent( inputrec: tInputRecord );
    procedure   selfkbd( keycode: _KEY_EVENT_RECORD );
    procedure   add( _controlkeystate: longword; _virtualkeycode: word; _execproc: tProc );
    destructor  done;
  end;

  pComboBox = ^tComboBox;
  tComboBox = object( tRoot )
    count, itemindex, cursorpos, firstitem, crcolora: integer;
    downed: boolean;
    onchange: tProc;
    constructor init;
    procedure   paint;
    procedure   handleevent( inputrec: tInputRecord );
    procedure   selfkbd( keycode: _KEY_EVENT_RECORD );
    procedure   setcrpos( rel_curpos_index, rel_f_item_index: integer );
    procedure   add( s: string );
    destructor  done;
  end;

  pDriveComboBox = ^tDriveComboBox;
  tDriveComboBox = object( tComboBox )
    constructor init;
    destructor  done;
  end;

  pLabel = ^tLabel;
  tLabel = object( tRoot )
    constructor init;
    procedure   paint;
    destructor  done;
  end;

  pCheckBox = ^tCheckBox;
  tCheckBox = object( tRoot )
    checked: boolean;
    constructor init;
    procedure   paint;
    procedure   handleevent( inputrec: tInputRecord );
    procedure   selfkbd( keycode: _KEY_EVENT_RECORD );
    destructor  done;
  end;

  pProgressBar = ^tProgressBar;
  tProgressBar = object( tRoot )
    max, position: integer;
    chars: string[2];
    constructor init;
    procedure   paint;
    procedure   setpos( value: integer );
    destructor  done;
  end;

  pTrackBar = ^tTrackBar;
  tTrackBar = object( tRoot )
    max, position, step: integer;
    chars: string[2];
    constructor init;
    procedure   paint;
    procedure   setpos( value: integer );
    procedure   handleevent( inputrec: tInputRecord );
    procedure   selfkbd( keycode: _KEY_EVENT_RECORD );
    destructor  done;
  end;

  pGroupBox = ^tGroupBox;
  tGroupBox = object( tRoot )
    constructor init;
    procedure   paint;
    destructor  done;
  end;

  pSpinEdit = ^tSpinEdit;
  tSpinEdit = object( tEdit )
    value, max, smallstep, bigstep, min: integer;
    constructor init;
    procedure   paint;
    procedure   handleevent( inputrec: tInputRecord );
    procedure   selfkbd( keycode: _KEY_EVENT_RECORD );
    destructor  done;
  end;

  pRadioGroup = ^tRadioGroup;
  tRadioGroup = array of pointer;

  pRadioButton = ^tRadioButton;
  tRadioButton = object( tRoot )
    checked: boolean;
    group: tRadioGroup;
    constructor init;
    procedure   paint;
    procedure   handleevent( inputrec: tInputRecord );
    procedure   selfkbd( keycode: _KEY_EVENT_RECORD );
    destructor  done;
  end;

  pFileListBox = ^tFileListBox;
  tFileListBox = object( tRoot )
    path, drive, ldir: string;
    cursorpos, firstitem, count, dircount: longint;
    crcolora, crcolori: byte;
    items: array of tWin32FindData;
    constructor init;
    procedure   paint;
    procedure   handleevent( inputrec: tInputRecord );
    procedure   selfkbd( keycode: _KEY_EVENT_RECORD );
    procedure   setcrpos( rel_curpos_index, rel_f_item_index: integer );
    procedure   additem( item: tWin32FindData; repaint: boolean );
    procedure   qsort( l, h: integer; cmpfunc: tCmpFunc );
    procedure   insertitem( item: tWin32FindData; insbefore: integer; repaint: boolean );
    procedure   delete( index: integer; repaint: boolean );
    procedure   clear( repaint: boolean );
    procedure   getfiles( directory: string );
    procedure   changedir;
    destructor  done;
  end;

function newApplet( left, top, width, height: integer; title: string; exitstate: longword; exitkey: word ): pApplet;
function newButton( parent: pApplet ): pButton;
function newListBox( parent: pApplet ): pListBox;
function newEdit( parent: pApplet ): pEdit;
function newMemo( parent: pApplet ): pMemo;
function newShortCut( parent: pApplet ): pShortCut;
function newComboBox( parent: pApplet ): pComboBox;
function newDriveComboBox( parent: pApplet ): pDriveComboBox;
function newLabel( parent: pApplet; x, y, w: integer; text: string ): pLabel;
function newCheckBox( parent: pApplet ): pCheckBox;
function newProgressBar( parent: pApplet ): pProgressBar;
function newTrackBar( parent: pApplet ): pTrackBar;
function newGroupBox( parent: pApplet ): pGroupBox;
function newSpinEdit( parent: pApplet ): pSpinEdit;
function newRadioButton( parent: pApplet; var group: tRadioGroup ): pRadioButton;
function newFileListBox( parent: pApplet; initialdir: string ): pFileListBox;
function newTimer( parent: pApplet; execproc: tProc; interval: integer ): pTimer;
function newStrings: pStrings;

function destroyAll( var applet: pApplet ): integer;
function getFocused( applet: pApplet ): pointer;
procedure repaintAll( var applet: pApplet );
procedure chFocus( var applet: pApplet; direction: integer );
procedure run( var applet: pApplet );

var

  shortcuts: pShortCut;
  scbgcolor: integer;

implementation




//////////////////////////////////
//           ========
//            APPLET
//           ========
//////////////////////////////////




constructor tApplet.init;

  begin
    count := 0;
    setlength( components, count );
    left := 1;
    top := 1;
    width := 79;
    height := 24;
    exitkey := Ord( 'X' );
    exitstate := CKS_ALT;
  end;

procedure   tApplet.add( component: pointer );

  begin
    inc( count );
    setlength( components, count );
    components[ count - 1 ] := component;
  end;

destructor  tApplet.done;

  begin
    count := 0;
    setlength( components, count );
  end;



//////////////////////////////////
//         =============
//          ROOT OBJECT
//         =============
//////////////////////////////////




constructor tRoot.init;

  begin
    top := 1;
    left := 1;
    width := 20;
    height := 5;
    color := 7;
    activecolor := 15;
    bgcolor := 0;
    visible := true;
    focused := false;
    strings := newStrings;
  end;

procedure   tRoot.paint;

  begin
    setcaret( left, top );
    if focused then textcolor( activecolor ) else textcolor( color );
    textbackground( bgcolor );
  end;

procedure   tRoot.selfkbd( keycode: _KEY_EVENT_RECORD );

  begin
    if keycode.dwControlKeyState and CKS_SHIFT > 0 then
      begin if keycode.wVirtualKeyCode = VK_TAB then ChFocus( parent, -1 ) end
    else if keycode.wVirtualKeyCode = VK_TAB then ChFocus( parent, 1 );
  end;

procedure   tRoot.handleevent( inputrec: tInputRecord );

  begin
    if inputrec.EventType = KEY_EVENT then
      if inputrec.Event.KeyEvent.bKeyDown then
        self.selfkbd( inputrec.event.keyEvent );
  end;

destructor  tRoot.done;

  begin
    strings.done;
  end;




//////////////////////////////////
//           ========
//            BUTTON
//           ========
//////////////////////////////////




constructor tButton.init;

  begin
    inherited;
    key := oButton;
  end;

procedure   tButton.paint;

  begin
    inherited;
    if assigned( onpaint ) then begin onpaint; exit; end;
//    if focused then _write( #17#32 + text + #32#16 ) else
    _write( '[ ' + text + ' ]' );

    redraw;

  end;

procedure   tButton.handleevent( inputrec: tInputRecord );

  begin
    if inputrec.EventType = KEY_EVENT then
      if inputrec.Event.KeyEvent.bKeyDown then
        self.selfkbd( inputrec.event.keyEvent );
  end;

procedure   tButton.selfkbd( keycode: _KEY_EVENT_RECORD );

  begin
    if assigned( onkbd ) then begin onkbd( keycode ); exit; end;
    case keycode.wVirtualKeyCode of
      VK_RETURN: if assigned( exec ) then exec;
      VK_DOWN: ChFocus( parent, 1 );
      VK_UP: ChFocus( parent, -1 );
      VK_LEFT: ChFocus( parent, -1 );
      VK_RIGHT: ChFocus( parent, 1 );
    end;
    inherited;
  end;

destructor  tButton.done;

  begin
    if assigned( ondone ) then begin ondone; exit; end;
    inherited;
  end;




//////////////////////////////////
//           =========
//            LISTBOX
//           =========
//////////////////////////////////




constructor tListBox.init;

  begin
    inherited;
    key := oListBox;
    cursorpos := 0;
    crcolora := 9;
    crcolori := 1;
    firstitem := 0;
  end;

procedure   tListBox.paint;

  var

    e, i, lastitem, l, h: integer;
    outstr: string;

  begin
    inherited;
    if assigned( onpaint ) then begin onpaint; exit; end;

//    if not focused then drawBorder( left, top, width, height, bsSimple ) else
    drawBorder( left, top, width, height, bsDouble );
    if text <> '' then
      begin
        setcaret( left + ( width - length( text ) ) div 2, top );
        _write( ' ' + text + ' ' );
      end;

    if cursorpos - firstitem > height - 2 then firstitem :=  cursorpos - height + 2;
    if cursorpos - firstitem < 0 then dec( firstitem );

    l := low( strings.items );
    h := high( strings.items );

    lastitem := firstitem + height - 2;

    if lastitem > h then
      begin
        lastitem := h;
        firstitem := lastitem - height + 2;
      end;

    if firstitem < l then
      begin
        firstitem := l;
        lastitem := firstitem + height - 2;
      end;

    if lastitem > h then lastitem := h;

    if cursorpos < l then cursorpos := l;
    if cursorpos > h then cursorpos := h;

    for e := firstitem to lastitem do
      begin
        if cursorpos = e then
          if focused then textbackground( crcolora ) else textbackground( crcolori )
        else textbackground( bgcolor );

        setcaret( left + 1, top + 1 + e - firstitem );
        outstr := strings.items[ e ];
        if length( outstr ) < width - 2 then
          for i := 1 to width - 1 - length( outstr ) do outstr := outstr + ' '
        else outstr := copy( outstr, 1, width - 2 );
        _write( outstr );
      end;

    redraw;

  end;

procedure   tListBox.handleevent( inputrec: tInputRecord );

  begin
    if inputrec.EventType = KEY_EVENT then
      if inputrec.Event.KeyEvent.bKeyDown then
        self.selfkbd( inputrec.event.keyEvent );
  end;

procedure   tListBox.selfkbd( keycode: _KEY_EVENT_RECORD );

  begin
    if assigned( onkbd ) then begin onkbd( keycode ); exit; end;

    case keycode.wVirtualKeyCode of
      VK_UP: if cursorpos > 0 then setcrpos( -1, 0 );
      VK_DOWN: if cursorpos < high( strings.items ) then setcrpos( 1, 0 );
      VK_PRIOR: setcrpos( - height + 2, - height + 2 );
      VK_NEXT: setcrpos( height - 2, height - 2 );
      VK_HOME: setcrpos( - cursorpos, - firstitem );
      VK_END: setcrpos( count, count );
      VK_RETURN: if assigned( exec ) then exec;
    end;

    inherited;
  end;

procedure   tListBox.setcrpos( rel_curpos_index, rel_f_item_index: integer );

  begin
    cursorpos := cursorpos + rel_curpos_index;
    firstitem := firstitem + rel_f_item_index;
    paint;
  end;

procedure   tListBox.add( s: string; repaint: boolean );

  begin
    strings.add( s );
    if repaint then paint;
  end;

procedure   tListBox.insertitem( item: string; insbefore: integer; repaint: boolean );

  var

    e: integer;

  begin
    strings.insert( item, insbefore );

    if repaint then paint;
  end;

procedure   tListBox.clear;

  begin
    strings.clear;

    paint;
  end;

destructor  tListBox.done;

  begin
    if assigned( ondone ) then begin ondone; exit; end;
    inherited;
  end;




//////////////////////////////////
//            ======
//             EDIT
//            ======
//////////////////////////////////




constructor tEdit.init;

  begin
    inherited;
    key := oEdit;
    cursorpos := 0;
    maxlength := 255;
    firstchar := 0;
    selcolor := 15;
    selbgcolor := 9;
    selstart := -1;
    selend := -1;
    blankchar := ' ';
  end;

procedure   tEdit.paint;

  var

    outstr, space: string;
    e, p1, p2: integer;

  begin
    if focused then cursoron else cursoroff;
    inherited;
    if assigned( onpaint ) then begin onpaint; exit; end;

    dec( width );

    outstr := text;

    if cursorpos = length( text ) then space := blankchar else space := '';

    if cursorpos >= width then firstchar := cursorpos - width + 1 else firstchar := 0;

    if cursorpos < 0 then cursorpos := 0;

    outstr := copy( outstr, firstchar + 1, width );

{    outstr := outstr + space; space := '';
    if ( length( outstr ) <= width ) then
      for e := 1 to width - length( outstr ) do space := space + ' ';}
    p1 := 0; p2 := width;
    if selstart < pos( outstr, text ) then
      p1 := 0;
    if ( selstart >= pos( outstr, text ) ) and ( selstart < pos( outstr, text ) + width ) then
      p1 := selstart - pos( outstr, text );
    if selstart >= pos( outstr, text ) + width then
      p1 := width;
    if selend < pos( outstr, text ) then
      p2 := 0;
    if ( selend >= pos( outstr, text ) ) and ( selend < pos( outstr, text ) + width ) then
      p2 := selend - pos( outstr, text ) + 1;
    if selend >= pos( outstr, text ) + width then
      p2 := width;

    outstr := outstr + space; space := '';
    if ( length( outstr ) <= width ) then
      for e := 1 to width - length( outstr ) do space := space + blankchar;
    textcolor( color );
    textbackground( bgcolor );
    _write( copy( outstr, 1, p1 ) );
    textcolor( selcolor );
    textbackground( selbgcolor );
    _write( copy( outstr, p1 + 1, p2 - p1 ) );
    textcolor( color );
    textbackground( bgcolor );
    _write( copy( outstr, p2 + 1, width ) + space );

//    _write( outstr + space );

    setcaret( left + cursorpos - firstchar, top );
    gotoxy( left + cursorpos - firstchar, top );

    inc( width );

    redraw;
  end;

procedure   tEdit.setcrpos( index: integer );

  begin
    cursorpos := index;
    selstart := -1;
    selend := -1;
  end;

procedure   tEdit.handleevent( inputrec: tInputRecord );

  begin
    if inputrec.EventType = KEY_EVENT then
      if inputrec.Event.KeyEvent.bKeyDown then
        self.selfkbd( inputrec.event.keyEvent );
  end;

procedure   tEdit.selfkbd( keycode: _KEY_EVENT_RECORD );

  begin

    if assigned( onkbd ) then begin onkbd( keycode ); exit; end;

    if ( ord( keycode.AsciiChar ) in validchars ) and ( keycode.dwControlKeyState and CKS_FUNCKEY = 0 ) then
      if length( text ) < maxlength then
      begin
        text := copy( text, 1, cursorpos ) + keycode.AsciiChar + copy( text, cursorpos + 1, length( text ) );
        inc( cursorpos );
      end;

    if keycode.dwControlKeyState and CKS_SHIFT > 0 then
      case keycode.wVirtualKeyCode of
        VK_LEFT: begin
                   if cursorpos <= selstart then _dec( selstart, 0 ) else
                   if cursorpos = selend then _dec( selend, 0 ) else
                   begin selstart := cursorpos + 1; selend := cursorpos + 1; end;
                   _dec( cursorpos, 0 );
                 end;
        VK_RIGHT: begin
{                    if cursorpos = selend then _inc( selend, length( text ) ) else
                    if cursorpos >= selstart then _inc( selstart, length( text ) ) else
                    begin selstart := cursorpos + 1; selend := cursorpos + 1; end;
                    _inc( cursorpos, length( text ) );}
                   if cursorpos = selend then _inc( selend, length( text ) ) else
                   if cursorpos <= selstart then _inc( selstart, length( text ) ) else
                   begin selstart := cursorpos + 1; selend := cursorpos + 1; end;
                   _inc( cursorpos, length( text ) );
                  end;
      end;

    if keycode.dwControlKeyState and CKS_SHIFT = CKS_SHIFT then
      begin
//        write( 'helo' );
      end;

    if keycode.dwControlKeyState and CKS_MODIFY = 0 then
      case keycode.wVirtualKeyCode of
        VK_LEFT:   if cursorpos > 0 then setcrpos( cursorpos - 1 );
        VK_RIGHT:  if cursorpos < length( text ) then setcrpos( cursorpos + 1 );
        VK_DELETE: if selstart <> selend then
                     begin
                       if selstart = 0 then delete( text, 1, selend - selstart )
                       else delete( text, selstart, selend - selstart + 1 );
                       if cursorpos > length( text ) then cursorpos := length( text );
                       selstart := -1;
                       selend := -1;
                     end
                   else
                     delete( text, cursorpos + 1, 1 );
        VK_BACK:   if selstart <> selend then
                     begin
                       if selstart = 0 then delete( text, 1, selend - selstart )
                       else delete( text, selstart, selend - selstart + 1 );
                       if cursorpos > length( text ) then cursorpos := length( text );
                       selstart := -1;
                       selend := -1;
                     end
                   else
                     begin
                       delete( text, cursorpos, 1 );
                       dec( cursorpos );
                     end;
        VK_END:    setcrpos( length( text ) );
        VK_HOME:   setcrpos( 0 );
        VK_RETURN: if assigned( exec ) then exec;
      end;

    paint;

    inherited;
  end;

destructor  tEdit.done;

  begin
    inherited;
  end;



//////////////////////////////////
//         ======
//          MEMO
//         ======
//////////////////////////////////




constructor tMemo.init;

  begin
    inherited;
    key := oMemo;
    cursorpos := 0;
    readonly := true;
  end;

procedure   tMemo.paint;

  var

    e, i, h, lastitem: integer;
    outstr: string;

  begin
    inherited;
    if assigned( onpaint ) then begin onpaint; exit; end;

    if cursorpos > high( strings.items ) - height then cursorpos := high( strings.items ) - height;
    if cursorpos < 0 then cursorpos := 0;

    h := high( strings.items );

    if height > h then lastitem := h else lastitem := height;

    if cursorpos + lastitem > h then lastitem := cursorpos - h;

    for e := cursorpos to cursorpos + lastitem do
      begin
        setcaret( left, top + e - cursorpos );

        outstr := strings.items[ e ];

        if length( outstr ) < width then
          for i := 1 to width - length( outstr ) do outstr := outstr + ' '
        else outstr := copy( outstr, 1, width );

        _write( outstr );
      end;

    redraw;

  end;

procedure   tMemo.handleevent( inputrec: tInputRecord );

  begin
    if inputrec.EventType = KEY_EVENT then
      if inputrec.Event.KeyEvent.bKeyDown then
        self.selfkbd( inputrec.event.keyEvent );
  end;

procedure   tMemo.selfkbd( keycode: _KEY_EVENT_RECORD );

  begin
    if assigned( onkbd ) then begin onkbd( keycode ); exit; end;

    case keycode.wVirtualKeyCode of
      VK_UP: if cursorpos > 0 then setcrpos( -1 );
      VK_DOWN: if cursorpos < high( strings.items ) - height then setcrpos( 1 );
      VK_PRIOR: setcrpos( - height );
      VK_NEXT: setcrpos( height );
      VK_HOME: setcrpos( - cursorpos );
      VK_END: setcrpos( count - height - 1 );
      VK_RETURN: if assigned( exec ) then exec;
    end;

    paint;
    inherited;
  end;

procedure   tMemo.add( s: string; repaint: boolean );

  begin
    strings.add( s );

    if repaint then paint;
  end;

procedure   tMemo.loadfromfile( filename: string );

  var

    f: textfile;
    s: string;

  begin

    assignfile( f, filename );
    reset( f );
    repeat
      readln( f, s );
      strings.add( s );
    until eof( f );
    closefile( f );

  end;

procedure   tMemo.setcrpos( rel_curpos_index: integer );

  begin
    cursorpos := cursorpos + rel_curpos_index;
    paint;
  end;

destructor  tMemo.done;

  begin
    inherited;
  end;



//////////////////////////////////
//         ==========
//          SHORTCUT
//         ==========
//////////////////////////////////




constructor tShortCut.init;

  begin
    inherited;
    key := oShortCut;
    setlength( shortcuts, 0 );
  end;

procedure   tShortCut.paint;

  begin

  end;

procedure   tShortCut.handleevent( inputrec: tInputRecord );

  begin
    if inputrec.EventType = KEY_EVENT then
      if inputrec.Event.KeyEvent.bKeyDown then
        self.selfkbd( inputrec.event.keyEvent );
  end;

procedure   tShortCut.selfkbd( keycode: _KEY_EVENT_RECORD );

  var

    e: integer;

  begin
    for e := low( shortcuts ) to high( shortcuts ) do
    if ( shortcuts[ e ].controlkeystate and keycode.dwControlKeyState > 0 ) and
       ( shortcuts[ e ].virtualkeycode = keycode.wVirtualKeyCode ) then
      if assigned( shortcuts[ e ].execproc ) then shortcuts[ e ].execproc;
  end;

procedure   tShortCut.add( _controlkeystate: longword; _virtualkeycode: word; _execproc: tProc );

  begin
    setlength( shortcuts, high( shortcuts ) + 2 );
    with shortcuts[ high( shortcuts ) ] do
    begin
      controlkeystate := _controlkeystate;
      virtualkeycode := _virtualkeycode;
      execproc := _execproc;
    end;
  end;

destructor  tShortCut.done;

  begin
    inherited;
    setlength( shortcuts, 0 );
  end;





//////////////////////////////////
//         ==========
//          COMBOBOX
//         ==========
//////////////////////////////////




constructor tComboBox.init;

  begin
    inherited;

    key := oComboBox;
    itemindex := 0;
  end;

procedure   tComboBox.paint;

  var

    outstr, space: string;
    e, l, h, i, diff, lastitem: integer;

  begin
    inherited;
    if assigned( onpaint ) then begin onpaint; exit; end;

    dec( width );

    outstr := copy( strings.items[ itemindex ], 1, width );

    outstr := outstr + space; space := '';
    if ( length( outstr ) <= width ) then
      for e := 1 to width - length( outstr ) do space := space + ' ';

    _write( outstr + space + #25 );

    if downed then
      begin
        inc( top );
        diff := 0;

        if height > count then diff := height - count - 1;
        dec( height, diff );

        drawBorder( left, top, width, height, bsSimple );

        if cursorpos - firstitem > height - 2 then firstitem :=  cursorpos - height + 2;
        if cursorpos - firstitem < 0 then dec( firstitem );

        l := low( strings.items );
        h := high( strings.items );

        lastitem := firstitem + height - 2;

        if lastitem > h then begin lastitem := h; firstitem := lastitem - height + 2; end;
        if firstitem < l then begin firstitem := l; lastitem := firstitem + height - 2; end;
        if lastitem > h then lastitem := h;
        if cursorpos < l then cursorpos := l;
        if cursorpos > h then cursorpos := h;

        for e := firstitem to lastitem do
          begin
            if cursorpos = e then textbackground( crcolora )
            else textbackground( bgcolor );

            setcaret( left + 1, top + 1 + e - firstitem );
            outstr := strings.items[ e ];
            if length( outstr ) <= width - 1 then
              for i := 1 to width - 1 - length( outstr ) do outstr := outstr + ' '
            else outstr := copy( outstr, 1, width - 1 );
            _write( outstr );
          end;

        dec( top );
        inc( height, diff );
      end;

    inc( width );

    redraw;

  end;

procedure   tComboBox.handleevent( inputrec: tInputRecord );

  begin
    if inputrec.EventType = KEY_EVENT then
      if inputrec.Event.KeyEvent.bKeyDown then
        self.selfkbd( inputrec.event.keyEvent );
  end;

procedure   tComboBox.selfkbd( keycode: _KEY_EVENT_RECORD );

  begin
    if assigned( onkbd ) then begin onkbd( keycode ); exit; end;

    if not downed then
      begin

        if keycode.dwControlKeyState and CKS_ALT > 0 then
          case keycode.wVirtualKeyCode of
            VK_UP: begin _dec( itemindex, 0 ); if assigned( onchange ) then onchange; repaintall( parent ); end;
            VK_DOWN: begin _inc( itemindex, count - 1 ); if assigned( onchange ) then onchange; repaintall( parent ); end;
          end;

        if keycode.dwControlKeyState and CKS_CONTROL > 0 then
          case keycode.wVirtualKeyCode of
            VK_DOWN: downed := true;
          end;

      end
    else
      begin

        case keycode.wVirtualKeyCode of
          VK_UP: if cursorpos > 0 then setcrpos( -1, 0 );
          VK_DOWN: if cursorpos < high( strings.items ) then setcrpos( 1, 0 );
          VK_PRIOR: setcrpos( - height + 2, - height + 2 );
          VK_NEXT: setcrpos( height - 2, height - 2 );
          VK_HOME: setcrpos( - cursorpos, - firstitem );
          VK_END: setcrpos( count, count );
          VK_RETURN: begin itemindex := cursorpos; downed := false; if assigned( onchange ) then onchange; repaintall( parent ); end;
          VK_ESCAPE, VK_TAB: begin downed := false; repaintall( parent ); end;
        end;

      end;

    paint;

    inherited;
  end;

procedure   tComboBox.setcrpos( rel_curpos_index, rel_f_item_index: integer );

  begin
    cursorpos := cursorpos + rel_curpos_index;
    firstitem := firstitem + rel_f_item_index;
    paint;
  end;

procedure   tComboBox.add( s: string );

  begin
    strings.add( s );

    paint;
  end;

destructor  tComboBox.done;

  begin
    inherited;
  end;




//////////////////////////////////
//        ============
//         DRIVECOMBO
//        ============
//////////////////////////////////




constructor tDriveComboBox.init;

  var

    buf: string;
    ln, i: integer;

  begin
    inherited;

    key := oDriveComboBox;

    setlength( buf, 255 );
    ln := getlogicaldrivestrings( 250, pchar( buf ) );
    for i := 1 to ln div 4 do
    add( copy( buf, ( i - 1 ) * 4 + 1, i * 4 - ( ( i - 1 ) * 4 + 1 ) ) );

  end;

destructor  tDriveComboBox.done;

  begin
    inherited;
  end;




//////////////////////////////////
//         =======
//          LABEL
//         =======
//////////////////////////////////




constructor tLabel.init;

  begin
    inherited;

    key := oLabel;
    bgcolor := scbgcolor;
  end;

procedure   tLabel.paint;

  begin
    inherited;
    if assigned( onpaint ) then begin onpaint; exit; end;

    _write( copy( text, 1, width ) );

    redraw;

  end;

destructor  tLabel.done;

  begin
    inherited;
  end;




//////////////////////////////////
//         ==========
//          CHECKBOX
//         ==========
//////////////////////////////////




constructor tCheckBox.init;

  begin
    inherited;

    key := oCheckBox;
    checked := false;
  end;

procedure   tCheckBox.paint;

  begin
    inherited;
    if assigned( onpaint ) then begin onpaint; exit; end;

    _write( '[' + check[ csCheckBox, checked ] + '] ' + copy( text, 1, width - 4 ) );

    redraw;

  end;

procedure   tCheckBox.handleevent( inputrec: tInputRecord );

  begin
    if inputrec.EventType = KEY_EVENT then
      if inputrec.Event.KeyEvent.bKeyDown then
        self.selfkbd( inputrec.event.keyEvent );
  end;

procedure   tCheckBox.selfkbd( keycode: _KEY_EVENT_RECORD );

  begin
    if assigned( onkbd ) then begin onkbd( keycode ); exit; end;

    case keycode.wVirtualKeyCode of
      VK_SPACE: checked := not checked;
      VK_RETURN: if assigned( exec ) then exec;
      VK_DOWN: ChFocus( parent, 1 );
      VK_UP: ChFocus( parent, -1 );
      VK_LEFT: ChFocus( parent, -1 );
      VK_RIGHT: ChFocus( parent, 1 );
    end;

    paint;
    inherited;
  end;

destructor  tCheckBox.done;

  begin
    inherited;
  end;




//////////////////////////////////
//        =============
//         PROGRESSBAR
//        =============
//////////////////////////////////




constructor tProgressBar.init;

  begin
    inherited;

    key := oProgressBar;
    max := 100;
    position := 0;
    chars := #$DB#$B1;
  end;

procedure   tProgressBar.paint;

  var

    e: integer;

  begin
    inherited;
    if assigned( onpaint ) then begin onpaint; exit; end;

    for e := left to _max( round( width * position / max ), max ) do
      _write( chars[ 1 ] );
    for e := _max( round( width * position / max ) + 1, max ) to width do
      _write( chars[ 2 ] );

    redraw;

  end;

procedure   tProgressBar.setpos( value: integer );

  begin
    position := value;
    paint;
  end;

destructor  tProgressBar.done;

  begin
    inherited;
  end;




//////////////////////////////////
//          ==========
//           TRACKBAR
//          ==========
//////////////////////////////////




constructor tTrackBar.init;

  begin
    inherited;

    key := oTrackBar;
    max := 100;
    position := 0;
    step := 5;
    chars := #$C5#$C4;
  end;

procedure   tTrackBar.paint;

  var

    e: integer;

  begin
    inherited;
    if assigned( onpaint ) then begin onpaint; exit; end;

    for e := left to _max( round( width * position / max ), width ) + 2 do
      _write( chars[ 2 ] );
    _write( chars[ 1 ] );
    for e := _max( round( width * position / max ), width ) + 4 to width + 3 do
      _write( chars[ 2 ] );

    redraw;

  end;

procedure   tTrackBar.setpos( value: integer );

  begin
    position := value;
    paint;
  end;

procedure   tTrackBar.handleevent( inputrec: tInputRecord );

  begin
    if inputrec.EventType = KEY_EVENT then
      if inputrec.Event.KeyEvent.bKeyDown then
        self.selfkbd( inputrec.event.keyEvent );
  end;

procedure   tTrackBar.selfkbd( keycode: _KEY_EVENT_RECORD );

  begin
    if assigned( onkbd ) then begin onkbd( keycode ); exit; end;

    case keycode.wVirtualKeyCode of
      VK_RIGHT, VK_UP: position := _max( position + step, max );
      VK_LEFT, VK_DOWN: position := _min( position - step, 0 );
    end;

    paint;

    inherited;
  end;

destructor  tTrackBar.done;

  begin
    inherited;
  end;




//////////////////////////////////
//          ==========
//           GROUPBOX
//          ==========
//////////////////////////////////




constructor tGroupBox.init;

  begin
    inherited;

    key := oGroupBox;
  end;

procedure   tGroupBox.paint;

  begin
    inherited;
    if assigned( onpaint ) then begin onpaint; exit; end;

    drawCBorder( text, left, top, width, height, bsSimple );
  end;

destructor  tGroupBox.done;

  begin
    inherited;
  end;




//////////////////////////////////
//          ==========
//           SPINEDIT
//          ==========
//////////////////////////////////




constructor tSpinEdit.init;

  begin
    inherited;

    key := oSpinEdit;

    value := 1;
    min := 1;
    max := 100;
    smallstep := 1;
    bigstep := 5;
  end;

procedure   tSpinEdit.paint;

  begin

    text := inttostr( value );
    tEdit.paint;

////////////////////////////////////////////////////////////////////////////////////////////////

    setcaret( left + width - 1, top );
    _write( #$12 );

    if assigned( onpaint ) then begin onpaint; exit; end;

    redraw;

  end;

procedure   tSpinEdit.handleevent( inputrec: tInputRecord );

  begin
    if inputrec.EventType = KEY_EVENT then
      if inputrec.Event.KeyEvent.bKeyDown then
        self.selfkbd( inputrec.event.keyEvent );
  end;

procedure   tSpinEdit.selfkbd( keycode: _KEY_EVENT_RECORD );

  begin
    if assigned( onkbd ) then begin onkbd( keycode ); exit; end;

    if ( keycode.wVirtualKeyCode in [ 48..57 ] ) and ( keycode.dwControlKeyState and CKS_FUNCKEY = 0 ) then
      if length( text ) < maxlength then
      begin
        text := copy( text, 1, cursorpos ) + keycode.AsciiChar + copy( text, cursorpos + 1, length( text ) );
        value := strtoint( text );
        if value < max then inc( cursorpos );
      end;

    if keycode.dwControlKeyState and CKS_MODIFY = 0 then
      case keycode.wVirtualKeyCode of
        VK_UP: begin value := _max( value + smallstep, max ); setcrpos( length( inttostr( value ) ) ); end;
        VK_DOWN: begin value := _min( value - smallstep, min ); setcrpos( length( inttostr( value ) ) ); end;
        VK_PRIOR: begin value := _max( value + bigstep, max ); setcrpos( length( inttostr( value ) ) ); end;
        VK_NEXT: begin value := _min( value - bigstep, min ); setcrpos( length( inttostr( value ) ) ); end;

        VK_LEFT:   if cursorpos > 0 then setcrpos( cursorpos - 1 );
        VK_RIGHT:  if cursorpos < length( text ) then setcrpos( cursorpos + 1 );
        VK_DELETE: if selstart <> selend then
                     begin
                       delete( text, selstart, selend - selstart );
                       value := strtoint( text );
                       selstart := -1;
                       selend := -1;
                     end
                   else
                     begin
                       delete( text, cursorpos + 1, 1 );
                       value := strtoint( text );
                     end;
        VK_BACK:   if selstart <> selend then
                     begin
                       delete( text, selstart, selend - selstart );
                       value := strtoint( text );
                       selstart := -1;
                       selend := -1;
                     end
                   else
                     begin
                       delete( text, cursorpos, 1 );
                       value := strtoint( text );
                       dec( cursorpos );
                     end;
        VK_END:    setcrpos( length( text ) );
        VK_HOME:   setcrpos( 0 );
      end;

    value := _max( value, max );
    value := _min( value, min );
    paint;

    if keycode.dwControlKeyState and CKS_SHIFT > 0 then
      begin if keycode.wVirtualKeyCode = VK_TAB then ChFocus( parent, -1 ) end
    else if keycode.wVirtualKeyCode = VK_TAB then ChFocus( parent, 1 );
  end;

destructor  tSpinEdit.done;

  begin
    inherited;
  end;




//////////////////////////////////
//        =============
//         RADIOBUTTON
//        =============
//////////////////////////////////




constructor tRadioButton.init;

  begin
    inherited;

    key := oRadioButton;
    checked := false;
  end;

procedure   tRadioButton.paint;

  begin
    inherited;
    if assigned( onpaint ) then begin onpaint; exit; end;

    _write( '(' + check[ csRadioButton, checked ] + ') ' + copy( text, 1, width - 4 ) );

    redraw;
  end;

procedure   tRadioButton.handleevent( inputrec: tInputRecord );

  begin
    if inputrec.EventType = KEY_EVENT then
      if inputrec.Event.KeyEvent.bKeyDown then
        self.selfkbd( inputrec.event.keyEvent );
  end;

procedure   tRadioButton.selfkbd( keycode: _KEY_EVENT_RECORD );

  var

    e: integer;

  begin
    if assigned( onkbd ) then begin onkbd( keycode ); exit; end;

    case keycode.wVirtualKeyCode of
      VK_SPACE: begin
                  for e := 0 to high( group ) do
                    begin
                      pRadioButton( group[ e ] ).checked := false;
                      pRadioButton( group[ e ] ).paint;
                    end;
                  self.checked := true;
                end;
    end;

    paint;

    inherited;
  end;

destructor  tRadioButton.done;

  begin
    inherited;
  end;




//////////////////////////////////
//        =============
//         FILELISTBOX
//        =============
//////////////////////////////////




constructor tFileListBox.init;

  begin

    inherited;
    key := oFileListBox;
    cursorpos := 0;
    crcolora := 9;
    crcolori := 1;
    firstitem := 0;
    setlength( items, 0 );

    path := '';
    drive := '';
  end;

procedure   tFileListBox.paint;

  var

    e, lastitem, l, h: integer;
    outstr: string;

  begin
    inherited;
    if assigned( onpaint ) then begin onpaint; exit; end;

    drawCBorder( text, left, top, width, height, bsDouble );

    dec( height, 2 );

    if cursorpos > height + firstitem then firstitem := cursorpos - height;
    if cursorpos < firstitem then dec( firstitem );

    l := low( items );
    h := high( items );

    lastitem := firstitem + height;

    if lastitem  > h then begin lastitem  := h; firstitem := h - height; end;
    if firstitem < l then begin firstitem := l; lastitem  := l + height; end;

    lastitem :=  _max( lastitem, h );

    cursorpos := _min( cursorpos, l );
    cursorpos := _max( cursorpos, h );

    for e := firstitem to lastitem do
      begin
        if cursorpos = e then
          if focused then textbackground( crcolora ) else textbackground( crcolori )
        else textbackground( bgcolor );

        setcaret( left + 1, top + 1 + e - firstitem );
        outstr := copy( items[ e ].cFileName, 1, width - 1 );
        while length( outstr ) < width - 1 do outstr := outstr + ' ';

        _write( outstr );
      end;

    inc( height, 2 );

    redraw;

  end;

procedure   tFileListBox.handleevent( inputrec: tInputRecord );

  begin
    if inputrec.EventType = KEY_EVENT then
      if inputrec.Event.KeyEvent.bKeyDown then
        self.selfkbd( inputrec.event.keyEvent );
  end;

procedure   tFileListBox.selfkbd( keycode: _KEY_EVENT_RECORD );

  begin
    if assigned( onkbd ) then begin onkbd( keycode ); exit; end;

    case keycode.wVirtualKeyCode of
      VK_UP: if cursorpos > 0 then setcrpos( -1, 0 );
      VK_DOWN: if cursorpos < high( items ) then setcrpos( 1, 0 );
      VK_PRIOR: setcrpos( - height + 2, - height + 2 );
      VK_NEXT: setcrpos( height - 2, height - 2 );
      VK_HOME: setcrpos( - cursorpos, - firstitem );
      VK_END: setcrpos( count, count );
      VK_RETURN: changedir;
    end;

    inherited;
  end;

{procedure   tFileListBox.add( s: string; repaint: boolean );

  begin
    setlength( strings, high( strings ) + 2 );
    strings[ high( strings ) ] := s;
    inc( count );
    if repaint then paint;
  end;}

procedure   tFileListBox.additem( item: tWin32FindData; repaint: boolean );

  begin
    setlength( items, high( items ) + 2 );
    items[ high( items ) ] := item;
    inc( count );
    if item.dwFileAttributes and file_attribute_directory > 0 then inc( dircount );
    if repaint then paint;
  end;

procedure   tFileListBox.qsort( l, h: integer; cmpfunc: tCmpFunc );

    var

      fixelem, selem  : tWin32Finddata;
      bindex,  jindex : integer;

    begin
      bindex  := l;
      jindex  := h;
      fixelem := items[ ( l + h ) div 2 ];

      repeat
        while cmpfunc( fixelem, items[ bindex ] ) = 1 do inc( bindex );
        while cmpfunc( items[ jindex ], fixelem ) = 1 do dec( jindex );
        if ( bindex <= jindex ) then
          begin
             selem := items[ bindex ];
             items[ bindex ] := items[ jindex ];
             items[ jindex ] := selem;
             inc( bindex );
             _dec( jindex, 0 );
          end;
      until ( bindex > jindex );

      if ( l < jindex ) then qsort( l, jindex, cmpfunc );
      if ( bindex < h ) then qsort( bindex, h, cmpfunc );
  end;

procedure   tFileListBox.insertitem( item: tWin32FindData; insbefore: integer; repaint: boolean );

  var

    e: integer;

  begin
    setlength( items, high( items ) + 2 );
    inc( count );
    if item.dwFileAttributes and file_attribute_directory > 0 then inc( dircount );

    insbefore := _max( insbefore, count );

    for e := count - 1 downto insbefore + 1 do
      items[ e ] := items[ e - 1 ];
    items[ insbefore ] := item;

    if repaint then paint;
  end;

procedure   tFileListBox.delete( index: integer; repaint: boolean );

  var

    e: integer;

  begin
    index := _min( index, 1 );
    index := _max( index, count - 1 );
    if items[ index ].dwFileAttributes and file_attribute_directory > 0 then dec( dircount );
    for e := index - 1 to count - 2 do
      items[ e ] := items[ e + 1 ];
    setlength( items, high( items ) );
    dec( count );
    if repaint then paint;
  end;

procedure   tFileListBox.clear( repaint: boolean );

  begin
    setlength( items, 0 );
    count := 0;
    dircount := 0;
    cursorpos := 0;
    if repaint then paint;
  end;

procedure   tFileListBox.getfiles( directory: string );

  var

    fHandle: longint;
    files: tWin32FindData;
    tmp: string;
    e: integer;

  begin
    {$I-}
    chdir( directory );
    getdir( 0, path );
    if path[ length( path ) ] <> '\' then path := path + '\';
    drive := copy( directory, 1, 3 );
    text := path;

    clear( false );

    fHandle := findFirstFile( '*.*', files );
      Repeat
        if not ( ( files.cFileName[ 0 ] = #46 ) and ( files.cFileName[ 1 ] = #0 ) ) then

        if files.dwFileAttributes and faDir > 0 then
          insertitem( files, 0, false )
        else additem( files, false );
      Until not findNextFile( fHandle, files );
    findClose( fHandle );

    if dircount <> 0 then qsort( 0, dircount - 1, cmpbyfilename );
    if dircount <> count then
      qsort( dircount, count - 1, cmpbyfilename );

    if ldir > path then
      begin
        tmp := copy( ldir, length( path ), length( ldir ) );
        tmp := copy( tmp, 2, length( tmp ) - 2 );
        for e := 0 to count do
          if ( pos( tmp, items[ e ].cFileName ) = 1 ) and
             ( items[ e ].cFileName[ length( tmp ) ] = #0 ) then
          cursorpos := e;
      end;

    paint;

    {$I+}
  end;

procedure   tFileListBox.changedir;

  begin
    ldir := path;
    if items[ cursorpos ].dwFileAttributes and faDir > 0 then
    getfiles( path + items[ cursorpos ].cFileName );
  end;

procedure   tFileListBox.setcrpos( rel_curpos_index, rel_f_item_index: integer );

  begin
    cursorpos := cursorpos + rel_curpos_index;
    firstitem := firstitem + rel_f_item_index;
    paint;
  end;

destructor  tFileListBox.done;

  begin
    inherited;
  end;


//////////////////////////////////
//           =======
//            TIMER
//           =======
//////////////////////////////////



constructor tTimer.init;

  begin
    key := oTimer;
  end;

procedure   tTimer.start;

  begin
    if assigned( exec ) then
    if thhandle = 0 then
      thhandle := createthread( nil, 0, @tTimer.thread, nil, 0, thid );
  end;

procedure   tTimer.thread;

  begin
    if gettickcount mod interval = 0 then exec;
  end;

procedure   tTimer.stop;

  begin
    closehandle( thhandle );
  end;

destructor  tTimer.done;

  begin
  end;


//////////////////////////////////
//         =========
//          STRINGS
//         =========
//////////////////////////////////




constructor tStrings.init;

  begin
    key := oStrings;
  end;

procedure   tStrings.add( s: string );

  begin
    setlength( items, high( items ) + 2 );
    items[ high( items ) ] := s;
    inc( count );
  end;

procedure   tStrings.delete( i: integer );

  var

    e: integer;

  begin
    i := _max( i, count );
    i := _min( i, 1 ); 

    for e := i to count do
      items[ e - 1 ] := items[ e ];

    setlength( items, high( items ) );
    dec( count );
  end;

procedure   tStrings.insert( s: string; before: integer );

  var

    e: integer;

  begin
    setlength( items, high( items ) + 2 );
    inc( count );

    before := _max( before, count );

    for e := count - 1 downto before + 1 do
      items[ e ] := items[ e - 1 ];
    items[ before ] := s;
  end;

procedure   tStrings.clear;

  begin
    setlength( items, 0 );
    count := 0;
  end;

destructor  tStrings.done;

  begin
    inherited;
  end;


//////////////////////////////////
//       ================
//        MAIN FUNCTIONS
//       ================
//////////////////////////////////



function newApplet( left, top, width, height: integer; title: string; exitstate: longword; exitkey: word ): pApplet;

  begin
    new( result );

    reallocmem( result, sizeof( tApplet ) );
    result.init;
    result.left := left;
    result.top := top;
    result.width := width;
    result.height := height;
    result.exitkey := exitkey;
    result.exitstate := exitstate;

    settitle( pchar( title ) );
  end;

procedure addgroup( var what: pRadioButton; var group: tRadioGroup );

  var

    e: integer;

  begin

    setlength( group, high( group ) + 2 );
    group[ high( group ) ] := what;

    if high( group ) <> -1 then
      for e := 0 to high( group ) do pRadioButton( group[ e ] ).group := group;

  end;

function addTo( var applet: pApplet; key: obj ): pointer;

  begin
    new( result );

    case key of
      oButton: reallocmem( result, sizeof( tButton ) );
      oListBox: reallocmem( result, sizeof( tListBox ) );
      oEdit: reallocmem( result, sizeof( tEdit ) );
      oMemo: reallocmem( result, sizeof( tMemo ) );
      oShortCut: reallocmem( result, sizeof( tShortCut ) );
      oComboBox: reallocmem( result, sizeof( tComboBox ) );
      oDriveComboBox: reallocmem( result, sizeof( tDriveComboBox ) );
      oLabel: reallocmem( result, sizeof( tLabel ) );
      oCheckBox: reallocmem( result, sizeof( tCheckBox ) );
      oProgressBar: reallocmem( result, sizeof( tProgressBar ) );
      oTrackBar: reallocmem( result, sizeof( tTrackBar ) );
      oGroupBox: reallocmem( result, sizeof( tGroupBox ) );
      oSpinEdit: reallocmem( result, sizeof( tSpinEdit ) );
      oRadioButton: reallocmem( result, sizeof( tRadioButton ) );
      oFileListBox: reallocmem( result, sizeof( tFileListBox ) );
      oTimer: reallocmem( result, sizeof( tTimer ) );
    end;

    if not ( key in [oShortCut, oTimer] ) then
      applet.add( result );

    pRoot( result ).parent := applet;

  end;

function newButton( parent: pApplet ): pButton;

  begin
    result := addto( parent, oButton );

    result.init;
  end;

function newListBox( parent: pApplet ): pListBox;

  begin
    result := addto( parent, oListBox );

    result.init;
  end;

function newEdit( parent: pApplet ): pEdit;

  begin
    result := addto( parent, oEdit );

    result.init;
  end;

function newMemo( parent: pApplet ): pMemo;

  begin
    result := addto( parent, oMemo );

    result.init;
  end;

function newShortCut( parent: pApplet ): pShortCut;

  begin
    result := addto( parent, oShortCut );

    result.init;
  end;

function newComboBox( parent: pApplet ): pComboBox;

  begin
    result := addto( parent, oComboBox );

    result.init;
  end;

function newDriveComboBox( parent: pApplet ): pDriveComboBox;

  begin
    result := addto( parent, oDriveComboBox );

    result.init;
  end;

function newLabel( parent: pApplet; x, y, w: integer; text: string ): pLabel;

  begin
    result := addto( parent, oLabel );

    result.init;
    result.left := x;
    result.top := y;
    result.width := w;
    result.text := text;
    result.onfocus := chFocus;
  end;

function newCheckBox( parent: pApplet ): pCheckBox;

  begin
    result := addto( parent, oCheckBox );

    result.init;
  end;

function newProgressBar( parent: pApplet ): pProgressBar;

  begin
    result := addto( parent, oProgressBar );

    result.init;
    result.onfocus := chFocus;
  end;

function newTrackBar( parent: pApplet ): pTrackBar;

  begin
    result := addto( parent, oTrackBar );

    result.init;
  end;

function newGroupBox( parent: pApplet ): pGroupBox;

  begin
    result := addto( parent, oGroupBox );

    result.init;
    result.onfocus := chFocus;
  end;

function newSpinEdit( parent: pApplet ): pSpinEdit;

  begin
    result := addto( parent, oSpinEdit );

    result.init;
  end;

function newRadioButton( parent: pApplet; var group: tRadioGroup ): pRadioButton;

  begin
    result := addto( parent, oRadioButton );
    addgroup( result, group );

    result.init;
    result.group := group;
  end;

function newFileListBox( parent: pApplet; initialdir: string ): pFileListBox;

  begin
    result := addto( parent, oFileListBox );

    result.init;
    result.getfiles( initialdir );
  end;

function newTimer( parent: pApplet; execproc: tProc; interval: integer ): pTimer;
  begin
    result := addto( parent, oTimer );

    result.exec := execproc;
    result.interval := interval;
  end;

function newStrings: pStrings;
  begin
    new( result );

    result.clear;
  end;

function destroyAll( var applet: pApplet ): integer;

  var

    e: integer;

  begin

    for e := 0 to applet.count - 1 do
      case pRoot( applet.components[ e ] ).key of
        oButton: freemem( pButton( applet.components[ e ] ) );
        oListBox: freemem( pListBox( applet.components[ e ] ) );
        oEdit: freemem( pEdit( applet.components[ e ] ) );
        oMemo: freemem( pMemo( applet.components[ e ] ) );
        oShortCut: freemem( pShortCut( applet.components[ e ] ) );
        oComboBox: freemem( pComboBox( applet.components[ e ] ) );
        oDriveComboBox: freemem( pDriveComboBox( applet.components[ e ] ) );
        oLabel: freemem( pLabel( applet.components[ e ] ) );
        oCheckBox: freemem( pCheckBox( applet.components[ e ] ) );
        oProgressBar: freemem( pProgressBar( applet.components[ e ] ) );
        oTrackBar: freemem( pTrackBar( applet.components[ e ] ) );
        oGroupBox: freemem( pGroupBox( applet.components[ e ] ) );
        oSpinEdit: freemem( pSpinEdit( applet.components[ e ] ) );
        oRadioButton: freemem( pRadioButton( applet.components[ e ] ) );
        oFileListBox: freemem( pFileListBox( applet.components[ e ] ) );
        oTimer: freemem( pTimer( applet.components[ e ] ) );
      end;

    freemem( applet );

    result := 0;
    fillbuff80x25( 0 );
  end;

procedure repaintAll( var applet: pApplet );

  var

    e: integer;

  begin
    textbackground( scbgcolor );
    fillbuff80x25( textattr );

    for e := 0 to applet.count - 1 do
      case pRoot( applet.components[ e ] ).key of
        oButton: pButton( applet.components[ e ] ).paint;
        oListBox: pListBox( applet.components[ e ] ).paint;
        oEdit: pEdit( applet.components[ e ] ).paint;
        oMemo: pMemo( applet.components[ e ] ).paint;
        oComboBox: pComboBox( applet.components[ e ] ).paint;
        oDriveComboBox: pDriveComboBox( applet.components[ e ] ).paint;
        oLabel: pLabel( applet.components[ e ] ).paint;
        oCheckBox: pCheckBox( applet.components[ e ] ).paint;
        oProgressBar: pProgressBar( applet.components[ e ] ).paint;
        oTrackBar: pTrackBar( applet.components[ e ] ).paint;
        oGroupBox: pGroupBox( applet.components[ e ] ).paint;
        oSpinEdit: pSpinEdit( applet.components[ e ] ).paint;
        oRadioButton: pRadioButton( applet.components[ e ] ).paint;
        oFileListBox: pFileListBox( applet.components[ e ] ).paint;
      end;

  end;

procedure chFocus( var applet: pApplet; direction: integer );

  var

    e, cmp, chn: integer;

  begin
    for e := 0 to applet.count - 1 do
      if pRoot( applet.components[ e ] ).focused then break;

    pRoot( applet.components[ e ] ).focused := false;
    case pRoot( applet.components[ e ] ).key of
      oButton: pButton( applet.components[ e ] ).paint;
      oListBox: pListBox( applet.components[ e ] ).paint;
      oEdit: pEdit( applet.components[ e ] ).paint;
      oMemo: pMemo( applet.components[ e ] ).paint;
      oComboBox: pComboBox( applet.components[ e ] ).paint;
      oDriveComboBox: pDriveComboBox( applet.components[ e ] ).paint;
      oLabel: pLabel( applet.components[ e ] ).paint;
      oCheckBox: pCheckBox( applet.components[ e ] ).paint;
      oProgressBar: pProgressBar( applet.components[ e ] ).paint;
      oTrackBar: pTrackBar( applet.components[ e ] ).paint;
      oGroupBox: pGroupBox( applet.components[ e ] ).paint;
      oSpinEdit: pSpinEdit( applet.components[ e ] ).paint;
      oRadioButton: pRadioButton( applet.components[ e ] ).paint;
      oFileListBox: pFileListBox( applet.components[ e ] ).paint;
    end;

    if direction = 1 then cmp := applet.count - 1 else cmp := 0;
    if direction = 1 then chn := 0 else chn := applet.count - 1;

    if e = cmp then
      begin
        pRoot( applet.components[ chn ] ).focused := true;
        case pRoot( applet.components[ chn ] ).key of
          oButton: begin pButton( applet.components[ chn ] ).paint; if assigned( pButton( applet.components[ chn ] ).onfocus ) then pButton( applet.components[ chn ] ).onfocus( applet, direction ) end;
          oListBox: begin pListBox( applet.components[ chn ] ).paint; if assigned( pListBox( applet.components[ chn ] ).onfocus ) then pListBox( applet.components[ chn ] ).onfocus( applet, direction ) end;
          oEdit: begin pEdit( applet.components[ chn ] ).paint; if assigned( pEdit( applet.components[ chn ] ).onfocus ) then pEdit( applet.components[ chn ] ).onfocus( applet, direction ) end;
          oMemo: begin pMemo( applet.components[ chn ] ).paint; if assigned( pMemo( applet.components[ chn ] ).onfocus ) then pMemo( applet.components[ chn ] ).onfocus( applet, direction ) end;
          oComboBox: begin pComboBox( applet.components[ chn ] ).paint; if assigned( pComboBox( applet.components[ chn ] ).onfocus ) then pComboBox( applet.components[ chn ] ).onfocus( applet, direction ) end;
          oDriveComboBox: begin pDriveComboBox( applet.components[ chn ] ).paint; if assigned( pDriveComboBox( applet.components[ chn ] ).onfocus ) then pDriveComboBox( applet.components[ chn ] ).onfocus( applet, direction ) end;
          oLabel: begin pLabel( applet.components[ chn ] ).paint; if assigned( pLabel( applet.components[ chn ] ).onfocus ) then pLabel( applet.components[ chn ] ).onfocus( applet, direction ) end;
          oCheckBox: begin pCheckBox( applet.components[ chn ] ).paint; if assigned( pCheckBox( applet.components[ chn ] ).onfocus ) then pCheckBox( applet.components[ chn ] ).onfocus( applet, direction ) end;
          oProgressBar: begin pProgressBar( applet.components[ chn ] ).paint; if assigned( pProgressBar( applet.components[ chn ] ).onfocus ) then pProgressBar( applet.components[ chn ] ).onfocus( applet, direction ) end;
          oTrackBar: begin pTrackBar( applet.components[ chn ] ).paint; if assigned( pTrackBar( applet.components[ chn ] ).onfocus ) then pTrackBar( applet.components[ chn ] ).onfocus( applet, direction ) end;
          oGroupBox: begin pGroupBox( applet.components[ chn ] ).paint; if assigned( pGroupBox( applet.components[ chn ] ).onfocus ) then pGroupBox( applet.components[ chn ] ).onfocus( applet, direction ) end;
          oSpinEdit: begin pSpinEdit( applet.components[ chn ] ).paint; if assigned( pSpinEdit( applet.components[ chn ] ).onfocus ) then pSpinEdit( applet.components[ chn ] ).onfocus( applet, direction ) end;
          oRadioButton: begin pRadioButton( applet.components[ chn ] ).paint; if assigned( pRadioButton( applet.components[ chn ] ).onfocus ) then pRadioButton( applet.components[ chn ] ).onfocus( applet, direction ) end;
          oFileListBox: begin pFileListBox( applet.components[ chn ] ).paint; if assigned( pFileListBox( applet.components[ chn ] ).onfocus ) then pFileListBox( applet.components[ chn ] ).onfocus( applet, direction ) end;
        end;
      end else
      begin
        pRoot( applet.components[ e + direction ] ).focused := true;
        case pRoot( applet.components[ e + direction ] ).key of
          oButton: begin pButton( applet.components[ e + direction ] ).paint; if assigned( pButton( applet.components[ e + direction ] ).onfocus ) then pButton( applet.components[ e + direction ] ).onfocus( applet, direction ) end;
          oListBox: begin pListBox( applet.components[ e + direction ] ).paint; if assigned( pListBox( applet.components[ e + direction ] ).onfocus ) then pListBox( applet.components[ e + direction ] ).onfocus( applet, direction ) end;
          oEdit: begin pEdit( applet.components[ e + direction ] ).paint; if assigned( pEdit( applet.components[ e + direction ] ).onfocus ) then pEdit( applet.components[ e + direction ] ).onfocus( applet, direction ) end;
          oMemo: begin pMemo( applet.components[ e + direction ] ).paint; if assigned( pMemo( applet.components[ e + direction ] ).onfocus ) then pMemo( applet.components[ e + direction ] ).onfocus( applet, direction ) end;
          oComboBox: begin pComboBox( applet.components[ e + direction ] ).paint; if assigned( pComboBox( applet.components[ e + direction ] ).onfocus ) then pComboBox( applet.components[ e + direction ] ).onfocus( applet, direction ) end;
          oDriveComboBox: begin pDriveComboBox( applet.components[ e + direction ] ).paint; if assigned( pDriveComboBox( applet.components[ e + direction ] ).onfocus ) then pDriveComboBox( applet.components[ e + direction ] ).onfocus( applet, direction ) end;
          oLabel: begin pLabel( applet.components[ e + direction ] ).paint; if assigned( pLabel( applet.components[ e + direction ] ).onfocus ) then pLabel( applet.components[ e + direction ] ).onfocus( applet, direction ) end;
          oCheckBox: begin pCheckBox( applet.components[ e + direction ] ).paint; if assigned( pCheckBox( applet.components[ e + direction ] ).onfocus ) then pCheckBox( applet.components[ e + direction ] ).onfocus( applet, direction ) end;
          oProgressBar: begin pProgressBar( applet.components[ e + direction ] ).paint; if assigned( pProgressBar( applet.components[ e + direction ] ).onfocus ) then pProgressBar( applet.components[ e + direction ] ).onfocus( applet, direction ) end;
          oTrackBar: begin pTrackBar( applet.components[ e + direction ] ).paint; if assigned( pTrackBar( applet.components[ e + direction ] ).onfocus ) then pTrackBar( applet.components[ e + direction ] ).onfocus( applet, direction ) end;
          oGroupBox: begin pGroupBox( applet.components[ e + direction ] ).paint; if assigned( pGroupBox( applet.components[ e + direction ] ).onfocus ) then pGroupBox( applet.components[ e + direction ] ).onfocus( applet, direction ) end;
          oSpinEdit: begin pSpinEdit( applet.components[ e + direction ] ).paint; if assigned( pSpinEdit( applet.components[ e + direction ] ).onfocus ) then pSpinEdit( applet.components[ e + direction ] ).onfocus( applet, direction ) end;
          oRadioButton: begin pRadioButton( applet.components[ e + direction ] ).paint; if assigned( pRadioButton( applet.components[ e + direction ] ).onfocus ) then pRadioButton( applet.components[ e + direction ] ).onfocus( applet, direction ) end;
          oFileListBox: begin pFileListBox( applet.components[ e + direction ] ).paint; if assigned( pFileListBox( applet.components[ e + direction ] ).onfocus ) then pFileListBox( applet.components[ e + direction ] ).onfocus( applet, direction ) end;
        end;
      end;
  end;

function getFocused( applet: pApplet ): pointer;

  var

    e: integer;

  begin
    result := nil;

    for e := 0 to applet.count - 1 do
      if pRoot( applet.components[ e ] ).focused then
        begin result := applet.components[ e ]; break; end;
  end;

function altX( keystate: _KEY_EVENT_RECORD ): boolean;

  begin
    result := ( ( keystate.wVirtualKeyCode = Ord( 'X' ) ) and ( keystate.dwControlKeyState and CKS_LALT > 0 ) );
  end;

procedure run( var applet: pApplet );

  var

    inputrec: TInputRecord;

  begin
    repaintall( applet );

    repeat

      inputrec := getevent( true );

      if not ( ( inputrec.event.keyEvent.wVirtualKeyCode = applet.exitkey ) and ( inputrec.event.keyEvent.dwControlKeyState and applet.exitstate > 0 ) ) then
      case pRoot( getfocused( applet ) ).key of
        oButton:   pButton  ( getfocused( applet ) ).handleevent( inputrec );
        oListBox:  pListBox ( getfocused( applet ) ).handleevent( inputrec );
        oEdit:     pEdit    ( getfocused( applet ) ).handleevent( inputrec );
        oMemo:     pMemo    ( getfocused( applet ) ).handleevent( inputrec );
        oComboBox: pComboBox( getfocused( applet ) ).handleevent( inputrec );
        oDriveComboBox: pDriveComboBox( getfocused( applet ) ).handleevent( inputrec );
        oLabel:    pLabel( getfocused( applet ) ).handleevent( inputrec );
        oCheckBox: pCheckBox( getfocused( applet ) ).handleevent( inputrec );
        oProgressBar: pProgressBar( getfocused( applet ) ).handleevent( inputrec );
        oTrackBar: pTrackBar( getfocused( applet ) ).handleevent( inputrec );
        oGroupBox: pGroupBox( getfocused( applet ) ).handleevent( inputrec );
        oSpinEdit: pSpinEdit( getfocused( applet ) ).handleevent( inputrec );
        oRadioButton: pRadioButton( getfocused( applet ) ).handleevent( inputrec );
        oFileListBox: pFileListBox( getfocused( applet ) ).handleevent( inputrec );
      end;

      if assigned( shortcuts ) then shortcuts.handleevent( inputrec );

    until ( inputrec.event.keyEvent.wVirtualKeyCode = applet.exitkey ) and ( inputrec.event.keyEvent.dwControlKeyState and applet.exitstate > 0 );

    destroyall( applet );
  end;

initialization

  scbgcolor := 1; // blue
  textbackground( scbgcolor );

  fillbuff80x25( textattr );

  cursoroff;

end.















{




//////////////////////////////////
//         =
//
//         =
//////////////////////////////////




constructor t.init;

  begin
    inherited;

    key :=
  end;

procedure   t.paint;

  begin
    inherited;
    if assigned( onpaint ) then begin onpaint; exit; end;

  end;

procedure   t.selfkbd( keycode: _KEY_EVENT_RECORD );

  begin
    if assigned( onkbd ) then begin onkbd( keycode ); exit; end;

    inherited;
  end;

destructor  t.done;

  begin
    inherited;
  end;


    if selstart < pos( outstr, text ) then
      p1 := 0;
    if ( selstart >= pos( outstr, text ) ) and ( selstart < pos( outstr, text ) + width ) then
      p1 := selstart - pos( outstr, text ) + 1;
    if selstart >= pos( outstr, text ) + width then
      p1 := width;
    if selend < pos( outstr, text ) then
      p2 := 0;
    if ( selend >= pos( outstr, text ) ) and ( selend < pos( outstr, text ) + width ) then
      p2 := selend - pos( outstr, text ) + 1;
    if selend >= pos( outstr, text ) + width then
      p2 := width;

    outstr := outstr + space; space := '';
    if ( length( outstr ) <= width ) then
      for e := 1 to width - length( outstr ) do space := space + ' ';
    setcolors( color, bgcolor );
    _write( copy( outstr, 1, p1 ) );
    setcolors( selcolor, selbgcolor );
    _write( copy( outstr, p1 + 1, p2 - p1 ) );
    setcolors( color, bgcolor );
    _write( copy( outstr, p2 + 1, width ) + space );





    if keycode.dwControlKeyState and CKS_SHIFT > 0 then
      case keycode.wVirtualKeyCode of
        VK_LEFT: begin
                   if cursorpos = selend then _dec( selend, 0 ) else
                   if cursorpos <= selstart then _dec( selstart, 0 ) else
                   begin selstart := cursorpos; selend := cursorpos + 1; end;
                   _dec( cursorpos, 0 );
                 end;
        VK_RIGHT: begin
                    if cursorpos <= selend then _inc( selend, length( text ) ) else
                    if cursorpos = selstart then _inc( selstart, length( text ) ) else
                    begin selstart := cursorpos; selend := cursorpos + 1; end;
                    _inc( cursorpos, length( text ) );
                  end;
      end;


procedure   tFileListBox.insertby( item: tWin32FindData; repaint: boolean; cmpfunc: tCmpFunc );

  var

    l, h, m: longint;

  begin
    m := 0;
    l := 0;
    h := count;
      if h > 0 then
        if h > 1 then
          begin
            repeat
              m := trunc( ( l + h ) / 2 );
              if cmpfunc( item, items[ m ] ) = 1 then l := m else h := m;
            until abs( h - l ) = 1;
          m := trunc( ( l + h ) / 2 ) + 1;
          end
        else
          if cmpfunc( item, items[ m ] ) = 1 then m := 1;
    insertitem( item, m, repaint );
  end;




