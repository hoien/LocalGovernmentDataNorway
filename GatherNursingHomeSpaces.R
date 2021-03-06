################
#Download data to the care technology project
#Henning Øien
#Sykehjemsplasser
#
##############

#Clear workspace


#Packages needed to collect data through SSB api
#For more information see: http://data.ssb.no/api

library(rjstat)
library(mosaic)
library(httr)

#Getting data from the following table: 
#07790: F1. Konsern - Pleie og omsorg - grunnlagsdata (K) 1999 - 2016
#See "http://www.ssb.no/tabell/07790"

url <- "http://data.ssb.no/api/v0/no/table/07790"

#The following variables are in the table

#1 Region
#2 ContentsCode
#3 Tid

# Defining the variables I need

## I include all municipalities (an alternative is to use all)

region <- '{ "code": "Region",
"selection": {  "filter": "item", "values": [/*Østfold*/"0101","0104",
"0105","0106","0111","0118","0119","0121","0122","0123","0124","0125",
"0127","0128","0135","0136","0137","0138",
/*Akershus*/"0211","0213","0214","0215","0216","0217","0219","0220","0221","0226","0227","0228","0229","0230","0231","0233","0234","0235","0236","0237","0238","0239","0301","0402","0403","0412","0415","0417","0418","0419","0420","0423","0425","0426","0427","0428","0429","0430","0432","0434","0436","0437","0438","0439","0441","0501","0502","0511","0512","0513","0514","0515","0516","0517","0519","0520","0521","0522","0528","0529","0532","0533","0534","0536","0538","0540","0541","0542","0543","0544","0545","0602","0604","0605","0612","0615","0616","0617","0618","0619","0620","0621","0622","0623","0624","0625","0626","0627","0628","0631","0632","0633","0701","0702","0704","0706","0709","0711","0713","0714","0716","0718","0719","0720","0722","0723","0728","0805","0806","0807","0811","0814","0815","0817","0819","0821","0822","0826","0827","0828","0829","0830","0831","0833","0834","0901","0904","0906","0911","0912","0914","0919","0926","0928","0929","0935","0937","0938","0940","0941","1001","1002","1003","1004","1014","1017","1018","1021","1026","1027","1029","1032","1034","1037","1046","1101","1102","1103","1106","1111","1112","1114","1119","1120","1121","1122","1124","1127","1129","1130","1133","1134","1135","1141","1142","1144","1145","1146","1149","1151","1154","1159","1160","1201","1211","1214","1216","1219","1221","1222","1223","1224","1227","1228","1231","1232","1233","1234","1235","1238","1241","1242","1243","1244","1245","1246","1247","1251","1252","1253","1256","1259","1260","1263","1264","1265","1266","1401","1411","1412","1413","1416","1417","1418","1419","1420","1421","1422","1424","1426","1428","1429","1430","1431","1432","1433","1438","1439","1441","1443","1444","1445","1449","1502","1503","1504","1505","1511","1514","1515","1516","1517","1519","1520","1523","1524","1525","1526","1528","1529","1531","1532","1534","1535","1539","1543","1545","1546","1547","1548","1551","1554","1556","1557","1560","1563","1566","1567","1569","1571","1572","1573","1576","1601","1612","1613","1617","1620","1621","1622","1624","1627","1630","1632","1633","1634","1635","1636","1638","1640","1644","1648","1653","1657","1662","1663","1664","1665","1702","1703","1711","1714","1717","1718","1719","1721","1723","1724","1725","1729","1736","1738","1739","1740","1742","1743","1744","1748","1749","1750","1751","1755","1756","1804","1805","1811","1812","1813","1815","1816","1818","1820","1822","1824","1825","1826","1827","1828","1832","1833","1834","1835","1836","1837","1838","1839","1840","1841","1842","1845","1848","1849","1850","1851","1852","1853","1854","1856","1857","1859","1860","1865","1866","1867","1868","1870","1871","1874","1901","1902","1903","1911","1913","1915","1917","1919","1920","1922","1923","1924","1925","1926","1927","1928","1929","1931","1933","1936","1938","1939","1940","1941","1942","1943","2002","2003","2004","2011","2012","2014","2015","2017","2018","2019","2020","2021","2022","2023","2024","2025","2027","2028","2030","2111"
]}}'

## Here I include plasser i institusjon korrigert for utleie

content <- '{
  "code": "ContentsCode",
"selection": {
"filter": "item",
"values": ["CRC27802820"]  }
}'

##I include all time periods

tid <- '{
  "code": "Tid",
"selection": {
"filter": "all",
"values": ["*"]
}  
}'

##The data format

format<-'"response":{"format":"json-stat"}'

###Alle calls are written in this format: {query:[{variables}]format}

#I use the paste function to make a string of all the content

variables<-paste(region, content, tid, sep = ",")
variables<-paste0("[", variables, "]")
variables<-paste(variables, format, sep = ",")

data<-paste0("{", "query:", variables, "}")

#Make the call

temp <- POST(url , body = data, encode = "json", verbose())

#Make a table and data frame of table

table <- fromJSONstat(content(temp, "text"), naming = "id")

NursingSpaces <- table[[1]]

write.csv(NursingSpaces, file = "NursingSpaces.csv")






