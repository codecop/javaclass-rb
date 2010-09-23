package at.kugel.util.code.bcel;

//Kugel's "Java Code & Tools Library", Copyright (c) 1999-2004, Theossos Comp Group
import java.util.List;

import org.apache.bcel.classfile.JavaClass;

/**
 * Abstraction of a place where to find the physical class files for a given full class name. This must also configure
 * the <code>org.apache.bcel.Repository</code> to use the right repository for BCEL automatic class loading, i.e. for
 * interfaces.
 * @author Kugel, <i>Theossos Comp Group</i>
 * @version 1.00 - 25.06.2004
 */
public interface ClassFileRepository
{

   String CLASS_FILE_EXTENSION = ".class";

   void readRepository();

   void readRepository(List<String> classNameList);

   boolean isInRepository(String className);

   boolean isInRepository(JavaClass jclas);

   JavaClass getParsedClassFor(String className);

   int getNumberOfClasses();

   List<String> getAllClassNames(boolean skipInnerClasses);
}
