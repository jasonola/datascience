* Encoding: UTF-8.

DATASET ACTIVATE Jeu_de_données2.
DESCRIPTIVES VARIABLES=population
  /STATISTICS=SUM.

COMPUTE poidseff=26*population/8544527.
EXECUTE.

WEIGHT BY poidseff.

FREQUENCIES VARIABLES=tendance_parti frontiere_int
  /ORDER=ANALYSIS.

DESCRIPTIVES VARIABLES=enseignants benef_aide_soc boursiers etrangers requerants crimes
  /STATISTICS=MEAN STDDEV MIN MAX.


RECODE tendance_parti frontiere_int ('G'='0') ('C'='1') ('D'='2') ('N'='0') ('O'='1').
EXECUTE.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN
  /DEPENDENT crimes
  /METHOD=ENTER tendance_parti frontiere_int enseignants benef_aide_soc boursiers etrangers
    requerants
  /SCATTERPLOT=(*ZRESID ,*ZPRED).

FACTOR
  /VARIABLES enseignants benef_aide_soc boursiers etrangers requerants
  /MISSING LISTWISE
  /ANALYSIS enseignants benef_aide_soc boursiers etrangers requerants
  /PRINT INITIAL KMO
  /FORMAT SORT
  /PLOT EIGEN ROTATION
  /CRITERIA FACTORS(2) ITERATE(25)
  /EXTRACTION PC
  /ROTATION NOROTATE
  /SAVE REG(ALL)
  /METHOD=CORRELATION.

* Générateur de graphiques.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=FAC1_1 FAC2_1 unite_spaciale MISSING=LISTWISE
    REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE
  /FITLINE TOTAL=NO SUBGROUP=NO.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: FAC1_1=col(source(s), name("FAC1_1"))
  DATA: FAC2_1=col(source(s), name("FAC2_1"))
  DATA: unite_spaciale=col(source(s), name("unite_spaciale"), unit.category())
  GUIDE: axis(dim(1), label("REGR factor score   1 for analysis 1"))
  GUIDE: axis(dim(2), label("REGR factor score   2 for analysis 1"))
  GUIDE: text.title(label("Nuage de points de REGR factor score   2 for analysis 1 par REGR ",
    "factor score   1 for analysis 1"))
  ELEMENT: point(position(FAC1_1*FAC2_1), label(unite_spaciale))
END GPL.

CLUSTER
  /MATRIX IN(D0.18159714044288577)
  /METHOD WARD
  /ID=unite_spaciale
  /PRINT SCHEDULE
  /PLOT DENDROGRAM HICICLE
  /SAVE CLUSTER(3).

Dataset Close D0.18159714044288577.
* Générateur de graphiques.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=FAC1_1 FAC2_1 CLU3_1 unite_spaciale MISSING=LISTWISE
    REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE
  /FITLINE TOTAL=NO SUBGROUP=NO.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: FAC1_1=col(source(s), name("FAC1_1"))
  DATA: FAC2_1=col(source(s), name("FAC2_1"))
  DATA: CLU3_1=col(source(s), name("CLU3_1"), unit.category())
  DATA: unite_spaciale=col(source(s), name("unite_spaciale"), unit.category())
  GUIDE: axis(dim(1), label("REGR factor score   1 for analysis 1"))
  GUIDE: axis(dim(2), label("REGR factor score   2 for analysis 1"))
  GUIDE: legend(aesthetic(aesthetic.color.interior), label("Ward Method                          ",
    "   "))
  GUIDE: text.title(label("Nuage de points de REGR factor score   2 for analysis 1 par REGR ",
    "factor score   1 for analysis 1 par Ward Method"))
  ELEMENT: point(position(FAC1_1*FAC2_1), color.interior(CLU3_1), label(unite_spaciale))
END GPL.



