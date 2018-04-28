def quickSort(alist):
    quickSortHelper(alist, 0, len(alist)-1)

def quickSortHelper(alist, first, last):
    if first < last:

        splitpoint = partition(alist, first, last)

        quickSortHelper(alist, first, splitpoint-1)
        quickSortHelper(alist, splitpoint+1, last)

def partition(alist, first, last): # python是引用传递，其他语言要用指针来传递
    pivotvalue = alist[first] # 如果要使用中值三方法，则只需找到中值然后和first交换，然后继续执行原来的代码就行（目前的思路，需要验证）

    leftmark = first + 1
    rightmark = last

    done = False

    while not done:

        while leftmark <= rightmark and alist[leftmark] <= pivotvalue:
            leftmark += 1
        while rightmark >= leftmark and alist[rightmark] >= pivotvalue:
            rightmark -= 1
        
        if rightmark < leftmark:
            done = True
        else:
            alist[rightmark], alist[leftmark] = alist[leftmark], alist[rightmark]
        
    alist[first], alist[rightmark] = alist[rightmark], alist[first]

    return rightmark


alist = [54, 26, 93, 17, 77, 31, 44, 55, 20]
quickSort(alist)
print(alist)