library fpgui;
{$mode objfpc}

{$DEFINE Java}     //// uncomment if you want a Java-compatible fpGUI library
                   ///   ( do not forget to uncomment fpglib_class too )

{$DEFINE assistive}     //// uncomment if you want assistive fpGUI library

uses
 cmem,                 /// uncomment if you need cmem
 {$IF DEFINED(assistive)}
  sakfpg,
  {$endif}
  {$IF DEFINED(Java)}
     jni,
   {$endif} 
  sysutils,
 ctypes,
 fpg_form,
 classes,
  fpglib_class,
 fpg_base,
  fpg_main,
 fpg_stylemanager,
  mystyle;

type
 Tproc = procedure(senderformIndex, senderTypeIndex, senderIndex : cint32);

 {$IF DEFINED(Java) or DEFINED(assistive)}
     var
  {$endif}

     {$IF DEFINED(Java)}
        theclass : JClass;
      {$endif}

 {$IF DEFINED(assistive)}

  Isassistive : cbool = false;
 //////// sak assistive kit
 function fpgenableassistive({$IF DEFINED(Java)}PEnv: PJNIEnv; Obj: JObject {$endif}) : cint32 ; cdecl;
 begin
result := sakfpg.saKLoadlib() ;
 if result <> -1 then Isassistive := true else Isassistive := false;
 end;

{$IF DEFINED(Java)}
function fpgenableassistivecust(PEnv: PJNIEnv; Obj: JObject; portaudioLib: JString; espeakLib: JString;
  espeakDataDir: JString) : cint32 ; cdecl;
  begin
result := sakfpg.saKLoadLibcust((PEnv^^).GetStringUTFChars(PEnv, portaudioLib, nil),
                             (PEnv^^).GetStringUTFChars(PEnv, espeakLib, nil),
                             (PEnv^^).GetStringUTFChars(PEnv, espeakDataDir, nil));
      (PEnv^^).ReleaseStringUTFChars(PEnv, portaudioLib, nil);
      (PEnv^^).ReleaseStringUTFChars(PEnv, espeakLib, nil);
      (PEnv^^).ReleaseStringUTFChars(PEnv, espeakDataDir, nil);
if result <> -1 then Isassistive := true else Isassistive := false;
 end;
{$else}
function fpgenableassistivecust(portaudioLib: pchar; espeakLib: pchar;
  espeakDataDir: pchar) : cint32 ; cdecl;
 begin
result := sakfpg.saKLoadLibcust(portaudioLib, espeakLib, espeakDataDir) ;
 if result <> -1 then Isassistive := true else Isassistive := false;
 end;
{$endif}

 function fpgdisableassistive({$IF DEFINED(Java)}PEnv: PJNIEnv; Obj: JObject {$endif}) : cint32 ; cdecl;
 begin
result := sakfpg.saKunLoadlib() ;
 Isassistive := false;
 end;

function fpgfreeassistive({$IF DEFINED(Java)}PEnv: PJNIEnv; Obj: JObject {$endif}) : cint32 ; cdecl;
 begin
result := sakfpg.saKFreeLib() ;
 Isassistive := false;
 end;

{$endif}

///////////////// fpg_main

{$IF DEFINED(Java)}
procedure fpgInitialize({$IF DEFINED(Java)} PEnv: PJNIEnv; Obj: JObject ; MClass : Jstring {$endif}); cdecl;
var
MainClass : Pchar ;
begin
 MainClass :=  (PEnv^^).GetStringUTFChars(PEnv, MClass, nil);
 theclass := (PEnv^^).FindClass(PEnv,MainClass) ;
 setlength(afpgform,0);
 fpgapplication.Initialize;
 (PEnv^^).ReleaseStringUTFChars(PEnv, MClass, nil);
end;
{$else}
procedure fpgInitialize(); cdecl;
begin
setlength(afpgform,0);
fpgapplication.Initialize;
end;
{$endif}

procedure fpgRun({$IF DEFINED(Java)} PEnv: PJNIEnv; Obj: JObject {$endif}); cdecl;
begin
fpgapplication.Run;
end;

