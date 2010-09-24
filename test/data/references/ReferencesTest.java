public class ReferencesTest {

   private ReferencesTest field; // self reference

   public ReferencesTest() {
      super(); // Object is super class, also has ctor
      field.x();
   }

  public void x() { }

}
