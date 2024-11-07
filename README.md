# rwseについて

製作者: Kaoru Matsui

**rwse**(R wavelet shrinkage estimation)は，ソフトウェアフォールト発見数データから，離散型非同次ポアソン過程における強度関数を推定するプログラムです．

# rwseの使い方
このリポジトリをcloneした後, 必要なパッケージをインストールしてrwse直下で`/src/WaveletShrinkageEstimation.R`をインポートして使用してください.

詳しい使い方はrwse/example/ExampleUsage.Rをご覧ください．

# rwseで使える各関数について
## LoadData()
データセットを読み込むための関数です. txt形式で, 1行目にテスト時刻, 2行目にフォール発見数が記載されているものに限ります.
```
LoadData(
    DataPath = "データセットのパス"
)
```
## Wse()
Wseを行う関数です. 引数は以下をとることができます. データ変換, 閾値決定アルゴリズム, 閾値法の詳しい内容は後述します.
```
Wse(
   Data = データセット
   DataTransform =  ("none", "A1", "A2", "A3", "B1", "B2", "Fi", "Fr"), #データ変換の指定
   ThresholdName = ("ldt", "ut", "lut", "lht"), #閾値決定アルゴリズムの指定
   ThresholdMode = ("h", "s"), #閾値法の指定
   Var = データ変換の際の分散を指定(デフォルトは1),
   Index = 分割データのデータ長を指定,
   InitThresholdvalue = 閾値の初期値(適当で良い),
)
```
### データ変換
データ変換は`DataTransform`によって指定することができます. rwseでは次の表のデータ変換が実装され, 変換式に違いがあります. すべての変換において逆変換の式に違いがあるため, 逆変換の式のみ参考に載せておきます.
| 変数名 | 変換名 | 逆変換の式 |
| ------------- | ------------- | ------------- |
| none  | データ変換を行わない  | 式なし |
| A1  | Anscombe transformation 1  | $`(s_i^2-3/2)/4`$  |
| A2  | Anscombe transformation 2  | $`(s_i^2-1/2)/4`$  |
| A3  | Anscombe transformation 3  | $`(s_i^2)/4+\sqrt{3/2}/(4*s_i)-11/(8*s_i^2)+5*\sqrt{3/2}/(8*s_i^3)-1/8`$  |
| B1  | Bartlet transformation 1  | $`(b_i^2-2)/4`$  |
| B2  | Bartlet transformation 2  | $`(b_i^2)/4`$  |
| Fi  | Fisz transformation  | 複雑なため省略  |
| Fr  | Freeman transformation |　$`(f_i^2+f_i^{-2}-2)/4`$　|

### 閾値決定アルゴリズム
閾値決定アルゴリズムは`ThresholdName`によって指定することができます. rwseでは次の表の閾値決定アルゴリズムが実装されています.
| 変数名 | 閾値決定アルゴリズム名 | 備考 |
| ------------- | ------------- | ------------- |
| ldt | Level-dependent-Threshold | dt="none"を指定した場合のみ適用化 |
| ut | Universal-Threshold | dt="none"以外を指定した場合のみ適用化 |
| lut | Level-dependent Universal Threshold | dt="none"以外を指定した場合のみ適用化 |
| lht | Level-out-half Cross-validation Threshold | dt="none"以外を指定した場合のみ適用化 |

### 閾値法
閾値法は`ThresholdMode`によって指定することができます. rwseでは次の表の閾値法が実装されています.
| 変数名 | 閾値決定アルゴリズム名 |
| ------------- | ------------- |
| s | Soft thresholding method |
| h | Hard thresholding method |

### 実行結果
wse()は推定値, スケーリング係数, ウェーブレット係数, 閾値処理後のウェーブレット係数を返します. データ構造は以下となります.
```
Result = wse()

Result
$EstimationData #推定値
$Cs #スケーリング係数
$Ds #ウェーブレット係数
$DenoisedDs #閾値処理後のウェーブレット係数
```

## Tipsh()
Tipshアルゴリズムを用いてwseを行う関数です. 各引数以下をとることができます. 閾値法は`Wse()`と同様です.
```
tipsh(
   Data = データセット
   ThresholdMode = ("h", "s"), #閾値法の指定
   Var = データ変換の際の分散を指定(デフォルトは1),
   Index = 分割データのデータ長を指定,
)
```
### 実行結果
Tipsh()は推定値, スケーリング係数, ウェーブレット係数, 閾値処理後のウェーブレット係数を返します. データ構造は以下となります.
```
Result = Tipsh()

Result
$EstimationData #推定値
$Cs #スケーリング係数
$Ds #ウェーブレット係数
$DenoisedDs #閾値処理後のウェーブレット係数
```

## CreateResult()
hard閾値法とsoft閾値法の実行結果を同時に.csvと.Rdata形式で保存する関数です.
```
CreateResult(
    Hard = hard閾値法の実行結果,
    Soft = soft閾値法の実行結果,
    Index = 分割データのデータ長を指定(ファイル名に影響),
    ResultPath = 実行結果を格納するパス
)
```
