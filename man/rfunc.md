# rfunc

存放所有寫的 R Function 。

## main-rfunc.R

匯入所有的 R 檔， `hca.R` 、 `hcaon.R` 、 `io.R` 、 `ashd.R` 、 `mulggplotpic.R` 、 `picopt.R` 、 `picopt.R` 、 `mulggplotpic-build.R`。


## hca.R

基本的階層式分群，作為 `hcaon.R` 之後集群方法的基礎。

### hcadpic()

產生階層式分群的樹狀繪圖

```
hcadpic( hcdata, hck = 5, hcm = "ward.D", dism = "euclidean")
```

### hcad()

產生階層式分群 Data.frame

```
hcad( hcdata, hck = 5, hcm = "ward.D", dism = "euclidean")
```


## hcaon.R

共有 `hcaon()` 、 `hcaon2()` 函數。

### hcaon()

hcaon() 會產生 `階層式分群` 、 `變異數分析` 、 `各群敘述統計` 、 `就學貸款下的各群敘述統計` 、 `各分群的人數比例` 等 結果資料集。

```
hcaon( Odata, beky, keycol, hck = 5, hcm = "ward.D", dism = "euclidean", dtname = "unt", swd = getwd())
```

- `Odata` 階層式分群的資料集。

- `beky` 為要階層式分群的資料集的欄位名稱。

- `keycol` 為階層式分群的辨識欄位。

- `hck` 為控制階層式分群的群數。

- `hcm` 為控制階層式分群的方法。

- `dism` 為控制階層式分群的距離。

- `dtname` 為產生後資料集的名稱。

- `swd` 為分析工作目錄檔案的路徑。

### hcaon2()

hcaon2() 會產生階層式分群的樹狀圖，參數與 hcaon() 一致。

```
hcaon2( Odata, beky, keycol, hck = 5, hcm = "ward.D", dism = "euclidean", dtname = "unt", swd = getwd())
```

## io.R

自動對指定路徑的目錄下的所有 CSV 檔案進行匯入與 Data.Frame 輸出。

### 匯入為 Data.Frame 格式

```
path = "C:/csv"
rcsvdf(path)
```

### 匯入為 List 格式

```
path = "C:/csv"
rcsvlt(path)
```

### 匯出為 CSV 檔案

```
wrta(xdo , ycsv, swd)
```
- `xdo` Data.Frame 的 物件

- `ycsv` 所要匯出 CSV 的檔名 (字串)

- `swd` 匯出的目錄路徑 (字串)

## ashd.R

為資料型態的轉換與檢視 `List` 中多個 `Data.Frame` 資料。

## mulggplotpic.R

來源為 `cookbook` 的 ggplot2 多圖合併 Function。[Here](http://www.cookbook-r.com/Graphs/Multiple_graphs_on_one_page_(ggplot2)/)

```
multiplot()
```


## mulggplotpic-build.R

`hcaon.R` 下的 `hcaon()` 所產生的集群資料，處理成散佈圖。

- `sg2proc()` 為單圖散佈圖

- `mg2proc()` 為多圖散佈圖


## picopt.R

繪圖輸出

`picopt()` 、 `gpot()`