procedure fpgprocessMessages({$IF DEFINED(Java)} PEnv: PJNIEnv; Obj: JObject {$endif}); cdecl;
begin
fpgapplication.processMessages;
end;

function fpggetscreenDpi({$IF DEFINED(Java)} PEnv: PJNIEnv; Obj: JObject {$endif}) : cint32; cdecl;
begin
result := fpgapplication.screen_dpi;
end;

/////// style Manager
procedure fpgsetstyle({$IF DEFINED(Java)} PEnv: PJNIEnv; Obj: JObject ; {$endif}style: {$IF DEFINED(Java)} JString {$else} PChar {$endif}); cdecl;
begin
   {$IF DEFINED(Java)}
   if fpgstyleManager.setstyle((PEnv^^).GetStringUTFChars(PEnv, style, nil)) then
     fpgstyle := fpgstyleManager.style;
    (PEnv^^).ReleaseStringUTFChars(PEnv, style, nil);
      {$else}
  if fpgstyleManager.setstyle(style) then
     fpgstyle := fpgstyleManager.style;
    {$endif}
  end;

///////////////// fpg_form

procedure fpgformcreate({$IF DEFINED(Java)} PEnv: PJNIEnv; Obj: JObject; {$endif} index:cint32 ; aOwner: cint32); cdecl;  /// if aOwner < 0 then no owner
var
TheOwner: Tcomponent ;
{$IF DEFINED(assistive)}
orilength : cint32;
{$endif}
begin

   {$IF DEFINED(assistive)}
   orilength := length(afpgform) ;
   {$endif}
   if index+1 > length(afpgform) then setlength(afpgform,index+1);
  {$IF DEFINED(assistive)}
   if orilength < length(afpgform) -1 then
      begin
      while orilength < length(afpgform) -1
     do begin
     afpgform[orilength] := TXform.create(nil);
     afpgform[orilength].close;
     inc(orilength) ;
     end;
     end;
    {$endif}
     if afpgform[index] <> nil then  afpgform[index].close;
     if (aOwner > -1) and (aOwner < length(afpgform)) then TheOwner :=  afpgform[index] else TheOwner := nil ;
     afpgform[index] := TXform.create(TheOwner);
     setlength(afpgform[index].afpgbutton,0);
     afpgform[index].Name:= 'form' + inttostr(index);
     afpgform[index].Index  := index ;
     afpgform[index].Onclick:= nil;
     afpgform[index].TypeObj:= 0;
     afpgform[index].onclickproc := nil ;
     {$IF DEFINED(assistive)}
     if Isassistive = true then
      begin
      Initspeech.Timercount.enabled := false;
      Initspeech.Timercount.enabled := true;
      end;
     {$endif}
end;

{$IF DEFINED(Java)}
procedure fpgformOnclick(PEnv: PJNIEnv; Obj: JObject; index: cint32; aproc: JString); cdecl;
var
theproc : pchar ;
begin
 theproc := (PEnv^^).GetStringUTFChars(PEnv, aproc, nil);
 afpgform[index].PEnv := PEnv;
 afpgform[index].Obj:= Obj;
 afpgform[index].onClickProc := (PEnv^^).GetStaticMethodID(PEnv,theclass,theproc,'()V')  ;
{$else}
procedure fpgformOnclick(index : cint32; aproc: Tproc); cdecl;
begin
 afpgform[index].onclickproc := aproc ;
{$endif}
afpgform[index].Onclick:= @afpgform[index].onclickpr;
end;

{$IF DEFINED(Java)}
procedure fpgformOnclose(PEnv: PJNIEnv; Obj: JObject; index: cint32; aproc: JString); cdecl;
var
theproc : pchar ;
begin
 theproc := (PEnv^^).GetStringUTFChars(PEnv, aproc, nil);
 afpgform[index].PEnv := PEnv;
 afpgform[index].Obj:= Obj;
 afpgform[index].onCloseProc := (PEnv^^).GetStaticMethodID(PEnv,theclass,theproc,'()V')  ;
{$else}
procedure fpgformOnclose(index : cint32; aproc: Tproc); cdecl;
begin
 afpgform[index].oncloseproc := aproc ;
{$endif}
afpgform[index].Onclose:= @afpgform[index].onclosepr;
end;


