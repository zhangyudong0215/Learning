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
        for i in range(1, 281):
            url = self.url_head + str(i) + self.url_tail
            yield Request(url, self.parse)
    
    def parse(self, response):
        print(response.text)
