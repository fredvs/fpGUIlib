unit fpglib_class;

{$DEFINE Java}     //// uncomment if you want a Java-compatible fpGuI library

interface

uses
   {$IF DEFINED(Java)}
     jni,
   {$endif}
  ctypes,
  fpg_grid,
  fpg_Panel,
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
  fpg_dialogs;

type
  TProc = procedure(SenderFormIndex, SenderTypeIndex, SenderIndex : cint32);
///////// fpg_Button
  type
    TxButton = class(TfpgButton)
   public
   Index : cint32;
   TypeObj : cint32 ;
   FormIndex : cint32;
   {$IF DEFINED(Java)}
  onClickProc: JMethodID;
  PEnv : PJNIEnv;
  Obj:JObject;
  {$else}
  onClickProc: TProc ;
  {$endif}
   procedure OnClickPr(Sender: TObject);
    end;

///////// fpg_Panel
    type
     TxPanel = class(TfpgPanel)
     public
    Index : cint32;
    TypeObj : cint32 ;
    FormIndex : cint32;
    {$IF DEFINED(Java)}
  onClickProc: JMethodID;
  PEnv : PJNIEnv;
  Obj:JObject;
  {$else}
  onClickProc: TProc ;
  {$endif}
    procedure OnClickPr(Sender: TObject);
     end;


/////////// fpg_Form
type
  TxForm = class(TfpgForm)
 public
 Index : cint32;
 TypeObj : cint32 ;
 AfpgButton : array of TxButton;
 AfpgPanel : array of TxPanel;
 // OnAfterCreate : procedure;
 // procedure AfterCreate; override;
 {$IF DEFINED(Java)}
  onClickProc: JMethodID;
  oncloseProc: JMethodID;
  PEnv : PJNIEnv;
  Obj:JObject;
  {$else}
  onClickProc: TProc ;
  oncloseProc: TProc ;
  {$endif}
 procedure OnClickPr(Sender: TObject);
 procedure OnClosePr(Sender: TObject; var act : Tcloseaction);
  end;

var
 AfpgForm : array of TxForm; ////// the main Forms-array

implementation

procedure TxForm.onClickPr(Sender: TObject);
begin
  if onClickProc <> nil then 
{$IF DEFINED(Java)}
  (PEnv^^).CallVoidMethod(PEnv,Obj,onClickProc)  ;
{$else}
 onClickProc(index,TypeObj,index);
 {$endif}
end;

procedure TxForm.onclosePr(Sender: TObject; var act : Tcloseaction);
begin
  if oncloseProc <> nil then
 {$IF DEFINED(Java)} 
 (PEnv^^).CallVoidMethod(PEnv,Obj,oncloseProc)  ;
{$else}
 oncloseProc(index,TypeObj,index);
 {$endif}
end;


procedure TxButton.onClickPr(Sender: TObject);
begin
  if onClickProc <> nil then 
{$IF DEFINED(Java)}  
  (PEnv^^).CallVoidMethod(PEnv,Obj,onClickProc)  ;
{$else}
 onClickProc(index,TypeObj,index);
 {$endif}
end;

procedure TxPanel.onClickPr(Sender: TObject);
begin
  if onClickProc <> nil then 
  {$IF DEFINED(Java)}
  (PEnv^^).CallVoidMethod(PEnv,Obj,onClickProc)  ;
 {$else}
 onClickProc(index,TypeObj,index);
 {$endif}
 end;

begin
end.