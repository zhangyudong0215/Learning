# coding: utf-8

from requests_html import HTMLSession
import requests
import regex as re
import functools
import argparse
import os

session = HTMLSession()


def get_info(url, responses, pattern):
    response = session.get(url)
    responses.append(response)
    title = response.html.find('h1.entry-title', first=True).text
    pages = []
    for item in response.html.absolute_links:
        res = pattern.match(item)
        if res:
            pages.append(res.group(1))
    return max(map(int, pages)), title


def get_page_imgs(response):
    imgs = []
    content = response.html.find('div.entry-content', first=True)
    pics = content.find('p')
    for pic in pics:
        try:
            imgs.append(pic.find('img', first=True).attrs['src'])
        except:
            pass
    return imgs


def merge(list1, list2):
    list1.extend(list2)
    return list1


def save_image(img_url, order, save_path):
    img_response = requests.get(img_url)
    with open(os.path.join(save_path, '%d.jpg' % order), 'ab') as f:
        f.write(img_response.content)


def download(imgs, save_path):
    for index, img_url in enumerate(imgs):
        save_image(img_url, index + 1, save_path)


def main(**kwargs):
    url = kwargs['url']
    pattern = re.compile(url + r'/(\d+)')

    responses = []

    max_page, title = get_info(url, responses, pattern)

    save_path = kwargs['save_path']
    if os.path.isdir(save_path):
        save_path = os.path.join(save_path, title)
        os.mkdir(save_path)

    for index in range(2, max_page + 1):
        responses.append(session.get(url + '/' + str(index)))

    imgs = functools.reduce(merge, map(get_page_imgs, responses))

    download(imgs, save_path)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='download some R18 comics')
    parser.add_argument(
        '-u', '--url', dest='url', nargs='?', default='', help='fixed links')
    parser.add_argument(
        '-s',
        '--save_path',
        dest='save_path',
        nargs='?',
        default='E:/ZYD/spider/177test/',
        help='储存地址')

    args = parser.parse_args()

    kwargs = vars(args)
    main(**kwargs)

# python E:/ZYD/Github/Learning/self_learning_projects/py3/spider/R18/177spider.py -u url -s E:/ZYD/spider
