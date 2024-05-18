library(ggplot2)
library(dplyr)
library(gridExtra)
library(grid)

# 设置文件路径
file_path <- "F:/demo/tf-data"

# 读取目录下所有CSV文件
file_list <- list.files(path = file_path, pattern = "*.csv", full.names = TRUE)

# 初始化一个大的数据框架来存储所有数据
all_data <- data.frame(File = character(), Mutation = character(), Value = numeric(), Type = character())

# 遍历文件列表，处理数据
for (file in file_list) {
  data <- read.csv(file)
  # 检查文件名以区分增强子和启动子
  if (grepl("-q", basename(file))) {
    # 增强子
    data_long <- data %>%
      pivot_longer(cols = c(Predict_linear_val, Predict_average1),
                   names_to = "Mutation",
                   values_to = "Value")
    enhancer_or_promoter <- "Enhancer"
  } else if (grepl("-h", basename(file))) {
    # 启动子
    data_long <- data %>%
      pivot_longer(cols = c(Predict_linear_val, Predict_average2),
                   names_to = "Mutation",
                   values_to = "Value")
    enhancer_or_promoter <- "Promoter"
  }
  # 添加文件名和类型到数据框
  data_long$File <- basename(file)
  data_long$Type <- enhancer_or_promoter
  all_data <- rbind(all_data, data_long)
}

# 绘制所有数据的图形
p <- ggplot(all_data, aes(x = Mutation, y = Value, fill = Mutation)) +
  geom_boxplot() +
  facet_wrap(~File, scales = "free_y") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1),
        axis.text.y = element_text(size = 10),
        strip.text.x = element_text(size = 6))

# 保存图形
ggsave("F:/demo/tf-data/result/all_plots.pdf", p, width = 20, height = 15)
