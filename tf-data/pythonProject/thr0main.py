import os
import pandas as pd

# 指定读取文件的目录
read_dir = 'F:\\demo\\tf-data\\f_d'
# 指定输出文件的目录
output_dir = 'F:\\demo\\tf-data\\f-result'

# 获取指定目录中的所有文件
files = os.listdir(read_dir)

# 初始化两个字典用于存储前后区域的数据
front_data = {}
back_data = {}

# 遍历每个文件
for file in files:
    # 构造完整的文件路径
    file_path = os.path.join(read_dir, file)

    # 检查文件是否符合命名规则
    if '~' in file:
        # 分割文件名
        parts = file.split('~')
        front = parts[0]
        back = parts[1].split('.')[0]  # 去掉扩展名

        # 读取文件数据
        data = pd.read_csv(file_path)

        # 提取T列、U列和X列的数据
        s_data = data['Predict_linear_val']
        t_data = data['Predict_average1']
        w_data = data['Predict_average2']  # 后区域需要提取X列数据

        # 将数据添加到对应的字典中
        if front not in front_data:
            front_data[front] = [s_data, t_data]
        else:
            front_data[front][0] = pd.concat([front_data[front][0], s_data])
            front_data[front][1] = pd.concat([front_data[front][1], t_data])

        if back not in back_data:
            back_data[back] = [s_data, w_data]  # 后区域使用X列数据
        else:
            back_data[back][0] = pd.concat([back_data[back][0], s_data])
            back_data[back][1] = pd.concat([back_data[back][1], w_data])

# 输出合并后的数据
for key, data in front_data.items():
    output_path = os.path.join(output_dir, f'{key}-q.csv')
    output = pd.DataFrame({'Predict_linear_val': data[0], 'Predict_average1': data[1]})
    output.to_csv(output_path, index=False)

for key, data in back_data.items():
    output_path = os.path.join(output_dir, f'{key}-h.csv')
    output = pd.DataFrame({'Predict_linear_val': data[0], 'Predict_average2': data[1]})
    output.to_csv(output_path, index=False)