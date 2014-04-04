#file fpgui-at-test_win.py
import string 
import os,sys
dia = sys.path[0]
from ctypes import*

def theproc(frmindx,typobj,objindx):
    fpgui.fpgformwindowtitle(0, 'Main Form was clicked...')
    return 0 

def theprocbut0(frmindx,typobj,objindx):
    fpgui.fpgformbackgroundcolor(0,123456)
    return 0 
    
def theprocbut1(frmindx,typobj,objindx):
    fpgui.fpgformbackgroundcolor(0,3456)
    return 0 

def theprocbut2(frmindx,typobj,objindx):
    fpgui.fpgformsetwidth(0,fpgui.fpgformgetwidth(0)+(10)) 
    fpgui.fpgformsetheight(0,fpgui.fpgformgetheight(0)+(10)) 
    fpgui.fpgformupdateposition(0)
    return 0 
    
def theprocbut3(frmindx,typobj,objindx):
    fpgui.fpgformsetleft(0,fpgui.fpgformgetleft(0)+(10)) 
    fpgui.fpgformsettop(0,fpgui.fpgformgettop(0)+(10)) 
    fpgui.fpgformupdateposition(0)
    return 0 
    
def theprocbut4(frmindx,typobj,objindx):
    fpgui.fpgformcreate(1, -1)
    fpgui.fpgformsetposition(1, 300,100,270,100)
    fpgui.fpgformwindowtitle(1, 'Hello Galaxy!')
    fpgui.fpgformscreenposition(1,2)
    fpgui.fpgformbackgroundcolor(1,2563456)
    fpgui.fpgbuttoncreate(1,0,-1) ;
    fpgui.fpgbuttonsetposition(1,0, 90, 40 , 80 , 30)
    fpgui.fpgbuttonsettext(1,0, 'close')
    fpgui.fpgbuttononclick(1,0,theprocb10) 
    fpgui.fpgformshow(1)
    return 0 
    
def theprocbut5(frmindx,typobj,objindx):
    fpgui.fpgformcreate(2, -1)
    fpgui.fpgformsetposition(2, 300,100,300,200)
    fpgui.fpgformwindowtitle(2, 'Hello universe! i am a modal form...')
    fpgui.fpgformscreenposition(2,2)
    fpgui.fpgformbackgroundcolor(2,63456)
    fpgui.fpgbuttoncreate(2,0,-1) ;
    fpgui.fpgbuttonsetposition(2,0, 100, 70 , 100 , 40)
    fpgui.fpgbuttonsettext(2,0, 'close')
    fpgui.fpgbuttononclick(2,0,theprocb11) 
    fpgui.fpgformshowmodal(2)
    return 0 
 
def theprocbut6(frmindx,typobj,objindx):
    fpgui.fpgsetstyle('plastic Light Gray')
    fpgui.fpgformhide(0) 
    fpgui.fpgformshow(0) 
    return 0  
  
def theprocbut7(frmindx,typobj,objindx):
    fpgui.fpgsetstyle('carbon')
    fpgui.fpgformhide(0) 
    fpgui.fpgformshow(0) 
    return 0    
    
def theprocbut8(frmindx,typobj,objindx):
    fpgui.fpgsetstyle('plastic Dark Gray')
    fpgui.fpgformhide(0) 
    fpgui.fpgformshow(0) 
    return 0 
  
def theprocbut9(frmindx,typobj,objindx):
    fpgui.fpgsetstyle('Demo style')
    fpgui.fpgformhide(0) 
    fpgui.fpgformshow(0) 
    return 0 
    
def theprocbut10(frmindx,typobj,objindx):
    fpgui.fpgformclose(1) 
    return 0  

def theprocbut11(frmindx,typobj,objindx):
    fpgui.fpgformclose(2) 
    return 0   
    
def theprocbut12(frmindx,typobj,objindx):
    fpgui.fpgbuttonsetenabled(0,11,1)
    fpgui.fpgbuttonsetenabled(0,10,0)
    fpgui.fpgenableassistivecust( '',dia + '/sakit/libwin32/espeak.exe',dia + '/sakit')   
    return 0 
    
