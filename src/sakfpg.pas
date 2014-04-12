unit sakfpg;

{*******************************************************************************
*             Speech Assistive Kit ( sak ) for fpGUI library                   *
*                  --------------------------------------                      *
*                                                                              *
*          Assistive Procedures using eSpeak and Portaudio libraries           *
*                                                                              *
*                                                                              *
*                 Fred van Stappen /  fiens@hotmail.com                        *
*                                                                              *
*                                                                              *
********************************************************************************
*  1 th release: 2013-06-15  (multi objects, multi forms)                      *
*  2 th release: 2013-08-01  (use espeak.exe)                                  *
*                                                                              *
********************************************************************************}
    {
    Copyright (C) 2014  Fred van Stappen

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 51 Franklin Street, Fifth Floor,
    Boston, MA  02110-1301  USA
    }

interface

uses
  fpglib_class,
  fpg_base,
  fpg_main,
  fpg_grid,
  fpg_button,
  fpg_CheckBox,
  fpg_RadioButton,
  fpg_Menu,
  fpg_ComboBox,
  fpg_ListBox,
  fpg_TrackBar,
  fpg_memo,
  fpg_edit,
  fpg_form,
  fpg_dialogs,
  //}
    Classes, Math, SysUtils, Process
  {$IF not DEFINED(Windows)}

  ,dynlibs, baseunix
       {$endif}
  ;

const
  male = 1;
  female = 2;

 type

  TProc = procedure of object;
  TOnEnter = procedure(Sender: TObject) of object;
  TOnClick = procedure(Sender: TObject) of object;
  TOnChange = procedure(Sender: TObject) of object;
  TOnDestroy = procedure(Sender: TObject) of object;

  TOnKeyChar = procedure(Sender: TObject; Key: TfpgChar; var ifok: boolean) of object;
  TOnKeyPress = procedure(Sender: TObject; var Key: word; var Shift: TShiftState;
    var ifok: boolean) of object;
  TOnMouseDown = procedure(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; const Pointm: TPoint) of object;
  TOnMouseUp = procedure(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; const Pointm: TPoint) of object;
  TOnFocusChange = procedure(Sender: TObject; col: longint; row: longint) of object;
   TOnTrackbarChange = procedure(Sender: TObject; position : longint) of object;

type
  TSAK_Assistive = class(TObject)
  private
    TheObject: TObject;
    OriOnKeyPress: TOnKeyPress;
    OriOnClick: TOnClick;
    OriOnEnter: TOnEnter;
    OriOnMouseDown: TOnMouseDown;
    OriOnMouseUp: TOnMouseUp;
    OriOnChange: TOnChange;
    OriOnDestroy: TOnDestroy;
    OriOnKeyChar: TOnKeyChar;
    OriOnFocusChange: TOnFocusChange;
    OriOnTrackbarChange: TOnTrackbarChange;

  public
    Description: ansistring;
    Soundfile: ansistring;
  end;

type
  TSAK_Init = class(TObject)
  public
    {$ifdef windows}
       {$else}
  PA_FileName: ansistring;
       {$endif}

    ES_FileName: ansistring;
    ES_DataDirectory: ansistring;
    voice_language: ansistring;
    voice_gender: ansistring;
    isloaded: boolean;
    isworking: boolean;
    CompCount: integer;
    CheckObject : TObject;
    CheckKey: word;
    CheckShift: TShiftState ;
    AssistiveData: array of TSAK_Assistive;
    CheckKeyChar : TfpgChar;
    CheckCol, CheckRow, CheckPos : longint ;
    TimerCount: TfpgTimer;
    TimerRepeat: TfpgTimer;

    procedure SAKEnter(Sender: TObject);
    procedure SAKChange(Sender: TObject);
    procedure SAKClick(Sender: TObject);
    procedure SAKDestroy(Sender: TObject);

    procedure CheckCount(Sender: TObject);

    procedure CheckRepeatEnter(Sender: TObject);
    procedure CheckRepeatChange(Sender: TObject);
    procedure CheckRepeatKeyPress(Sender: TObject);

    procedure CheckRepeatKeyChar(Sender: TObject);
    procedure CheckFocusChange(Sender: TObject);
    procedure SAKKeyChar(Sender: TObject; Key: TfpgChar; var ifok: boolean);
    procedure SAKKeyPress(Sender: TObject; var Key: word; var Shift: TShiftState;
      var ifok: boolean);
    procedure SAKMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; const pointm: Tpoint);
    procedure SAKMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; const pointm: Tpoint);
    procedure SAKFocusChange(Sender: TObject; col: longint; row: longint);
    procedure CheckTrackbarChange(Sender: TObject);
    procedure SAKTrackbarChange(Sender: TObject; pos : longint);

  private
    function LoadLib: integer;
    function unLoadLib: integer;
    procedure InitObject;
  end;


//// Load with default
function SAKLoadlib: integer;

/// Load with custom
function SAKLoadLibCust(PortaudioLib: pchar; eSpeakLib: pchar;
  eSpeakDataDir: pchar): integer;

function SAKUnloadLib: integer;

function SAKFreeLib: integer;

////// Change voice language or/and gender
function SAKSetVoice(gender : shortint; language : string) : integer;
//// gender : 1 = male, 2 = female.
//// language : is the language code, for example :
//// 'en' for english, 'fr' for french, 'pt' for Portugues, etc...
//// (check in /espeak-data if your language is there...)

///// Start speaking the text with default voice
function espeak_key(Text: string): integer;
function SAKSay(Text: string): integer;

function espeak_cancel: integer;

function WhatName(Sender: TObject): string;

var
  old8087cw: word;
  InitSpeech: TSAK_Init;
  isloadedroot : boolean = false ;
  mouseclicked:  boolean =  false;
    AProcess: TProcess;
   {$IFDEF Windows}
    {$else}
  Pa_Handle:TLibHandle=dynlibs.NilHandle;
  {$ENDIF}


 implementation

