# :nodoc:

# Attributes of a project in the test corpus of Java projects.
# Test corpus has classes in classes/ or classes.zip. Same for test-classes.
# Author::          Peter Kofler
# Copyright::       Copyright (c) 2009, Peter Kofler.       
# License::         {BSD License}[link:/files/license_txt.html]
#
class CorpusInfo < Struct.new(:location, :classes, :testClasses, :packages)
   
  def self.with_default_folders(location, packages)
    classes = pure_zip_or_nil(location, 'classes')
    testClasses = pure_zip_or_nil(location, 'test-classes')
    CorpusInfo.new(location, classes, testClasses, packages )
  end
  
  def self.pure_zip_or_nil(location, name)
    classes = File.join(location, name)
    classes = File.join(location, name + '.zip') unless File.exist?(classes) 
    classes = nil unless File.exist?(classes)
    classes
  end
  
  def package
    if packages.size > 0
      packages[0]
    else
      nil
    end
  end
  
end

# Set location of the test data corpus.
corpus_root = 'E:\OfficeDateien\Corpus'
Corpus = Hash[
  *[
    %w[Sun10      Java1_JDK-1.0.2(Sun_official)            java],
    %w[WF         Java2_Swing(WF_iMagine)                  at.workforce], 
    %w[S1         Java5_Batch(S1_Fabric)                   ],
    %w[Harmony15  Java5_JDK-1.5M15-r991518(Apache_Harmony) ],
    %w[Harmony16  Java5_JDK-1.6M3-r991881(Apache_Harmony)  ],
    %w[RCP        Java5_RCP_2011(IBM_Costing)              ],
    %w[BIA        Java6_Swing(BIA_Monarch)                 com.bia],
    %w[HBD        Java6_Web(HBD_Online)                    at.herold],
  ].map { |pair|
    if pair[2] then package = [pair[2]] else package = [] end
    c =  CorpusInfo.with_default_folders(File.join(corpus_root, pair[1]), package)
    [pair[0].to_sym, c]
  }.flatten
]

# my own projects 
Corpus[:Base] = CorpusInfo.with_default_folders('E:\Develop\Java', ['at.kugel'])
Corpus[:Lib] = CorpusInfo.with_default_folders('E:\Develop\Java\CodeLib', ['at.kugel'])

# temporary corpus for static analysis
Corpus[:Uep2] = CorpusInfo.new('D:\Internet\uep2', 'D:\Internet\cummulated.clz', 'D:\Internet\cummulated_test.clz', ['uep'])
Corpus[:Nuss] = CorpusInfo.new('D:\Backend\NUSS',  'D:\Backend\cummulated.clz',  'D:\Backend\cummulated_test.clz',  ['at.lotterien'])