procedure fpgformName({$IF DEFINED(Java)} PEnv: PJNIEnv; Obj: JObject; {$endif} index : cint32; fname: {$IF DEFINED(Java)} JString {$else} PChar {$endif}); cdecl;
begin
{$IF DEFINED(Java)}
afpgform[index].Name :=  (PEnv^^).GetStringUTFChars(PEnv, fname, nil);
(PEnv^^).ReleaseStringUTFChars(PEnv, fname, nil);
 {$else}
 afpgform[index].Name := fname;
 {$endif}
end;

procedure fpgformsetposition({$IF DEFINED(Java)} PEnv: PJNIEnv; Obj: JObject; {$endif} index : cint32; aleft, atop, awidth, aheight: cint32); cdecl;
begin
afpgform[index].setposition(aleft, atop, awidth, aheight) ;
end;

procedure fpgformWindowTitle({$IF DEFINED(Java)} PEnv: PJNIEnv; Obj: JObject; {$endif} index : cint32; wtitle: {$IF DEFINED(Java)} JString  {$else} PChar {$endif}); cdecl;
begin
   {$IF DEFINED(Java)}
  afpgform[index].WindowTitle  := (PEnv^^).GetStringUTFChars(PEnv, wtitle, nil);
     (PEnv^^).ReleaseStringUTFChars(PEnv, wtitle, nil);
    {$else}
   afpgform[index].WindowTitle  := wtitle;
    {$endif}
  end;

procedure fpgformupdateposition({$IF DEFINED(Java)} PEnv: PJNIEnv; Obj: JObject; {$endif} index : cint32); cdecl;
begin
afpgform[index].updateWindowposition;
end;

procedure fpgformsetvisible({$IF DEFINED(Java)} PEnv: PJNIEnv; Obj: JObject; {$endif} index : cint32; visible : cbool); cdecl;
begin
afpgform[index].visible:= visible ;
end;

function fpgformgetvisible({$IF DEFINED(Java)} PEnv: PJNIEnv; Obj: JObject; {$endif} index : cint32): cbool; cdecl;
begin
result := afpgform[index].visible ;
end;

procedure fpgformsetenabled({$IF DEFINED(Java)} PEnv: PJNIEnv; Obj: JObject; {$endif} index : cint32; enable : cbool); cdecl;
begin
afpgform[index].enabled:= enable ;
end;

function fpgformgetenabled({$IF DEFINED(Java)} PEnv: PJNIEnv; Obj: JObject; {$endif} index : cint32): cbool; cdecl;
begin
result := afpgform[index].enabled ;
end;

procedure fpgformshow({$IF DEFINED(Java)} PEnv: PJNIEnv; Obj: JObject; {$endif} index : cint32); cdecl;
begin
afpgform[index].show;
end;

procedure fpgformType({$IF DEFINED(Java)} PEnv: PJNIEnv; Obj: JObject; {$endif} index : cint32; typ : cint32); cdecl;
begin
case typ of
0 : afpgform[index].WindowType:= wtchild;
1 : afpgform[index].WindowType:= wtWindow;
2 : afpgform[index].WindowType:= wtModalform;
3 : afpgform[index].WindowType:= wtpopup;
end;
end;

procedure fpgformattributes({$IF DEFINED(Java)} PEnv: PJNIEnv; Obj: JObject; {$endif} index : cint32; atb : cint32); cdecl;
begin
case atb of
0 : afpgform[index].Windowattributes:= [];
1 : afpgform[index].Windowattributes:= afpgform[index].Windowattributes + [wasizeable];
2 : afpgform[index].Windowattributes:= afpgform[index].Windowattributes + [waautopos];
3 : afpgform[index].Windowattributes:=  afpgform[index].Windowattributes + [wascreencenterpos];
4 : afpgform[index].Windowattributes:=  afpgform[index].Windowattributes + [wastayOntop];
5 : afpgform[index].Windowattributes:= afpgform[index].Windowattributes + [waFullscreen];
6 : afpgform[index].Windowattributes:= afpgform[index].Windowattributes + [waborderless];
7 : afpgform[index].Windowattributes:= afpgform[index].Windowattributes + [waunblockableMessages];
8 : afpgform[index].Windowattributes:= afpgform[index].Windowattributes + [waX11skipWMHints];
9 : afpgform[index].Windowattributes:= afpgform[index].Windowattributes + [waOneThirdDownpos];
end;
end;

