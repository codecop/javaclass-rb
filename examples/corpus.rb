# :nodoc:
# Set location of the test data corpus.
corpus_root = 'E:\OfficeDateien\Corpus'
Corpus = Hash[
  *[
    %w[Sun10      Java1_JDK-1.0.2(Sun_official) ],
    %w[WF         Java2_Swing(WF_iMagine) ],
    %w[S1         Java5_Batch(S1_Fabric)  ],
    %w[Harmony15  Java5_JDK-1.5M15-r991518(Apache_Harmony)  ],
    %w[Harmony16  Java5_JDK-1.6M3-r991881(Apache_Harmony)   ],
    %w[RCP        Java5_RCP_2011(IBM_Costing)   ],
    %w[BIA        Java6_Swing(BIA_Monarch)  ],
    %w[HBD        Java6_Web(HBD_Online)  ],
  ].map { |pair| 
    [pair[0].to_sym, File.join(corpus_root, pair[1])] 
  }.flatten
]
Corpus[:Base] = 'E:\Develop\Java'
Corpus[:Lib] = 'E:\Develop\Java\CodeLib'
