# rsloan

利用 大學管理學院 8 年的"就學貸款"與"學生成績"資料，進行 集群、ANOVA 與視覺化分析。

## RSLoan - R Shiny

為 R Shiny 開發。

### Home

![rsloanhome](https://cloud.githubusercontent.com/assets/6993715/26279500/895e3722-3de8-11e7-8165-7b8c544483eb.png)


### Work

![rsloanimport](https://cloud.githubusercontent.com/assets/6993715/26279502/a8cb9f50-3de8-11e7-8245-6f5d8a93b12d.png)


## R Function

分析集群的函數，為 `rsloan` 的基礎， `dataipt` 、 `dataopt` 為資料輸入跟資料輸出的目錄。


### Import

```
set.seed(929)
getwd()

# R Kan Dev Function Main File
source("C:/dataipt/rfunc/main-rfunc.R")

# Data input CSV file
dataipth = "C:/dataipt/lhucmdt/lhumlndcw70"

# Data output CSV file
dataopth = "C:/dataopt/lhucmdt"

# input DF
rcsvdf(dataipth)

# input List
lhudata = rcsvlt(dataipth)
```


### Setting

```
# Cluster Analysis Base colnames 
hacbdt = c( "cala","loam","ec", "cppg")

# Cluster Analysis PKey colnames 
pkb = c( "sid")
```


### Hierarchical clustering

產生 `階層式分群` 、 `變異數分析` 、 `各群敘述統計` 、 `就學貸款下的各群敘述統計` 、 `各分群的人數比例` 等 資料集。

```
# Hierarchical clustering
hcaon(im13,  hacbdt, pkb, hck = 6, dtname = "im13")
```


### Plot

產生 `單科目` 與 `多科目` 的散佈圖。

```
# HCA Multiple ggplot proc

mainindex = c( "cala" )
courindex = c( "itdc", "cppg", "pcpg", "oopg", "itdcn", "cala", "calb", "ec", 
"dtst", "nwkpm", "sadm", "idbs", "st", "mana", "inkpg", "dbms", "mis")

sg2proc("im11avt", mainindex, courindex)
mg2proc("im11avt", mainindex, courindex)
```

## Details

### raw

為目前分析過後的管理學院學生資料。

- [dtcna70](https://github.com/kancheng/rsloan/tree/master/raw/dtcna70) 為資料清洗過 NA 的資料集。

- [origdt](https://github.com/kancheng/rsloan/tree/master/raw/origdt) 為資料未處理 NA 的原始資料集。

- [sql](https://github.com/kancheng/rsloan/tree/master/raw/sql) 為資料清洗過 NA 的 SQL 資料。


### rfunc

by Windows R Console 。 [Here](https://github.com/kancheng/rsloan/blob/master/man/rfunc.md)

若想要直接在 Console 的部分直接用寫好的自訂函數，可於 `rfunc` 目錄中執行寫好的 R File。


### shiny-server

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

### rprofile

為執行 R 執行預設時自動載入。


## Environment

詳見 [rsloan-environment](https://github.com/kancheng/rsloan-environment) 環境部屬

- [R Shiny Server](https://github.com/rstudio/shiny-server)
- [Ubuntu 14.04](https://en.wikipedia.org/wiki/Ubuntu_(operating_system))
- [RMySQL](https://github.com/rstats-db/RMySQL)
- [MariaDB](https://en.wikipedia.org/wiki/MariaDB)

## R Version

package 對應該版本為 `R version 3.3.2`。


## Data Cleaning

NA 值的資料筆數處理 [rsloan-dcna](https://github.com/kancheng/rsloan-dcna) 。

![nca](https://cloud.githubusercontent.com/assets/6993715/26279527/1e21e4bc-3de9-11e7-9e47-26c9c852b130.PNG)

```
有實際成績的科目欄位 / 所有科目欄位
```


## Paper

Kan, Hao-Cheng. (2017). *"A Study of Academic Achievement Analysis System: Using Cluster Analysis and Visualization"*. (Lunghwa University of Science and Technology). Retrieved from http://hdl.handle.net/11296/ndltd/17803647827157686465 .


## LICENSE

[MIT License](https://github.com/kancheng/rsloan/blob/master/LICENSE)


