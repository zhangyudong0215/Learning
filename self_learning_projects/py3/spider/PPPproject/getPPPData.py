# -*- coding: utf-8 -*-
"""
Created on Tue Nov 21 22:25:14 2017

@author: 张煜东的台式工作机
"""

import requests
from time import sleep
from random import random
import pickle
from mylog import MyLog as mylog
from bs4 import BeautifulSoup
import time

path = 'E:/ZYD/python/learning.git/self_learning_projects/py3/spider/PPPproject/'
header = {
    'user-agent':
    'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:54.0) Gecko/20100101 Firefox/54.0',
    'accept':
    'text/html, application/xhtml+xml, application/xml; q=0.9, image/webp, */*; q=0.8'
}
#string_1 = 'http://www.cpppc.org:8082/efmisweb/ppp/projectLibrary/getPPPList.do?queryPage='
#string_2 = '&distStr=&induStr=&investStr=&projName=&sortby=&orderby=&stageArr='
#
#data_json = []
#for i in range(1777):
#    sleep(random()*10+2)
#    url = string_1 + str(i+1) + string_2
#    response = requests.get(url, headers=header).text
#    data_json.append(response)
#    mylog().info('Python 返回Page:%s  数据成功' % str(i+1))
#
#pickle.dump(data_json, open(path + 'data_tmp.txt', 'wb'))

projects = pickle.load(open(path + 'PROJ_DATA.txt', 'rb'))

# Second Part
url_1 = 'http://www.cpppc.org:8082/efmisweb/ppp/projectLibrary/getProjInfoNational.do?projId='

time1 = time.time()
for i in projects:
    if int(i['PROJ_STATE']) is 4:
        sleep(random() * 5 + 1)
        response = requests.get(url_1 + i['PROJ_RID'], headers=header).text
        soup = BeautifulSoup(response, 'lxml')
        # 项目公司名称
        anchorTag = soup.find(
            'td',
            attrs={
                'colspan': '5',
                'style': 'text-align: left;width: 30%;'
            })
        try:
            i['PROJ_COMPANY_NAME'] = str(anchorTag.get_text().split()[0])
        except:
            i['PROJ_COMPANY_NAME'] = None
        # 项目公司成立时间
        anchorTag = soup.find_all(
            'td',
            attrs={
                'colspan': '2',
                'style': 'text-align: left;width: 30%;'
            })
        try:
            i['PROJ_COMPANY_STARTDATE'] = str(anchorTag[-1].get_text())
        except:
            i['PROJ_COMPANY_STARTDATE'] = None
        # 项目公司注册资金
        anchorTag = soup.find_all('td')
        i['PROJ_COMPANY_COUNT'] = None
        for j in range(len(anchorTag)):
            if '项目公司注册资金' in str(anchorTag[j]):
                i['PROJ_COMPANY_COUNT'] = str(anchorTag[j + 1].get_text()[:-2])
        # 股东信息
        anchorTag = soup.find_all('td', attrs={'style': 'text-align:center;'})
        if not str(anchorTag[-1].get_text()) == str('暂无'):
            i['gudongcount'] = int(anchorTag[-5].get_text())
        else:
            i['gudongcount'] = 0
        if i['gudongcount']:
            for j in range(int(i['gudongcount'])):
                page_count = int(i['gudongcount']) * 5
                i['gudongmingcheng' +
                  str(j + 1)] = anchorTag[j * 5 - page_count + 1].get_text()
                i['shehuiziben' + str(j + 1)] = anchorTag[j * 5 - page_count +
                                                          2].get_text()
                i['chuzie' + str(j + 1)] = anchorTag[j * 5 - page_count +
                                                     3].get_text()
                i['guquanbili' + str(j + 1)] = anchorTag[j * 5 - page_count +
                                                         4].get_text()
    print('Python Projects ID:%s  完成  累计用时:%d秒' % (str(i['RN']),
                                                   time.time() - time1))

pickle.dump(projects, open(path + 'projects_11_24.txt', 'wb'))
#projects = pickle.load(open(path + 'projects2.txt', 'rb'))
