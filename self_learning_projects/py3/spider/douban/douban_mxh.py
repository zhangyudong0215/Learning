uban# -*- coding: utf-8 -*-
"""
Created on Sun Sep 24 20:24:07 2017

@author: 张煜东的台式工作机
"""


import re
import requests
import bs4
import pandas as pd

from bs4 import BeautifulSoup
from collections import namedtuple


class movie:
    def __init__(self, params):
        assert isinstance(params, dict)
        self.cover = params.get('cover')
        self.id = params.get('id')
        self.is_new = params.get('is_new')
        self.playable = params.get('playable')
        self.rate = params.get('rate')
        self.title = params.get('title')
        self.url = params.get('url')
    @property
    def show(self):
        print('title : %s' % (self.title))
        print('rate : %s' % (self.rate))
        print('id : %s' % (self.id))
    def check_url(self):
        url_pattern = re.compile(r'''\b((ftp|https?)://[-\w]+(\.\w[-\w]*)+|(?i:[a-z0-9](?:[-a-z0-9]*[a-z0-9])?\.)+(?-i:com\b|edu\b|biz\b|gov\b|in(?:t|fo)\b|mil\b|net\b|org\b|[a-z][a-z]\b))(:\d+)?(/[^.!,?;"'<>()\[\]{}\s\x7F-\xFF]*(?:[.!,?]+[^.!,?;"'<>()\[\]{}\s\x7F-\xFF]+)*)?''')
        return url_pattern.match(self.url)
    def get_detail(self):
        assert self.check_url(), 'Wrong url format : {}'.format(self.url)
        headers = {'user-agent': 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:54.0) Gecko/20100101 Firefox/54.0',
                   'accept': 'text/html, application/xhtml+xml, application/xml; q=0.9, image/webp, */*; q=0.8'}
        response = requests.get(self.url, headers=headers)
        self.detail = response.text
    @property
    def show_detail(self):
        print(self.detail)
    def extract_movie(self):
        home_url = 'https://movie.douban.com'
        movie_pattern = re.compile('/subject/[0-9]+?/')
        movie_index = movie_pattern.findall(self.detail)
        self.movies_url = [home_url + x for x in movie_index]
        return self.movies_url

class movie_detail:
    def __init__(self, url):
        self.soup = self.get_movie_detail(url)
        assert isinstance(self.soup, bs4.BeautifulSoup)
        people_info = self.soup.find_all('div', attrs={'id':'info'})[0]

        # 标题
        try:
            self.title = self.soup.title.string.strip()
        except:
            self.title = 'none'

        # 导演
        try:
            director_temp = people_info.find_all('a', attrs={'rel':'v:directedBy'})[0]
            director_name = director_temp.string
            director_url = self.wrap_url(director_temp['href'])
            self.director = {director_name:director_url}
        except:
            self.director = {'none':'none'}

        # 编剧
        try:
            pattern_composer = re.compile('''<a href="(/celebrity/[0-9]+?/)">(.+?)</a>''')
            composer_temp = pattern_composer.findall(str(people_info))
            self.composer = {}
            for (x, y) in composer_temp:
                self.composer[y] = self.wrap_url(x)
        except:
            self.composer = {'none':'none'}

        # 主演
        try:
            actors_temp = people_info.find_all('a', attrs={'rel':'v:starring'})
            self.actors = {}
            for actor in actors_temp:
                name = actor.string
                url = actor['href']
                self.actors[name] = self.wrap_url(url)
        except:
            self.actors = {'none':'none'}

        # 电影类型
        try:
            movie_class_temp = people_info.find_all('span', attrs={'property':'v:genre'})
            self.movie_class = ','.join([x.string for x in movie_class_temp])
        except:
            self.movie_class = 'none'

        # 制片国家/地区
        try:
            pattern_place = re.compile('<span class="pl">制片国家/地区:</span>(.+?)<br/>')
            self.place = pattern_place.findall(str(people_info))[0].strip()
        except:
            self.place = 'none'

        # 语言
        try:
            pattern_language = re.compile('<span class="pl">语言:</span>(.+?)<br/>')
            self.language = pattern_language.findall(str(people_info))[0].strip()
        except:
            self.language = 'none'

        # 上映时间
        try:
            self.time = people_info.find_all('span', attrs={'property':'v:initialReleaseDate'})[0].string.strip()
        except:
            self.time = 'none'

        # 片长
        try:
            self.length = people_info.find_all('span', attrs={'property':'v:runtime'})[0].string.strip()
        except:
            self.length = 'none'

        # 别名
        try:
            pattern_alias = re.compile('<span class="pl">又名:</span>(.+?)<br/>')
            self.alias = pattern_alias.findall(str(people_info))[0].strip()
        except:
            self.alias = 'none'

        # imdb链接
        try:
            self.IMDB_url = people_info.find_all('a', attrs={'rel':'nofollow'})[0]['href']
        except:
            self.IMDB_url = 'none'
    
    def get_movie_detail(self, url):
        headers = {'user-agent': 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:54.0) Gecko/20100101 Firefox/54.0'}
        response = requests.get(url, headers=headers)
        soup = BeautifulSoup(response.text, 'lxml')
        return soup
    
    def wrap_url(self, url):
        return 'https://movie.douban.com' + url

    @property
    def get_title(self):
        return self.title
    
    @property
    def get_director(self):
        return ','.join(self.director.keys())
    
    @property
    def get_composer(self):
        return ','.join(self.composer.keys())
    
    @property
    def get_actors(self):
        return ','.join(self.actors.keys())
    
    @property
    def get_movie_class(self):
        return self.movie_class
    
    @property
    def get_place(self):
        return self.place
    
    @property
    def get_language(self):
        return self.language
    
    @property
    def get_time(self):
        return self.time
    
    @property
    def get_length(self):
        return self.length
    
    @property
    def get_alias(self):
        return self.alias
    
    @property
    def get_IMDB(self):
        return self.IMDB_url
    
    @property
    def show(self):
        print('title : %s' % self.title)
        print('alias : %s' % self.alias)
        print('director : %s' % list(self.director.keys())[0])
        print('language : %s' % self.language)


