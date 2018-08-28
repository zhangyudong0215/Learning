# -*- coding: utf-8 -*-
from requests_html import HTMLSession
import regex as re
import time
from mylog import MyLog as mylog
import pymysql
from tqdm import tqdm


SUCCESSES = 0
ERRORS = 0
headers = {
    'user-agent':
    'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:54.0) Gecko/20100101 Firefox/54.0',
    'accept':
    'text/html, application/xhtml+xml, application/xml; q=0.9, image/webp, */*; q=0.8',
    'referer':
    'http://bbs.nju.edu.cn/g/JobExpress'
}
pattern_index = re.compile('bbscon\?board=JobExpress&file=M\.(\d+)\.A&num=\d+')
keep_going = True
count_articles = 99999999
count_crawled = 0
url_articles = []
logger = mylog()


def update_url_articles(res):
    global count_articles
    global keep_going
    global pattern_index
    for link in res.html.links:
        if link.startswith('bbscon?board=JobExpress&file=M.'):
            index = int(pattern_index.match(link).group(1))
            if index > count_crawled:
                count_articles = index if count_articles > index else count_articles
                url_articles.append((str(index), 'http://bbs.nju.edu.cn/'+link))
            else:
                keep_going = False

def insert(cursor, db, index, url):
    global SUCCESSES, ERRORS
    sql_query = "INSERT IGNORE INTO links VALUES ('%s', '%s')" %(str(index), url)
    try:
        cursor.execute(sql_query)
        db.commit()
        logger.info('成功: 插入id为: %s 的招聘信息' %str(index))
        SUCCESSES += 1
    except:
        db.rollback()
        logger.error('失败: 插入id为: %s 的招聘信息' %str(index))
        ERRORS += 1

def main():
    global pattern_index
    global keep_going
    global count_articles
    global count_crawled
    global url_articles
    global logger

    htmlsession = HTMLSession()
    start_url = 'http://bbs.nju.edu.cn/bbsdoc?board=JobExpress'
    db = pymysql.connect("39.108.157.74","root","00genius00","JobExpress" )
    cursor = db.cursor()
    cursor.execute("SELECT MAX(id) FROM links")
    count_crawled = cursor.fetchone()[0]
    res = htmlsession.get(start_url, headers=headers)
    update_url_articles(res)

    while keep_going:
        count_articles = count_articles-20 if count_articles>=20 else 0
        target_url = 'http://bbs.nju.edu.cn/bbsdoc?board=JobExpress&start=%s&type=doc' %str(count_articles)
        res = htmlsession.get(target_url, headers=headers)
        update_url_articles(res)
        time.sleep(0.5)

    for item in tqdm(url_articles):
        insert(cursor, db, item[0], item[1])

    logger.info('成功: %d, 失败: %d' %(SUCCESSES, ERRORS))


if __name__ == '__main__':
    main()
