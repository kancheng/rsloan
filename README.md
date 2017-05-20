# rsloan

利用 大學管理學院 8 年的"就學貸款"與"學生成績"資料，進行 集群、ANOVA 與視覺化分析。


# R Function

分析集群的函數，為 `rsloan` 的基礎， `dataipt` 、 `dataopt` 為資料輸入跟資料輸出的目錄。

## 匯入資料、函數與設定

```
set.seed(929)
getwd()

# R Kan Dev Function Main File
source("C:/dataipt/rfunc/main-rfunc.R")

# Data input CSV file
dataipth = "C:/dataipt/lhucmdt/lhumlndcw70"

# Data output CSV file
dataopth = "C:/dataopt/lhucmdt"

# Data coldf input CSV file
dfcolipth = "C:/dataipt/lhucmdt/dfsubjab/csv"

# input DF
rcsvdf(dataipth)

# input coldf Data
rcsvdf(dfcolipth)

# input List
lhudata = rcsvlt(dataipth)

# Cluster Analysis Base colnames 
hacbdt = c( "cala","loam","ec", "cppg")

# Cluster Analysis PKey colnames 
pkb = c( "sid")
```


## 階層分群

產生 `階層式分群` 、 `變異數分析` 、 `各群敘述統計` 、 `就學貸款下的各群敘述統計` 、 `各分群的人數比例` 等 結果資料集。

```
# hierarchical clustering
hcaon(im13,  hacbdt, pkb, hck = 6, dtname = "im13")
```


## 繪圖

產生 `單科目` 與 `多科目` 的散佈圖。

```
# HCA Multiple ggplot proc

mainindex = c( "cala" )
courindex = c( "itdc", "cppg", "pcpg", "oopg", "itdcn", "cala", "calb", "ec", 
"dtst", "nwkpm", "sadm", "idbs", "st", "mana", "inkpg", "dbms", "mis")

sg2proc("im11avt", mainindex, courindex, "im11df")
mg2proc("im11avt", mainindex, courindex, "im11df")
```

# Details

## raw

為目前分析過後的管理學院學生資料。

- [dtcna70](https://github.com/kancheng/rsloan/tree/master/raw/dtcna70) 為資料清洗過 NA 的資料集。

- [origdt](https://github.com/kancheng/rsloan/tree/master/raw/origdt) 為資料未處理 NA 的原始資料集。

- [sql](https://github.com/kancheng/rsloan/tree/master/raw/sql) 為資料清洗過 NA 的 SQL 資料。


## rfunc

by Windows R Console 。 [Here](https://github.com/kancheng/rsloan/blob/master/man/rfunc.md)

若想要直接在 Console 的部分直接用寫好的自訂函數，可於 `rfunc` 目錄中執行寫好的 R File。


## shiny-server

by Ubuntu Linux

```
shiny-server/rsloan/...
``` 

將 shiny-server 目錄向下 的整個 rsloan 目錄複製整個放置在 `/srv/shiny-server/` 路徑下面，如下 :

放置路徑
```
/srv/shiny-server/rsloan
```

瀏覽器
```
127.0.0.1:3838/rsloan
```

## rprofile

為執行 R 執行預設時自動載入。


# 環境

詳見 [rsloan-environment](https://github.com/kancheng/rsloan-environment) 環境部屬

- [R Shiny Server](https://github.com/rstudio/shiny-server)
- [Ubuntu 14.04](https://en.wikipedia.org/wiki/Ubuntu_(operating_system))
- [RMySQL](https://github.com/rstats-db/RMySQL)
- [MariaDB](https://en.wikipedia.org/wiki/MariaDB)

# 版本

`R version 3.3.2` 當中的所有 package 對應該版本。


# 資料

NA 值的學科處理 [rsloan-dcna](https://github.com/kancheng/rsloan-dcna) 。


# 文件

詳見 .....
