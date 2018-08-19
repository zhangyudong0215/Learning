from requests_html import HTMLSession
import regex as re
import string
from mylog import MyLog as mylog
import sqlalchemy
from sqlalchemy import Column, String, Integer, DateTime
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

ERRORS = 0

logger = mylog()
htmlsession = HTMLSession()
pattern = re.compile('http:\/\/www\.mzitu\.com\/\d{1,6}')
start_url = 'http://www.mzitu.com/all/'

# # 阿里云mysql
# engine = create_engine(
#     'mysql://root:00genius00@39.108.157.74:3306/mzitu?charset=utf8'
# )

# 本地数据库
engine = create_engine(
    'mysql://root:00genius00@localhost:3306/mzitu?charset=utf8'
)  # 这里一定要主动加上编码

Session = sessionmaker(bind=engine)
session = Session()
Base = declarative_base()


class Album(Base):
    ''' 写真集类型 '''
    __tablename__ = 'photo_album'
    pic_id = Column(Integer, primary_key=True)
    title = Column(String(200))
    category_tag = Column(String(100))
    upload_time = Column(DateTime)
    clicks = Column(Integer)
    labels = Column(String(200))
    page_count = Column(Integer)
    crawled = Column(Integer)


Album.metadata.create_all(engine)


def get_details(res):
    # 唯一标识 id
    url = res.url
    pic_id = int(url.split('/')[-1])
    # 标题
    title = res.html.find('h2.main-title', first=True).text
    tag = res.html.find('div.main-meta', first=True).find('span')
    # 分类标签
    category_tag = tag[0].find('a')[0].text
    # 上传时间
    upload_time = ':'.join([tag[1].text.replace('发布于', '').strip(),
                            '00'])  # 末尾添加':00'匹配mongodb时间格式
    # 浏览次数
    clicks = int(''.join([i for i in tag[2].text if i in string.digits]))
    tag = res.html.find('div.main-tags', first=True).find('a')
    # 相关专题
    labels = ','.join([i.text for i in tag])
    # 图片数量
    page_count = int(
        res.html.find('div.pagenavi', first=True).find('a')[-2].text)
    return pic_id, title, category_tag, upload_time, clicks, labels, page_count


def insert(res):
    ''' 插入数据 '''
    new_obj = Album(
        pic_id=res[0],
        title=res[1],
        category_tag=res[2],
        upload_time=res[3],
        clicks=res[4],
        labels=res[5],
        page_count=res[6],
        crawled=0,
    )
    session.add(new_obj)
    session.commit()


def update(link):
    global ERRORS
    session = Session()
    pic_id = int(link.split('/')[-1])
    if not session.query(Album).filter_by(pic_id=pic_id).first():
        res = htmlsession.get(link)
        try:
            res = get_details(res)
            insert(res)
            logger.info('新增图集 %s 写入数据库' % pic_id)
        except:
            ERRORS += 1
            logger.error('新增图集 %s 失败' % pic_id)
    session.close()


def main():
    response = htmlsession.get(start_url)
    urls = response.html.absolute_links
    album_links = [url for url in urls if pattern.match(url)]
    _ = list(map(update, album_links))
    logger.info('发生错误数 %d' % ERRORS)


if __name__ == '__main__':
    main()