/////////////////////////// Capture Assistive Procedures

function WhatName(Sender: TObject): string;
begin

  if (Sender is TfpgButton) then
    Result := Tfpgbutton(Sender).Text
  else
  if (Sender is TfpgForm) then
    Result := TfpgForm(Sender).WindowTitle
  else
  if (Sender is TfpgEdit) then
    Result := TfpgEdit(Sender).Name
  else
  if (Sender is TfpgMemo) then
    Result := TfpgMemo(Sender).Name
  else
  if (Sender is TfpgStringgrid) then
    Result := TfpgStringgrid(Sender).Name
  else
  if (Sender is TfpgRadiobutton) then
    Result := TfpgRadiobutton(Sender).Text
  else
  if (Sender is TfpgCheckBox) then
    Result := TfpgCheckBox(Sender).Text
  else
  if (Sender is TfpgListBox) then
    Result := TfpgListBox(Sender).text
  else
  if (Sender is TfpgFileDialog) then
    Result := TfpgFileDialog(Sender).WindowTitle
  else
   if (Sender is TfpgMenuBar) then
    Result := TfpgMenuBar(Sender).Name
  else
  if (Sender is TfpgPopupMenu) then
    Result := TfpgPopupMenu(Sender).name
  else
   if (Sender is TfpgMenuItem) then
    Result := TfpgMenuItem(Sender).Text
  else
    if (Sender is TfpgTrackBar) then
    Result := TfpgTrackBar(Sender).Name
  else
  if (Sender is TfpgComboBox) then
    Result := TfpgComboBox(Sender).Name ;

end;

procedure TSAK_Init.SAKDestroy(Sender: TObject);
var
  i : integer;
begin
isworking := false ;
  timercount.Enabled := false;

 unLoadLib;
   for i := 0 to (Length(InitSpeech.AssistiveData) - 1) do
  begin
    if (Sender = InitSpeech.AssistiveData[i].TheObject) and
        (InitSpeech.AssistiveData[i].OriOnDestroy <> nil) then
      begin
        InitSpeech.AssistiveData[i].OriOnDestroy(Sender);
       exit;
       end;
  end;
   isworking := true ;

  //  timercount.Enabled := true;

    end;

procedure TSAK_Init.SAKClick(Sender: TObject);
var
  texttmp, nameobj: string;
  i: integer;
begin
  for i := 0 to (Length(InitSpeech.AssistiveData) - 1) do
  begin
    if (Sender = InitSpeech.AssistiveData[i].TheObject) then
    begin
      mouseclicked := True;

      nameobj := whatname(Sender);

      texttmp := InitSpeech.AssistiveData[i].Description + ' ' +
        nameobj + ' executed';

      espeak_Key(texttmp);

      if InitSpeech.AssistiveData[i].OriOnClick <> nil then
       InitSpeech.AssistiveData[i].OriOnClick(Sender);

      exit;
    end;
  end;
end;

procedure TSAK_Init.SAKChange(Sender: TObject);
begin
 TimerRepeat.OnTimer := @CheckRepeatChange;
 TimerRepeat.Enabled:=false;
 TimerRepeat.Interval:=500;
 TimerRepeat.Enabled:=true;
 CheckObject := sender;
end;

 procedure TSAK_Init.CheckRepeatChange(Sender: TObject);
var
  i: integer;
  texttmp: string;
begin
   TimerRepeat.Enabled:=false;
  for i := 0 to (Length(InitSpeech.AssistiveData) - 1) do
  begin
   if (CheckObject = InitSpeech.AssistiveData[i].TheObject) then
   begin

    if (CheckObject is TfpgTrackBar) then
      with CheckObject as TfpgTrackBar do
        texttmp := name + ' position is, ' + inttostr(position);

    if (CheckObject is TfpgComboBox) then
      with CheckObject as TfpgComboBox do
        texttmp := Text + ' selected';

    if (CheckObject is TfpgListBox) then
      with CheckObject as TfpgListBox do
        texttmp := Text + ' selected';

    if (CheckObject is TfpgCheckBox) then
      with CheckObject as TfpgCheckBox do

        if Checked = False then
          texttmp := 'Change  ' + Text + ', in false'
        else
          texttmp :=
            'Change  ' + Text + ', in true';

    if (CheckObject is TfpgRadioButton) then
      with CheckObject as TfpgRadioButton do

        if Checked = False then
          texttmp := 'Change  ' + Text + ', in false'
        else
          texttmp :=
            'Change  ' + Text + ', in true';


    espeak_Key(texttmp);

    if InitSpeech.AssistiveData[i].OriOnChange <> nil then
    InitSpeech.AssistiveData[i].OriOnChange(CheckObject);

    exit;
  end;
end;
  end;

procedure TSAK_Init.SAKTrackbarChange(Sender: TObject; pos : longint);
begin
 TimerRepeat.Enabled:=false;
 TimerRepeat.Interval:=300;
 TimerRepeat.OnTimer := @CheckTrackbarChange;
 TimerRepeat.Enabled:=true;
 CheckObject := sender;
 CheckPos := pos;

end ;

procedure TSAK_Init.CheckTrackbarChange(Sender: TObject);
var
  i: integer;
  texttmp: string;
begin
   TimerRepeat.Enabled:=false;
  for i := 0 to (Length(InitSpeech.AssistiveData) - 1) do
  begin
   if (CheckObject = InitSpeech.AssistiveData[i].TheObject) and
   (CheckObject is TfpgTrackBar) then
    begin
      with CheckObject as TfpgTrackBar do  begin
        texttmp := name + ' position is, ' + inttostr(position);

       espeak_Key(texttmp);

   if InitSpeech.AssistiveData[i].OriOnTrackBarChange <> nil then
    InitSpeech.AssistiveData[i].OriOnTrackbarChange(CheckObject, position );

    exit;

    end;
    end;
  end;
