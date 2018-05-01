{$APPTYPE CONSOLE}
uses

  crt, cvext, crtplus, windows;

var

  app: pApplet;
  leftpanel, rightpanel: pFileListBox;
  i: integer;
  files: TWin32FindData;

BEGIN

  scbgcolor := 9;

  app := newApplet( 1, 1, 80, 25, '', CKS_ALT, Ord('X') );

  leftpanel := newFileListBox( app, 'c:\' );
  with leftpanel^ do
  begin
    left := 1;
    top := 1;
    width := 39;
    height := 24;
    bgcolor := 9;
    crcolora := crcolori;
  end;

  rightpanel := newFileListBox( app, 'c:\' );
  with rightpanel^ do
  begin
    left := 41;
    top := 1;
    width := 39;
    height := 24;
    bgcolor := 9;
    crcolora := crcolori;
    focused := true;
  end;

  run( app );

END.