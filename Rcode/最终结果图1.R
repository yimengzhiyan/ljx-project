library(tidyverse)
library(RColorBrewer)
library(ggplot2)

# 加载之前保存的数据
load("F:/demo/tf-data/f-result/mse_data.RData")

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
    arrange(class, fam)  # 按类别和家族排序
  
  classes <- unique(data_to_plot$class)
  color_palette <- generate_colors(length(classes))
  
  p <- ggplot(data_to_plot, aes(x = reorder(fam, class), y = mse, fill = class)) +
    geom_col(show.legend = TRUE, width = 0.85) +  # 显示柱状图
    geom_text(aes(label = sprintf("%.2f", mse)), vjust = -0.5, size = 3, check_overlap = TRUE) +  # 添加数值标签
    scale_fill_manual(values = color_palette, name = "Class", guide = guide_legend(reverse = TRUE)) +
    theme_minimal() +
    theme(
      panel.background = element_rect(fill = "white", colour = "black"),
      text = element_text(color = "black"),
      axis.text.x = element_text(angle = 65, vjust = 1, hjust = 1, size = 7, color = "black"),
      axis.title.x = element_blank(),
      axis.title.y = element_text(size = 14, color = "black"),
      plot.title = element_text(size = 16, face = "bold", color = "black"),
      plot.margin = margin(10, 40, 10, 10),
      legend.position = "right"
    ) +
    labs(x = NULL, y = "Mean Squared Error (MSE)", title = paste("MSE for", type, "Data"))
  
  return(p)
}

# 绘制图表
enhancer_plot <- plot_combined_mse(enhancer_data, "Enhancer")
promoter_plot <- plot_combined_mse(promoter_data, "Promoter")

# 显示图表
print(enhancer_plot)
print(promoter_plot)
