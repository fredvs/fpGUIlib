public class fpg_demo {

 /////////////// The callback methods used by fpGUI library ////////// 
 public static void formclick0()
 {fpg.formwindowtitle(0, "Main form was clicked");}
   
   public static void formclose0()
    {fpg.freeassistive();}
   
  public static void buttonclick0() 
   {fpg.formbackgroundcolor(0,123456) ; } 
  
   public static void buttonclick1() 
   {fpg.formbackgroundcolor(0,3456) ; } 
  
   public static void buttonclick2() 
   {fpg.formsetwidth(0,fpg.formgetwidth(0)+(10)) ;
    fpg.formsetheight(0,fpg.formgetheight(0)+(10)) ; 
    fpg.formupdateposition(0) ;} ;
  
   public static void buttonclick3() 
   {fpg.formsetleft(0,fpg.formgetleft(0)+(10)) ;
    fpg.formsettop(0,fpg.formgettop(0)+(10)) ; 
    fpg.formupdateposition(0) ;}
  
   public static void buttonclick4() 
   {fpg.formcreate(1, -1) ;
    fpg.formsetposition(1, 300,100,270,100);
    fpg.formwindowtitle(1, "hello Galaxy!");
    fpg.formscreenposition(1,2) ;
    fpg.formbackgroundcolor(1,2563456);
    fpg.buttoncreate(1,0,-1,-1) ;
    fpg.buttonsetposition(1,0, 90, 40 , 80 , 30);
    fpg.buttonsettext(1,0, "close");
    fpg.buttononclick(1,0,"buttonclick10"); 
    fpg.formshow(1) ;}  
  
   public static void buttonclick10() 
   { fpg.formclose(1) ;}  
  
   public static void buttonclick5() 
   {fpg.formcreate(2, -1) ;
    fpg.formsetposition( 2, 300,100,300,200);
    fpg.formwindowtitle(2, "Hello! i am a modal form...");
    fpg.formscreenposition(2,2) ;
    fpg.formbackgroundcolor(2,63456);
    fpg.buttoncreate(2,0,-1,-1) ;
    fpg.buttonsetposition(2,0, 100, 70 , 100 , 40);
    fpg.buttonsettext(2,0, "close");
    fpg.buttononclick(2,0,"buttonclick11"); 
    fpg.formshowmodal(2) ;}  
  
    public static void buttonclick11() 
   {fpg.formclose(2) ;}  
  
    public static void buttonclick14() 
   {fpg.formcreate(3, -1) ;
	fpg.formtype(3,3) ;
    fpg.formsetposition(3, 300,100,270,100);
    fpg.formscreenposition(3,2) ;
    fpg.formbackgroundcolor(3,6345612);
    fpg.buttoncreate(3,0,-1,-1) ;
    fpg.buttonsetposition(3,0, 90, 40 , 80 , 30);
    fpg.buttonsettext(3,0, "close");
    fpg.buttononclick(3,0,"buttonclick16"); 
    fpg.formshow(3) ;}  
  
    public static void buttonclick16() 
   {fpg.formclose(3) ;}  
  
    public static void buttonclick15() 
   {fpg.formcreate(4, -1) ;
    fpg.formsetposition(4, 300,100,300,200);
    fpg.formattributes(4,4) ;
    fpg.formwindowtitle(4, "Hello! I am always to front...");
    fpg.formscreenposition(4,2) ;
    fpg.formbackgroundcolor(4,5873456);
    fpg.buttoncreate(4,0,-1,-1) ;
    fpg.buttonsetposition(4,0, 100, 70 , 100 , 40);
    fpg.buttonsettext(4,0, "close");
    fpg.buttononclick(4,0,"buttonclick17"); 
    fpg.formshow(4) ;}  
  
   public static void buttonclick17() 
   {fpg.formclose(4) ;} 
  
   public static void buttonclick6() 
   {fpg.setstyle("plastic Light Gray") ;
    fpg.formhide(0) ;
    fpg.formshow(0) ;
   }  
   public static void buttonclick7() 
   {fpg.setstyle("carbon") ;
    fpg.formhide(0) ;
    fpg.formshow(0) ;
   }  
   public static void buttonclick8() 
   {fpg.setstyle("plastic Dark Gray") ;
    fpg.formhide(0) ;
    fpg.formshow(0) ;
   }  
   public static void buttonclick9() 
   {fpg.setstyle("Demo style") ;
    fpg.formhide(0) ;
    fpg.formshow(0) ;
   } 
   
   public static void buttonclick12() 
   {fpg.buttonsetenabled(0,11,1);
	fpg.buttonsetenabled(0,10,0);
	   
	   String pa = System.getProperty("user.dir");
	   String os = System.getProperty( "os.name" ).toLowerCase();
		
		if( os.indexOf( "win" ) >= 0 )
		{
	fpg.enableassistivecust(pa + "",
	                      pa + "/sakit/libwin32/espeak.exe",
                          pa + "/sakit") ;
			}
		else
	 {
			if( System.getProperty( "os.arch" ).contains( "64" ) )
			{
	fpg.enableassistivecust(pa + "/sakit/liblinux64/libportaudio_x64.so",
	                      pa + "/sakit/liblinux64/speak_x64",
                          pa + "/sakit") ;
			}
			else
			{
	fpg.enableassistivecust(pa + "/sakit/liblinux32/libportaudio_x86.so",
	                      pa + "/sakit/liblinux32/speak_x86",
                          pa + "/sakit") ;
			}
		}		
	
   }  
   public static void buttonclick13() 
   {
    fpg.buttonsetenabled(0,11,0);
	fpg.buttonsetenabled(0,10,1);
	fpg.disableassistive();
   }  
     
///////////////// The main application /////////////////////////  
  public static void main(String[] args) 
  {
   System.loadLibrary("fpgui");
    fpg.initialize("fpg_demo");  //// the name of main class
      
    fpg.setstyle("Demo Style");
    fpg.formcreate(0, -1);
    fpg.formsetposition(0, 300,100,370,435);
    fpg.formscreenposition(0,2);
    fpg.formonclick(0,"formclick0");
    fpg.formonclose(0,"formclose0");
        
    fpg.formwindowtitle(0, "Hello. Im a fpGUI lib form");
   
    fpg.buttoncreate(0,0,-1,-1) ;
    fpg.buttonsetposition(0,0, 15, 10 , 150 , 40);
    fpg.buttonsettext(0,0, "Paint it Green") ;
    fpg.buttononclick(0,0,"buttonclick0");
    
    fpg.buttoncreate(0,1,-1,-1) ;
    fpg.buttonsetposition(0,1, 200, 10 , 150, 40) ;
    fpg.buttonsettext(0,1, "Paint it Blue") ;
    fpg.buttononclick(0,1,"buttonclick1");
    
    fpg.buttoncreate(0,2,-1,-1) ;
    fpg.buttonsetposition(0,2, 15, 70 , 150 , 40);
    fpg.buttonsettext(0,2, "Resize Me") ;
    fpg.buttononclick(0,2,"buttonclick2");
    
    fpg.buttoncreate(0,3,-1,-1) ;
    fpg.buttonsetposition(0,3, 200, 70 , 150, 40) ;
    fpg.buttonsettext(0,3, "Move Me") ;
    fpg.buttononclick(0,3,"buttonclick3");
    
    fpg.buttoncreate(0,4,-1,-1) ;
    fpg.buttonsetposition(0,4, 15, 130 , 150 , 40) ;
    fpg.buttonsettext(0,4, "Create Normal form") ;
    fpg.buttononclick(0,4,"buttonclick4") ; 

    fpg.buttoncreate(0,5,-1,-1) ; ;
    fpg.buttonsetposition(0,5, 200, 130 , 150, 40) ;
    fpg.buttonsettext(0,5, "Create Modal form") ;
    fpg.buttononclick(0,5,"buttonclick5") ;

    fpg.buttoncreate(0,6,-1,-1) ; ;
    fpg.buttonsetposition(0,6, 15, 250 , 150 , 40) ;
    fpg.buttonsettext(0,6, "Style plastic") ;
    fpg.buttononclick(0,6,"buttonclick6") ; 

    fpg.buttoncreate(0,7,-1,-1) ; ;
    fpg.buttonsetposition(0,7, 200, 250 , 150, 40) ;
    fpg.buttonsettext(0,7, "Style carbon") ;
    fpg.buttononclick(0,7,"buttonclick7") ;

    fpg.buttoncreate(0,8,-1,-1) ; ;
    fpg.buttonsetposition(0,8, 15, 310 , 150 , 40) ;
    fpg.buttonsettext(0,8, "Style Dark") ;
    fpg.buttononclick(0,8,"buttonclick8") ; 

    fpg.buttoncreate(0,9,-1,-1) ; ;
    fpg.buttonsetposition(0,9, 200,310 , 150, 40) ;
    fpg.buttonsettext(0,9, "Style custom") ;
    fpg.buttononclick(0,9,"buttonclick9") ;

    fpg.buttoncreate(0,10,-1,-1) ; ;
    fpg.buttonsetposition(0,10, 15, 370 , 150 , 40) ;
    fpg.buttonsettext(0,10, "Enable Assistive") ;
    fpg.buttononclick(0,10,"buttonclick12") ; 

    fpg.buttoncreate(0,11,-1,-1) ; 
    fpg.buttonsetposition(0,11, 200,370 , 150, 40) ;
    fpg.buttonsettext(0,11, "Disable Assistive") ;
    fpg.buttonsetenabled(0,11,0) ;
    fpg.buttononclick(0,11,"buttonclick13") ;

    fpg.buttoncreate(0,12,-1,-1) ; ;
    fpg.buttonsetposition(0,12, 15,190 , 150, 40) ;
    fpg.buttonsettext(0,12, "Create splash form") ;
    fpg.buttononclick(0,12,"buttonclick14") ;

    fpg.buttoncreate(0,13,-1,-1) ; ;
    fpg.buttonsetposition(0,13, 200, 190 , 150 , 40) ;
    fpg.buttonsettext(0,13,"Create to front" ) ;
    fpg.buttononclick(0,13,"buttonclick15") ;

    fpg.formshow(0);
    
    fpg.run();
   
  }
}
     
