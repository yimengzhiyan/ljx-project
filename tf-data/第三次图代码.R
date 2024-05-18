library(ggplot2)
library(dplyr)
library(tidyr)

# 设置文件路径
file_path <- "F:/demo/tf-data"

# 读取目录下所有CSV文件
file_list <- list.files(path = file_path, pattern = "*.csv", full.names = TRUE)

# 初始化数据框
enhancer_data <- data.frame(Mutation = character(), Value = numeric(), Enhancer = character())
promoter_data <- data.frame(Mutation = character(), Value = numeric(), Promoter = character())

# 遍历文件列表，处理数据
for (file in file_list) {
  data <- read.csv(file)
  
  name <- gsub("(.+)-(q|h).csv", "\\1", basename(file))
  
  if (grepl("-q", basename(file))) {
    tmp <- data %>% 
      pivot_longer(cols = c(Predict_linear_val, Predict_average1),
                   names_to = "Mutation",
                   values_to = "Value") %>%
      mutate(Enhancer = name)
    enhancer_data <- rbind(enhancer_data, tmp)
  } else if (grepl("-h", basename(file))) {
    tmp <- data %>% 
      pivot_longer(cols = c(Predict_linear_val, Predict_average2),
                   names_to = "Mutation",
                   values_to = "Value") %>%
      mutate(Promoter = name)
    promoter_data <- rbind(promoter_data, tmp)
  }
}

# 设置增强子和启动子的填充颜色
fill_colors <- c("Pre-mutation" = "#FF9999", "Post-mutation" = "#66CCCC") #鲜艳的红与蓝

# 绘制增强子的箱线图
p1 <- ggplot(enhancer_data, aes(x = Enhancer, y = Value, fill = Mutation)) +
  geom_boxplot(outlier.shape = 21, outlier.color = "gray", outlier.fill = "white") +
  scale_fill_manual(values = fill_colors) +
  coord_flip() +
  labs(title = "Enhancer", x = "", y = "Value") +
  theme_light() +
  theme(
    legend.position = "bottom",
    plot.title = element_text(face = "bold", size = 14),
    axis.text.x = element_text(angle = 45, hjust = 1, color = "gray"),
    axis.text.y = element_text(color = "gray")
  )

# 绘制启动子的箱线图
p2 <- ggplot(promoter_data, aes(x = Promoter, y = Value, fill = Mutation)) +
  geom_boxplot(outlier.shape = 21, outlier.color = "gray", outlier.fill = "white") +
  scale_fill_manual(values = fill_colors) +
  coord_flip() +
  labs(title = "Promoter", x = "", y = "Value") +
  theme_light() +
  theme(
    legend.position = "bottom",
    plot.title = element_text(face = "bold", size = 14),
    axis.text.x = element_text(angle = 45, hjust = 1, color = "gray"),
    axis.text.y = element_text(color = "gray")
  )

# 保存图形
ggsave("F:/demo/tf-data/result/enhancers_plot.pdf", p1, width = 10, height = 5)
ggsave("F:/demo/tf-data/result/promoters_plot.pdf", p2, width = 10, height = 5)