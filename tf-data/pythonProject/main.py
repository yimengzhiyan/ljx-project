import os
import pandas as pd

# 指定读取文件的目录
read_dir = 'F:\\demo\\tf-data\\class_d'
# 指定输出文件的目录
output_dir = 'F:\\demo\\tf-data'

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

        # 提取T列和U列的数据
        t_data = data['Predict_linear_val']
        u_data = data['Predict_average1']

        # 将数据添加到对应的字典中
        if front not in front_data:
            front_data[front] = [t_data, u_data]
        else:
            # 使用pd.concat()来合并Series
            front_data[front][0] = pd.concat([front_data[front][0], t_data])
            front_data[front][1] = pd.concat([front_data[front][1], u_data])

        if back not in back_data:
            back_data[back] = [t_data, u_data]
        else:
            # 同样地，对后区域数据应用pd.concat()
            back_data[back][0] = pd.concat([back_data[back][0], t_data])
            back_data[back][1] = pd.concat([back_data[back][1], u_data])

# 输出合并后的数据
for key, data in front_data.items():
    output_path = os.path.join(output_dir, f'{key}-q.csv')
    output = pd.DataFrame({'Predict_linear_val': data[0], 'Predict_average1': data[1]})
    output.to_csv(output_path, index=False)

for key, data in back_data.items():
    output_path = os.path.join(output_dir, f'{key}-h.csv')
    output = pd.DataFrame({'Predict_linear_val': data[0], 'Predict_average1': data[1]})
    output.to_csv(output_path, index=False)