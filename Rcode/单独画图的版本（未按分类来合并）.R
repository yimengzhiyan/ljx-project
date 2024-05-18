library(RColorBrewer)
library(ggplot2)
library(dplyr)

# 生成更加鲜明的颜色方案
generate_colors <- function(n) {
  # 使用Set3色板，它提供更明亮的颜色，适合区分更多类别
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
    mutate(fam_class = paste(class, fam, sep = " - "))  # 组合类别和家族名称
  
  classes <- unique(data_to_plot$class)
  color_palette <- generate_colors(length(classes))
  
  ggplot(data_to_plot, aes(x = class, y = mse, fill = class)) +
    geom_col(position = position_dodge(width = 0.9), width = 0.85, color = "black") +
    geom_text(aes(label = fam), vjust = -0.5, position = position_dodge(width = 0.9), size = 3) +
    scale_fill_manual(values = color_palette) +
    theme_minimal(base_size = 14) +
    theme(
      axis.text.x = element_text(angle = 45, hjust = 1),
      axis.title.x = element_blank(),
      axis.title.y = element_text(size = 14),
      legend.position = "right",
      legend.title = element_text(size = 14),
      legend.text = element_text(size = 12),
      plot.title = element_text(size = 16, face = "bold"),
      plot.margin = margin(10, 40, 10, 10)
    ) +
    labs(x = NULL, y = "Mean Squared Error (MSE)", title = paste("MSE for", type, "Data"))
}

# 加载数据和应用绘图函数
enhancer_data <- mse_data %>% filter(type == "Enhancer")
promoter_data <- mse_data %>% filter(type == "Promoter")

# 假设使用适当的输出设置保存图像
ggsave("enhancer_plot.png", plot_combined_mse(enhancer_data, "Enhancer"), width = 20, height = 8, dpi = 300)
ggsave("promoter_plot.png", plot_combined_mse(promoter_data, "Promoter"), width = 20, height = 8, dpi = 300)


# 生成足够的颜色
generate_colors <- function(n) {
  colors <- grDevices::colors()[grep('gr(a|e)y', grDevices::colors(), invert = TRUE)]
  color_palette <- sample(colors, n)
  return(color_palette)
}
##单独画图
enhancer_data <- mse_data %>% filter(type == "Enhancer")
promoter_data <- mse_data %>% filter(type == "Promoter")

plot_combined_mse(enhancer_data, "Enhancer")
plot_combined_mse(promoter_data, "Promoter")