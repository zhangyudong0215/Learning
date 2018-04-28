import requests_html
import scrapy
from bs4 import BeautifulSoup
from scrapy.http import Request
from novel_scrapy.items import NovelScrapyItem


session = requests_html.HTMLSession()


class Myspider(scrapy.Spider):
    name = 'novel_scrapy'
    allowed_domains = ['23us.so']
    url_head = 'http://www.23us.so/list/1_'
    url_tail = '.html'

    def start_requests(self):
        url = self.url_head + '1' + self.url_tail
        yield Request(url, self.parse)
        # yield session.get(url) # 没有self.parse的API
    
    def parse(self, response):
        max_num = BeautifulSoup(response.text, 'lxml').find('a', class_='last').get_text()
        for index in range(1, int(max_num)+1):
            url = self.url_head + str(index) + self.url_tail
            yield Request(url, self.get_name)
    
    def get_name(self, response):
        tds = BeautifulSoup(response.text, 'lxml').find_all('tr', bgcolor='#FFFFFF')
        for td in tds:
            novel_name = td.find('a').get_text() # 书名是第一个a节点
            novel_url = td.find('a')['href'] # 书的主页
            yield Request(novel_url, self.get_chapter_url, meta={'name': novel_name, 'url': novel_url})
    
    def get_chapter_url(self, response):
        tag1 = BeautifulSoup(response.text, 'lxml').find('table').find_all('td')
        author = tag1[1].get_text()
        status = tag1[2].get_text()
        word_count = tag1[4].get_text()
        update_time = tag1[5].get_text()

        item = NovelScrapyItem()
        item['title'] = response.meta['name']
        item['author'] = author
        item['status'] = status
        item['word_count'] = word_count
        item['update_time'] = update_time
        item['url'] = response.meta['url']
        
        return item
