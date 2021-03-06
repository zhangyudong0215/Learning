# coding: utf-8
from requests_html import HTMLSession
from time import sleep
import os
import MySQLdb
import pandas as pd
from mylog import MyLog as mylog
from tqdm import tqdm

headers = {
    'user-agent':
    'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:54.0) Gecko/20100101 Firefox/54.0',
    'accept':
    'text/html, application/xhtml+xml, application/xml; q=0.9, image/webp, */*; q=0.8',
    'referer':
    'http://www.mzitu.com'
}
session = HTMLSession()
logger = mylog()


# 阿里云mysql
conn = MySQLdb.connect(
    host='39.108.157.74',
    port=3306,
    user='root',
    password='00genius00',
    database='mzitu',
    charset='utf8',
)

# # 本地mysql
# conn = MySQLdb.connect(
#     host='127.0.0.1',
#     port=3306,
#     user='root',
#     password='00genius00',
#     database='mzitu',
#     charset='utf8',
# )

cursor = conn.cursor()


def save_image(img_url, order, save_path):
    img_response = session.get(img_url, headers=headers)
    with open(os.path.join(save_path, '%d.jpg' % order), 'ab') as f:
        f.write(img_response.content)
    # sleep(0.3)


def download(pic_id, page_count, save_path):
    '''
    www.mzitu.com
    近期的写真集的图片链接有规律可循, 
    由此能够如下, 减少访问页面的一般的工作量.
    但是在爬虫的过程中发现早期部分(pic_id小于25500左右)的
    图集链接无规律, 调整代码没有难度但是无意义.
    所以就到此为止吧.
    '''
    logger.info('开始抓取图集 %s' % pic_id)
    base_url = 'http://www.mzitu.com/' + str(pic_id) + '/'
    res = session.get(base_url)
    first_img_url = res.html.xpath(
        '/html/body/div[2]/div[1]/div[3]/p/a/img/@src')[0]  # 秀一波xpath
    save_image(first_img_url, 1, save_path)

    index = 2
    while index <= page_count:
        if index < 10:
            img_url = first_img_url.replace('1.jpg', '%d.jpg' % index)
        else:
            img_url = first_img_url.replace('01.jpg', '%d.jpg' % index)
        if img_url == first_img_url:
            target_url = base_url + str(index)
            res = session.get(target_url)
            img_url = res.html.xpath(
                '/html/body/div[2]/div[1]/div[3]/p/a/img/@src')[0]
        save_image(img_url, index, save_path)
        index += 1

    cursor.execute('UPDATE photo_album SET crawled = 1 WHERE pic_id = %s' %
                   pic_id)  # 完成之后更新数据库
    conn.commit()
    logger.info('图集 %s 抓取完成' % pic_id)


def main_spider(title, pic_id, page_count, clicks, save_path):
    #     save_path = kwargs['save_path']
    if os.path.isdir(save_path):
        title = str(pic_id) + '_' + str(clicks) + '_' + title
        save_path = os.path.join(save_path, title)
        if not os.path.exists(save_path):
            os.mkdir(save_path)
            download(pic_id, page_count, save_path)


# query = "SELECT * FROM photo_album ORDER BY clicks DESC LIMIT 2558 OFFSET 1707"
query = '''
SELECT *
FROM mzitu.photo_album
WHERE crawled = 0
;
'''
data = pd.read_sql_query(query, conn)
data = pd.DataFrame(data)

for i in range(len(data)):
    title, pic_id, page_count, clicks = data.loc[
        i, ['title', 'pic_id', 'page_count', 'clicks']]
    main_spider(title, pic_id, page_count, clicks,
                '/home/ydzhang/spider_download/')