procedure fpgformshowModal({$IF DEFINED(Java)} PEnv: PJNIEnv; Obj: JObject; {$endif} index : cint32); cdecl;
begin
afpgform[index].showModal;
end;


procedure fpgformscreenposition({$IF DEFINED(Java)} PEnv: PJNIEnv; Obj: JObject; {$endif} index : cint32; pos : cint32); cdecl;
begin
case pos of
0: afpgform[index].Windowposition:= wpuser;
1: afpgform[index].Windowposition:= wpauto;
2: afpgform[index].Windowposition:= wpscreencenter;
3: afpgform[index].Windowposition:= wpOneThirdDown;
end;
end;

procedure fpgformhide({$IF DEFINED(Java)} PEnv: PJNIEnv; Obj: JObject; {$endif} index : cint32); cdecl;
begin
afpgform[index].hide;
end;

procedure fpgformclose({$IF DEFINED(Java)} PEnv: PJNIEnv; Obj: JObject; {$endif} index : cint32); cdecl;
begin
afpgform[index].close;
end;

procedure fpgformsetleft({$IF DEFINED(Java)} PEnv: PJNIEnv; Obj: JObject; {$endif} index : cint32 ; pos : cint32); cdecl;
begin
afpgform[index].left:= pos;
end;

function fpgformgetleft({$IF DEFINED(Java)} PEnv: PJNIEnv; Obj: JObject; {$endif} index : cint32) : cint32; cdecl;
begin
result := afpgform[index].left;
end;

procedure fpgformsettop({$IF DEFINED(Java)} PEnv: PJNIEnv; Obj: JObject; {$endif} index : cint32 ; pos : cint32); cdecl;
begin
afpgform[index].top:= pos;
end;

function fpgformgettop({$IF DEFINED(Java)} PEnv: PJNIEnv; Obj: JObject; {$endif} index : cint32) : cint32; cdecl;
begin
result := afpgform[index].top;
end;

procedure fpgformsetheight({$IF DEFINED(Java)} PEnv: PJNIEnv; Obj: JObject; {$endif} index : cint32 ; pos : cint32); cdecl;
begin
afpgform[index].height:= pos;
end;

function fpgformgetheight({$IF DEFINED(Java)} PEnv: PJNIEnv; Obj: JObject; {$endif} index : cint32) : cint32; cdecl;
begin
result := afpgform[index].height;
end;

procedure fpgformsetwidth({$IF DEFINED(Java)} PEnv: PJNIEnv; Obj: JObject; {$endif} index : cint32 ; pos : cint32); cdecl;
begin
afpgform[index].width:= pos;
end;

function fpgformgetwidth({$IF DEFINED(Java)} PEnv: PJNIEnv; Obj: JObject; {$endif} index : cint32) : cint32; cdecl;
begin
result := afpgform[index].width;
end;

procedure fpgformbackgroundcolor({$IF DEFINED(Java)} PEnv: PJNIEnv; Obj: JObject; {$endif} index : cint32; color : longword); cdecl;
begin
afpgform[index].backgroundcolor:= color;
end;

{
procedure Txform.aftercreate;
begin
if Onaftercreate <> nil then Onaftercreate;
end;

procedure fpgformaftercreate(index : cint32; aproc :Tproc); cdecl;
begin
afpgform[index].Onaftercreate := aproc ;
end;
}