end;


procedure TSAK_Init.SAKFocusChange(Sender: TObject; col: longint; row: longint);
begin
 TimerRepeat.Enabled:=false;
 TimerRepeat.Interval:=500;
 TimerRepeat.OnTimer := @CheckFocusChange;
 TimerRepeat.Enabled:=true;
 CheckObject := sender;
 CheckCol := col;
 CheckRow := row ;
end ;

procedure TSAK_Init.CheckFocusChange(Sender: TObject);
var
  i: integer;
  texttmp: string;
begin
 TimerRepeat.Enabled:=false;
  for i := 0 to high(InitSpeech.AssistiveData) do

    if (CheckObject = InitSpeech.AssistiveData[i].TheObject) and
      (CheckObject is tfpgstringgrid) then
    begin
      with CheckObject as tfpgstringgrid do
      begin
        texttmp := ColumnTitle[focuscol] + ', row ' + IntToStr(focusrow + 1) +
          '. ' + Cells[focuscol, focusrow];

        espeak_Key(texttmp);
      end;

      if InitSpeech.AssistiveData[i].OriOnFocusChange <> nil then
     InitSpeech.AssistiveData[i].OriOnFocusChange(CheckObject, CheckCol, CheckRow);

      exit;
    end;
end;


procedure TSAK_Init.SAKMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; const pointm: Tpoint);
begin
end;

procedure TSAK_Init.SAKMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; const pointm: Tpoint);
begin
end;


procedure TSAK_Init.SAKEnter(Sender: TObject);
begin
//if   mouseclicked =  false then
//begin
 TimerRepeat.OnTimer := @CheckRepeatEnter;
 TimerRepeat.Interval:=600;
 TimerRepeat.Enabled:=false;
 TimerRepeat.Enabled:=true;
 CheckObject := sender;
// end;

end;

procedure TSAK_Init.CheckRepeatEnter(Sender: TObject);
var
  texttmp, nameobj: string;
  i: integer;
begin
 TimerRepeat.Enabled:=false;
if mouseclicked = False then
  begin
    for i := 0 to (Length(InitSpeech.AssistiveData) - 1) do
    begin
      if (CheckObject = InitSpeech.AssistiveData[i].TheObject) then
      begin
        nameobj := whatname(CheckObject);
        texttmp := InitSpeech.AssistiveData[i].Description + ' ' +
          nameobj + ' selected';
        espeak_Key(texttmp);
        if InitSpeech.AssistiveData[i].OriOnEnter <> nil then
          InitSpeech.AssistiveData[i].OriOnEnter(CheckObject);

        exit;
      end;
    end;
  end;
  mouseclicked := False;

end;



procedure TSAK_Init.SAKKeyPress(Sender: TObject; var Key: word;
  var Shift: TShiftState; var ifok: boolean);
begin
 TimerRepeat.OnTimer := @CheckRepeatKeyPress;
 TimerRepeat.Interval:=300;
 TimerRepeat.Enabled:=false;
 TimerRepeat.Enabled:=true;
 CheckObject := sender;
 CheckKey := key ;
 CheckShift := Shift;
end;

procedure TSAK_Init.CheckRepeatKeyPress(Sender: TObject);
var
  i: integer;
 ifok : boolean;
begin
   ifok := true;
 TimerRepeat.Enabled:=false;
  for i := 0 to high(InitSpeech.AssistiveData) do
  begin
    if (CheckObject = InitSpeech.AssistiveData[i].TheObject) then
    begin
        if (CheckKey = 57611) and ((CheckObject is TfpgMemo) or (CheckObject is TfpgEdit)) then
        espeak_Cancel
      else
      begin
        case CheckKey of

          keyPEnter: espeak_Key('enter');
          8: espeak_Key('back space');
          32: if (CheckObject is TfpgCheckBox) or (CheckObject is TfpgRadioButton) or
              (CheckObject is TfpgComboBox) or (CheckObject is TfpgListBox) then
            else
              espeak_Key('space');

          57394: begin
            espeak_Key('up');
            if (CheckObject is TfpgTrackBar) then
               with CheckObject as TfpgTrackBar do if Position + ScrollStep <= max then
              Position := Position + ScrollStep ;
          end;
          57395: begin
            espeak_Key('down') ;
            if (CheckObject is TfpgTrackBar) then
            with CheckObject as TfpgTrackBar do if Position - ScrollStep >= min then
              Position := Position - ScrollStep ;
          end ;

          57396:  begin
            espeak_Key('left');
            if (CheckObject is TfpgTrackBar) then
             with CheckObject as TfpgTrackBar do if Position - ScrollStep >= min then
              Position := Position - ScrollStep ;
          end ;

          57397: begin
            espeak_Key('right');
            if (CheckObject is TfpgTrackBar) then
            with CheckObject as TfpgTrackBar do if Position + ScrollStep <= max then
              Position := Position + ScrollStep ;
          end ;

          57601: espeak_Key('f 1');
          57602: espeak_Key('f 2');
          57603: espeak_Key('f 3');
          57604: espeak_Key('f 4');
          57605: espeak_Key('f 5');
          57606: espeak_Key('f 6');
          57607: espeak_Key('f 7');
          57608: espeak_Key('f 8');
          57609: espeak_Key('f 9');
          57610: espeak_Key('f 10');
          57611: espeak_Key('f 11');
          keyPTab: espeak_Key('tab');
          58112: espeak_Key('shift left');
          58176: espeak_Key('shift right');
          58113: espeak_Key('control right');
          58177: espeak_Key('control left');
          18: espeak_Key('alt');
          58247: espeak_Key('caps lock');
          65535: espeak_Key('alt gr');
          33: espeak_Key('page up');
          34: espeak_Key('page down');
          46: espeak_Key('delete');
          57378: espeak_Key('insert');
          27: espeak_Key('escape');
          35: espeak_Key('end');
          57612: if (CheckObject is TfpgMemo) then
              with CheckObject as TfpgMemo do
                espeak_Key(Text)
            else
            if (CheckObject is Tfpgedit) then
              with CheckObject as Tfpgedit do
                espeak_Key(Text)
            else
              espeak_Key('f 12');
        end;

        if InitSpeech.AssistiveData[i].OriOnKeyPress <> nil then
          InitSpeech.AssistiveData[i].OriOnKeyPress(CheckObject, CheckKey, CheckShift, ifok);
                exit;
      end;
    end;
  end;

