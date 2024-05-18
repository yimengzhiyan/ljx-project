library(ggplot2)
library(dplyr)
library(tidyr)

# 设置文件路径
file_path <- "F:/demo/tf-data"

# 读取目录下所有CSV文件
file_list <- list.files(path = file_path, pattern = "*.csv", full.names = TRUE)

# 初始化两个数据框架
enhancer_data <- data.frame(Label = character(), Mutation = character(), Value = numeric())
promoter_data <- data.frame(Label = character(), Mutation = character(), Value = numeric())

# 遍历文件列表，处理数据
for (file in file_list) {
  data <- read.csv(file)
  label <- gsub("-q.csv|-h.csv", "", basename(file))
  
  if (grepl("-q", basename(file))) {
    # 增强子
    temp_data <- data %>%
      select(Predict_linear_val, Predict_average1) %>%
      setNames(c("Pre-mutation", "Post-mutation")) %>%
      pivot_longer(cols = everything(), names_to = "Mutation", values_to = "Value")
    temp_data$Label <- label
    enhancer_data <- rbind(enhancer_data, temp_data)
  } else if (grepl("-h", basename(file))) {
    # 启动子
    temp_data <- data %>%
      select(Predict_linear_val, Predict_average2) %>%
      setNames(c("Pre-mutation", "Post-mutation")) %>%
      pivot_longer(cols = everything(), names_to = "Mutation", values_to = "Value")
    temp_data$Label <- label
    promoter_data <- rbind(promoter_data, temp_data)
  }
}

# 绘制增强子数据的图形
enhancer_plot <- ggplot(enhancer_data, aes(x = Mutation, y = Value)) +
  geom_boxplot() +
  coord_flip() +
  facet_wrap(~Label, scales = "free", nrow = nrow(enhancer_data) / 2) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 0, hjust = 0.5, vjust = 0.5),
        axis.text.y = element_text(size = 12),
        strip.text = element_text(size = 12, face = "bold"),
        plot.title = element_text(hjust = 0.5)) +
  labs(title = "Enhancer")

# 绘制启动子数据的图形
promoter_plot <- ggplot(promoter_data, aes(x = Mutation, y = Value)) +
  geom_boxplot() +
  coord_flip() +
  facet_wrap(~Label, scales = "free", nrow = nrow(promoter_data) / 2) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 0, hjust = 0.5, vjust = 0.5),
        axis.text.y = element_text(size = 12),
        strip.text = element_text(size = 12, face = "bold"),
        plot.title = element_text(hjust = 0.5)) +
  labs(title = "Promoter")

# 保存图形
ggsave("F:/demo/tf-data/result/enhancers_plot.pdf", enhancer_plot, width = 20, height = 40)
ggsave("F:/demo/tf-data/result/promoters_plot.pdf", promoter_plot, width = 20, height = 40)