///////////////// fpg_button
procedure fpgbuttoncreate({$IF DEFINED(Java)} PEnv: PJNIEnv; Obj: JObject; {$endif} formindex: cint32; index:cint32 ;  OwnerType: cint32; OwnerIndex: cint32); cdecl;
{$IF DEFINED(assistive)}
var
orilength : cint32;
{$endif}
begin
   {$IF DEFINED(assistive)}
   orilength := length(afpgform[formindex].afpgbutton) ;
   {$endif}
   if index+1 > length(afpgform[formindex].afpgbutton) then setlength(afpgform[formindex].afpgbutton,index+1);
   {$IF DEFINED(assistive)}
   if orilength < length(afpgform[formindex].afpgbutton) -1 then
      begin
      while orilength < length(afpgform[formindex].afpgbutton) -1
     do begin
     afpgform[formindex].afpgbutton[orilength] := TXbutton.create(afpgform[formindex]);
     afpgform[formindex].afpgbutton[orilength].Free;
     inc(orilength) ;
     end;
     end;
   {$endif}
     if afpgform[formindex].afpgbutton[index]<> nil then  afpgform[formindex].afpgbutton[index].Free;

     if OwnerType <= 0 then
      begin
      afpgform[formindex].afpgbutton[index] := TXbutton.create(afpgform[formindex]);
      afpgform[formindex].afpgbutton[index].parent := afpgform[formindex] ;
      end else

     case OwnerType of
       1 :     /// panel
     begin
     // afpgform[formindex].afpgbutton[index] := TXbutton.create(afpgpanel[OwnerIndex]);
     // afpgform[formindex].afpgbutton[index].parent := afpgpanel[OwnerIndex] ;
     end;
     end;
      ;

      afpgform[formindex].afpgbutton[index].Name:= 'button' + inttostr(index);
      afpgform[formindex].afpgbutton[index].Index  := index ;
      afpgform[formindex].afpgbutton[index].onclickproc := nil ;
      afpgform[formindex].afpgbutton[index].TypeObj:= 2;
      afpgform[formindex].afpgbutton[index].formIndex:= formindex;
     {$IF DEFINED(assistive)}
   if  Isassistive = true then
       begin
   Initspeech.Timercount.enabled := false;
  Initspeech.Timercount.enabled := true;
  end;
     {$endif}
 end;

{$IF DEFINED(Java)}
procedure fpgbuttonOnclick(PEnv: PJNIEnv; Obj: JObject; formindex: cint32; index : cint32; aproc: JString); cdecl;
var
theproc : pchar ;
begin
 theproc := (PEnv^^).GetStringUTFChars(PEnv, aproc, nil);
 afpgform[formindex].afpgbutton[index].PEnv := PEnv;
 afpgform[formindex].afpgbutton[index].Obj:= Obj;
 afpgform[formindex].afpgbutton[index].onClickProc := (PEnv^^).GetStaticMethodID(PEnv,theclass,theproc,'()V')  ;
    (PEnv^^).ReleaseStringUTFChars(PEnv, aproc, nil);
{$else}
procedure fpgbuttonOnclick(formindex: cint32; index : cint32; aproc: Tproc); cdecl;
begin
afpgform[formindex].afpgbutton[index].onclickproc := aproc ;
{$endif}
afpgform[formindex].afpgbutton[index].Onclick:= @afpgform[formindex].afpgbutton[index].onclickpr;
 end;

procedure fpgbuttonsetleft({$IF DEFINED(Java)} PEnv: PJNIEnv; Obj: JObject; {$endif} formindex: cint32; index : cint32 ; pos : cint32); cdecl;
begin
afpgform[formindex].afpgbutton[index].left:= pos;
end;

function fpgbuttongetleft({$IF DEFINED(Java)} PEnv: PJNIEnv; Obj: JObject; {$endif} formindex: cint32; index : cint32) : cint32; cdecl;
begin
result := afpgform[formindex].afpgbutton[index].left;
end;

procedure fpgbuttonsettop({$IF DEFINED(Java)} PEnv: PJNIEnv; Obj: JObject; {$endif} formindex: cint32; index : cint32 ; pos : cint32); cdecl;
begin
afpgform[formindex].afpgbutton[index].top:= pos;
end;

function fpgbuttongettop({$IF DEFINED(Java)} PEnv: PJNIEnv; Obj: JObject; {$endif} formindex: cint32; index : cint32) : cint32; cdecl;
begin
result := afpgform[formindex].afpgbutton[index].top;
end;

procedure fpgbuttonsetheight({$IF DEFINED(Java)} PEnv: PJNIEnv; Obj: JObject; {$endif} formindex: cint32; index : cint32 ; pos : cint32); cdecl;
begin
afpgform[formindex].afpgbutton[index].height:= pos;
end;