end;


procedure TSAK_Init.SAKKeyChar(Sender: TObject; Key: TfpgChar; var ifok: boolean);
begin
 TimerRepeat.OnTimer := @CheckRepeatKeyChar;
 TimerRepeat.Enabled:=false;
 TimerRepeat.Interval:=300;
 TimerRepeat.Enabled:=true;
 CheckObject := sender;
 CheckKeyChar := key ;
end;

procedure TSAK_Init.CheckRepeatKeyChar(Sender: TObject);
var
  tempstr: string;
  i: integer;
  ifok : boolean;
begin
 ifok := true;
  TimerRepeat.Enabled:=false;
  tempstr := CheckKeyChar;
  tempstr := trim(tempstr);
  for i := 0 to (Length(InitSpeech.AssistiveData) - 1) do
  begin
    if (CheckObject = InitSpeech.AssistiveData[i].TheObject) then
    begin

      tempstr := CheckKeyChar;
      tempstr := trim(tempstr);
            if tempstr <> '' then
          espeak_Key(tempstr);

      if InitSpeech.AssistiveData[i].OriOnKeyChar <> nil then
      InitSpeech.AssistiveData[i].OriOnKeyChar(CheckObject, CheckKeyChar, ifok);

      exit;
    end;
  end;
end;


////////////////////// Loading Procedure

function SAKLoadLibCust(PortaudioLib: pchar; eSpeakLib: pchar;
  eSpeakDataDir: pchar): integer;
begin
 result := -1;
  {$ifdef windows}
  if (fileexists(eSpeakLib)) then result := 0;

        {$else}
if (fileexists(PortaudioLib)) then result := 0;
if result = 0 then if not (fileexists(eSpeakLib)) then result := -2 ;
          {$endif}

if result = 0 then if not directoryexists(eSpeakDataDir) then  result := -3;

if result = 0 then
begin

 if assigned(InitSpeech) then 
 if initspeech.isworking = True then exit;

 Result := -1;
  if assigned(InitSpeech) then
  begin
     initspeech.voice_language:= '';
     initspeech.voice_gender:= '' ;
    initspeech.isloaded := True
  end
  else
  begin
     InitSpeech := TSAK_Init.Create;
     initspeech.voice_language:= '';
     initspeech.voice_gender:= '' ;
     initspeech.isloaded := False;
     initspeech.ES_DataDirectory := eSpeakDataDir;
       {$ifdef windows}
       {$else}
         initspeech.PA_FileName := PortaudioLib;
         fpchmod(eSpeakLib,S_IRWXU) ;
        {$endif}
      initspeech.ES_FileName := eSpeakLib;
       Result := 0;
  end;

  if (Result = 0) or (initspeech.isloaded = True) then
  begin
    Result := InitSpeech.loadlib;
      if Result > -1 then 
   begin
   initspeech.isWorking := True;
   isloadedroot := True;
  end;
  end;
  if (result < 0 ) and (assigned(InitSpeech)) then InitSpeech.free;
end;
end;

function SAKLoadLib: integer;
var
  ordir: string;
