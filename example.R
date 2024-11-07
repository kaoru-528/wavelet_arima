library(forecast)
library(ggplot2)
WaveletTransformPath <- paste0(dirname(rstudioapi::getSourceEditorContext()$path), "/src/WaveletTransform.R")
source(WaveletTransformPath)
ThresholdPath <- paste0(dirname(rstudioapi::getSourceEditorContext()$path), "/src/Threshold.R")
source(ThresholdPath)
source(WaveletTransformPath)
DtPath <- paste0(dirname(rstudioapi::getSourceEditorContext()$path), "/src/DataTransform.R")
source(DtPath)
dataPath <- paste0(dirname(rstudioapi::getSourceEditorContext()$path), "/DS/DS4.txt")
ds <- read.table(dataPath)[2]
ts_data <- as.numeric(ds$V2)
split_data <- split(ts_data, ceiling(seq_along(ts_data) / 8))
# split_data <- AnscombeTransformFromGroups(split_data, Var = 1)

split_c <- c()
split_d2 <- c()
split_d3 <- c()
split_d4 <- c()
for (i in 1:(length(split_data) - 3)) {
    Cs <- GetScalingCoefficientsFromGroup(split_data[[i]])
    Ds <- GetWaveletCoefficientsFromGroup(Cs)
    split_c <- c(split_c, Cs[[4]])
    split_d2 <- c(split_d2, Ds[[2]])
    split_d3 <- c(split_d3, Ds[[3]])
    split_d4 <- c(split_d4, Ds[[4]])
}
# data <- split_d2
model_c0 <- auto.arima(
    split_c, # データ指定
    ic = "aic", # 情報量基準の指定
    trace = T, # トレース出力（結果一覧）
    stepwise = T, # 計算時の次数パターン省略
    approximation = F, # 近似計算の適用
    seasonal = T # 季節調整
)
pr_c0 <- forecast(model_c0, level = 95, h = 3)

model_d1 <- auto.arima(
    split_d2, # データ指定
    ic = "aic", # 情報量基準の指定
    trace = T, # トレース出力（結果一覧）
    stepwise = T, # 計算時の次数パターン省略
    approximation = F, # 近似計算の適用
    seasonal = T # 季節調整
)
pr_d1 <- forecast(model_d1, level = 95, h = 12)

model_d2 <- auto.arima(
    split_d3, # データ指定
    ic = "aic", # 情報量基準の指定
    trace = T, # トレース出力（結果一覧）
    stepwise = T, # 計算時の次数パターン省略
    approximation = F, # 近似計算の適用
    seasonal = T # 季節調整
)
pr_d2 <- forecast(model_d2, level = 95, h = 6)

model_d3 <- auto.arima(
    split_d4, # データ指定
    ic = "aic", # 情報量基準の指定
    trace = T, # トレース出力（結果一覧）
    stepwise = T, # 計算時の次数パターン省略
    approximation = F, # 近似計算の適用
    seasonal = T # 季節調整
)
pr_d3 <- forecast(model_d3, level = 95, h = 3)

Cs[[4]] <- pr_c0$mean[3]
Ds[[2]] <- pr_d1$mean[9:12]
Ds[[3]] <- pr_d2$mean[5:6]
Ds[[4]] <- pr_d3$mean[3]
# DenoisedDs <- ThresholdForGroup(Ds, ThresholdMode = "s", ThresholdName = "ldt", DataTransform = "none", Groups, InitThresholdValue, InitThresholdValue = 1)

Result <- InverseHaarWaveletTransformForGroup(Cs, DenoisedDs)
# Result <- InverseAnscombeTransformFromGroup(Result, Var = 1)
print(Result)

# Data2 <- pr_d1$mean[1:12]

# ggplot() +
#     geom_line(aes(x = 1:28, y = as.numeric(data)), color = "blue", size = 1) +
#     geom_point(aes(x = 1:28, y = as.numeric(data)), color = "blue", size = 4) +
#     geom_line(aes(x = 25:28, y = as.numeric(Data2)), color = "red", , size = 1) +
#     geom_point(aes(x = 25:28, y = as.numeric(Data2)), color = "red", , size = 4) +
#     geom_vline(
#         xintercept = 25,
#         linetype = "dotted",
#         color = "black",
#         size = 1
#     ) +
#     labs(
#         x = "number",
#         y = "wavelet coefficients value d[1]"
#     ) +
#     theme(
#         panel.background = element_rect(fill = "transparent", colour = "black"),
#         panel.grid = element_blank(),
#         text = element_text(size = 24),
#         legend.title = element_blank(),
#         legend.background = element_rect(fill = "white", color = "black", size = 0.2),
#         legend.position = c(0.005, 0.83),
#         legend.justification = c(0, 0),
#         legend.key.size = unit(1.0, "cm"),
#         legend.key = element_rect(fill = "white", color = "white")
#     ) +
#     ggsave("a.png", width = 13.44, height = 9.14)


