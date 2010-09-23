package at.kugel.tool.classes;

// Kugel's "Java Code & Tools Library", Copyright (c) 1999-2004, Theossos Comp Group
import java.io.File;
import java.lang.reflect.Modifier;
import java.util.zip.ZipEntry;

/**
 * An entry of a class in the classpath. This contains the reference to the fully qualified name and where to find it.
 * @author Kugel, <i>Theossos Comp Group</i>
 * @version 1.00 - 13.03.2004
 * @since JDK1.2
 */
public final class ClassPathEntry implements Comparable<ClassPathEntry>
{

   public static final String CLASS_EXTENSION = ".class";

   /** Value to be set by factory if we want to check for public or all classes. */
   static boolean checkForPublic = true;

   public final String className;
   public final String packageName;
   public final File origin;
   public final boolean isInner;
   /** Ternary value. 0 = not checked, 1 = yes, -1 = no. */
   public final int isPublic;

   private boolean duplicated;

   public ClassPathEntry(String pClassName, String pPackageName, File pOrigin)
   {
      className = pClassName;
      packageName = pPackageName.intern();
      origin = pOrigin;
      isInner = (pClassName.indexOf('$') > -1);

      int ip = 0;
      if (checkForPublic)
      {
         try
         {
            // classloader does NOT resolve classes, i.e. no static thingies are run...
            if ((ClassLoader.getSystemClassLoader().loadClass(toString()).getModifiers() & Modifier.PUBLIC) > 0)
            {
               ip = 1;
            }
            else
            {
               ip = -1;
            }
         }
         catch (final ClassNotFoundException ex)
         {
            ip = 0;
         }
         catch (final LinkageError ex)
         {
            // ex.printStackTrace();
            // may be NoClassDefFoundError or ClassFormatError (if references to other),
            // or SecurityEx
            ip = 0;
            System.err.println("WARNING: could not load " + toString() + " (" + ex.toString() + ")");
         }
      }
      isPublic = ip;

      // System.out.println("found " + packageName + "." + className + " in " + pOrigin);
   }

   @Override
   public boolean equals(Object obj)
   {
      if (!(obj instanceof ClassPathEntry))
      {
         return false;
      }

      final ClassPathEntry ce = (ClassPathEntry) obj;
      return ce.className.equals(className) && ce.packageName.equals(packageName);
   }

   @Override
   public int hashCode()
   {
      return className.hashCode() ^ packageName.hashCode();
   }

   @Override
   public final String toString()
   {
      if (packageName.length() == 0)
      {
         return className;
      }
      return packageName + '.' + className;
   }

   public int compareTo(ClassPathEntry o)
   {
      return toString().compareTo(o.toString());
   }

   // --- static ---

   private static ClassPathEntry create(String pClass, String pPackage, File pOrigin)
   {
      return new ClassPathEntry(pClass, pPackage, pOrigin);
   }

   static ClassPathEntry createFromClassFile(File pClassPathBase, File pClassInFileSystem)
   {
      final String baseDirectory = pClassPathBase.getPath();
      final String fullName = pClassInFileSystem.getPath().substring(baseDirectory.length());

      // get the path
      String path;
      final int i = fullName.lastIndexOf(File.separatorChar);
      if (i > -1)
      {
         path = fullName.substring(0, i).replace(File.separatorChar, '.');
      }
      else
      {
         path = "";
      }

      // get the name
      String name;
      if (i > -1)
      {
         name = fullName.substring(i + 1);
      }
      else
      {
         throw new IllegalArgumentException("no classname in entry: " + fullName);
      }

      if (name.endsWith(CLASS_EXTENSION))
      {
         name = name.substring(0, name.length() - 6);
      }
      else
      {
         throw new IllegalArgumentException("no classs file: " + fullName);
      }

      return create(name, path, pClassInFileSystem);
   }

   static ClassPathEntry createFromZipEntry(File pZipFile, ZipEntry pClassInZip)
   {
      final char ZIP_PATH_CHAR = '/';

      final String fullName = pClassInZip.getName();

      // get the path
      String path;
      final int i = fullName.lastIndexOf(ZIP_PATH_CHAR);
      if (i > -1)
      {
         path = fullName.substring(0, i).replace(ZIP_PATH_CHAR, '.');
      }
      else
      {
         path = "";
      }

      // get the name
      String name;
      if (i > -1)
      {
         name = fullName.substring(i + 1);
      }
      else
      {
         name = fullName;
      }

      if (name.endsWith(CLASS_EXTENSION))
      {
         name = name.substring(0, name.length() - 6);
      }
      else
      {
         throw new IllegalArgumentException("no class file: " + fullName);
      }

      return create(name, path, pZipFile);
   }

   public boolean isDuplicated()
   {
      return duplicated;
   }

   public void setDuplicated(boolean b)
   {
      duplicated = b;
   }

}