begin
  Result := -1;
  if assigned(InitSpeech) then
  begin
   initspeech.voice_language:= '';
     initspeech.voice_gender:= '' ;
    initspeech.isloaded := True;
  end
  else
  begin
    InitSpeech := TSAK_Init.Create;
    initspeech.isloaded := False;
     initspeech.voice_language:= '';
     initspeech.voice_gender:= '' ;
    ordir := IncludeTrailingBackslash(ExtractFilePath(ParamStr(0)));
   {$ifdef windows}
    InitSpeech.ES_DataDirectory := ordir + '\sakit';
     {$else}
    InitSpeech.ES_DataDirectory := ordir + '/sakit';
       {$endif}

   {$ifdef windows}

      Result := -1;
      if fileexists(ordir + 'espeak.exe') then
      begin
        Result := 0;
        initspeech.ES_FileName := ordir + 'espeak.exe';
      end
      else
      if fileexists(ordir + '\sakit\libwin32\espeak.exe') then
      begin
        initspeech.ES_FileName := ordir + '\sakit\libwin32\espeak.exe';
        Result := 0;
      end;
           {$endif}
         {$IF DEFINED(Linux) and  defined(cpu64)}
    if fileexists(ordir + 'LibPortaudio_x64.so') then
    begin
      Result := 0;
      initspeech.PA_FileName := ordir + 'LibPortaudio_x64.so';
    end
    else
    if fileexists(ordir + '/sakit/liblinux64/LibPortaudio_x64.so') then
    begin
      initspeech.PA_FileName := ordir + '/sakit/liblinux64/LibPortaudio_x64.so';
      Result := 0;
    end;

    if Result = 0 then
    begin
      Result := -1;
      if fileexists(ordir + 'speak_x64') then
      begin
        Result := 0;
        initspeech.ES_FileName := ordir + 'speak_x64';
        fpchmod(ordir + 'speak_x64',S_IRWXU) ;
      end
      else
      if fileexists(ordir + '/sakit/liblinux64/speak_x64') then
      begin
        initspeech.ES_FileName := ordir + '/sakit/liblinux64/speak_x64';
        Result := 0;
         fpchmod( ordir + '/sakit/liblinux64/speak_x64',S_IRWXU) ;
      end;
    end;
     {$endif}
      {$IF DEFINED(Linux) and defined(cpu86) }
    if fileexists(ordir + 'LibPortaudio_x86.so') then
    begin
      Result := 0;
      initspeech.PA_FileName := ordir + 'LibPortaudio_x86.so';
    end
    else
    if fileexists(ordir + '/sakit/liblinux32/LibPortaudio_x86.so') then
    begin
      initspeech.PA_FileName := ordir + '/sakit/liblinux32/LibPortaudio_x86.so';
      Result := 0;
    end;

    if Result = 0 then
    begin
      Result := -1;
      if fileexists(ordir + 'speak_x86') then
      begin
        Result := 0;
        initspeech.ES_FileName := ordir + 'speak_x86';
         fpchmod(ordir + 'speak_x86',S_IRWXU) ;
      end
      else
      if fileexists(ordir + '/sakit/liblinux32/speak_x86') then
      begin
        initspeech.ES_FileName := ordir + '/sakit/liblinux32/speak_x86';
        Result := 0;
        fpchmod( ordir + '/sakit/liblinux32/speak_x86',S_IRWXU) ;
      end;
    end;

                {$endif}

     {$IFDEF Darwin}
    if fileexists(ordir + 'LibPortaudio-32.dylib') then
    begin
      Result := 0;
      initspeech.PA_FileName := ordir + 'LibPortaudio-32.dylib';
    end
    else
    if fileexists(ordir + '/sakit/libmac32/LibPortaudio-32.dylib') then
    begin
      initspeech.PA_FileName := ordir + '/sakit/libmac32/LibPortaudio-32.dylib';
      Result := 0;
    end;

    if Result = 0 then
    begin
      Result := -1;
      if fileexists(ordir + 'speak') then
      begin
        Result := 0;
        initspeech.ES_FileName := ordir + 'speak';
         fpchmod(ordir + 'speak',S_IRWXU) ;
      end
      else
      if fileexists(ordir + '/sakit/libmac32/speak') then
      begin
        initspeech.ES_FileName := ordir + '/sakit/libmac32/speak';
        Result := 0;
        fpchmod( ordir + '/sakit/libmac32/speak',S_IRWXU) ;
      end;
    end;

                {$endif}
     if (result < 0 ) and (assigned(InitSpeech)) then InitSpeech.free;

  end;

  if (Result = 0) or (initspeech.isloaded = True) then
  begin
      Result := InitSpeech.loadlib;
        initspeech.isworking := True;
         isloadedroot := True;
  end  ;

end;

procedure TSAK_Init.InitObject;
var
  i, f ,g : integer;
