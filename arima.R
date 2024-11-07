library(forecast)
WaveletTransformPath <- paste0(dirname(rstudioapi::getSourceEditorContext()$path), "/src/WaveletTransform.R")
source(WaveletTransformPath)
dataPath <- paste0(dirname(rstudioapi::getSourceEditorContext()$path), "/DS/DS4.txt")
ds <- read.table(dataPath)[2]
ts_data <- as.numeric(ds$V2)
training_data <- ts_data[1:56]
model <- auto.arima(
    training_data, # データ指定
    ic = "aic", # 情報量基準の指定
    trace = T, # トレース出力（結果一覧）
    stepwise = T, # 計算時の次数パターン省略
    approximation = F, # 近似計算の適用
    seasonal = T # 季節調整
)
pr <- forecast(model, level = 95, h = 24)

print(pr$mean[1:24])
