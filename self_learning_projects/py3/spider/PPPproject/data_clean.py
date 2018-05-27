# -*- coding: utf-8 -*-
"""
Created on Tue Nov 21 22:25:14 2017

@author: 张煜东的台式工作机
"""

from pandas import Series, DataFrame
import json
import pickle


def to_DataFrame(savepath, filename):
    '''导出csv表格'''
    index = [i['RN'] for i in projects]  # 'RN' 序号
    proj_no = [i['PROJ_NO'] for i in projects]  # 'PROJ_NO' PROJ_NO
    proj_name = [i['PROJ_NAME'] for i in projects]  # 'PROJ_NAME' 项目名称
    start_time = [i['START_TIME'] for i in projects]  # 'START_TIME' 发起时间
    location = [i['PRV'] for i in projects
                ]  # 'PRV'   full name, combination of PRV1, 2, 3  所在地区
    province = [i['PRV1'] for i in projects]  # 'PRV1'  省
    city = [i['PRV2'] for i in projects]  # 'PRV2' 市
    region = [i['PRV3'] for i in projects]  # 'PRV3' 区
    type1 = [i['IVALUE'] for i in projects]  # 'IVALUE' 所属行业
    type2 = [i['IVALUE2'] for i in projects]  # 'IVALUE2' 所属行业分支
    invest_count = [i['INVEST_COUNT']
                    for i in projects]  # 'INVEST_COUNT' 项目总投资
    proj_type = [i['PROJ_TYPE'] for i in projects]  # 'PROJ_TYPE' 项目种类编号
    proj_type_name = [i['PROJ_TYPE_NAME']
                      for i in projects]  # 'PROJ_TYPE_NAME' 项目种类名称
    proj_state = [i['PROJ_STATE'] for i in projects]  # 'PROJ_STATE' 所处阶段编号
    proj_state_name = [i['PROJ_STATE_NAME']
                       for i in projects]  # 'PROJ_STATE_NAME' 所处阶段名称
    return_mode = [i['RETURN_MODE'] for i in projects]  # 'RETURN_MODE' 回报机制编号
    return_mode_name = [i['RETURN_MODE_NAME']
                        for i in projects]  # 'RETURN_MODE_NAME' 回报机制名称
    survey = [i['PROJ_SURVEY'] for i in projects]  # 'PROJ_SURVEY' 概况
    creating_uname = [i['CREATING_UNAME']
                      for i in projects]  # 'CREATING_UNAME' 未命名变量1
    start_uname = [i['START_UNAME'] for i in projects]  # 'START_UNAME' 未命名变量2
    period = [i['ESTIMATE_COPER'] for i in projects]  # 'ESTIMATE_COPER' 合作期限
    operate_mode = [i['OPERATE_MODE']
                    for i in projects]  # 'OPERATE_MODE' 项目运作方式编号
    operate_mode_name = [i['OPERATE_MODE_NAME']
                         for i in projects]  # 'OPERATE_MODE_NAME' 项目运作方式名称
    # 增加股东信息
    gudongcount = [i['gudongcount'] for i in projects]
    gudongmingcheng = {}
    shehuiziben = {}
    chuzie = {}
    guquanbili = {}
    for j in range(20):
        gudongmingcheng[str(j + 1)] = [
            i['gudongmingcheng' + str(j + 1)] for i in projects
        ]
        shehuiziben[str(j + 1)] = [
            i['shehuiziben' + str(j + 1)] for i in projects
        ]
        chuzie[str(j + 1)] = [i['chuzie' + str(j + 1)] for i in projects]
        guquanbili[str(j + 1)] = [
            i['guquanbili' + str(j + 1)] for i in projects
        ]

    frame_data = {
        '序号': index,
        'PROJ_NO': proj_no,
        '项目名称': proj_name,
        '发起时间': start_time,
        '所在地区': location,
        '省': province,
        '市': city,
        '区': region,
        '所属行业': type1,
        '所属行业分支': type2,
        '项目总投资(万元)': invest_count,
        '项目种类编号': proj_type,
        '项目种类名称': proj_type_name,
        '所处阶段编号': proj_state,
        '所处阶段名称': proj_state_name,
        '回报机制编号': return_mode,
        '回报机制名称': return_mode_name,
        'CREATING_UNAME': creating_uname,
        'START_UNAME': start_uname,
        '合作期限(年)': period,
        '项目运作方式编号': operate_mode,
        '项目运作方式名称': operate_mode_name,
        '概况': survey,
        '股东数量': gudongcount,
    }
    for j in range(20):
        frame_data['股东名称' + str(j + 1)] = gudongmingcheng[str(j + 1)]
        frame_data['政府或社会资本' + str(j + 1)] = shehuiziben[str(j + 1)]
        frame_data['出资额(万元)' + str(j + 1)] = chuzie[str(j + 1)]
        frame_data['股权比例(%)' + str(j + 1)] = guquanbili[str(j + 1)]

    frame_columns = [
        '序号',
        'PROJ_NO',
        '项目名称',
        '发起时间',
        '所在地区',
        '省',
        '市',
        '区',
        '所属行业',
        '所属行业分支',
        '项目总投资(万元)',
        '项目种类编号',
        '项目种类名称',
        '所处阶段编号',
        '所处阶段名称',
        '回报机制编号',
        '回报机制名称',
        'CREATING_UNAME',
        'START_UNAME',
        '合作期限(年)',
        '项目运作方式编号',
        '项目运作方式名称',
        '概况',
        '股东数量',
    ]
    for j in range(20):
        frame_columns.append('股东名称' + str(j + 1))
        frame_columns.append('政府或社会资本' + str(j + 1))
        frame_columns.append('出资额(万元)' + str(j + 1))
        frame_columns.append('股权比例(%)' + str(j + 1))

    PPP_table = DataFrame(frame_data, columns=frame_columns)
    PPP_table.to_csv(savepath + filename + '.csv', index=False)


path = 'E:/ZYD/python/learning.git/self_learning_projects/py3/spider/PPPproject/'
#data = pickle.load(open(path + 'data_tmp.txt', 'rb'))
#list_json = [json.loads(i) for i in data]
#projects = []
#[projects.extend(i['list']) for i in list_json]

# 增加股东信息
# 此处执行 getPPPData-Second Part

for i in projects:
    if not 'gudongcount' in i:
        i['gudongcount'] = 0
list_gudongcount = [i['gudongcount'] for i in projects]
Series_gudongcount = Series(list_gudongcount)
max_count = Series_gudongcount.max()
for i in projects:
    for j in range(i['gudongcount'] + 1, max_count + 1):
        i['gudongmingcheng' + str(j)] = ''
        i['shehuiziben' + str(j)] = ''
        i['chuzie' + str(j)] = ''
        i['guquanbili' + str(j)] = ''

to_DataFrame(path, 'PPPdata_11_24_2')
