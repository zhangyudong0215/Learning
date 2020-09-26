# coding: utf-8
import sys
import os
sys.path.append(os.getcwd())


bash_template = """
python E:/ZYD/Github/Learning/self_learning_projects/py3/spider/R18/177/177spider.py -u {url} -s E:/ZYD/spider/177
"""


def get_comics(bash_template, url):
    bash_file = bash_template.format(url=url)
    os.system(bash_file)


with open('E:/ZYD/Github/Learning/self_learning_projects/py3/spider/R18/177/urls_177.txt', 'r') as f:
    while True:
        url = f.readline().strip()
        if not url:
            break
        get_comics(bash_template, url)


# python E:/ZYD/Github/Learning/self_learning_projects/py3/spider/R18/177/177spider.py -u url -s E:/ZYD/spider/177
# python /home/ydzhang/GitHub/Learning/self_learning_projects/py3/spider/R18/177/177spider.py -u url -s /home/ydzhang/spider_download
# http://www.177piczz.info/html/2018/05/2032694.html