begin

  mouseclicked := False;

   InitSpeech.isWorking := False;

    SetLength(InitSpeech.AssistiveData, 1);

  if InitSpeech.AssistiveData[0] <> nil then InitSpeech.AssistiveData[0].Free;
  InitSpeech.AssistiveData[0] :=  TSAK_Assistive.Create();

      InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].Description :=
      'Application';

    InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].TheObject :=
      Tfpgapplication(fpgapplication);

   InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnKeyPress :=
    Tfpgapplication(fpgapplication).OnKeyPress;

  Tfpgapplication(fpgapplication).OnKeyPress := @InitSpeech.SAKKeyPress;

  for f := 0 to length(AfpgForm)- 1  do
  begin
      SetLength(InitSpeech.AssistiveData, Length(InitSpeech.AssistiveData) + 1);
  // espeak_Key('3');

    if  (AfpgForm[f]) <> nil then
    begin
    // espeak_Key('4');
      if InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1] <> nil then
      InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].Free;
    InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1] :=
      TSAK_Assistive.Create();

    InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].Description :=
      'Form';

    InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].TheObject :=
    AfpgForm[f] ;

    //espeak_Key('2');
    // if TfpgForm(AfpgForm[f]).OnClick <> nil then   espeak_Key('ok');

    InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnClick :=
 TfpgForm(AfpgForm[f]).OnClick;

   InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnKeyPress :=
   TfpgForm(AfpgForm[f]).OnKeyPress;


   InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnDestroy :=
   TfpgForm(AfpgForm[f]).OnDestroy;

  InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnMouseDown :=
  TfpgForm(AfpgForm[f]).OnMouseDown;

  TfpgForm(AfpgForm[f]).OnClick := @InitSpeech.SAKClick;

  TfpgForm(AfpgForm[f]).OnMouseDown := @InitSpeech.SAKMouseDown;

  TfpgForm(AfpgForm[f]).OnKeyPress := @InitSpeech.SAKKeyPress;

  TfpgForm(AfpgForm[f]).OnDestroy := @InitSpeech.SAKDestroy;

    with (AfpgForm[f]) as TfpgForm do

      for i := 0 to ComponentCount - 1 do
      begin
        if (Components[i] is TfpgButton) or (Components[i] is TfpgMemo) or
          (Components[i] is TfpgEdit) or (Components[i] is TfpgStringGrid) or
          (Components[i] is TfpgCheckBox) or (Components[i] is TfpgRadiobutton) or
          (Components[i] is TfpgListBox) or (Components[i] is TfpgComboBox) or
           (Components[i] is TfpgPopupMenu) or  (Components[i] is TfpgMenuItem) or
           (Components[i] is TfpgTrackBar)
          // or (Components[i] is TfpgFileDialog) or (Components[i] is TfpgSaveDialog)
        then
        begin
          SetLength(InitSpeech.AssistiveData, Length(InitSpeech.AssistiveData) + 1);

          InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1] :=
            TSAK_Assistive.Create();

           if (Components[i] is TfpgPopupMenu) then
          begin

            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].Description :=
              'Menu';
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].TheObject :=
              TfpgPopupMenu(Components[i]);
       InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnClick :=
       TfpgPopupMenu(Components[i]).OnShow;
       TfpgPopupMenu(Components[i]).OnShow := @InitSpeech.SAKClick;
         with (TfpgPopupMenu(Components[i]) as TfpgPopupMenu) do
          for g := 0 to ComponentCount - 1 do
          begin
            SetLength(InitSpeech.AssistiveData, Length(InitSpeech.AssistiveData) + 1);
    InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1] :=
      TSAK_Assistive.Create();
             InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].TheObject :=
              TfpgMenuItem(Components[g]);

       InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnClick :=
       TfpgMenuItem(Components[g]).OnClick;
        TfpgMenuItem(Components[g]).OnClick := @InitSpeech.SAKClick;
             end;
             end
          else
          if (Components[i] is TfpgButton) then
          begin

            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].Description :=
              'Button';
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].TheObject :=
              TfpgButton(Components[i]);
       InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnClick :=
       TfpgButton(Components[i]).OnClick;
       TfpgButton(Components[i]).OnClick := @InitSpeech.SAKClick;
         InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnEnter :=
       TfpgButton(Components[i]).OnEnter;
        TfpgButton(Components[i]).OnEnter := @InitSpeech.SAKEnter;
          end
          else
          if (Components[i] is TfpgStringGrid) then
          begin
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].Description :=
              'Grid';
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) -
              1].TheObject :=
              TfpgStringGrid(Components[i]);
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) -
              1].OriOnFocusChange :=
              TfpgStringGrid(Components[i]).OnFocusChange;
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) -
              1].OriOnMouseDown :=
              TfpgStringGrid(Components[i]).OnMouseDown;
            TfpgStringGrid(Components[i]).OnFocusChange := @InitSpeech.SAKFocusChange;
            TfpgStringGrid(Components[i]).OnMouseDown := @InitSpeech.SAKMouseDown;
                 InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnEnter :=
         TfpgStringGrid(Components[i]).OnEnter;
        TfpgStringGrid(Components[i]).OnEnter := @InitSpeech.SAKEnter;

          end
          else
           if (Components[i] is TfpgTrackBar) then
          begin
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].Description :=
              'Track bar';
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].TheObject :=
              TfpgTrackBar(Components[i]);
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnTrackbarChange :=
              TfpgTrackBar(Components[i]).OnChange;

            TfpgTrackBar(Components[i]).OnChange := @InitSpeech.SAKTrackBarChange;

            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnEnter :=
              TfpgTrackBar(Components[i]).OnEnter;

            TfpgTrackBar(Components[i]).OnEnter := @InitSpeech.SAKEnter;
          end
          else
          if (Components[i] is TfpgRadiobutton) then
          begin
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].Description :=
              'Radio Button';
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) -
              1].TheObject :=
              TfpgRadiobutton(Components[i]);
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) -
              1].OriOnChange :=
              TfpgRadiobutton(Components[i]).OnChange;

            TfpgRadiobutton(Components[i]).OnChange := @InitSpeech.SAKChange;

             InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) -
              1].OriOnEnter :=
              TfpgRadiobutton(Components[i]).OnEnter;

            TfpgRadiobutton(Components[i]).OnEnter := @InitSpeech.SAKEnter;

          end
          else

          if (Components[i] is TfpgCheckBox) then
          begin
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].Description :=
              'Check Box';
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].TheObject :=
              TfpgCheckBox(Components[i]);
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnChange :=
              TfpgCheckBox(Components[i]).OnChange;
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnEnter :=
              TfpgCheckBox(Components[i]).OnEnter;

            TfpgCheckBox(Components[i]).OnChange := @InitSpeech.SAKChange;
            TfpgCheckBox(Components[i]).OnEnter := @InitSpeech.SAKEnter;
          end
          else
          if (Components[i] is TfpgListBox) then
          begin
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].Description :=
              'List Box';
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].TheObject :=
              TfpgListBox(Components[i]);
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnChange :=
              TfpgListBox(Components[i]).OnChange;
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnEnter :=
              TfpgListBox(Components[i]).OnEnter;

            TfpgListBox(Components[i]).OnChange := @InitSpeech.SAKChange;
            TfpgListBox(Components[i]).OnEnter := @InitSpeech.SAKEnter;
          end
          else
          if (Components[i] is TfpgComboBox) then
          begin
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].Description :=
              'Combo Box';
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].TheObject :=
              TfpgComboBox(Components[i]);
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnChange :=
              TfpgComboBox(Components[i]).OnChange;
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnEnter :=
              TfpgComboBox(Components[i]).OnEnter;
            TfpgComboBox(Components[i]).OnChange := @InitSpeech.SAKChange;
            TfpgComboBox(Components[i]).OnEnter := @InitSpeech.SAKEnter;
          end
          else
          if (Components[i] is TfpgMemo) then
          begin
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].Description :=
              'Memo';
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].TheObject :=
              TfpgMemo(Components[i]);
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnEnter :=
              TfpgMemo(Components[i]).OnEnter;
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) -
              1].OriOnKeyChar :=
              TfpgMemo(Components[i]).OnKeyChar;

            TfpgMemo(Components[i]).OnEnter := @InitSpeech.SAKEnter;
            TfpgMemo(Components[i]).OnKeyChar := @InitSpeech.SAKKeyChar;
          end
          else
          if (Components[i] is TfpgEdit) then
          begin
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].Description :=
              'Edit';
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].TheObject :=
              TfpgEdit(Components[i]);
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) - 1].OriOnEnter :=
              TfpgEdit(Components[i]).OnEnter;
            InitSpeech.AssistiveData[Length(InitSpeech.AssistiveData) -
              1].OriOnKeyChar :=
              TfpgEdit(Components[i]).OnKeyChar;
            TfpgEdit(Components[i]).OnEnter := @InitSpeech.SAKEnter;
            TfpgEdit(Components[i]).OnKeyChar := @InitSpeech.SAKKeyChar;
          end;
        end;
      end;
  end;
  end;
   InitSpeech.isWorking := true;
