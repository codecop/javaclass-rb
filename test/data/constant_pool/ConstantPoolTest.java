public class ConstantPoolTest implements Runnable {

   // Class - it's own and Object
   // Field ref (plus String)
   String stringField = "String field";
   // Method ref - Object ctor
   // InterfaceMethod
   {
      ((Runnable)this).run();
   }
   final int intField = 42;
   float floatField = 3.1415898996736E+22f;
   long longField = 99999999L;
   double doubleField = 3.14159265258979E-208;
   // NameAndType - ctor init
   // Asciz - classname

   public void run(){}

}
