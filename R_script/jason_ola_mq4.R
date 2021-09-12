#Statistiques R, cartographie et création de test statistiques

#Import des packages qu'on va utiliser

#Import du package foreign afin de lire le fichier .sav d'SPSS
library(foreign)
#Import du package tidyverse incluant les differents packages de remaniement
#et de visualisation de données
library(tidyverse)
#Import du package sf pour manipuler les couches de cartographie
library(sf)
#Import du package readxl pour lire les fichiers excel
library(readxl)
#Import du package janitor pour le nettoyage des entêtes
library(janitor)
#Import du package classInt pour faire les intervalles de classes
library(classInt)
#Import du package ggsn pour l'échelle
library(ggsn)

#Partie A :
#A1

#Lecture du fichier .sav
spss_file <- read.spss("mq4spss.sav",to.data.frame = T)

#A2
#Création du diagramme de dispersion avec ggplot
#Selection du set de données
#Selection des variables dans aes (ici x : requerants et y : crimes)
spss_file %>% #Utilisation de l'opérateur pipe ( %>% ) qui transfère l'output
              #d'un coté en input de l'autre
  ggplot(mapping = aes(x = requerants, y = crimes))+
    #Selection de la couleur et de la taille du point
    geom_point(color = "#484848",
               size = 1)+
    #Affichage des noms d'individus
    geom_text(aes(label = unite_spaciale),
              size = 2)+
    #Nom des axes, titres et caption
    labs(title = "Diagramme de dispersion",
         subtitle = "Proportion de crimes en fonction de la proportion de requérants pour chaque canton",
         x = "Proportion de requérants",
         y = "Proportion de crimes",
         caption = "Valeurs non-pondérées\n
         Source : https://www.pxweb.bfs.admin.ch/pxweb/fr/")+
    #Modification de l'apparence des axes x et y pour mettre le %
    scale_x_continuous(breaks = c(4,8,12,16)/10000,
                       labels = paste0(c(4,8,12,16)/100,"%"))+
    scale_y_continuous(breaks = c(2,4,6,8)/1000,
                       labels = paste0(c(2,4,6,8)/10,"%"))+
    #Theme plus propre
    theme_minimal()+
    #Mise en italique de la source
    theme(plot.caption = element_text(face = "italic"))+
    #Sauvegarde en pdf
    ggsave("diagramme_de_dispersion.pdf")

# Création d'un boxplot
spss_file %>%
  ggplot(aes(y = benef_aide_soc))+
    geom_boxplot()+
    scale_y_continuous(breaks = c(1,2,3,4,5)/100,
                       labels = paste0(c(1,2,3,4,5),"%"))+
    labs(title = "Dispersion des bénéficiaires d'aide sociale",
         y = "Bénéficiaires d'aide sociale",
         caption = "Source : https://www.pxweb.bfs.admin.ch/pxweb/fr/"
    )+
    theme_minimal()+
    # Enlever l'affichage des valeurs de l'axe des x
    theme(axis.text.x = element_blank())+
    theme(plot.caption = element_text(face = "italic"))+
    ggsave("boxplot.pdf")


#Création de diagramme en barres
spss_file %>%
  arrange(requerants) %>%
  mutate(unite_spaciale = fct_inorder(unite_spaciale)) %>%
  ggplot(aes(y = unite_spaciale, x = requerants))+
  geom_col()+
  labs(title = "Diagramme en barres",
       subtitle = "Proportion de requérants par cantons",
       x = "Proportion de requérants",
       y = "",
       caption = "Source : https://www.pxweb.bfs.admin.ch/pxweb/fr/")+
  scale_x_continuous(breaks = c(0,5,10,15)/10000,
                     labels = paste0(c(0,5,10,15)/100,"%"))+
  theme_minimal()+
  theme(plot.caption = element_text(face = "italic"))+
  ggsave("diagramme_en_barres.pdf")

#A3
#Régression linéaire
#Utilisation de lm() avec crimes comme variable dépendante et le reste comme
#indépendante
linear_model <- lm(formula = spss_file$crimes ~
                     spss_file$tendance_parti +
                     spss_file$frontiere_int +
                     spss_file$enseignants +
                     spss_file$benef_aide_soc +
                     spss_file$boursiers +
                     spss_file$etrangers +
                     spss_file$requerants)
#Résumé de la régression
summary(linear_model)
cat("On voit sur ce résumé que la régression est significative, le p-value est",
"très faible : 8.439e-07. Aussi on voit que les variables boursiers, etrangers",
"et requerants sont significatives, en particulier etrangers")

#Diagramme des résidus
ggplot()+
  geom_point(aes(scale(linear_model$fitted.values),
                 scale(linear_model$residuals)))+
  #On prend en abscice les valeurs prédites et en ordonnée les résidus qu'on
  #standardise avec scale()
  labs(title = "Diagramme des résidus",
       subtitle = "Variable dépendante : crimes",
       x = "Valeurs prédites standardisées",
       y = "Résidus standardisés",
       caption = "Source : https://www.pxweb.bfs.admin.ch/pxweb/fr/")+
  theme_minimal()+
  theme(plot.caption = element_text(face = "italic"))+
  ggsave("diagramme_residus.pdf")
cat("Nuage de points centrés, nuage qui s'écarte un peu à droite,",
    "il y a une légère hétéroscédasticité, les hypothèse de travail",
    "sont vérifiées")

#Test chi2
#Création table contingence
table_cont <- table(spss_file$tendance_parti, spss_file$frontiere_int)

#Test
cat("Posons h0 : les variables sont indépendantes à alpha = 0.05")
chisq.test(table_cont)
cat("P > alpha, on rejette l'hypothèse d'indépendance.",
    "Cependant, le nombre faible de données rend l'analyse peu pertinente")

#A4
#Sélection de la variable qu'on veut analyser
x <- spss_file$requerants

#Fonction du test de la moyenne pour sigma inconnu, sans pondération
#Parametres :
#x est le vecteur sur lequel on veut appliquer le test
#mu est la moyenne théorique sur laquelle on se base
#n est la longueur du vecteur
#df est le degré de liberté
#alpha est le seuil de significativité, ici en parametre par défaut 0.05
#bilateral est le booléen qui indique si l'on veut faire un test bilatéral ou pas. Par défaut sur TRUE.
test_moyenne <- function(x, mu,
                         n = length(x),
                         df = n-1,
                         alpha = 0.05,
                         bilateral = T){
  #Création des variables pour la formule de la variable de décision t
  #xbar est la moyenne, xsqbar est la moyenne des x carrés
  #sx est l'écart type qui utilise les 2 variables créées au préalable
  xbar = sum(x)/n
  xsqbar = sum(x^2)/n
  sx = sqrt(xsqbar-xbar^2)
  #Calcul de la variable de décision t
  t = ((xbar-mu)/sx)*(sqrt(df))

  #Partie bilatérale du test
  if(bilateral == T){
    cat("Test bilatéral\n--------------\n")
    cat("Alpha = ",alpha,"(Mise en garde : Choisissez bien votre alpha,
               lors du test bilatéral on le divise par 2)\n")
    cat(paste0("h0 : mu = ",mu,"\n"))
    cat(paste0("h1 : mu ≠ ",mu,"\n"))
    #Calcul de la valeur P, ici *2 car bilatéral
    p = pt(-abs(t), df=df)*2

  }
  #Partie unilatérale du test
  else if(bilateral == F){
    cat("Test unilatéral\n---------------\n")
    cat("Alpha = ",alpha,"\n")
    cat(paste0("h0 : mu = ",mu,"\n"))
    cat(paste0("h1 : mu > ",mu,"\n"))
    #Calcul de la valeur P
    p = pt(-abs(t), df=df)
  }
  #cat pour imprimer dans la console les différents résultats
  cat("N = ", n, "\n")
  cat("Df = ",df,"\n")

  cat(paste0("P-value : ",p," \nT : ",t,"\n"))
  #Conditions de rejet ou non de la valeur P
  if(p > alpha){
    cat("P > alpha : On ne rejette pas h0")
  }
  else if(p == alpha){
    cat("P = alpha : mouais...")
  }
  else if(p < alpha){
    cat("P < alpha : On rejette h0")
  }
}

#Appel de la fonction
test_moyenne(x = x, mu = 0.004, bilateral = T)

#Partie B : Cartographie
#B1
#Import des différents shapefiles
cantons <- st_read("shapefiles/cantonsWGSCH.shp")
communes <- st_read("shapefiles/communesWGSCH.shp")
#Transformation des lacs en WGS84
lacs <- st_read("shapefiles/lacs.shp") %>% st_transform(crs = 4326)

#B2
#Création de carte avec fichiers trouvés
#Allemagne, source : http://www.diva-gis.org/gdata
allemagne <- st_read("DEU_adm/DEU_adm1.shp")
rails_allemagne <- st_read("DEU_rrd/DEU_rails.shp")
allemagne %>%
  ggplot()+
  geom_sf(fill = "transparent")+
  geom_sf(data = rails_allemagne,
          color = "gray",
          alpha = 0.5)+
  theme_void()+
  labs(title = "Carte des rails en Allemagne",
       caption = "source : http://www.diva-gis.org/gdata")

#B3
#Import des données excel
#On saute les 5 premieres lignes
donnees_communes <- read_excel("shapefiles/je-f-21.03.01.xlsx", skip = 5) %>%
  #On supprime les 3 premieres lignes
  tail(-3) %>%
  #On nettoye les sentêtes
  clean_names() %>%
  #On transforme les valeurs qui sont character en numeric en selectionnant
  #tout sauf commune
  mutate_at(vars(-commune),as.numeric)

#Import des identifiants de cantons
code_canton <- read_delim("shapefiles/codeCanton.csv", ";")

#Finalement on lie les informations au shapefile
communes_full <- communes %>%
  left_join(donnees_communes, by = c("NAME" = "commune")) %>%
  full_join(code_canton, by = c("KANTONSNUM" = "codeCanton"))

#B4
#On filtre le canton attribué : Grisons
grisons <- communes_full %>%
  filter(canton == "Grisons")

#On plot le canton
grisons %>%
  ggplot()+
  geom_sf()+
  theme_void()+
  labs(title = "Les Grisons et ses communes")

#B5
#Situation des Grisons
cantons %>%
  ggplot()+
  #couche de cantons
  geom_sf()+
  #couche des Grisons
  geom_sf(data = grisons,
          fill = "#293133",
          size = 0.3)+
  #couche des lacs
  geom_sf(data = lacs,
          fill = "#7293A8",
          size = 0.5)+
  theme_void()+
  labs(title = "Situation des Grisons")

#B6
#Création de carte thématique du canton des Grisons
#D'abord extraire la variable qu'on veut mettre en classes
habs <- grisons %>%
  pull(habitants)

#Créer les intervales avec classInt
intervales <- habs %>%
  classIntervals(n = 5) %>%
  pluck("brks")

#Créer une table pour créer une variable label qui contient l'intervale
labels <- tibble(int1 = intervales, int2 = lead(intervales)) %>%
  head(-1) %>%
  mutate(label = paste0(int1, " - ", int2))

#Ensuite couper la variable habitants dans l'intervale et le nommer d'apres
#le label
grisons <- grisons %>%
  mutate(ints = cut(habitants,
                    breaks = intervales,
                    labels = labels$label))

#Finalement afficher les résultats
grisons %>%
  ggplot()+
  geom_sf(aes(fill = ints))+
  scale_fill_brewer(palette = "Purples",
                    na.value = "gray30")+
  theme_void()+
  labs(title = "Canton des Grisons",
       subtitle = "Nombre d'habitants par communes en 2021",
       fill = "",
       caption = "Source : Moodle MQ4 \n Auteur : Jason Ola")+
  scalebar(data = grisons,
           transform = T,
           dist = 30,
           dist_unit = "km",
           model = "WGS84",
           st.size = 3,
           border.size = 0.5,
           height = 0.01,
           box.fill = c("#4e4d47", "#f5f5f2"))