def theprocbut13(frmindx,typobj,objindx):
    fpgui.fpgbuttonsetenabled(0,11,0)
    fpgui.fpgbuttonsetenabled(0,10,1)
    fpgui.fpgdisableassistive()
    return 0 
    
def theprocbut14(frmindx,typobj,objindx):
    fpgui.fpgformcreate(3, -1)
    fpgui.fpgformtype(3,3)
    fpgui.fpgformwindowtitle(2, 'Hello universe! I am a splash form...')
    fpgui.fpgformsetposition(3, 300,100,270,100)
    fpgui.fpgformscreenposition(3,2)
    fpgui.fpgformbackgroundcolor(3,6345612)
    fpgui.fpgbuttoncreate(3,0,-1) ;
    fpgui.fpgbuttonsetposition(3,0, 90, 40 , 80 , 30)
    fpgui.fpgbuttonsettext(3,0, 'close')
    fpgui.fpgbuttononclick(3,0,theprocb16) 
    fpgui.fpgformshow(3)
    return 0 
    
def theprocbut15(frmindx,typobj,objindx):
    fpgui.fpgformcreate(4, -1)
    fpgui.fpgformsetposition(4, 300,100,300,200)
    fpgui.fpgformwindowtitle(4, 'i am Always to front...')
    fpgui.fpgformscreenposition(4,2)
    fpgui.fpgformattributes(4,4)
    fpgui.fpgformbackgroundcolor(4,5873456)
    fpgui.fpgbuttoncreate(4,0,-1) ;
    fpgui.fpgbuttonsetposition(4,0, 100, 70 , 100 , 40)
    fpgui.fpgbuttonsettext(4,0, 'close')
    fpgui.fpgbuttononclick(4,0,theprocb17) 
    fpgui.fpgformshow(4)
    return 0   

def theprocbut16(frmindx,typobj,objindx):
    fpgui.fpgformclose(3) 
    return 0  

def theprocbut17(frmindx,typobj,objindx):
    fpgui.fpgformclose(4) 
    return 0  
     
CMPFUNC = CFUNCTYPE(c_int,c_int,c_int,c_int)

theprocf = CMPFUNC(theproc)
theprocb0 = CMPFUNC(theprocbut0)
theprocb1 = CMPFUNC(theprocbut1)
theprocb2 = CMPFUNC(theprocbut2)
theprocb3 = CMPFUNC(theprocbut3)
theprocb4 = CMPFUNC(theprocbut4)
theprocb5 = CMPFUNC(theprocbut5)
theprocb6 = CMPFUNC(theprocbut6)
theprocb7 = CMPFUNC(theprocbut7)
theprocb8 = CMPFUNC(theprocbut8)
theprocb9 = CMPFUNC(theprocbut9)
theprocb10 = CMPFUNC(theprocbut10)
theprocb11 = CMPFUNC(theprocbut11)
theprocb12 = CMPFUNC(theprocbut12)
theprocb13 = CMPFUNC(theprocbut13)
theprocb14 = CMPFUNC(theprocbut14)
theprocb15 = CMPFUNC(theprocbut15)
theprocb16 = CMPFUNC(theprocbut16)
theprocb17 = CMPFUNC(theprocbut17)

fpgui = cdll.LoadLibrary(di + "fpgui.dll")

fpgui.fpginitialize()
fpgui.fpgsetstyle('Demo style')
fpgui.fpgformcreate(0, -1)
fpgui.fpgformsetposition(0, 300,100,370,435)
fpgui.fpgformwindowtitle(0, 'hello world! i am a fpGui form...')

fpgui.fpgformonclick(0,theprocf) 

fpgui.fpgbuttoncreate(0,0,-1,-1) ;
fpgui.fpgbuttonsetposition(0,0, 15, 10 , 150 , 40)
fpgui.fpgbuttonsettext(0,0, 'paint it Green')
fpgui.fpgbuttononclick(0,0,theprocb0) 

