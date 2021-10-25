# FAO international food trade network 2010

## Files

- `FAO-trade-2010.net` - multirelational network in Pajek format
- `FAO-trade-2010-SUM.net` - network with merged relations (Sum of weights)
- `ISO3166-1.txt` - table of ISO_3166-1_alpha-2 country codes
- `FAO-trade-2010.nam` - Pajek short names file
- `FAO-PF_1+ln_2.net` - Pathfinder skeleton NET file (logarithmic weights)
- `FAO.ini` - Pathfinder skeleton INI file
- `FAO-PF.svg` - Pathfinder skeleton picture in SVG


## Description

The source data are from
- https://manliodedomenico.com/data.php

The network on 214 nodes and 318346 edges contains 364 trade relations amoung countries, obtained from FAO (Food and Agriculture Organization of the United Nations). The worldwide food import/export network is an economic network in which relations represent products, nodes are countries and edges in each relation represent import/export relationships of a specific food product among countries. The data were collected from FAO and built the multirelational network corresponding to trading in 2010.


References
1. M. De Domenico, V. Nicosia, A. Arenas, and V. Latora - "Structural reducibility of multilayer networks" - Nature Communications 2015 6, 6864
 

## Conversion to Pajek project file

```
> # FAO_Multiplex_Trade
> wdir <- "D:/vlado/data/multiRel/FAO_Multiplex_Trade/Dataset"
> setwd(wdir)
> source("https://raw.githubusercontent.com/bavla/Rnet/master/R/Pajek.R")
> R <- read.table("fao_trade_layers.txt",stringsAsFactors=FALSE,header=TRUE)
> L <- read.table("fao_trade_multiplex.edges",header=FALSE)
> N <- read.table("fao_trade_nodes.txt",stringsAsFactors=FALSE,header=TRUE)
> net <- file("FAO-trade-2010.net","w")
> n <- nrow(N)
> cat("% FAO trade 2010",date(),"\n*vertices",n,"\n",file=net)
> for(i in 1:n) cat(i,' "',N$nodeLabel[i],'"\n',sep="",file=net)
> for(i in 1:nrow(R)) cat("*edges :",i,' "',R$layerLabel[i],'"\n',sep="",file=net)
> cat("*edges\n",file=net)
> for(i in 1:nrow(L)) cat(L$V1[i],": ",L$V2[i]," ",L$V3[i]," ",L$V4[i],"\n",sep="",file=net)
> close(net)
```

## Two-letter ISO_3166-1_alpha-2 country codes

From
https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2
I created the table ISO of codes. We have to create a Pajek name file in which each country name is replaced by its code.