function fpgbuttongetheight({$IF DEFINED(Java)} PEnv: PJNIEnv; Obj: JObject; {$endif} formindex: cint32; index : cint32) : cint32; cdecl;
begin
result := afpgform[formindex].afpgbutton[index].height;
end;

procedure fpgbuttonsetwidth({$IF DEFINED(Java)} PEnv: PJNIEnv; Obj: JObject; {$endif} formindex: cint32; index : cint32 ; pos : cint32); cdecl;
begin
afpgform[formindex].afpgbutton[index].width:= pos;
end;

function fpgbuttongetwidth({$IF DEFINED(Java)} PEnv: PJNIEnv; Obj: JObject; {$endif} formindex: cint32; index : cint32) : cint32; cdecl;
begin
result := afpgform[formindex].afpgbutton[index].width;
end;

procedure fpgbuttonbackgroundcolor({$IF DEFINED(Java)} PEnv: PJNIEnv; Obj: JObject; {$endif} formindex: cint32; index : cint32; color : longword); cdecl;
begin
afpgform[formindex].afpgbutton[index].backgroundcolor:= color;
end;

procedure fpgbuttonshow({$IF DEFINED(Java)} PEnv: PJNIEnv; Obj: JObject; {$endif} formindex: cint32; index : cint32); cdecl;
begin
afpgform[formindex].afpgbutton[index].visible:=true;
end;

procedure fpgbuttonhide({$IF DEFINED(Java)} PEnv: PJNIEnv; Obj: JObject; {$endif} formindex: cint32; index : cint32); cdecl;
begin
afpgform[formindex].afpgbutton[index].visible:=false;
end;

procedure fpgbuttonsetText({$IF DEFINED(Java)} PEnv: PJNIEnv; Obj: JObject; {$endif} formindex: cint32; index : cint32; text : {$IF DEFINED(Java)} JString {$else} PChar {$endif}); cdecl;
begin
{$IF DEFINED(Java)}
afpgform[formindex].afpgbutton[index].Text:= (PEnv^^).GetStringUTFChars(PEnv, text, nil);
(PEnv^^).ReleaseStringUTFChars(PEnv, text, nil);
 {$else}
 afpgform[formindex].afpgbutton[index].Text:=text;
 {$endif}
end;

function fpgbuttongetText({$IF DEFINED(Java)} PEnv: PJNIEnv; Obj: JObject; {$endif} formindex: cint32; index : cint32): pchar; cdecl;
begin
result := pchar(afpgform[formindex].afpgbutton[index].Text);
end;

procedure fpgbuttonsetposition({$IF DEFINED(Java)} PEnv: PJNIEnv; Obj: JObject; {$endif} formindex: cint32; index : cint32; aleft, atop, awidth, aheight: cint32); cdecl; /// if aheight = -1 => default height cfr text height
begin
afpgform[formindex].afpgbutton[index].left:= aleft;
afpgform[formindex].afpgbutton[index].top:= atop;
afpgform[formindex].afpgbutton[index].width:= awidth;
if aheight > 0 then afpgform[formindex].afpgbutton[index].height:=aheight;
afpgform[formindex].afpgbutton[index].updateWindowposition;
end;

procedure fpgbuttonupdateposition({$IF DEFINED(Java)} PEnv: PJNIEnv; Obj: JObject; {$endif} formindex: cint32; index : cint32); cdecl;
begin
afpgform[formindex].afpgbutton[index].updateWindowposition;
end;

procedure fpgbuttonsetvisible({$IF DEFINED(Java)} PEnv: PJNIEnv; Obj: JObject; {$endif} formindex: cint32; index : cint32; visible : cbool); cdecl;
begin
afpgform[formindex].afpgbutton[index].visible:= visible ;
end;

function fpgbuttongetvisible({$IF DEFINED(Java)} PEnv: PJNIEnv; Obj: JObject; {$endif} formindex: cint32; index : cint32): cbool; cdecl;
begin
result := afpgform[formindex].afpgbutton[index].visible ;
end;