url = 'https://movie.douban.com/subject/26270502/'
# a = movie_detail(movie_urls[0])
# print(a.title)
# print(a.director)
# print(a.composer)
# print(a.actors)
# print(a.movie_class)
# print(a.place)
# print(a.language)
# print(a.time)
# print(a.length)
# print(a.alias)
# print(a.IMDB_url)
# a.get_actors
# ', '.join(a.actors.keys())

movie_urls = ['https://movie.douban.com/subject/26270502/',
              'https://movie.douban.com/subject/26828215/',
              'https://movie.douban.com/subject/26709254/']

list_index = []
list_title = []
list_director = []
list_composer = []
list_actors = []
list_movie_class = []
list_place = []
list_language = []
list_time = []
list_length = []
list_alias = []
list_IMDBurl = []
index_pattern = re.compile('https://movie.douban.com/subject/([0-9]+?)/')


for step, url in enumerate(movie_urls):
    movie_index = index_pattern.findall(url)
    list_index.append(movie_index)
    movie_data = movie_detail(url)
    list_title.append(movie_data.get_title)
    list_director.append(movie_data.get_director)
    list_composer.append(movie_data.get_composer)
    list_actors.append(movie_data.get_actors)
    list_movie_class.append(movie_data.get_movie_class)
    list_place.append(movie_data.get_place)
    list_language.append(movie_data.get_language)
    list_time.append(movie_data.get_time)
    list_length.append(movie_data.get_length)
    list_alias.append(movie_data.get_alias)
    list_IMDBurl.append(movie_data.get_IMDB)
    if (step+1) % 10==0:
        print('Current step : %d, fetch movie: %s' % (step, movie_data.title))

result_table = pd.DataFrame({
        'id': list_index,
        'title': list_title,
        'director': list_director,
        'composer': list_composer,
        'actors': list_actors,
        'movie_class': list_movie_class,
        'place': list_place,
        'language': list_language,
        'time': list_time,
        'length': list_length,
        'alias': list_alias,
        'IMDB': list_IMDBurl}, columns = ['id', 'title', 'alias', 'director', 'composer', 
                                       'actors', 'movie_class', 'place', 'language', 'time', 
                                       'length', 'IMDB'])

result_table