end;


procedure TSAK_Init.CheckCount(Sender: TObject);
begin
 timercount.Enabled := False;

//  if (isWorking = True) then
//  begin
// if (fpgapplication.ComponentCount <> CompCount) then
 //begin
   isWorking := false ;
    UnLoadLib;
    InitObject;
 //   isWorking := True ;
// end;

end;


///////////////// loading sak

 function TSAK_Init.LoadLib: integer;
begin
  Result := -1;

  if initspeech.isloaded = True then
    Result := 0
  else
  begin
   old8087cw := Get8087CW;
  SetExceptionMask([exInvalidOp, exDenormalized, exZeroDivide,
    exOverflow, exUnderflow, exPrecision]);
  Set8087CW($133f);
  {$ifdef windows}
  Result := 0 ;
       {$else}
    if not fileexists(PA_FileName) then
      Result := -2
    else
    begin
    Pa_Handle:=DynLibs.LoadLibrary(PA_FileName);
    if Pa_Handle <> DynLibs.NilHandle then
      Result := 0
    else
      Result := -21;
     end;

    if Result = 0 then
    begin
    {$endif}
      if not fileexists(ES_FileName) then
        Result := -3
      else
      if Result = 0 then
      begin

           TimerRepeat := Tfpgtimer.Create(50000);
          TimerRepeat.Enabled := False;
          TimerCount := Tfpgtimer.Create(50000);
          TimerCount.Enabled := False;
          TimerCount.Interval := 3000;
    timerCount.OnTimer := @CheckCount;
        end;
    {$ifdef windows}
       {$else}
      end;
        {$endif}
       end;

  if Result > -1 then
  begin
    initspeech.isloaded := True;

    CompCount := fpgapplication.ComponentCount;

    InitObject;
    espeak_Key('sak is working...');
    TimerRepeat.Enabled:=false;
    TimerRepeat.Interval := 800;

    TimerCount.Enabled := False;

  end;
end;

function SAKFreeLib: integer;
var
  i: integer;
begin
    if assigned(InitSpeech) then
  begin

      InitSpeech.TimerCount.Enabled:=false;

   InitSpeech.TimerRepeat.Enabled:=false;
  SAKUnLoadLib;
  sleep(250);

   InitSpeech.TimerCount.Free;

   InitSpeech.TimerRepeat.Free;
     for i := 0 to high(InitSpeech.AssistiveData) do
      InitSpeech.AssistiveData[i].Free;
    InitSpeech.Free;
    AProcess.Free;
     {$ifdef windows}
       {$else}
       sleep(100);
      DynLibs.UnloadLibrary(Pa_Handle);
    Pa_Handle:=DynLibs.NilHandle;
        {$endif}
    Set8087CW(old8087cw);
     isloadedroot := false;
end;
 end;

function SAKUnLoadLib: integer;
begin
if  (isloadedroot = True) then
begin
 if (assigned(InitSpeech)) then
  begin
  InitSpeech.isWorking := False;
  InitSpeech.UnLoadLib;
  end;
  end;
end;

function TSAK_Init.UnLoadLib: integer;
var
  i : integer;
