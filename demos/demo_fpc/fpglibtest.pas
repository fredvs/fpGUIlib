program fpglibtest;

uses
  fpgui_h, sysutils ;

var
x : integer = 0;
isassist : boolean = false ;

clred : longword = $ffFF0000 ;

procedure FormClick0(formindex, typeobj, objindex : integer);
begin
if odd(x) then fpgFormBackgroundColor(0,$fff0fff0) else
 fpgFormBackgroundColor(0,$ff9400d3)  ;
inc(x);
end;

procedure ButtonClick00(formindex, typeobj, objindex : integer);
var
title : string ;
begin
title := 'Button 0 was clicked. Total click is ' + inttostr(x);
fpgFormWindowTitle(0, pchar(title));
fpgFormSetWidth(0,fpgFormGetWidth(0)+(10)) ;
fpgFormSetHeight(0,fpgFormGetHeight(0)+(10)) ;
fpgFormUpdatePosition(0);
inc(x);
end;

procedure ButtonClick01(formSender, typeSender, indexSender : integer);
var
title : string ;
begin
title := 'Button 1 was clicked. Total click is ' + inttostr(x);
fpgFormWindowTitle(0, pchar(title));

if odd(x) then fpgFormBackgroundColor(0,$ff32cd32) else
  fpgFormBackgroundColor(0,$ffa52a2a)  ;
inc(x);
end;

procedure FormClick1(formSender, typeSender, indexSender : integer);
begin
 if odd(x) then fpgFormBackgroundColor(1,$ff00ffff) else
  fpgFormBackgroundColor(1,$fff5f5dc)  ;
 inc(x);
 end;

procedure ButtonClick10(formSender, typeSender, indexSender : integer);
var
title : string ;
begin
title := 'Button 0 was clicked. Total click is '+ inttostr(x);
fpgFormWindowTitle(1, pchar(title));
 if odd(x) then fpgFormBackgroundColor(1,$fff0fff0) else
  fpgFormBackgroundColor(1,$ff9400d3)  ;
 inc(x);
end;

procedure ButtonClick11(formSender, typeSender, indexSender : integer);
var
title : string ;
begin
title := 'Button 1 was clicked. Total click is ' +inttostr(x);
fpgFormWindowTitle(1, pchar(title));
fpgFormSetLeft(1,fpgFormGetLeft(1)+(10)) ;
fpgFormSetTop(1,fpgFormGetTop(1)+(10)) ;
fpgFormSetWidth(1,fpgFormGetWidth(1)+(10)) ;
fpgFormSetHeight(1,fpgFormGetHeight(1)+(10)) ;
fpgFormUpdatePosition(1);
inc(x);
end;

procedure FormClick2(formSender, typeSender, indexSender : integer);
begin

if odd(x) then fpgFormBackgroundColor(2,$ff32cd32) else
  fpgFormBackgroundColor(2,$ffa52a2a)  ;
inc(x);

end;

procedure ButtonClick20(formSender, typeSender, indexSender : integer);
var
title : string ;
begin
title := 'Button 0 was clicked. Total click is ' + inttostr(x);
fpgFormWindowTitle(2, pchar(title));

fpgFormSetWidth(2,fpgFormGetWidth(2)+(10)) ;
fpgFormSetHeight(2,fpgFormGetHeight(2)+(10)) ;
if odd(x) then fpgFormBackgroundColor(2,$ff00ffff) else
 fpgFormBackgroundColor(2,$fff5f5dc)  ;
fpgFormUpdatePosition(2);
inc(x);
end;

procedure ButtonClick21(formSender, typeSender, indexSender : integer);
var
title : string ;
begin
title := 'Button 1 was clicked. Total click is ' + inttostr(x);
fpgFormWindowTitle(2, pchar(title));

fpgFormBackgroundColor(2,clred)  ;
inc(clred,50);
end;

procedure enableassist(formSender, typeSender, indexSender : integer);
var
title : string ;
begin
if isassist = false then
begin
   title := 'Disable Assistive';
   fpgButtonSetText(2, 2, Pchar(title));
   //fpgEnableAssistive();
   isassist := true ;
end else
begin
   title := 'Enable Assistive';
     fpgButtonSetText(2, 2, Pchar(title));
     //fpgdisableassistive();
     isassist := false ;
end;
end;

procedure MainProc;

var
indexform : cardinal = 0;
ordir, title : string;
begin
    ordir := IncludeTrailingBackslash(ExtractFilePath(ParamStr(0)));
    {$IFDEF Windows}
      ordir := ordir + 'libfpgui.dll';
    {$ENDIF}

   {$IFDEF linux}
        ordir := ordir + 'libfpgui.so';
    {$ENDIF}

  // writeln('init');

 if fpg_loadlib(pchar(ordir)) then
  try
  
 // writeln('ok fpg_loadlib');
    fpginitialize() ;
    
 //  writeln('ok fpginitialize');  
    
  // fpgSetStyle('Demo Style') ;
        while indexform < 3 do
 begin
    if indexform = 0 then fpgSetStyle('Demo Style') ;
     if indexform = 1 then fpgSetStyle('Motif') ;
      if indexform = 2 then  fpgSetStyle('Plastic Light Gray') ;


    fpgFormCreate(indexform,-1) ;

    fpgFormSetPosition(indexform, 100 + (40 * indexform), 100 + (40 * indexform), 600 + (40 * indexform), 300+ (40 * indexform));
    fpgFormWindowTitle(indexform, pchar('Hello world... I am form ' + inttostr(indexform) + ' from fpg library.  Click on me please...'));

    if indexform = 0 then fpgFormOnClick(indexform,@FormClick0);
    if indexform = 1 then fpgFormOnClick(indexform,@FormClick1);
    if indexform = 2 then fpgFormOnClick(indexform,@FormClick2);

       fpgButtonCreate(indexform,0,0,0) ;
       fpgButtonCreate(indexform,1,0,0) ;

       fpgButtonSetPosition(indexform,0, 150, 100 , 150 , 40)  ;
       fpgButtonSetPosition(indexform, 1, 350, 100 , 150, 40)  ;

    title := 'Test 1';
   fpgButtonSetText(indexform, 0, Pchar(title));
      title := 'Test 2';
   fpgButtonSetText(indexform, 1, Pchar(title));

   if indexform = 0 then
    begin
    fpgButtonOnClick(indexform,0,@ButtonClick00) ;
    fpgButtonOnClick(indexform,1,@ButtonClick01);
    end;

    if indexform = 1 then
    begin
    fpgButtonOnClick(indexform,0,@ButtonClick10) ;
    fpgButtonOnClick(indexform,1,@ButtonClick11);
    end;

     if indexform = 2 then
    begin
    fpgButtonOnClick(indexform,0,@ButtonClick20) ;
    fpgButtonOnClick(indexform,1,@ButtonClick21);

    // fpgButtonCreate(indexform,2,0,0) ;
    // fpgButtonSetPosition(indexform, 2, 250, 200 , 150, 40)  ;
    //   title := 'Enable Assistive';
    // fpgButtonSetText(indexform, 2, Pchar(title));
    // fpgButtonOnClick(indexform,2,@enableassist);
    end;

     fpgFormShow(indexform)  ;
      inc(indexform);
       end;

      fpgRun();
    finally
  // fpgFreeAssistive();
    fpg_unloadlib();
  end;
end;

begin
  MainProc;
end.
