unit fpgui_h;
{this is the dynamic loading version of fpglib library wrapper.
load fpglib library with fpglib_loadlib() and release it with fpglib_unloadlib().

with reference counter too...

 fred van stappen / fiens@hotmail.com
}
{$defIne Assistive}     //// uncomment if use assistive fpguI library

interface

uses
   {$Ifdef unIX}
  cthreads,
  cwstring, {$endIf}
  dynlibs, ctypes;

 type
 tproc = procedure(senderformIndex, sendertypeIndex, senderIndex : cint32);

var
  /// fpg_main
  fpginitialize: procedure(); cdecl;
  fpgrun: procedure(); cdecl;
  fpgprocessmessages: procedure(); cdecl;
  fpggetscreendpi: function() : cint32; cdecl;
  {$If defIned(Assistive)}
   /// Assistive kit
  fpgenableAssistivecust : function(portaudiolib: pchar; espeaklib: pchar;
  espeakdatadir: pchar) : cint32 ; cdecl;
  fpgenableAssistive: function() : integer ; cdecl;
  fpgdisableAssistive: function() : integer ; cdecl;
  fpgfreeAssistive: function() : integer ; cdecl;
  {$endif}
  //// style manager
  fpgsetstyle: procedure(style : pchar); cdecl;
  /// fpg_form
  fpgformcreate: procedure (index:cint32; Aowner: integer); cdecl;  /// if Aowner < 0 then no owner
  fpgformname: procedure(Index: cint32; fname : pchar); cdecl;
  fpgformsetposition: procedure(index : cint32; aleft, atop, awidth, aheight: integer); cdecl;
  fpgformwindowtitle: procedure(Index: cint32; wtitle: pchar); cdecl;
  fpgformupdateposition: procedure(Index: cint32); cdecl;
  fpgformshow: procedure(Index: cint32); cdecl;
  fpgformscreenposition: procedure(index : cint32; pos : cint32); cdecl;
  fpgformshowmodal: procedure(index : cint32); cdecl;
  fpgformsetvisible: procedure(index : cint32; visible : cbool) ; cdecl;
  fpgformgetvisible: function(index : cint32) : cbool ; cdecl;
  fpgformsetenabled: procedure(index : cint32; enable : cbool) ; cdecl;
  fpgformgetenabled: function(index : cint32) : cbool ; cdecl;
  fpgformclose: procedure(Index: cint32); cdecl;
  fpgformhide: procedure(Index: cint32); cdecl;
  fpgformonclick: procedure(index : cint32; aproc: tproc); cdecl;
  fpgformbackgroundcolor: procedure(index : cint32; color : longword); cdecl;
  fpgformsetleft: procedure(index : cint32 ; pos : integer); cdecl;
  fpgformsettop: procedure(index : cint32 ; pos : integer); cdecl;
  fpgformsetheight: procedure(index : cint32 ; pos : integer); cdecl;
  fpgformsetwidth: procedure(index : cint32 ; pos : integer); cdecl;
  fpgformgetleft: function(index : cint32) : integer; cdecl;
  fpgformgettop: function(index : cint32) : integer; cdecl;
  fpgformgetheight: function(index : cint32) : integer; cdecl;
  fpgformgetwidth: function(index : cint32) : integer; cdecl;
  fpgformAttributes: procedure(index : cint32; atb : cint32); cdecl;
  fpgformtype: procedure(index : cint32; typ : cint32); cdecl;

  {fpgformAftercreate: procedure(index : cint32; aproc: tproc); cdecl;}

  /// fpg_button
   fpgbuttoncreate: procedure (formindex: cint32; index:cint32 ;  ownertype: cint32; ownerIndex: cint32); cdecl;
   fpgbuttonshow: procedure(formindex: cint32; Index: cint32); cdecl;
   fpgbuttonhide: procedure(formindex: cint32; Index: cint32); cdecl;
   fpgbuttonsetvisible: procedure(formindex: cint32; index : cint32; visible : cbool) ; cdecl;
  fpgbuttongetvisible: function(formindex: cint32; index : cint32) : cbool ; cdecl;
  fpgbuttonsetenabled: procedure(formindex: cint32; index : cint32; enable : cbool) ; cdecl;
  fpgbuttongetenabled: function(formindex: cint32; index : cint32) : cbool ; cdecl;
   fpgbuttononclick: procedure(formindex: cint32; index : cint32; aproc: tproc); cdecl;
   fpgbuttonbackgroundcolor: procedure(formindex: cint32; index : cint32; color : longword); cdecl;
  fpgbuttonsetleft: procedure(formindex: cint32; index : cint32 ; pos : integer); cdecl;
  fpgbuttonsettop: procedure(formindex: cint32; index : cint32 ; pos : integer); cdecl;
  fpgbuttonsetheight: procedure(formindex: cint32; index : cint32 ; pos : integer); cdecl;
  fpgbuttonsetwidth: procedure(formindex: cint32; index : cint32 ; pos : integer); cdecl;
  fpgbuttongetleft: function(formindex: cint32; index : cint32) : integer; cdecl;
  fpgbuttongettop: function(formindex: cint32; index : cint32) : integer; cdecl;
  fpgbuttongetheight: function(formindex: cint32; index : cint32) : integer; cdecl;
  fpgbuttongetwidth: function(formindex: cint32; index : cint32) : integer; cdecl;
  fpgbuttonsettext: procedure(formindex: cint32; Index: cint32; texte: pchar); cdecl;
  fpgbuttongettext: function(formindex: cint32; Index: cint32): pchar; cdecl;
  fpgbuttonupdateposition: procedure(formindex: cint32; Index: cint32); cdecl;
  fpgbuttonsetposition: procedure(formindex: cint32; index : cint32; aleft, atop, awidth, aheight: integer); cdecl;

  libhandle: tlibhandle = dynlibs.nilhandle;
  referencecounter: cint32 = 0;

