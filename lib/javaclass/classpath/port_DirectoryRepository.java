/**
 * Abstraction of a place where to find the physical class files for a given full class name. This must also configure
 * the <code>org.apache.bcel.Repository</code> to use the right repository for BCEL automatic class loading, i.e. for
 * interfaces.
 */


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

