# -*- coding: utf-8 -*-
"""
Created on Wed Sep 20 10:31:06 2017

@author: matlab2017a
"""

import logging
import getpass
import sys


# 定义MyLog类
class MyLog(object):
    # 类MyLog的构造函数
    def __init__(self):
        self.user = getpass.getuser()
        self.logger = logging.getLogger(self.user)
        self.logger.setLevel(logging.DEBUG)

        # 日志文件名
        self.logFile = sys.argv[0][0:-3] + '.log'
        self.formatter = logging.Formatter(
            '%(asctime)-12s %(levelname)-8s %(name)-10s %(message)-12s\r\n')

        # 日志显示到屏幕上并输出到日志文件内
        self.logHand = logging.FileHandler(self.logFile, encoding='utf8')
        self.logHand.setFormatter(self.formatter)
        self.logHand.setLevel(logging.DEBUG)

        self.logHandSt = logging.StreamHandler()
        self.logHandSt.setFormatter(self.formatter)
        self.logHandSt.setLevel(logging.DEBUG)

        if not self.logger.handlers:  # 避免重复添加handler导致的重复输出问题
            self.logger.addHandler(self.logHand)
            self.logger.addHandler(self.logHandSt)

    # 日志的5个级别对应以下的5个函数
    def debug(self, msg):
        self.logger.debug(msg)

    def info(self, msg):
        self.logger.info(msg)

    def warning(self, msg):
        self.logger.warning(msg)

    def error(self, msg):
        self.logger.error(msg)

    def critical(self, msg):
        self.logger.critical(msg)

if __name__ == '__main__':
    mylog = MyLog()
    mylog.debug("I'm debug 测试中文")
    mylog.info("I'm info")
    mylog.warning("I'm warn")
    mylog.error("I'm error 测试中文")
    mylog.critical("I'm critical")