begin
  if assigned(InitSpeech) then
  begin

  InitSpeech.TimerCount.Enabled := False;

    for i := 0 to high(InitSpeech.AssistiveData) do
    begin
        if (assigned(InitSpeech.AssistiveData[i].TheObject)) and
        (InitSpeech.AssistiveData[i].TheObject is Tfpgapplication) then
      begin
        Tfpgapplication(InitSpeech.AssistiveData[i].TheObject).OnKeyPress :=
          InitSpeech.AssistiveData[i].OriOnKeyPress;
        end
      else
      if (assigned(InitSpeech.AssistiveData[i].TheObject)) and
        (InitSpeech.AssistiveData[i].TheObject is TfpgForm) then
      begin
         TfpgForm(InitSpeech.AssistiveData[i].TheObject).OnClick :=
          InitSpeech.AssistiveData[i].OriOnClick;
        TfpgForm(InitSpeech.AssistiveData[i].TheObject).OnKeyPress :=
          InitSpeech.AssistiveData[i].OriOnKeyPress;
        TfpgForm(InitSpeech.AssistiveData[i].TheObject).OnMouseDown :=
          InitSpeech.AssistiveData[i].OriOnMouseDown;
        TfpgForm(InitSpeech.AssistiveData[i].TheObject).OnDestroy :=
          InitSpeech.AssistiveData[i].OriOnDestroy;
        end
      else
      if (assigned(InitSpeech.AssistiveData[i].TheObject)) and
        (InitSpeech.AssistiveData[i].TheObject is TfpgButton) then
      begin
        TfpgButton(InitSpeech.AssistiveData[i].TheObject).OnClick :=
          InitSpeech.AssistiveData[i].OriOnClick;
         TfpgButton(InitSpeech.AssistiveData[i].TheObject).OnEnter :=
          InitSpeech.AssistiveData[i].OriOnEnter;
      end
       else
      if (assigned(InitSpeech.AssistiveData[i].TheObject)) and
        (InitSpeech.AssistiveData[i].TheObject is TfpgPopupMenu) then
      begin
        TfpgPopupMenu(InitSpeech.AssistiveData[i].TheObject).OnShow :=
          InitSpeech.AssistiveData[i].OriOnClick;
      end
        else
      if (assigned(InitSpeech.AssistiveData[i].TheObject)) and
        (InitSpeech.AssistiveData[i].TheObject is TfpgMenuItem) then
      begin
        TfpgMenuItem(InitSpeech.AssistiveData[i].TheObject).OnClick :=
          InitSpeech.AssistiveData[i].OriOnClick;
      end
      else
      if (assigned(InitSpeech.AssistiveData[i].TheObject)) and
        (InitSpeech.AssistiveData[i].TheObject is TfpgEdit) then
      begin
        TfpgEdit(InitSpeech.AssistiveData[i].TheObject).OnKeyChar :=
          InitSpeech.AssistiveData[i].OriOnKeyChar;
        TfpgEdit(InitSpeech.AssistiveData[i].TheObject).OnEnter :=
          InitSpeech.AssistiveData[i].OriOnEnter;
      end
      else
      if (assigned(InitSpeech.AssistiveData[i].TheObject)) and
        (InitSpeech.AssistiveData[i].TheObject is TfpgMemo) then
      begin
        TfpgMemo(InitSpeech.AssistiveData[i].TheObject).OnKeyChar :=
          InitSpeech.AssistiveData[i].OriOnKeyChar;
        TfpgMemo(InitSpeech.AssistiveData[i].TheObject).OnEnter :=
          InitSpeech.AssistiveData[i].OriOnEnter;
      end
      else
      if (assigned(InitSpeech.AssistiveData[i].TheObject)) and
        (InitSpeech.AssistiveData[i].TheObject is TfpgStringgrid) then
      begin
        TfpgStringgrid(InitSpeech.AssistiveData[i].TheObject).OnFocusChange :=
          InitSpeech.AssistiveData[i].OriOnFocusChange;
        TfpgStringgrid(InitSpeech.AssistiveData[i].TheObject).OnMouseDown :=
          InitSpeech.AssistiveData[i].OriOnMouseDown;
         TfpgStringgrid(InitSpeech.AssistiveData[i].TheObject).OnEnter :=
          InitSpeech.AssistiveData[i].OriOnEnter;
      end
      else
      if (assigned(InitSpeech.AssistiveData[i].TheObject)) and
        (InitSpeech.AssistiveData[i].TheObject is TfpgCheckBox) then
      begin
        TfpgCheckBox(InitSpeech.AssistiveData[i].TheObject).OnChange :=
          InitSpeech.AssistiveData[i].OriOnChange;
        TfpgCheckBox(InitSpeech.AssistiveData[i].TheObject).OnEnter :=
          InitSpeech.AssistiveData[i].OriOnEnter;
      end
      else
      if (assigned(InitSpeech.AssistiveData[i].TheObject)) and
        (InitSpeech.AssistiveData[i].TheObject is TfpgTrackBar) then
      begin
        TfpgTrackBar(InitSpeech.AssistiveData[i].TheObject).OnChange :=
          InitSpeech.AssistiveData[i].OriOnTrackbarChange;
        TfpgTrackBar(InitSpeech.AssistiveData[i].TheObject).OnEnter :=
          InitSpeech.AssistiveData[i].OriOnEnter;
      end
      else
      if (assigned(InitSpeech.AssistiveData[i].TheObject)) and
        (InitSpeech.AssistiveData[i].TheObject is TfpgComboBox) then
      begin
        TfpgComboBox(InitSpeech.AssistiveData[i].TheObject).OnChange :=
          InitSpeech.AssistiveData[i].OriOnChange;
        TfpgComboBox(InitSpeech.AssistiveData[i].TheObject).OnEnter :=
          InitSpeech.AssistiveData[i].OriOnEnter;
      end
      else
      if (assigned(InitSpeech.AssistiveData[i].TheObject)) and
        (InitSpeech.AssistiveData[i].TheObject is TfpgListBox) then
      begin
        TfpgListBox(InitSpeech.AssistiveData[i].TheObject).OnChange :=
          InitSpeech.AssistiveData[i].OriOnChange;
        TfpgListBox(InitSpeech.AssistiveData[i].TheObject).OnEnter :=
          InitSpeech.AssistiveData[i].OriOnEnter;
      end
      else
      if (assigned(InitSpeech.AssistiveData[i].TheObject)) and
        (InitSpeech.AssistiveData[i].TheObject is TfpgRadiobutton) then
      begin
        TfpgRadiobutton(InitSpeech.AssistiveData[i].TheObject).OnChange :=
          InitSpeech.AssistiveData[i].OriOnChange;
         TfpgRadiobutton(InitSpeech.AssistiveData[i].TheObject).OnEnter :=
          InitSpeech.AssistiveData[i].OriOnEnter;
      end;
    end;

    SetLength(InitSpeech.AssistiveData, 0);

  end;
end;
////////////////////// Voice Config Procedures ///////////////
function SAKSetVoice(gender : shortint; language : string) : integer;
begin
  if gender = 1 then  initspeech.voice_gender:= 'm3' else initspeech.voice_gender:= 'f2';
  initspeech.voice_language:= language;
end;

////////////////////// Speecher Procedures ////////////////
function espeak_key(Text: string): integer;

begin

   AProcess := TProcess.Create(nil);
   AProcess.Executable:= initspeech.ES_FileName;
    if (initspeech.voice_gender = '') and (initspeech.voice_language = '') then
    begin
   AProcess.Parameters.Add('--path=' + InitSpeech.ES_DataDirectory);
   AProcess.Parameters.Add('"' + Text + '"');
     end else
   begin
   AProcess.Parameters.Add('-v') ;
    AProcess.Parameters.Add(initspeech.voice_language + '+'
    +  initspeech.voice_gender) ;

   AProcess.Parameters.Add('--path=' + InitSpeech.ES_DataDirectory);
   AProcess.Parameters.Add('"' + Text + '"');
     end ;

   AProcess.Options := AProcess.Options + [poNoConsole];
   AProcess.FreeOnRelease;
   AProcess.Execute;

  end;


function SAKSay(Text: string): integer;
begin
 result := espeak_Key(Text);
end;


function espeak_cancel: integer;
begin
  if assigned(AProcess) then
    AProcess.Terminate(0);
end;


end.
