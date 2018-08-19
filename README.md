# Learning
Self-Learning projects

## [20180130]Py3 and Golang recently
## [20180421]Add a spider
## [20180427]finish the first scrapy project
熟悉scrapy框架, 主要通过修改spider和item完成爬虫.
## [20180501]start learning mysql
成功导入scrapy抓取的[顶点小说](http://www.23us.so/)数据, 解决mysql中文乱码问题, 记录在CSDN博客中.
## [20180505]学习了mysql, mongodb, redis基础以及一些python操作 
学习了三个数据库的增删改查和ORM, ODM的一些操作; 安装了几个全平台的可视化工具
## 爬[某网站](3w.mzitu.com在README中记录网址)图片的时候遇到了防盗链
这种反爬措施的基本思路似乎是检查上一个访问的url, 应对方法是在`headers`中添加`referer`(key), 设置一个恰当的`url`(value)即可.
另外就是requests-html包可以完全替代requests包, 剩下的问题就是scrapy的Request返回的结果能否用requests-html包进行解析. 虽然用xpath看起来也不错, 可还是比不上absolute_links带来的便利. 
2018-5-8 22:25:00 基本完成爬虫主体, 准备存入Mysql或MongoDB. 
## [20180819]将mzitu爬虫数据库从本地转移到阿里云服务器
## [20180819]最近Julia 1.0.0发布了, 了解一下
