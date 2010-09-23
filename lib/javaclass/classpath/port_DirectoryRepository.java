package at.kugel.util.code.bcel;

//Kugel's "Java Code & Tools Library", Copyright (c) 1999-2004, Theossos Comp Group
import java.io.File;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.bcel.Repository;
import org.apache.bcel.classfile.JavaClass;
import org.apache.bcel.util.ClassPath;
import org.apache.bcel.util.SyntheticRepository;

import at.kugel.util.io.WildcardSearchEnumeration;

/**
 * Repository of classes in a simple class directory.
 * @author Kugel, <i>Theossos Comp Group</i>
 * @version 1.00 - 25.06.2004
 */
public final class DirectoryRepository implements ClassFileRepository
{

   private final Map<String, File> filesInRepository = new HashMap<String, File>();
   private final File baseDir;

   public DirectoryRepository(File baseDirectory)
   {
      this(baseDirectory, null);
   }

   public DirectoryRepository(File baseDirectory, String pClassPath)
   {
      baseDir = baseDirectory;

      String fullClassPath = System.getProperty("java.home") + File.separator + "lib" + File.separator + "rt.jar";
      if (pClassPath != null)
      {
         fullClassPath += ';' + pClassPath;
      }

      final ClassPath singleDirClassPath = new ClassPath(fullClassPath + File.pathSeparatorChar + baseDir.toString());
      Repository.setRepository(SyntheticRepository.getInstance(singleDirClassPath));
   }

   public void readRepository()
   {
      final String fileMask = baseDir.getPath() + File.separatorChar + "*" + CLASS_FILE_EXTENSION;
      final Enumeration<File> en = new WildcardSearchEnumeration(fileMask, true);
      while (en.hasMoreElements())
      {
         final File file = en.nextElement();
         final String className = classNameFromFileName(file);
         // System.out.println(className);
         filesInRepository.put(className, file);
      }

      if (getNumberOfClasses() == 0)
      {
         throw new IllegalArgumentException("no classes (*" + CLASS_FILE_EXTENSION + ") found in dir " + baseDir);
      }
   }

   public void readRepository(List<String> classNameList)
   {
      for (final String className : classNameList)
      {
         final File file = fileNameFromClassName(className);
         if (file.exists())
         {
            // System.out.println(className);
            filesInRepository.put(className, file);
         }
         else
         {
            throw new IllegalArgumentException("file for class " + className + " not found in dir " + baseDir);
         }
      }
   }

   private String classNameFromFileName(File file)
   {
      String className = file.getPath();
      className = className.substring(baseDir.toString().length() + 1);
      className = className.replace(File.separatorChar, '.');
      className = className.substring(0, className.length() - CLASS_FILE_EXTENSION.length());
      return className;
   }

   private File fileNameFromClassName(String className)
   {
      String fileName = className;
      fileName = fileName.replace('.', File.separatorChar);
      fileName = fileName + CLASS_FILE_EXTENSION;
      return new File(baseDir, fileName);
   }

   public boolean isInRepository(String className)
   {
      if (className == null)
      {
         throw new NullPointerException("className is null");
      }
      return filesInRepository.containsKey(className);
   }

   public boolean isInRepository(JavaClass jclas)
   {
      // return fileFromClass(jclas).exists();
      return isInRepository(jclas.getClassName());
   }

   public JavaClass getParsedClassFor(String className)
   {
      if (!filesInRepository.containsKey(className))
      {
         throw new IllegalArgumentException("file for class " + className + " not in repository");
      }

      return Repository.lookupClass(className);

      /*
       try {
       return new ClassParser(fileNameFromClassName(className)).parse();
       } catch (IOException ex) {
       throw new IllegalArgumentException("file for class " + className + " not readable: " + ex.toString());
       }
       */
   }

   /*
    private File fileFromClass(JavaClass jclas) {
    return new File(fileNameFromClassName(jclas.getClassName()));
    }
    
    private String fileNameFromClassName(String className) {
    // return baseDir.getPath() + File.separatorChar + className.replace('.', File.separatorChar) + CLASS_FILE_EXTENSION;
    return filesInRepository.get(className).toString();
    }
    */

   @Override
   public String toString()
   {
      return this.getClass().getName() + "{baseDir=" + baseDir + ",filesInRepository=" + getNumberOfClasses() + '}';
   }

   public int getNumberOfClasses()
   {
      return filesInRepository.size();
   }

   public List<String> getAllClassNames(boolean skipInnerClasses)
   {
      final List<String> result = new ArrayList<String>();

      for (final String name : filesInRepository.keySet())
      {
         if (skipInnerClasses && name.indexOf('$') != -1)
         {
            continue;
         }
         result.add(name);
      }

      Collections.sort(result);
      return result;
   }

}