procedure fpgbuttonsetenabled({$IF DEFINED(Java)} PEnv: PJNIEnv; Obj: JObject; {$endif} formindex: cint32; index : cint32; enable : cbool); cdecl;
begin
afpgform[formindex].afpgbutton[index].enabled:= enable ;
end;

function fpgbuttongetenabled({$IF DEFINED(Java)} PEnv: PJNIEnv; Obj: JObject; {$endif} formindex: cint32; index : cint32): cbool; cdecl;
begin
result := afpgform[formindex].afpgbutton[index].enabled ;
end;

exports

  {$IF not DEFINED(Java)}
  //// fpg_main
fpgInitialize  name 'fpginitialize' ,
fpgRun name  'fpgrun',
fpgprocessMessages name  'processmessages',
//fpgsetscreenDpi name 'fpgsetscreendpi',
fpggetscreenDpi name 'fpggetscreendpi',
{$IF DEFINED(assistive)}
//// assistive
fpgEnableassistive name 'fpgenableassistive',
fpgEnableassistivecust name 'fpgenableassistivecust',
fpgDisableassistive name 'fpgdisableassistive',
fpgFreeassistive name 'fpgfreeassistive',
{$endif}
//// styleManager
fpgsetstyle name 'fpgsetstyle',
//// fpg_form
fpgformcreate name  'fpgformcreate',
fpgformName name  'fpgformname',
fpgformsetposition name  'fpgformsetposition',
fpgformWindowTitle name  'fpgformwindowtitle',
fpgformupdateposition  name 'fpgformupdateposition' ,
fpgformshowModal name 'fpgformshowmodal',
fpgformscreenposition name 'fpgformscreenposition',
fpgformOnclick name 'fpgformonclick'  ,
fpgformOnclose name 'fpgformonclose'  ,
// fpgformaftercreate name 'fpgformaftercreate' ,
fpgformbackgroundcolor name 'fpgformbackgroundcolor' ,
fpgformgetleft name 'fpgformgetleft',
fpgformgettop name 'fpgformgettop',
fpgformgetheight name 'fpgformgetheight',
fpgformgetwidth name 'fpgformgetwidth',
fpgformsetleft name 'fpgformsetleft',
fpgformsettop name 'fpgformsettop',
fpgformsetheight name 'fpgformsetheight',
fpgformsetwidth name 'fpgformsetwidth',
fpgformhide name 'fpgformhide',
fpgformclose name 'fpgformclose',
fpgformshow  name 'fpgformshow',
fpgformsetvisible name 'fpgformsetvisible',
fpgformgetvisible name  'fpgformgetvisible',
fpgformsetenabled name 'fpgformsetenabled',
fpgformgetenabled name 'fpgformgetenabled',
fpgformType name 'fpgformtype',
fpgformattributes name 'fpgformattributes',

///// fpg_button
fpgbuttoncreate name 'fpgbuttoncreate',
fpgbuttonOnclick  name 'fpgbuttononclick',
fpgbuttonbackgroundcolor name 'fpgbuttonbackgroundcolor' ,
fpgbuttongetleft name 'fpgbuttongetleft',
fpgbuttongettop name 'fpgbuttongettop',
fpgbuttongetheight name 'fpgbuttongetheight',
fpgbuttongetwidth name 'fpgbuttongetwidth',
fpgbuttonsetleft name 'fpgbuttonsetleft',
fpgbuttonsettop name 'fpgbuttonsettop',
fpgbuttonsetheight name 'fpgbuttonsetheight',
fpgbuttonsetwidth name 'fpgbuttonsetwidth',
fpgbuttonshow name 'fpgbuttonshow',
fpgbuttonhide name 'fpgbuttonhide',
fpgbuttonsetText name 'fpgbuttonsettext',
fpgbuttongetText  name 'fpgbuttongettext',
fpgbuttonupdateposition  name 'fpgbuttonupdateposition',
fpgbuttonsetposition name'fpgbuttonsetposition',
fpgbuttonsetvisible name 'fpgbuttonsetvisible',
fpgbuttongetvisible name 'fpgbuttongetvisible',
fpgbuttonsetenabled name 'fpgbuttonsetenabled',
fpgbuttongetenabled name 'fpgbuttongetenabled'

  {$else}

