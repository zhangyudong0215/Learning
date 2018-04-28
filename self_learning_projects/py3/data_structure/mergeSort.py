def mergeSort(alist):
    print("Splitting: ", alist)

    if len(alist) > 1:
        mid = len(alist) // 2
        lefthalf = alist[: mid] # 此处传递slice时间复杂度为O(k), 要真的实现O(nlogn)的复杂度，这里要改成传递索引
        righthalf = alist[mid: ]

        mergeSort(lefthalf)
        mergeSort(righthalf)

        i, j, k = 0, 0, 0
        while i < len(lefthalf) and j < len(righthalf):

            if lefthalf[i] < righthalf[j]:
                alist[k] = lefthalf[i]
                i += 1
            else:
                alist[k] = righthalf[j]
                j += 1
            
            k += 1
        
        while i < len(lefthalf):
            alist[k] = lefthalf[i]
            i += 1
            k += 1
        
        while j < len(righthalf):
            alist[k] = righthalf[j]
            j += 1
            k += 1

    print("merging: ", alist)

alist = [54, 26, 93, 17, 77, 31, 44, 55, 20]
mergeSort(alist)
print(alist)