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
###################################################################################################
##第一次尝试
# 函数：根据分类合并柱状图
merge_plots <- function(class_data, mse_data, main_title) {
  unique_classes <- distinct(class_data[[1]])
  plot_list <- list()
  
  for (class in unique_classes[[1]]) {
    families <- filter(class_data, class_data[[1]] == class)[[2]]
    family_mse <- mse_data[names(mse_data) %in% families]
    plot_list[[class]] <- barplot(unlist(family_mse), main = paste(main_title, "for", class), col = sample(rainbow(length(family_mse))))
  }
  
  return(plot_list)
}

# 合并增强子和启动子的柱状图
merged_enhancer_plots <- merge_plots(e_data, enhancers_mse, "Enhancers MSE")
merged_promoter_plots <- merge_plots(p_data, promoters_mse, "Promoters MSE")
#################################################################################################



#################################################################################################第二次尝试：重新计算mse并分配标签




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

#### 画出合并的柱状图
ggplot(mse_data, aes(x = file, y = mse, fill = type)) +
  geom_bar(stat = "identity", position = "dodge") +
  theme_minimal() +
  labs(title = "MSE Values of Enhancers and Promoters", x = "File", y = "MSE") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) # 旋转X轴标签以便阅读

#####注意：根据您的文件数量和文件名，X轴标签可能会很拥挤，所以您可能需要调整图表的尺寸或重新调整X轴标签。
###########################################################################################################

