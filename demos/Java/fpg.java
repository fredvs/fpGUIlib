public class fpg {
/////////////////////// the fpGUI library declarations ///////////////	
  public static native void initialize(String t);
  public static native void formcreate(int i, int j);
  public static native void formtype(int i, int j);
  public static native void formattributes(int i, int j);
  public static native void formsetposition(int i, int j,int k, int l,int m);
  public static native void formscreenposition(int i, int j);
  public static native void formshow(int i);
  public static native void formhide(int i);
  public static native void formshowmodal(int i);
  public static native void formclose(int i);
  public static native void run();
  public static native void processmessages();
  public static native void formwindowtitle(int i, String t);
  public static native void formbackgroundcolor(int i, int j);
  public static native void formsetwidth(int i, int j);
  public static native void formsetheight(int i, int j);
  public static native int formgetwidth(int i); 
  public static native int formgetheight(int i);
  public static native void formsettop(int i, int j);
  public static native void formsetleft(int i, int j);
  public static native int formgettop(int i); 
  public static native int formgetleft(int i);
  public static native void formupdateposition(int i);
  public static native void formonclick(int i, String t);
  public static native void formonclose(int i, String t);
  
  public static native void buttonsettext(int i, int j, String t);
  public static native void setstyle(String t);
  public static native void buttoncreate(int i, int j, int k, int l);
  public static native void buttononclick(int i, int j, String t);
  public static native void buttonsetposition(int i, int j,int k, int l,int m, int n);
  public static native void buttonsetenabled(int i, int j,int k) ;
  
  public static native int enableassistivecust(String a, String b, String c);
  public static native int enableassistive();
  public static native int disableassistive();
  public static native int freeassistive();
 
  static
  {
    System.loadLibrary("fpgui");
 } 
 
 /////////////// The callback methods used by fpGUI library ////////// 
 public static void formclick0()
 { formwindowtitle(0, "Main form was boum");}
   
   public static void formclose0()
    {freeassistive();}
  
  
  public static void buttonclick0() 
   { formbackgroundcolor(0,123456) ; } 
  
   public static void buttonclick1() 
   { formbackgroundcolor(0,3456) ; } 
  
   public static void buttonclick2() 
   {formsetwidth(0,formgetwidth(0)+(10)) ;
    formsetheight(0,formgetheight(0)+(10)) ; 
    formupdateposition(0) ;} ;
  
   public static void buttonclick3() 
   {formsetleft(0,formgetleft(0)+(10)) ;
    formsettop(0,formgettop(0)+(10)) ; 
    formupdateposition(0) ;}
  
   public static void buttonclick4() 
   {formcreate(1, -1) ;
    formsetposition(1, 300,100,270,100);
    formwindowtitle(1, "hello Galaxy!");
    formscreenposition(1,2) ;
    formbackgroundcolor(1,2563456);
    buttoncreate(1,0,-1,-1) ;
    buttonsetposition(1,0, 90, 40 , 80 , 30);
    buttonsettext(1,0, "close");
    buttononclick(1,0,"buttonclick10"); 
    formshow(1) ;}  
  
   public static void buttonclick10() 
   { formclose(1) ;}  
  
   public static void buttonclick5() 
   {formcreate(2, -1) ;
    formsetposition( 2, 300,100,300,200);
    formwindowtitle(2, "Hello! i am a modal form...");
    formscreenposition(2,2) ;
    formbackgroundcolor(2,63456);
    buttoncreate(2,0,-1,-1) ;
    buttonsetposition(2,0, 100, 70 , 100 , 40);
    buttonsettext(2,0, "close");
    buttononclick(2,0,"buttonclick11"); 
    formshowmodal(2) ;}  
  
    public static void buttonclick11() 
   { formclose(2) ;}  
  
    public static void buttonclick14() 
   {formcreate(3, -1) ;
	formtype(3,3) ;
    formsetposition(3, 300,100,270,100);
    formscreenposition(3,2) ;
    formbackgroundcolor(3,6345612);
    buttoncreate(3,0,-1,-1) ;
    buttonsetposition(3,0, 90, 40 , 80 , 30);
    buttonsettext(3,0, "close");
    buttononclick(3,0,"buttonclick16"); 
    formshow(3) ;}  
  
    public static void buttonclick16() 
   { formclose(3) ;}  
  
    public static void buttonclick15() 
   {formcreate(4, -1) ;
    formsetposition(4, 300,100,300,200);
    formattributes(4,4) ;
    formwindowtitle(4, "Hello! I am always to front...");
    formscreenposition(4,2) ;
    formbackgroundcolor(4,5873456);
    buttoncreate(4,0,-1,-1) ;
    buttonsetposition(4,0, 100, 70 , 100 , 40);
    buttonsettext(4,0, "close");
    buttononclick(4,0,"buttonclick17"); 
    formshow(4) ;}  
  
   public static void buttonclick17() 
   { formclose(4) ;} 
  
   public static void buttonclick6() 
   { setstyle("plastic Light Gray") ;
     formhide(0) ;
     formshow(0) ;
   }  
   public static void buttonclick7() 
   { setstyle("carbon") ;
     formhide(0) ;
     formshow(0) ;
   }  
   public static void buttonclick8() 
   { setstyle("plastic Dark Gray") ;
     formhide(0) ;
     formshow(0) ;
   }  
   public static void buttonclick9() 
   { setstyle("Demo style") ;
     formhide(0) ;
     formshow(0) ;
   } 
   
   public static void buttonclick12() 
   {   buttonsetenabled(0,11,1);
	   buttonsetenabled(0,10,0);
	   
	   String pa = System.getProperty("user.dir");
	   String os = System.getProperty( "os.name" ).toLowerCase();
		
		if( os.indexOf( "win" ) >= 0 )
		{
	  enableassistivecust(pa + "",
	                      pa + "/lib/sakit/libwin32/espeak.exe",
                          pa + "/lib/sakit") ;
			}
		else
	 {
			if( System.getProperty( "os.arch" ).contains( "64" ) )
			{
	  enableassistivecust(pa + "/lib/sakit/liblinux64/libportaudio_x64.so",
	                      pa + "/lib/sakit/liblinux64/speak_x64",
                          pa + "/lib/sakit") ;
			}
			else
			{
	  enableassistivecust(pa + "/lib/sakit/liblinux32/libportaudio_x86.so",
	                      pa + "/lib/sakit/liblinux32/speak_x86",
                          pa + "/lib/sakit") ;
			}
		}		
	
   }  
   public static void buttonclick13() 
   { 
     buttonsetenabled(0,11,0);
	 buttonsetenabled(0,10,1);
	 disableassistive();
   }  
     
///////////////// The main application /////////////////////////  
  public static void main(String[] args) 
  {
  //  System.loadLibrary("fpgui");
    initialize("fpg");  //// the name of main class
      
    setstyle("Demo Style");
    formcreate(0, -1);
    formsetposition(0, 300,100,370,435);
    formscreenposition(0,2);
    formonclick(0,"formclick0");
    formonclose(0,"formclose0");
        
    formwindowtitle(0, "Hello. Im a fpGUI lib form");
   
    buttoncreate(0,0,-1,-1) ;
    buttonsetposition(0,0, 15, 10 , 150 , 40);
    buttonsettext(0,0, "Paint it Green") ;
    buttononclick(0,0,"buttonclick0");
    
    buttoncreate(0,1,-1,-1) ;
    buttonsetposition(0,1, 200, 10 , 150, 40) ;
    buttonsettext(0,1, "Paint it Blue") ;
    buttononclick(0,1,"buttonclick1");
    
    buttoncreate(0,2,-1,-1) ;
    buttonsetposition(0,2, 15, 70 , 150 , 40);
    buttonsettext(0,2, "Resize Me") ;
    buttononclick(0,2,"buttonclick2");
    
    buttoncreate(0,3,-1,-1) ;
    buttonsetposition(0,3, 200, 70 , 150, 40) ;
    buttonsettext(0,3, "Move Me") ;
    buttononclick(0,3,"buttonclick3");
    
    buttoncreate(0,4,-1,-1) ;
    buttonsetposition(0,4, 15, 130 , 150 , 40) ;
    buttonsettext(0,4, "Create Normal form") ;
    buttononclick(0,4,"buttonclick4") ; 

    buttoncreate(0,5,-1,-1) ; ;
    buttonsetposition(0,5, 200, 130 , 150, 40) ;
    buttonsettext(0,5, "Create Modal form") ;
    buttononclick(0,5,"buttonclick5") ;

    buttoncreate(0,6,-1,-1) ; ;
    buttonsetposition(0,6, 15, 250 , 150 , 40) ;
    buttonsettext(0,6, "Style plastic") ;
    buttononclick(0,6,"buttonclick6") ; 

    buttoncreate(0,7,-1,-1) ; ;
    buttonsetposition(0,7, 200, 250 , 150, 40) ;
    buttonsettext(0,7, "Style carbon") ;
    buttononclick(0,7,"buttonclick7") ;

    buttoncreate(0,8,-1,-1) ; ;
    buttonsetposition(0,8, 15, 310 , 150 , 40) ;
    buttonsettext(0,8, "Style Dark") ;
    buttononclick(0,8,"buttonclick8") ; 

    buttoncreate(0,9,-1,-1) ; ;
    buttonsetposition(0,9, 200,310 , 150, 40) ;
    buttonsettext(0,9, "Style custom") ;
    buttononclick(0,9,"buttonclick9") ;

    buttoncreate(0,10,-1,-1) ; ;
    buttonsetposition(0,10, 15, 370 , 150 , 40) ;
    buttonsettext(0,10, "Enable Assistive") ;
    buttononclick(0,10,"buttonclick12") ; 

    buttoncreate(0,11,-1,-1) ; 
    buttonsetposition(0,11, 200,370 , 150, 40) ;
    buttonsettext(0,11, "Disable Assistive") ;
    buttonsetenabled(0,11,0) ;
    buttononclick(0,11,"buttonclick13") ;

    buttoncreate(0,12,-1,-1) ; ;
    buttonsetposition(0,12, 15,190 , 150, 40) ;
    buttonsettext(0,12, "Create splash form") ;
    buttononclick(0,12,"buttonclick14") ;

    buttoncreate(0,13,-1,-1) ; ;
    buttonsetposition(0,13, 200, 190 , 150 , 40) ;
    buttonsettext(0,13,"Create to front" ) ;
    buttononclick(0,13,"buttonclick15") ;

    formshow(0);
    
    run();
   
  }
     
} 

 
