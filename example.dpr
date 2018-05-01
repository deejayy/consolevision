{$APPTYPE CONSOLE}
{$H-}
uses crt, cvext, crtplus, windows;

var

  applet: pApplet;

  button1, button2: pButton;
  edit1: pEdit;
  listbox1: pListBox;
  checkbox1: pCheckBox;
  memo1: pMemo;
  combobox1: pComboBox;
  drivecombobox1: pDriveComboBox;
  label1: pLabel;

procedure quit;
begin

  destroyall( applet );
  halt;

end;

procedure refresh;
begin

  clrscr;
  repaintall( applet );

end;

BEGIN

  applet := newapplet( 1, 1, 80, 25, '', CKS_ALT, ord( 'X' ) );

  button1 := newbutton( applet );
  with button1^ do
  begin
    text := 'gomb';
    top := 2;
    left := 2;
    color := 7;
    activecolor := 15;
    focused := true;
  end;

  button2 := newbutton( applet );
  with button2^ do
  begin
    text := 'kil‚p‚s';
    top := 4;
    left := 2;
    color := 7;
    activecolor := 15;
    exec := quit;
  end;

  label1 := newlabel( applet, 14, 2, 35, 'ez itt egy sima label de mi lenne, ha latszana is ?' );

  listbox1 := newlistbox( applet );
  with listbox1^ do
  begin
    top := 6;
    left := 2;
    color := 7;
    activecolor := 15;
    add( 'elso sor', false );
    add( '2. sor', false );
    add( '3. sor', false );
    add( '4. sor', false );
    add( '5. sor', false );
    add( '6. sor', false );
    add( '7. sor', false );
    add( '8. sor', false );
    add( '9. sor', false );
    add( 'a t”bbit l sd a forr sban', true );
  end;

  checkbox1 := newcheckbox( applet );
  with checkbox1^ do
  begin
    top := 13;
    left := 2;
    width := 20;
    color := 7;
    activecolor := 15;
    text := 'rem‚lem ez az‚rt mûk”dik..., ‚s igen :)'
  end;

  memo1 := newmemo( applet );
  with memo1^ do
  begin
    top := 15;
    left := 2;
    color := 7;
    activecolor := 15;
    add( 'sajnos csak ilyen gagyi adatokkal fogom felt”lteni megint', false );
    add( '2. sor', false );
    add( '3. sor', false );
    add( '4. sor', false );
    add( '5. sor', false );
    add( '6. sor', false );
    add( '7. sor', false );
    add( '8. sor', false );
    add( '9. sor', false );
    add( 'a t”bbit l sd a forr sban', false );
  end;

  combobox1 := newcombobox( applet );
  with combobox1^ do
  begin
    top := 4;
    left := 30;
    width := 40;
    bgcolor := 9;
    color := 7;
    activecolor := 15;
    add( 'ctrl+le' );
    add( '‚s ¡me a combobox' );
    add( 'enter=kiv laszt' );
    add( 'ha ez a lista nincs' );
    add( 'akkor alt+fel, ‚s alt+le' );
    add( 'v ltogat' );

  end;

  drivecombobox1 := newdrivecombobox( applet );
  with drivecombobox1^ do
  begin
    top := 6;
    left := 30;
    bgcolor := 9;
    activecolor := 15;
  end;

  shortcuts := newshortcut( applet );
  shortcuts.add( CKS_LALT or CKS_RALT, VK_F4, @quit );
  shortcuts.add( CKS_LCONTROL or CKS_RCONTROL, Ord( 'R' ), @refresh );

  run( applet );

END.