# coding: utf-8

# MemTotal:       98954444 kB
# MemFree:         7207264 kB
# MemAvailable:    7728408 kB
# Buffers:           38772 kB
# Cached:           593300 kB
# SwapCached:       402376 kB
# Active:         83708512 kB
# Inactive:        6576620 kB
# Active(anon):   83478784 kB
# Inactive(anon):  6180268 kB
# Active(file):     229728 kB
# Inactive(file):   396352 kB
# Unevictable:           0 kB
# Mlocked:               0 kB
# SwapTotal:      100610044 kB
# SwapFree:       19740960 kB
# Dirty:                40 kB
# Writeback:             0 kB
# AnonPages:      89259056 kB
# Mapped:            59032 kB
# Shmem:              5968 kB
# Slab:             585048 kB
# SReclaimable:     456668 kB
# SUnreclaim:       128380 kB
# KernelStack:       22816 kB
# PageTables:       476492 kB
# NFS_Unstable:          0 kB
# Bounce:                0 kB
# WritebackTmp:          0 kB
# CommitLimit:    150087264 kB
# Committed_AS:   129484588 kB
# VmallocTotal:   34359738367 kB
# VmallocUsed:           0 kB
# VmallocChunk:          0 kB
# HardwareCorrupted:     0 kB
# AnonHugePages:  26757120 kB
# CmaTotal:              0 kB
# CmaFree:               0 kB
# HugePages_Total:       0
# HugePages_Free:        0
# HugePages_Rsvd:        0
# HugePages_Surp:        0
# Hugepagesize:       2048 kB
# DirectMap4k:      169632 kB
# DirectMap2M:    17606656 kB
# DirectMap1G:    84934656 kB

## os 监控内存
# import time


# def get_total_mem():
#     with open('/proc/meminfo') as f:
#         total = int(f.readline().split()[1])
#         free = int(f.readline().split()[1])
#         available = int(f.readline().split()[1])
#         buffers = int(f.readline().split()[1])
#         cache = int(f.readline().split()[1])
#     mem_use = total - free - buffers - cache
#     localtime = time.asctime( time.localtime(time.time()) )
#     print(localtime)
#     print('MEMORY Total: %.2fGB\tFree: %.2fGB %.1f%%\t \
#         Available: %.2fGB %.1f%%\tMEM_USE: %.2fGB %.1f%%' % 
#            (total/1048576, free/1048576, free/total*100, 
#             available/1048576, available/total, 
#             mem_use/1048576, mem_use/total))

# def main():
#     while True:
#         time.sleep(3)
#         get_total_mem()

## psutil 监控内存
import os
import time
import psutil
import argparse


class MemDetect():
    '''
    output the information of memory usage
    '''
    def __init__(self, pid=os.getpid(), period=5):
        self.pid = pid
        self.period = period

    def mem_detect(self):
        p = psutil.Process(self.pid)
        mem = psutil.virtual_memory()
        localtime = time.asctime(time.localtime(time.time()))
        print(localtime)
        print('Total: %.2fGB\tFree: %.2fGB %.2f%%\t \
            Available: %.2fGB %.2f%%\tMEM_USE: %.2fGB %.2f%%' % 
               (mem.total/1024**3, mem.free/1024**3, mem.free/mem.total*100, 
                mem.available/1024**3, mem.available/mem.total*100, 
                mem.used/1024**3, mem.used/mem.total*100))
        print("进程名称: %s\t内存占用百分比: %.2f%%" 
            %(p.name(), p.memory_percent()))

    def detect_main(self):
        while os.path.isfile('/proc/%s/stat' %str(self.pid)):
            mem_detect(int(self.pid))
            time.sleep(int(self.period))
        print("--------the process is over--------")

def mem_detect(pid):
    p = psutil.Process(pid)
    mem = psutil.virtual_memory()
    localtime = time.asctime(time.localtime(time.time()))
    print(localtime)
    print('Total: %.2fGB\tFree: %.2fGB %.2f%%\t \
        Available: %.2fGB %.2f%%\tMEM_USE: %.2fGB %.2f%%' % 
           (mem.total/1024**3, mem.free/1024**3, mem.free/mem.total*100, 
            mem.available/1024**3, mem.available/mem.total*100, 
            mem.used/1024**3, mem.used/mem.total*100))
    print("进程名称: %s\t内存占用百分比: %.2f%%" 
        %(p.name(), p.memory_percent()))

def detect_main(**kwargs):
    while os.path.isfile('/proc/%s/stat' %str(kwargs['pid'])):
        mem_detect(int(kwargs['pid']))
        time.sleep(int(kwargs['period']))
    print("--------the process is over--------")


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=\
            'detect the memory use of programme according to the pid')
    parser.add_argument('-p', '--pid', dest='pid', nargs='?', 
        default=os.getpid(), help='pid of the programme')
    parser.add_argument('-t', '--time', dest='period', nargs='?', 
        default=5, help='输出间隔时间')

    args = parser.parse_args()

    # how to use
    # $ python MemDetect.py (-p somepid) (-t timespan)

    kwargs = vars(args)
    detect_main(**kwargs)
