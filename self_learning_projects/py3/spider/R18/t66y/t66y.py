from requests_html import HTMLSession
import regex
from functools import partial
from tqdm import tqdm, tgrange, tnrange
from bs4 import BeautifulSoup
import pickle
import time
from mylog import MyLog as mylog

logger = mylog()
htmlsession = HTMLSession()
headers = {
    'user-agent':
    'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:54.0) Gecko/20100101 Firefox/54.0',
    'accept':
    'text/html, application/xhtml+xml, application/xml; q=0.9, image/webp, */*; q=0.8',
    'referer':
    'http://t66y.com/index.php'
}
proxies = {
    'http': 'http://127.0.0.1:1080/',
    'https': 'http://127.0.0.1:1080/,
}
base_url = 'http://t66y.com/thread0806.php?fid=20'
pattern = 'http://t66y\.com/htm_data/20/\d+/\d+\.html'

get_response = partial(htmlsession.get, proxies=proxies, headers=headers)


def get_page_count(res):
    page_count = res.html.find(
        'a.w70', first=True).find(
            'input', first=True).attrs['value'].split('/')[-1]
    return int(page_count)


def get_page_urls(page_count):
    base_page_url = 'http://t66y.com/thread0806.php?fid=20&search=&page='
    page_urls = [base_page_url + str(i) for i in range(2, page_count + 1)]
    return page_urls


def get_novel_urls(res):
    novel_urls = [
        link for link in res.html.absolute_links if regex.match(pattern, link)
    ]
    return novel_urls


def get_first_page_details(res):
    text = ''
    tag = res.html.find('div[class="t t2"]')
    for element in tag:
        reply = element.find(
            'div[class="tpc_content do_not_catch"]', first=True).text
        if len(reply) > 100:
            text += reply + '\n'
    return text


def get_page_details(res):
    text = ''
    tag = res.html.find('div[class="t t2"]')
    for element in tag:
        reply = element.find('div[class="tpc_content"]', first=True).text
        if len(reply) > 100:
            text += reply + '\n'
    return text


def get_details(novel_url):
    novel_id = novel_url.split('/')[-1][:-5]
    res = get_response(novel_url)
    title = res.html.find(
        'input[class="input"]', first=True).attrs['value'].replace('Re:', '')
    page_count = get_page_count(res)

    logger.info('正在抓取 id: {novel_id} title: <<{title}>>'.format(
        novel_id=novel_id, title=title))

    text = get_first_page_details(res)
    base = 'http://t66y.com/read.php?tid={novel_id}&fpage=0&toread=&page='.format(
        novel_id=novel_id)
    for i in range(2, page_count + 1):
        page_url = base + str(i)
        res = get_response(page_url)
        text += get_page_details(res)
    logger.info('完成抓取 id: {novel_id} title: <<{title}>>'.format(
        novel_id=novel_id, title=title))
    return title, text


def save(title, text):
    with open('novels/{title}.txt'.format(title=title), 'w') as f:
        f.write(text)


def main():
    #     res = get_response(base_url)
    #     page_count = get_page_count(res)
    #     page_urls = get_page_urls(page_count)

    #     novel_urls = get_novel_url(res)
    #     for url in tqdm(page_urls):
    #         res = get_response(url)
    #         novel_urls.extend(get_novel_urls(res))
    # #             time.sleep(1)
    #     novel_urls = list(set(novel_urls))

    #     with open('novel_urls.txt', 'wb') as f:
    #         pickle.dump(novel_urls, f)

    with open('novel_urls.txt', 'rb') as f:
        novel_urls = pickle.load(f)

    for novel_url in tqdm(novel_urls):
        try:
            title, text = get_details(novel_url)
            save(title, text)
        except:
            logger.error(novel_url)
            pass


if __name__ == '__main__':
    main()
