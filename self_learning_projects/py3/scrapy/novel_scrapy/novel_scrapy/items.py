# -*- coding: utf-8 -*-

# Define here the models for your scraped items
#
# See documentation in:
# http://doc.scrapy.org/en/latest/topics/items.html

import scrapy


class NovelScrapyItem(scrapy.Item):
    # define the fields for your item here like:
    # name = scrapy.Field()
    title = scrapy.Field()
    latest_chapter = scrapy.Field()
    auther = scrapy.Field()
    word_count = scrapy.Field()
    update_time = scrapy.Field()
    status = scrapy.Field()
