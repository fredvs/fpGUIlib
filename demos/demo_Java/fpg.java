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
 
 } 

 
