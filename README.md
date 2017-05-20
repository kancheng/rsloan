# rsloan

利用 大學管理學院 8 年的"就學貸款"與"學生成績"資料，進行 集群、ANOVA 與視覺化分析。

## raw

為目前分析過後的管理學院學生資料

## rfunc

by Windows R Console

若想要直接在 Console 的部分直接用寫好的自訂函數，可於 [`rfunc`](https://github.com/kancheng/rsloan/blob/master/man/rfunc.md) 目錄中執行寫好的 R File。

## shiny-server

by Ubuntu Linux

當中`shiny-server/rsloan/` 下的 `rsloan-tem.R` 是在非正式完成前測試檔案，完成後才會移置 `ui.R` 和 `server.R` 這兩個檔案裡面 。

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

# 資料

NA 值的學科處理 [rsloan-dcna](https://github.com/kancheng/rsloan-dcna)

# 文件

詳見 .....
