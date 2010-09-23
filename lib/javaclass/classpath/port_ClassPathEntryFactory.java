package at.kugel.tool.classes;

// Kugel's "Java Code & Tools Library", Copyright (c) 1999-2004, Theossos Comp Group
import java.io.File;
import java.io.IOException;
import java.security.InvalidParameterException;
import java.util.Enumeration;
import java.util.List;
import java.util.StringTokenizer;
import java.util.Vector;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

import at.kugel.util.io.WildcardSearch;

/**
 * Factory to get the CPEs (Class Path Entries) from a system path, given path or archive.
 * @author Kugel, <i>Theossos Comp Group</i>
 * @version 1.00 - 13.03.2004
 */
public final class ClassPathEntryFactory
{

   /**
    * 0 = no output, 1 = system path, 2 = archives and directories, 3 = statistics, 5 = duplicates.
    */
   private final int debugLevel = 3;

   private static final String CLASS_EXTENSION = ClassPathEntry.CLASS_EXTENSION;
   private boolean dropInnerClasses = true;
   private boolean dropPackageClasses = true;

   private long numberEntries;
   private long numberDuplicatedEntries;

   private void resetStatistics()
   {
      numberEntries = 0;
      numberDuplicatedEntries = 0;
   }

   private void printStatistics()
   {
      if (dropPackageClasses)
      {

         System.out.println("   Found " + numberEntries + " new and " + numberDuplicatedEntries + " duplicated public classes");

      }
      else
      {

         System.out.println("   Found " + numberEntries + " new and " + numberDuplicatedEntries + " duplicated classes");

      }
   }

   private void addEntryToList(final ClassPathEntry cpe, List<ClassPathEntry> pClassList2Add)
   {
      if (dropInnerClasses && cpe.isInner)
      {
         return;
      }
      if (dropPackageClasses && cpe.isPublic == -1)
      {
         return;
      }

      if (!pClassList2Add.contains(cpe))
      {
         numberEntries++;
         pClassList2Add.add(cpe);

      }
      else
      {

         numberDuplicatedEntries++;

         if (debugLevel >= 5)
         {
            final int i = pClassList2Add.indexOf(cpe);
            final ClassPathEntry duplicated = pClassList2Add.get(i);
            duplicated.setDuplicated(true);
            System.out.println("   Duplicate class: " + cpe + " in " + duplicated.origin + " and " + cpe.origin);
         }
      }
   }

   public void readAllClassesFromDirectory(File pClassPathBase, List<ClassPathEntry> pClassList2Add)
   {
      if (debugLevel >= 2)
      {
         System.out.println(" * Reading classes from directory " + pClassPathBase);
         resetStatistics();
      }

      final Vector<File> foundElements = new Vector<File>();

      WildcardSearch.getFiles(pClassPathBase.getPath() + File.separatorChar + "*" + CLASS_EXTENSION, true, foundElements);
      for (final File file : foundElements)
      {
         final ClassPathEntry cpe = ClassPathEntry.createFromClassFile(pClassPathBase, file);

         addEntryToList(cpe, pClassList2Add);
      }

      foundElements.removeAllElements();

      if (debugLevel >= 3)
      {
         printStatistics();
      }
   }

   public void readAllClassesFromZip(File pZipFile, List<ClassPathEntry> pClassList2Add) throws IOException
   {
      if (debugLevel >= 2)
      {
         System.out.println(" * Reading classes from archive " + pZipFile);
         resetStatistics();
      }

      final ZipFile zf = new ZipFile(pZipFile);
      for (final Enumeration<? extends ZipEntry> en = zf.entries(); en.hasMoreElements();)
      {
         final ZipEntry entry = en.nextElement();

         if (entry.getName().endsWith(CLASS_EXTENSION))
         {
            final ClassPathEntry cpe = ClassPathEntry.createFromZipEntry(pZipFile, entry);
            addEntryToList(cpe, pClassList2Add);
         }

      }

      if (debugLevel >= 3)
      {
         printStatistics();
      }
   }

