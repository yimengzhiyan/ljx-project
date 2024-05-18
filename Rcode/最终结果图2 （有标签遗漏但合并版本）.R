library(RColorBrewer)
library(ggplot2)
library(dplyr)

# 生成更加鲜明的颜色方案
generate_colors <- function(n) {
  color_palette <- brewer.pal(min(n, 12), "Set3")
  if (n > 12) {
    additional_colors <- colorRampPalette(brewer.pal(12, "Set3"))(n - 12)
    color_palette <- c(color_palette, additional_colors)
  }
  return(color_palette)
}

# 绘图函数
plot_combined_mse <- function(mse_data, type) {
  data_to_plot <- mse_data %>%
    filter(type == type) %>%
    mutate(fam_class = paste(class, fam, sep = " - "),  # Combine class and family name
           class_first = !duplicated(class))  # Mark first occurrence of each class
  
  classes <- unique(data_to_plot$class)
  color_palette <- generate_colors(length(classes))
  
  ggplot(data_to_plot, aes(x = fam_class, y = mse, fill = class)) +
    geom_col(show.legend = FALSE, position = position_dodge(width = 0.9), width = 0.85) +
    geom_text(aes(label = ifelse(class_first, class, "")), position = position_dodge(width = 0.9), 
              vjust = -0.5, size = 3, check_overlap = TRUE) +  # Show class name only for the first bar
    scale_fill_manual(values = color_palette) +
    theme_minimal() +
    theme(
      panel.background = element_rect(fill = "white", colour = "black"),
      text = element_text(color = "black"),
      axis.text.x = element_text(angle = 45, hjust = 1, color = "black"),
      axis.title.x = element_blank(),
      axis.title.y = element_text(size = 14, color = "black"),
      plot.title = element_text(size = 16, face = "bold", color = "black")
    ) +
    labs(x = NULL, y = "Mean Squared Error (MSE)", title = paste("MSE for", type, "Data")) +
    scale_x_discrete(breaks = data_to_plot$fam_class, labels = data_to_plot$fam_class)
}

# 加载数据并应用绘图函数
enhancer_data <- mse_data %>% filter(type == "Enhancer")
promoter_data <- mse_data %>% filter(type == "Promoter")

# 假设使用适当的输出设置保存图像
ggsave("enhancer_plot.png", plot_combined_mse(enhancer_data, "Enhancer"), width = 20, height = 8, dpi = 300)
ggsave("promoter_plot.png", plot_combined_mse(promoter_data, "Promoter"), width = 20, height = 8, dpi = 300)