```
> ISO <- read.delim("ISO3166-1.txt",stringsAsFactors=FALSE,skip=1)
> head(ISO)
  Code          CountryName
1   AD              Andorra
2   AE United Arab Emirates
3   AF          Afghanistan
4   AG  Antigua and Barbuda
5   AI             Anguilla
6   AL              Albania
> C <- gsub("_"," ",N$nodeLabel)
> p <- match(C,ISO$CountryName)
> q <- which(is.na(p))
> length(q)
[1] 22
> M <- cbind(q,C[q])
> M
      q                                                
 [1,] "8"   "China, Hong Kong SAR"                     
 [2,] "9"   "China, mainland"                          
 [3,] "10"  "China, Taiwan Province of"                
 [4,] "19"  "Iran (Islamic Republic of)"               
 [5,] "31"  "Republic of Korea"                        
 [6,] "44"  "United Kingdom"                           
 [7,] "59"  "CÃƒÂ´te d'Ivoire"                         
 [8,] "63"  "Czech Republic"                           
 [9,] "83"  "Republic of Moldova"                      
[10,] "90"  "The former Yugoslav Republic of Macedonia"
[11,] "93"  "Unspecified"                              
[12,] "95"  "Bolivia (Plurinational State of)"         
[13,] "111" "Sudan (former)"                           
[14,] "113" "United Republic of Tanzania"              
[15,] "129" "Netherlands Antilles"                     
[16,] "140" "China, Macao SAR"                         
[17,] "141" "Democratic People's Republic of Korea"    
[18,] "142" "Democratic Republic of the Congo"         
[19,] "163" "Swaziland"                                
[20,] "186" "Occupied Palestinian Territory"           
[21,] "188" "British Virgin Islands"                   
[22,] "205" "Micronesia (Federated States of)"         
> match("Hong Kong",ISO$CountryName)
[1] 95
> match("China",ISO$CountryName)
[1] 48
> match("Taiwan, Province of China",ISO$CountryName)
[1] 228
> match("Iran",ISO$CountryName)
[1] 108
> match("Korea, Republic of",ISO$CountryName)
[1] 122
> match("United Kingdom of Great Britain and Northern Ireland",ISO$CountryName)
[1] 77
> match("Côte d'Ivoire",ISO$CountryName)
[1] 44
> match("Czechia",ISO$CountryName)
[1] 56
> match("Moldova, Republic of",ISO$CountryName)
[1] 139
> match("North Macedonia",ISO$CountryName)
[1] 144
> # Unspecified -> XX
> match("Bolivia",ISO$CountryName)
[1] 29
> match("Sudan",ISO$CountryName)
[1] 196
> match("Tanzania, United Republic of",ISO$CountryName)
[1] 229
> # Netherlands Antilles -> AN  https://www.google.com/search?q=netherlands+antilles+iso+code&oq=Netherlands+Antilles+ISO
> match("Macao",ISO$CountryName)
[1] 148
> match("Korea (Democratic People's Republic of)",ISO$CountryName)
[1] 121
> match("Congo, Democratic Republic of the",ISO$CountryName)
[1] 40
> match("Eswatini",ISO$CountryName)
[1] 213
> match("Palestine, State of",ISO$CountryName)
[1] 183
> match("Virgin Islands (British)",ISO$CountryName)
[1] 239
> match("Micronesia",ISO$CountryName)
[1] 73
> s <- c(95,NA,228,108,122,77,44,56,139,144,NA,29,196,229,NA,148,121,40,213,183,239,73)
> p[q] <- s
> ISS <- ISO$Code[p]
> qq <- which(is.na(ISS))
> cbind(qq,C[qq])
     qq                          
[1,] "9"   "China, mainland"     
[2,] "93"  "Unspecified"         
[3,] "129" "Netherlands Antilles"
[4,] "154" "Namibia" 
> ISS[9] <- "QM"
> ISS[93] <- "XX"
> ISS[129] <- "AN"
> ISS[154] <- "NA"
> ISS
  [1] "AF" "AU" "AT" "BE" "BR" "CA" "CN" "HK" "QM" "TW" "DK" "EG" "FI" "FR" "DE" "GT" "IN" "ID"
 [19] "IR" "IQ" "IE" "IT" "JP" "KZ" "LB" "MY" "NL" "PK" "PH" "PL" "KR" "RU" "SA" "SG" "ES" "SE"
 [37] "CH" "TJ" "TH" "TR" "TM" "UA" "AE" "GB" "US" "UZ" "VN" "AL" "AR" "BS" "BA" "BG" "CV" "CM"
 [55] "CO" "KM" "CG" "CR" "CI" "HR" "CU" "CY" "CZ" "DM" "DO" "EC" "ET" "GR" "HU" "IL" "KE" "KG"
 [73] "LT" "LU" "MW" "MX" "ME" "MA" "NI" "NO" "PA" "PT" "MD" "RO" "ST" "RS" "SK" "SI" "SY" "MK"
 [91] "TN" "UG" "XX" "VE" "BO" "CL" "SV" "EE" "FJ" "GE" "HN" "IS" "JM" "MG" "NZ" "PG" "PY" "PE"
[109] "ZA" "LK" "SD" "TT" "TZ" "UY" "ZM" "AM" "BY" "CF" "GH" "GY" "LV" "ML" "NR" "NG" "OM" "SL"
[127] "AW" "BB" "AN" "SR" "AS" "AG" "AZ" "BH" "BD" "BZ" "BM" "BW" "KH" "MO" "KP" "CD" "DJ" "ER"
[145] "GN" "JO" "LA" "MT" "MH" "MU" "MN" "MZ" "MM" "NA" "NP" "NC" "NE" "QA" "RW" "LC" "WS" "SB"
[163] "SZ" "TL" "TO" "VU" "YE" "ZW" "DZ" "BF" "GD" "KW" "TG" "FK" "GU" "SO" "KN" "VC" "AO" "BJ"
[181] "BI" "PF" "GA" "HT" "LR" "PS" "SN" "VG" "SC" "BT" "CK" "LS" "GM" "GW" "NU" "TD" "GQ" "FO"
[199] "MS" "PM" "TC" "BN" "GL" "LY" "FM" "PW" "KI" "SH" "TV" "KY" "YT" "MV" "MR" "AD" 
> net <- file("FAO-trade-2010.nam","w")
> n <- nrow(N)
> cat("% FAO trade 2010",date(),"\n*vertices",n,"\n",file=net)
> for(i in 1:n) cat(i,' "',ISS[i],'"\n',sep="",file=net)
> close(net)
```

