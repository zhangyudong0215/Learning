# -*- coding: utf-8 -*-
"""
Created on Wed Sep 20 11:18:48 2017

@author: 张煜东的台式工作机
"""

import requests
from bs4 import BeautifulSoup
from mylog import MyLog as mylog
from time import sleep
from pandas import DataFrame
from random import random


class MovieItem(object):
    title = None
    year = None
    score = None
    director = None
    script = None
    actor = None
    genre = None
    runtime = None


class GetMovie(object):
    '''获取电影信息 '''

    def __init__(self):
        self.urlBase = 'https://movie.douban.com/subject/26264454/'
        self.log = mylog()  # 自定义日志模块
        self.urls_all = urls_all  # [self.urlBase]
        self.urls_to_spider = urls_to_spider  # [self.urlBase]  # 未爬urls
        self.resturlsnum = len(self.urls_to_spider)
        self.items = []
        self.main()
        self.optimize()
        self.to_DataFrame()

    def getResponseContent(self, url):
        '''获取页面返回的数据 '''
        sleep(random() * 6)
        print('剩余%d个urls等待爬取' % self.resturlsnum)
        try:
            header = {
                'user-agent':
                'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:54.0) Gecko/20100101 Firefox/54.0',
                'accept':
                'text/html, application/xhtml+xml, application/xml; q=0.9, image/webp, */*; q=0.8'
            }
            response = requests.get(url, headers=header).content
            self.resturlsnum = self.resturlsnum - 1
        except:
            self.log.error('Python 返回URL:%s  数据失败' % url)
        else:
            self.log.info('Python 返回URUL:%s  数据成功' % url)
            return response

    def getNewUrls(self, soup):
        '''提取不重复推荐电影url'''
        #        htmlContent = self.getResponseContent(url)
        #        soup = BeautifulSoup(htmlContent, 'lxml')
        anchorTag = soup.find('div', attrs={'class': 'recommendations-bd'})
        if anchorTag:
            count = 0
            tags = anchorTag.find_all('dl')
            for tag in tags:
                url_new = tag.dd.a.get('href')
                if url_new not in self.urls_all:
                    self.urls_all.append(url_new)
                    self.urls_to_spider.append(url_new)
                    count = count + 1
            print('新增urls数量为：%d' % count)

    def spider(self, url):
        '''提取html信息'''
        # 提取网页信息
        item = MovieItem()
        htmlContent = self.getResponseContent(url)
        soup = BeautifulSoup(htmlContent, 'lxml')
        anchorTag = soup.find('div', attrs={'class': 'subjectwrap clearfix'})
        if anchorTag:  # 确认页面存在
            infoTag = anchorTag.find('div', attrs={'id': 'info'})
            tags = infoTag.find_all('span')
            tags_starring = infoTag.find_all('a', attrs={'rel': 'v:starring'})
            tags_genre = infoTag.find_all(
                'span', attrs={'property': 'v:genre'})
            # 电影名
            try:
                item.title = soup.find(
                    'span', attrs={
                        'property': 'v:itemreviewed'
                    }).get_text()
            except:
                item.runtime = None
            # 上映时间
            try:
                item.year = soup.find(
                    'span', attrs={
                        'class': 'year'
                    }).get_text()[1:-1]
            except:
                item.runtime = None
            # 豆瓣评分
            try:
                item.score = anchorTag.find(
                    'strong', attrs={
                        'class': 'll rating_num'
                    }).get_text()
            except:
                item.runtime = None
            # 导演
            try:
                item.director = tags[0].find('a').get_text()
            except:
                item.runtime = None
            # 编剧
            try:
                item.script = []
                [
                    item.script.append(i.get_text())
                    for i in tags[5].find_all('a')
                ]
            except:
                item.runtime = None
            # 主演
            try:
                item.actor = []
                [item.actor.append(i.get_text()) for i in tags_starring]
            except:
                item.runtime = None
            # 类型
            try:
                item.genre = []
                [item.genre.append(i.get_text()) for i in tags_genre]
            except:
                item.runtime = None
            # 片长
            try:
                item.runtime = anchorTag.find(
                    'span', attrs={
                        'property': 'v:runtime'
                    }).get_text()
            except:
                item.runtime = None

            # 储存信息
            self.items.append(item)
            self.log.info('获取电影名为：<<%s>>成功' % (item.title))

            # 获取推荐电影urls
            self.getNewUrls(soup)

    def main(self):
        while len(self.urls_all) < 20000:
            urls_num = len(self.urls_to_spider)
            for i in range(urls_num):
                url = self.urls_to_spider.pop(0)
                self.spider(url)
            if not len(self.urls_to_spider):
                break

    def optimize(self):
        for item in self.items:
            item.score = item.score
            item.script = ','.join(item.script)
            item.actor = ','.join(item.actor)
            item.genre = ','.join(item.genre)

    def to_DataFrame(self):
        title = []
        year = []
        score = []
        director = []
        script = []
        actor = []
        genre = []
        runtime = []

        for item in self.items:
            title.append(item.title)
            year.append(item.year)
            score.append(item.score)
            director.append(item.director)
            script.append(item.script)
            actor.append(item.actor)
            genre.append(item.genre)
            runtime.append(item.runtime)

        movie_table = DataFrame(
            {
                'title': title,
                'year': year,
                'score': score,
                'director': director,
                'script': script,
                'actor': actor,
                'genre': genre,
                'runtime': runtime
            },
            columns=[
                'title', 'year', 'score', 'director', 'script', 'actor',
                'genre', 'runtime'
            ])

        movie_table.to_csv('douban movie.csv')


def show(item):
    print('电影名: %s\n' % item.title, '上映年份: %s\n' % item.year,
          '豆瓣评分: %s\n' % item.score, '导演: %s\n' % item.director,
          '编剧: %s\n' % item.script, '主演: %s\n' % item.actor,
          '类型: %s\n' % item.genre, '片长: %s\n' % item.runtime)


if __name__ == '__main__':
    GDB = GetMovie()
    print('新增urls共%d个' % len(GDB.urls_to_spider))
