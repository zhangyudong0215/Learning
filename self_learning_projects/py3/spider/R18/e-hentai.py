# coding: utf-8
from requests_html import HTMLSession
import requests
from bs4 import BeautifulSoup
import time
import regex as re
from functools import partial, reduce
import requests
import argparse
import os

session = HTMLSession()
period = 5
proxies = { 
    "http": "http://127.0.0.1:1080", 
    "https": "https://127.0.0.1:1080", 
}   

def get_html(url):
    time.sleep(period)
    return session.get(url, proxies=proxies)

def get_title(url, proxies):
    response = requests.get(url, proxies=proxies).text
    time.sleep(period)
    soup = BeautifulSoup(response, 'lxml')
    return soup.find('h1', attrs={'id': 'gj'}).text

def get_page_urls(res):
    pattern_page = re.compile('\?p=\d+$')
    return [url for url in res.html.absolute_links if pattern_page.search(url)]

def get_all_html(page_urls, responses):
    responses.extend(list(map(get_html, page_urls)))

def get_page_img_urls(res, imgs_urls, pattern_imgs):
    curPageImgsUrl = [url for url in res.html.absolute_links if pattern_imgs.search(url)]
    imgs_urls.extend(curPageImgsUrl)

def get_tail(url):
    return int(url.split('-')[-1])

def get_img_urls(responses):
    pattern_imgs = re.compile('-\d+$')
    imgs_urls = []
    for res in responses:
        get_page_img_urls(res, imgs_urls, pattern_imgs)
    imgs_urls.sort(key=get_tail)
    return imgs_urls

def save_image(img_url, order, save_path, proxies):
    response = requests.get(img_url, proxies=proxies).text
    time.sleep(period)
    soup = BeautifulSoup(response, 'lxml')
    img_url = soup.find('img', attrs={'id': 'img'})['src']
    img_response = requests.get(img_url, proxies=proxies)
    time.sleep(period)
    with open(os.path.join(save_path, '%d.jpg' %order), 'ab') as f:
        f.write(img_response.content)

def download(imgs_urls, save_path, proxies):
    length = len(imgs_urls)
    for index, img_url in enumerate(imgs_urls):
        save_image(img_url, index+1, save_path, proxies)
        print('已完成: %d/%d' %(index+1, length))

def main(**kwargs):
    url = kwargs['url']

    responses = []
    res = get_html(url)
    responses.append(res)

    title = get_title(url, proxies)
    save_path = kwargs['save_path']
    save_path = os.path.join(save_path, title)
    if not os.path.isdir(save_path):
        os.mkdir(save_path)

    page_urls = get_page_urls(res)
    get_all_html(page_urls, responses)
    imgs_urls = get_img_urls(responses)
    download(imgs_urls, save_path, proxies)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=\
            'download some R18 comics from e-hentai.org')
    parser.add_argument('-u', '--url', dest='url', nargs='?', 
        default='', help='fixed links')
    parser.add_argument('-s', '--save_path', dest='save_path', nargs='?', 
        default='E:/ZYD/spider/e_hentai_test/', help='储存地址')

    args = parser.parse_args()

    kwargs = vars(args)
    main(**kwargs)

# python E:/ZYD/Github/Learning/self_learning_projects/py3/spider/R18/e-hentai.py -u url -s E:/ZYD/spider