function fpg_Isloaded: cbool; inline;
function fpg_loadlib(const fpglibfilename: pchar): cbool;
procedure fpg_unloadlib();

implementation

function fpg_Isloaded: cbool;
begin
  result := (libhandle <> dynlibs.nilhandle);
end;

function fpg_loadlib(const fpglibfilename: pchar): cbool;
begin
  result := false;
  if libhandle <> 0 then
  begin
    Inc(referencecounter);
    result := true;
  end
  else
  begin
    if length(fpglibfilename) = 0 then exit;
    libhandle := dynlibs.loadlibrary(fpglibfilename); // obtain the handle we want
    if libhandle <> dynlibs.nilhandle then
    begin
      try
        ///// fpg_main
        pointer(fpgInitialize) := getprocAddress(libhandle, 'fpginitialize');
        pointer(fpgrun) := getprocAddress(libhandle, 'fpgrun');
        pointer(fpgprocessmessages) := getprocAddress(libhandle, 'fpgprocessmessages');
        pointer(fpggetscreendpi) := getprocAddress(libhandle, 'fpggetscreendpi');

        {$If defIned(Assistive)}
        ///// Assistive
        pointer(fpgenableAssistive) := getprocAddress(libhandle, 'fpgenableassistive');
        pointer(fpgdisableAssistive) := getprocAddress(libhandle, 'fpgdisableassistive');
        pointer(fpgfreeAssistive) := getprocAddress(libhandle, 'fpgfreeassistive');
        {$endif}
        ///// style manager
        pointer(fpgsetstyle) := getprocAddress(libhandle,'fpgsetstyle');

        ///// fpg_form
        pointer(fpgformcreate) := getprocAddress(libhandle, 'fpgformcreate');
        pointer(fpgformname) := getprocAddress(libhandle, 'fpgformname');
        pointer(fpgformsetposition) := getprocAddress(libhandle, 'fpgformsetposition');
        pointer(fpgformwindowtitle) := getprocAddress(libhandle, 'fpgformwindowtitle');
        pointer(fpgformupdateposition) := getprocAddress(libhandle, 'fpgformupdateposition');
        pointer(fpgformshow) := getprocAddress(libhandle, 'fpgformshow');
        pointer(fpgformhide) := getprocAddress(libhandle, 'fpgformhide');
        pointer(fpgformclose) := getprocAddress(libhandle, 'fpgformclose');
        pointer(fpgformonclick) := getprocAddress(libhandle, 'fpgformonclick');
        pointer(fpgformscreenposition) := getprocAddress(libhandle, 'fpgformscreenposition');
        pointer(fpgformshowmodal) := getprocAddress(libhandle, 'fpgformshowmodal');
        //pointer(fpgformAftercreate) := getprocAddress(libhandle, 'fpgformAftercreate');
        pointer(fpgformbackgroundcolor) := getprocAddress(libhandle, 'fpgformbackgroundcolor');
        pointer(fpgformsetleft) := getprocAddress(libhandle, 'fpgformsetleft');
        pointer(fpgformsettop) := getprocAddress(libhandle, 'fpgformsettop');
        pointer(fpgformsetwidth) := getprocAddress(libhandle, 'fpgformsetwidth');
        pointer(fpgformsetheight) := getprocAddress(libhandle, 'fpgformsetheight');
        pointer(fpgformgetleft) := getprocAddress(libhandle, 'fpgformgetleft');
        pointer(fpgformgettop) := getprocAddress(libhandle, 'fpgformgettop');
        pointer(fpgformgetwidth) := getprocAddress(libhandle, 'fpgformgetwidth');
        pointer(fpgformgetheight) := getprocAddress(libhandle, 'fpgformgetheight');
        pointer(fpgformsetvisible) := getprocAddress(libhandle, 'fpgformsetvisible');
        pointer(fpgformgetvisible) := getprocAddress(libhandle, 'fpgformgetvisible');
        pointer(fpgformsetenabled) := getprocAddress(libhandle, 'fpgformsetenabled');
        pointer(fpgformgetenabled) := getprocAddress(libhandle, 'fpgformgetenabled');
        pointer(fpgformAttributes) := getprocAddress(libhandle, 'fpgformtype');

         ////// fpg_button
        pointer(fpgbuttoncreate) := getprocAddress(libhandle, 'fpgbuttoncreate');
        pointer(fpgbuttonshow) := getprocAddress(libhandle, 'fpgbuttonshow');
        pointer(fpgbuttonhide) := getprocAddress(libhandle, 'fpgbuttonhide');
        pointer(fpgbuttononclick) := getprocAddress(libhandle, 'fpgbuttononclick');
        pointer(fpgbuttonbackgroundcolor) := getprocAddress(libhandle, 'fpgbuttonbackgroundcolor');
        pointer(fpgbuttonsetleft) := getprocAddress(libhandle, 'fpgbuttonsetleft');
        pointer(fpgbuttonsettop) := getprocAddress(libhandle, 'fpgbuttonsettop');
        pointer(fpgbuttonsetwidth) := getprocAddress(libhandle, 'fpgbuttonsetwidth');
        pointer(fpgbuttonsetheight) := getprocAddress(libhandle, 'fpgbuttonsetheight');
        pointer(fpgbuttongetleft) := getprocAddress(libhandle, 'fpgbuttongetleft');
        pointer(fpgbuttongettop) := getprocAddress(libhandle, 'fpgbuttongettop');
        pointer(fpgbuttongetwidth) := getprocAddress(libhandle, 'fpgbuttongetwidth');
        pointer(fpgbuttongetheight) := getprocAddress(libhandle, 'fpgbuttongetheight');
        pointer(fpgbuttonsettext) := getprocAddress(libhandle, 'fpgbuttonsettext');
        pointer(fpgbuttongettext) := getprocAddress(libhandle, 'fpgbuttongettext');
        pointer(fpgbuttonupdateposition) := getprocAddress(libhandle, 'fpgbuttonupdateposition');
        pointer(fpgbuttonsetposition) := getprocAddress(libhandle, 'fpgbuttonsetposition');
        pointer(fpgbuttonsetvisible) := getprocAddress(libhandle, 'fpgbuttonsetvisible');
        pointer(fpgbuttongetvisible) := getprocAddress(libhandle, 'fpgbuttongetvisible');
        pointer(fpgbuttonsetenabled) := getprocAddress(libhandle, 'fpgbuttonsetenabled');
        pointer(fpgbuttongetenabled) := getprocAddress(libhandle, 'fpgbuttongetenabled');

        referencecounter := 1;

        result := fpg_Isloaded;
      except
        fpg_unloadlib();
      end;
    end;
  end;
end;

procedure fpg_unloadlib();
begin
   // < reference counting
  if referencecounter > 0 then
    dec(referencecounter);
  if referencecounter > 0 then
    exit;
  // >
    if libhandle <> dynlibs.nilhandle then
  begin
    dynlibs.unloadlibrary(libhandle);
    libhandle := dynlibs.nilhandle;
  end;
end;

end.