//// fpg_main
fpgInitialize  name 'Java_fpg_initialize' ,
fpgRun name  'Java_fpg_run',
fpgprocessMessages name  'Java_fpg_processmessages',
//fpgsetscreenDpi name 'Java_fpg_setscreendpi',
fpggetscreenDpi name 'Java_fpg_getscreendpi',
{$IF DEFINED(assistive)}
//// assistive
fpgEnableassistive name 'Java_fpg_enableassistive',
fpgEnableassistivecust name 'Java_fpg_enableassistivecust',
fpgDisableassistive name 'Java_fpg_disableassistive',
fpgFreeassistive name 'Java_fpg_freeassistive',

{$endif}
//// styleManager
fpgsetstyle name 'Java_fpg_setstyle',
//// fpg_form
fpgformcreate name  'Java_fpg_formcreate',
fpgformName name  'Java_fpg_formname',
fpgformsetposition name  'Java_fpg_formsetposition',
fpgformWindowTitle name  'Java_fpg_formwindowtitle',
fpgformupdateposition  name 'Java_fpg_formupdateposition' ,
fpgformshowModal name 'Java_fpg_formshowmodal',
fpgformscreenposition name 'Java_fpg_formscreenposition',
fpgformOnclick name 'Java_fpg_formonclick'  ,
fpgformOnclose name 'Java_fpg_formonclose'  ,
// fpgformaftercreate name 'Java_fpg_formaftercreate' ,
fpgformbackgroundcolor name 'Java_fpg_formbackgroundcolor' ,
fpgformgetleft name 'Java_fpg_formgetleft',
fpgformgettop name 'Java_fpg_formgettop',
fpgformgetheight name 'Java_fpg_formgetheight',
fpgformgetwidth name 'Java_fpg_formgetwidth',
fpgformsetleft name 'Java_fpg_formsetleft',
fpgformsettop name 'Java_fpg_formsettop',
fpgformsetheight name 'Java_fpg_formsetheight',
fpgformsetwidth name 'Java_fpg_formsetwidth',
fpgformhide name 'Java_fpg_formhide',
fpgformclose name 'Java_fpg_formclose',
fpgformshow  name 'Java_fpg_formshow',
fpgformsetvisible name 'Java_fpg_formsetvisible',
fpgformgetvisible name  'Java_fpg_formgetvisible',
fpgformsetenabled name 'Java_fpg_formsetenabled',
fpgformgetenabled name 'Java_fpg_formgetenabled',
fpgformType name 'Java_fpg_formtype',
fpgformattributes name 'Java_fpg_formattributes',

///// fpg_button
fpgbuttoncreate name 'Java_fpg_buttoncreate',
fpgbuttonOnclick  name 'Java_fpg_buttononclick',
fpgbuttonbackgroundcolor name 'Java_fpg_buttonbackgroundcolor' ,
fpgbuttongetleft name 'Java_fpg_buttongetleft',
fpgbuttongettop name 'Java_fpg_buttongettop',
fpgbuttongetheight name 'Java_fpg_buttongetheight',
fpgbuttongetwidth name 'Java_fpg_buttongetwidth',
fpgbuttonsetleft name 'Java_fpg_buttonsetleft',
fpgbuttonsettop name 'Java_fpg_buttonsettop',
fpgbuttonsetheight name 'Java_fpg_buttonsetheight',
fpgbuttonsetwidth name 'Java_fpg_buttonsetwidth',
fpgbuttonshow name 'Java_fpg_buttonshow',
fpgbuttonhide name 'Java_fpg_buttonhide',
fpgbuttonsettext name 'Java_fpg_buttonsettext',
fpgbuttongettext  name 'Java_fpg_buttongettext',
fpgbuttonupdateposition  name 'Java_fpg_buttonupdateposition',
fpgbuttonsetposition name'Java_fpg_buttonsetposition',
fpgbuttonsetvisible name 'Java_fpg_buttonsetvisible',
fpgbuttongetvisible name 'Java_fpg_buttongetvisible',
fpgbuttonsetenabled name 'Java_fpg_buttonsetenabled'
,fpgbuttongetenabled name 'Java_fpg_buttongetenabled'

      {$endif}

;
end.