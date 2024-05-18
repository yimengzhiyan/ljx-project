library(tidyverse)

# 设置工作目录
setwd("F:/demo/tf-data/f-result")

# 获取文件列表
enhancer_files <- list.files(pattern = "-q\\.csv$")
promoter_files <- list.files(pattern = "-h\\.csv$")

# 读取并计算一个文件的MSE
calculate_file_mse <- function(file_path) {
  data <- read_csv(file_path)
  mse <- mean((data[[1]] - data[[2]])^2)
  return(mse)
}

# 对每个增强子文件计算MSE
enhancers_mse <- setNames(lapply(enhancer_files, calculate_file_mse), enhancer_files)

# 对每个启动子文件计算MSE
promoters_mse <- setNames(lapply(promoter_files, calculate_file_mse), promoter_files)


plot_mse <- function(mse_data, type, color) {
  names <- gsub("(-q|-h)\\.csv$", "", names(mse_data))
  barplot(unlist(mse_data), names.arg = names, main = paste("MSE for", type, "Data"), col = color, las = 2, cex.names = 0.7, cex.main = 1.2)
}

# 使用不同的暖色调
enhancer_color <- "pink"
promoter_color <- "salmon"

# 绘制图表
plot_mse(enhancers_mse, "Enhancer", enhancer_color)
plot_mse(promoters_mse, "Promoter", promoter_color)



# 读取P.csv和E.csv
# 更新后的分类信息读取代码
p_class_info <- read_csv("P.csv") %>% 
  select(class, fam) %>%
  distinct()

e_class_info <- read_csv("E.csv") %>% 
  select(class, fam) %>%
  distinct()
# 读取并计算一个文件的MSE
calculate_file_mse <- function(file_path) {
  data <- read_csv(file_path)
  mse <- mean((data[[1]] - data[[2]])^2)
  return(mse)
}

# 对每个增强子和启动子文件计算MSE，并创建数据框
enhancers_mse <- setNames(lapply(enhancer_files, calculate_file_mse), enhancer_files)
promoters_mse <- setNames(lapply(promoter_files, calculate_file_mse), promoter_files)

# 将MSE值和对应的类型组织到一个数据框
mse_data <- tibble(
  file = c(names(enhancers_mse), names(promoters_mse)),
  mse = c(unlist(enhancers_mse), unlist(promoters_mse)),
  type = c(rep("Enhancer", length(enhancers_mse)), rep("Promoter", length(promoters_mse)))
)
# 合并类信息到MSE数据中，这需要确保文件名能够匹配到类信息中的家族名
mse_data <- mse_data %>%
  mutate(family = gsub("(\\-q|\\-h)\\.csv$", "", file),
         class = ifelse(type == "Enhancer", 
                        e_class_info$class[match(family, e_class_info$fam)], 
                        p_class_info$class[match(family, p_class_info$fam)]))