fpgui.fpgbuttoncreate(0,1,-1,-1) ;
fpgui.fpgbuttonsetposition(0,1, 200, 10 , 150, 40)
fpgui.fpgbuttonsettext(0,1, 'paint it blue')
fpgui.fpgbuttononclick(0,1,theprocb1)

fpgui.fpgbuttoncreate(0,2,-1,-1) ;
fpgui.fpgbuttonsetposition(0,2, 15, 70 , 150 , 40)
fpgui.fpgbuttonsettext(0,2, 'resize Me')
fpgui.fpgbuttononclick(0,2,theprocb2) 

fpgui.fpgbuttoncreate(0,3,-1,-1) ;
fpgui.fpgbuttonsetposition(0,3, 200, 70 , 150, 40)
fpgui.fpgbuttonsettext(0,3, 'Move Me')
fpgui.fpgbuttononclick(0,3,theprocb3)

fpgui.fpgbuttoncreate(0,4,-1,-1) ;
fpgui.fpgbuttonsetposition(0,4, 15, 130 , 150 , 40)
fpgui.fpgbuttonsettext(0,4, 'create Normal form')
fpgui.fpgbuttononclick(0,4,theprocb4) 

fpgui.fpgbuttoncreate(0,5,-1,-1) ;
fpgui.fpgbuttonsetposition(0,5, 200, 130 , 150, 40)
fpgui.fpgbuttonsettext(0,5, 'create Modal form')
fpgui.fpgbuttononclick(0,5,theprocb5)

fpgui.fpgbuttoncreate(0,6,-1,-1) ;
fpgui.fpgbuttonsetposition(0,6, 15, 250 , 150 , 40)
fpgui.fpgbuttonsettext(0,6, 'style plastic')
fpgui.fpgbuttononclick(0,6,theprocb6) 

fpgui.fpgbuttoncreate(0,7,-1,-1) ;
fpgui.fpgbuttonsetposition(0,7, 200, 250 , 150, 40)
fpgui.fpgbuttonsettext(0,7, 'style carbon')
fpgui.fpgbuttononclick(0,7,theprocb7)

fpgui.fpgbuttoncreate(0,8,-1,-1) ;
fpgui.fpgbuttonsetposition(0,8, 15, 310 , 150 , 40)
fpgui.fpgbuttonsettext(0,8, 'style Dark')
fpgui.fpgbuttononclick(0,8,theprocb8) 

fpgui.fpgbuttoncreate(0,9,-1,-1) ;
fpgui.fpgbuttonsetposition(0,9, 200,310 , 150, 40)
fpgui.fpgbuttonsettext(0,9, 'style custom')
fpgui.fpgbuttononclick(0,9,theprocb9)

fpgui.fpgbuttoncreate(0,10,-1,-1) ;
fpgui.fpgbuttonsetposition(0,10, 15, 370 , 150 , 40)
fpgui.fpgbuttonsettext(0,10, 'enable Assistive')
fpgui.fpgbuttononclick(0,10,theprocb12) 

fpgui.fpgbuttoncreate(0,11,-1,-1) ;
fpgui.fpgbuttonsetposition(0,11, 200,370 , 150, 40)
fpgui.fpgbuttonsettext(0,11, 'Disable Assistive')
fpgui.fpgbuttonsetenabled(0,11,0)
fpgui.fpgbuttononclick(0,11,theprocb13)

fpgui.fpgbuttoncreate(0,12,-1,-1) ;
fpgui.fpgbuttonsetposition(0,12, 15,190 , 150, 40)
fpgui.fpgbuttonsettext(0,12, 'create splash form')
fpgui.fpgbuttononclick(0,12,theprocb14)

fpgui.fpgbuttoncreate(0,13,-1,-1) ;
fpgui.fpgbuttonsetposition(0,13, 200, 190 , 150 , 40)
fpgui.fpgbuttonsettext(0,13,'create to front' )
fpgui.fpgbuttononclick(0,13,theprocb15) 


fpgui.fpgformscreenposition(0,2)
fpgui.fpgformshow(0)
fpgui.fpgrun()
