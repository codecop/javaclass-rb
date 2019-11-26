package packagename;

public class PublicClass {

   private class PublicClass_PrivateInnerClass {
   }

   private static class PublicClass_StaticPrivateInnerClass {
   }

   class PublicClass_PackageInnerClass {
   }
   
   static class PublicClass_StaticPackageInnerClass {
   }

   public class PublicClass_PublicInnerClass {
   }
   
   public static class PublicClass_StaticPublicInnerClass {
   }
   
   void named() {
       class Method_PackageInnerClass {
       }
   }

   void anonymous() {
       new Runnable() {
           public void run() {
           }
       };
   }
}

class PackageClass {

    private class PackageClass_PrivateInnerClass {
    }

    private static class PackageClass_StaticPrivateInnerClass {
    }

    class PackageClass_PackageInnerClass {
    }
    
    static class PackageClass_StaticPackageInnerClass {
    }

    public class PackageClass_PublicInnerClass {
    }
    
    public static class PackageClass_StaticPublicInnerClass {
    }
}
