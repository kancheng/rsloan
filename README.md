# rsloan

利用 大學管理學院 8 年的"就學貸款"與"學生成績"資料，進行 集群、ANOVA 與視覺化分析。

## raw

為目前分析過後的管理學院學生資料。

- [dtcna70](https://github.com/kancheng/rsloan/tree/master/raw/dtcna70)
- [origdt](https://github.com/kancheng/rsloan/tree/master/raw/origdt)
- [sql](https://github.com/kancheng/rsloan/tree/master/raw/sql)

## rfunc

by Windows R Console

若想要直接在 Console 的部分直接用寫好的自訂函數，可於 `rfunc` 目錄中執行寫好的 R File。

[Here](https://github.com/kancheng/rsloan/blob/master/man/rfunc.md)

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

NA 值的學科處理 [rsloan-dcna](https://github.com/kancheng/rsloan-dcna)

# 文件

詳見 .....
