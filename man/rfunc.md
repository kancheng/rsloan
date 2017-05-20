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