   public void readAllZipsFromDirectory(File pClassPathBase, List<ClassPathEntry> pClassList2Add) throws IOException
   {
      if (debugLevel >= 2)
      {
         System.out.println(" * Reading jars from directory " + pClassPathBase);
         resetStatistics();
      }

      final Vector<File> foundElements = new Vector<File>();

      WildcardSearch.getFiles(pClassPathBase.getPath() + File.separatorChar + "*.jar", true, foundElements);
      for (final File entry : foundElements)
      {
         readAllClassesFromZip(entry, pClassList2Add);
      }
      foundElements.removeAllElements();

      WildcardSearch.getFiles(pClassPathBase.getPath() + File.separatorChar + "*.zip", true, foundElements);
      for (final File entry : foundElements)
      {
         readAllClassesFromZip(entry, pClassList2Add);
      }
      foundElements.removeAllElements();
   }

   public void readAllFromClassPath(String pPath, List<ClassPathEntry> pClassList2Add) throws IOException
   {
      final StringTokenizer pathTokenizer = new StringTokenizer(pPath, File.pathSeparator);
      while (pathTokenizer.hasMoreTokens())
      {
         final String path = pathTokenizer.nextToken();

         if (path.endsWith(".zip") || path.endsWith(".jar"))
         {
            final File zipFile = new File(path);
            if (zipFile.exists() && zipFile.isFile() && zipFile.canRead())
            {
               readAllClassesFromZip(zipFile, pClassList2Add);
            }
            else
            {
               if (debugLevel >= 2)
               {
                  System.out.println("WARNING: archive " + path + " from classpath not found");
               }
            }

         }
         else
         {

            final File directoryFile = new File(path);
            if (directoryFile.exists() && directoryFile.isDirectory())
            {
               readAllClassesFromDirectory(directoryFile, pClassList2Add);
            }
            else
            {
               if (debugLevel >= 2)
               {
                  System.out.println("WARNING: directory " + path + " from classpath not found");
               }
            }

         }
      }
   }

   private void readAllFromSystemClassPath(String name, List<ClassPathEntry> pClassList2Add) throws IOException
   {
      final String p = System.getProperty(name);

      if (debugLevel >= 1)
      {
         System.out.println("Working on path " + name + " (" + p + ")");
      }

      if (p != null && p.length() > 0)
      {
         if (name.endsWith(".dirs"))
         {
            readAllZipsFromDirectory(new File(p), pClassList2Add);

         }
         else if (name.endsWith(".path"))
         {
            readAllFromClassPath(p, pClassList2Add);

         }
         else
         {
            throw new InvalidParameterException("no path or directory system property given");
         }
      }
   }

   public void readAllFromSystemClassPaths(List<ClassPathEntry> pClassList2Add) throws IOException
   {
      readAllFromSystemClassPath("sun.boot.class.path", pClassList2Add);
      readAllFromSystemClassPath("java.endorsed.dirs", pClassList2Add);
      readAllFromSystemClassPath("java.ext.dirs", pClassList2Add);
      readAllFromSystemClassPath("java.class.path", pClassList2Add);
   }

   public void readAllFromUserClassPaths(String p, List<ClassPathEntry> pClassList2Add) throws IOException
   {
      if (debugLevel >= 1)
      {
         System.out.println("Working on user input (" + p + ")");
      }

      final File userFile = new File(p);
      if (p.indexOf(File.pathSeparator) > -1)
      {
         // this is a pathlist
         readAllFromClassPath(p, pClassList2Add);

      }
      else if (userFile.isDirectory())
      {
         // may be a WEB-INF clone - read all zips and jars
         readAllZipsFromDirectory(userFile, pClassList2Add);
         // but also may be a single class list
         readAllClassesFromDirectory(userFile, pClassList2Add);

      }
      else
      {
         // must be a file - a zip
         readAllClassesFromZip(userFile, pClassList2Add);
      }

   }

   public boolean isDropInnerClasses()
   {
      return dropInnerClasses;
   }

   public void setDropInnerClasses(boolean b)
   {
      dropInnerClasses = b;
   }

   public boolean isDropPackageClasses()
   {
      return dropPackageClasses;
   }

   public void setDropPackageClasses(boolean b)
   {
      dropPackageClasses = b;
   }

   // /** Just for testing. */
   // public static void main(String[] args) throws IOException
   // {
   // final ClassPathEntryFactory fac = new ClassPathEntryFactory();
   // final List<ClassPathEntry> list = new ArrayList<ClassPathEntry>();
   //
   // System.out.println("*** reading ***");
   // fac.readAllFromSystemClassPaths(list);
   // System.out.println("*** sorting ***");
   // Collections.sort(list);
   //
   // System.out.println("found " + list.size() + " classes.");
   // }

}
