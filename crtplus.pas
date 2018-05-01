{$O-}
{*******************************************************}
{                                                       }
{       CRT Plus Unit                                   }
{                                                       }
{       Copyright (C) 2000-03 DeeJayy                   }
{                                                       }
{*******************************************************}
{                     DELPHI 4.0+                       }
{         Copyright (C) 2003       DeeJayy              }
{                                                       }
{*******************************************************}

unit crtplus;

interface

uses windows, crt;

resourcestring
  copyright = 'copyright (c) 2002-2003, DeeJayy';
  homepage  = 'http://deejayy.virtualave.net, http://deejayy.sth.sze.hu';

const

  { control key states }
  CKS_NONE       = $0000;
  CKS_RALT       = $0001;
  CKS_LALT       = $0002;
  CKS_RCONTROL   = $0004;
  CKS_LCONTROL   = $0008;
  CKS_SHIFT      = $0010;
  CKS_NUMLOCK    = $0020;
  CKS_SCROLLLOCK = $0040;
  CKS_CAPSLOCK   = $0080;
  CKS_FUNCKEY    = $0100;
  CKS_ANY        = $FFFF;
  { +++ }
  CKS_MODIFY     = CKS_LALT or CKS_LCONTROL or CKS_SHIFT or CKS_RALT or CKS_RCONTROL;
  CKS_ALT        = CKS_LALT or CKS_RALT;
  CKS_CONTROL    = CKS_LCONTROL or CKS_RCONTROL;

  { File attributes (windows) }
  faRo           =    FILE_ATTRIBUTE_READONLY;
  faHid          =    FILE_ATTRIBUTE_HIDDEN;
  faSys          =    FILE_ATTRIBUTE_SYSTEM;
  faDir          =    FILE_ATTRIBUTE_DIRECTORY;
  faArc          =    FILE_ATTRIBUTE_ARCHIVE;
  faNor          =    FILE_ATTRIBUTE_NORMAL;
  faTmp          =    FILE_ATTRIBUTE_TEMPORARY;
  faCmp          =    FILE_ATTRIBUTE_COMPRESSED;
  faOff          =    FILE_ATTRIBUTE_OFFLINE;
  faAny          =    $00FF;

  { border styles for drawBorder() }
  bsSimple = $0001;
  bsDouble = $0002;

  { border characters for drawBorder() }
  border: array[1..2, 1..6] of char =
  ( ( #218, #196, #191, #179, #192, #217 ),
    ( #201, #205, #187, #186, #200, #188 ) );

  { valid characters for pEdit }
  validchars: set of byte = [ 32..255 ];

  csCheckBox = $0001;
  csRadioButton = $0002;
  check: array[ 1..2, false..true ] of char = ( ( #32, #88 ), ( #32, #07 ) );

type

  { shortcutrec for tShortCut }
  tShortCutRec = record
    controlkeystate: longword;
    virtualkeycode : word;
    execproc: procedure;
  end;

  pScBuf = ^tScBuf;
  tScBuf = array[ 1..25, 1..80 ] of tCharInfo;

var

  buff80x25: pScBuf;
  caretx, carety: integer;
  scbi: tConsoleScreenBufferInfo;
  dwtemp: longword;
  textattr: word;

procedure _dec( var x: integer; limit: integer );
procedure _inc( var x: integer; limit: integer );
function  _min( x: integer; limit: integer ): integer;
function  _max( x: integer; limit: integer ): integer;

function  inttostr( int: integer ): string;
function  strtoint( s: string ): integer;
function  lowercase( s: string ): string;
function  uppercase( s: string ): string;
function  fileexists( s: string ): boolean;

function  coords( x, y: integer ): tCoord;
procedure fillbuff80x25( attr: byte );
procedure redraw;
procedure _write( s: string );
procedure CursorOff;
procedure CursorOn;
function  GetKeyCode(  forceoff: boolean ): _KEY_EVENT_RECORD;
function  GetEvent( forceoff: boolean ): TInputRecord;
procedure GotoXY( X, Y: Byte );

procedure drawBorder( left, top, width, height, style: integer );
procedure drawCBorder( caption: string; left, top, width, height, style: integer );
procedure setCaret( x, y: integer );
procedure TextColor( Color: Byte );
procedure TextBackground( Color: Byte );

function  cmpbyfilename( fd1, fd2: tWin32FindData ): longint;
function  cmpbyfilesize( fd1, fd2: tWin32FindData ): longint;

implementation

procedure _dec( var x: integer; limit: integer );

  begin
    if x > limit then dec( x );
  end;

procedure _inc( var x: integer; limit: integer );

  begin
    if x < limit then inc( x );
  end;

function _min( x: integer; limit: integer ): integer;

  begin
    if x <= limit then result := limit else result := x;
  end;

function _max( x: integer; limit: integer ): integer;

  begin
    if x >= limit then result := limit else result := x;
  end;

function inttostr( int: integer ): string;

  begin
    result := '';
    str( int, result );
  end;

function _ValLong( s: string; var code: integer ): longint;
asm
{       FUNCTION _ValLong( s: AnsiString; VAR code: Integer ) : Longint;        }
{     ->EAX     Pointer to string       }
{       EDX     Pointer to code result  }
{     <-EAX     Result                  }

        PUSH    EBX
        PUSH    ESI
        PUSH    EDI

        MOV     ESI,EAX
        PUSH    EAX             { save for the error case       }

        TEST    EAX,EAX
        JE      @@empty

        XOR     EAX,EAX
        XOR     EBX,EBX
        MOV     EDI,07FFFFFFFH / 10     { limit }

@@blankLoop:
        MOV     BL,[ESI]
        INC     ESI
        CMP     BL,' '
        JE      @@blankLoop

@@endBlanks:
        MOV     CH,0
        CMP     BL,'-'
        JE      @@minus
        CMP     BL,'+'
        JE      @@plus
        CMP     BL,'$'
        JE      @@dollar

        CMP     BL, 'x'
        JE      @@dollar
        CMP     BL, 'X'
        JE      @@dollar
        CMP     BL, '0'
        JNE     @@firstDigit
        MOV     BL, [ESI]
        INC     ESI
        CMP     BL, 'x'
        JE      @@dollar
        CMP     BL, 'X'
        JE      @@dollar
        TEST    BL, BL
        JE      @@endDigits
        JMP     @@digLoop

@@firstDigit:
        TEST    BL,BL
        JE      @@error

@@digLoop:
        SUB     BL,'0'
        CMP     BL,9
        JA      @@error
        CMP     EAX,EDI         { value > limit ?       }
        JA      @@overFlow
        LEA     EAX,[EAX+EAX*4]
        ADD     EAX,EAX
        ADD     EAX,EBX         { fortunately, we can't have a carry    }

        MOV     BL,[ESI]
        INC     ESI

        TEST    BL,BL
        JNE     @@digLoop

@@endDigits:
        DEC     CH
        JE      @@negate
        TEST    EAX,EAX
        JGE     @@successExit
        JMP     @@overFlow

@@empty:
        INC     ESI
        JMP     @@error

@@negate:
        NEG     EAX
        JLE     @@successExit
        JS      @@successExit           { to handle 2**31 correctly, where the negate overflows }

@@error:
@@overFlow:
        POP     EBX
        SUB     ESI,EBX
        JMP     @@exit

@@minus:
        INC     CH
@@plus:
        MOV     BL,[ESI]
        INC     ESI
        JMP     @@firstDigit

@@dollar:
        MOV     EDI,0FFFFFFFH

        MOV     BL,[ESI]
        INC     ESI
        TEST    BL,BL
        JZ      @@empty

@@hDigLoop:
        CMP     BL,'a'
        JB      @@upper
        SUB     BL,'a' - 'A'
@@upper:
        SUB     BL,'0'
        CMP     BL,9
        JBE     @@digOk
        SUB     BL,'A' - '0'
        CMP     BL,5
        JA      @@error
        ADD     BL,10
@@digOk:
        CMP     EAX,EDI
        JA      @@overFlow
        SHL     EAX,4
        ADD     EAX,EBX

        MOV     BL,[ESI]
        INC     ESI

        TEST    BL,BL
        JNE     @@hDigLoop

@@successExit:
        POP     ECX                     { saved copy of string pointer  }
        XOR     ESI,ESI         { signal no error to caller     }

@@exit:
        MOV     [EDX],ESI
        POP     EDI
        POP     ESI
        POP     EBX
end;

function strtoint( s: string ): integer;

  asm
     lea  edx, [dwtemp]
     lea  eax, [s]
     call _ValLong
     mov  [ebp-$08], eax
  end;

function  lowercase( s: string ): string;

  var

    e: integer;

  begin
    result := s;
    for e := 1 to length( s ) do
      if s[ e ] in [ 'A'..'Z' ] then result[ e ] := chr( ord( s[ e ] ) + 31 );
  end;

function  uppercase( s: string ): string;

  var

    e: integer;

  begin
    result := s;
    for e := 1 to length( s ) do
      if s[ e ] in [ 'a'..'z' ] then result[ e ] := chr( ord( s[ e ] ) - 31 );
  end;

function fileexists( s: string ): boolean;

  var

    handle      : longint;
    fd          : twin32finddata;

  begin

    handle := findfirstfile( pchar( s ), fd );
    result := handle <> -1;
    findclose( handle );

  end;

function coords( x, y: integer ): tCoord;

  begin

    result.X := X;
    result.Y := Y;

  end;

procedure fillbuff80x25( attr: byte );

  var

    e: integer;

  begin

    for e := 1 to 2000 do
      begin
        buff80x25[ 1, e ].Attributes := attr;
        buff80x25[ 1, e ].AsciiChar := ' ';
      end;
    redraw;

  end;

procedure redraw;

  begin

    writeconsoleoutput( WHandle, buff80x25, scbi.dwSize, coords( 0, 0 ), scbi.srWindow );

  end;

procedure _write( s: string );

  var

    e: integer;

  begin

    for e := 1 to length( s ) do
      begin
        buff80x25[ carety, caretx + e - 1 ].AsciiChar := s[ e ];
        buff80x25[ carety, caretx + e - 1 ].Attributes := textattr;
      end;

    caretx := caretx + length( s );
    carety := carety + ( ( caretx + length( s ) ) div 80 ) * 1;

  end;

procedure GotoXY( X, Y: Byte );

  begin

    SetConsoleCursorPosition( WHandle, coords( x - 1, y - 1 ) );

  end;

procedure FillRect( left, top, width, height: integer );

  var

    scx, scy, w, h: integer;

  begin
    scx := caretx;
    scy := carety;
    for w := left to left + width do
      for h := top to top + height do
        begin
          setcaret( w, h );
          _write( ' ' );
        end;
    setcaret( scx, scy );
  end;

procedure drawBorder( left, top, width, height, style: integer );

  var

    e: integer;

  begin
    fillrect( left, top, width, height );

    setcaret( left, top );
    _write( border[ style, 1 ] );

    for e := left + 1 to left + width - 1 do
      _write( border[ style, 2 ] );

    _write( border[ style, 3 ] );

    for e := top + 1 to top + height - 1 do
      begin
        setcaret( left, e );
        _write( border[ style, 4 ] );
        setcaret( left + width, e );
        _write( border[ style, 4 ] );
      end;

    setcaret( left, top + height );

    _write( border[ style, 5 ] );

    for e := left + 1 to left + width - 1 do
      _write( border[ style, 2 ] );

    _write( border[ style, 6 ] );

    redraw;

  end;

procedure CursorOff;

  var

    CrInfo: _CONSOLE_CURSOR_INFO;

  begin

    GetConsoleCursorInfo( WHandle, CrInfo );
    CrInfo.bVisible := False;
    SetConsoleCursorInfo( WHandle, CrInfo );

  end;

procedure CursorOn;

  var

    CrInfo: _CONSOLE_CURSOR_INFO;

  begin

    GetConsoleCursorInfo( WHandle, CrInfo );
    CrInfo.bVisible := True;
    SetConsoleCursorInfo( WHandle, CrInfo );

  end;

function GetKeyCode( forceoff: boolean ): _KEY_EVENT_RECORD;

  var

    NumRead:       LongWord;
    InputRec:      TInputRecord;

  begin

    repeat
      ReadConsoleInput( RHandle, InputRec, 1, NumRead );
      if InputRec.EventType <> KEY_EVENT then Continue;

      if InputRec.Event.KeyEvent.bKeyDown then
        begin
          result := InputRec.Event.KeyEvent;
          Exit;
        end

    until forceoff;

  end;

function GetEvent( forceoff: boolean ): TInputRecord;

  begin

    repeat
      ReadConsoleInput( RHandle, result, 1, dwtemp );
    until forceoff;

  end;

procedure drawCBorder( caption: string; left, top, width, height, style: integer );

  var

    e, l: integer;

  begin
    fillrect( left, top, width, height );

    setcaret( left, top );
    _write( border[ style, 1 ] );

    //
    if length( caption ) > width - 2 then
      caption := copy( caption, 1, width - 8 ) + '...';

    if caption <> '' then
      begin
        l := length( caption );
        for e := left + 1 to ( left + ( width - l ) div 2 ) - 1 do
          _write( border[ style, 2 ] );
        _write( ' ' + caption + ' ' );
        for e := ( left + ( width - l ) div 2 ) + l + 2 to left + width - 1 do
          _write( border[ style, 2 ] );
      end
    else
      for e := left + 1 to left + width - 1 do
        _write( border[ style, 2 ] );

    //
    _write( border[ style, 3 ] );

    for e := top + 1 to top + height - 1 do
      begin
        setcaret( left, e );
        _write( border[ style, 4 ] );
        setcaret( left + width, e );
        _write( border[ style, 4 ] );
      end;

    setcaret( left, top + height );

    _write( border[ style, 5 ] );

    for e := left + 1 to left + width - 1 do
      _write( border[ style, 2 ] );

    _write( border[ style, 6 ] );

    redraw;

  end;

procedure setCaret( x, y: integer );

  begin

    caretx := x;
    carety := y;

  end;

procedure TextColor( Color: Byte );

  begin

    textattr := ( color and $f ) or ( textattr and $f0 );

  end;

procedure TextBackground( Color: Byte );

  begin

    textattr := ( color shl 4 ) or ( textattr and $f );

  end;

function  cmpbyfilename( fd1, fd2: tWin32FindData ): longint;

  begin
    if lowercase( fd1.cFileName ) > lowercase( fd2.cFileName ) then result := 1 else result := -1;
  end;

function  cmpbyfilesize( fd1, fd2: tWin32FindData ): longint;

  begin
    if fd1.nFileSizeLow > fd2.nFileSizeLow then result := 1 else result := -1;
  end;

initialization

  write( copyright, '  ', homepage );
  caretx := 1;
  carety := 1;
  textattr := $07;
  getmem( buff80x25, sizeof( tScBuf ) );
  getconsolescreenbufferinfo( WHandle, scbi );

end.
