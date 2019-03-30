import random


def print_name(func):
    def wrapper(*args):
        print("Running test for %s" % func.__name__)
        res = func(*args)
        return res
    return wrapper


# 快速排序
def quick_sort(arr):
    if len(arr) < 2:
        return arr
    mid = arr[0]
    left = [i for i in arr[1:] if i < mid]
    right = [i for i in arr[1:] if i >= mid]
    return quick_sort(left) + [mid] + quick_sort(right)


@print_name
def test_quick():
    test_l = list(range(20))
    random.shuffle(test_l)
    assert quick_sort(test_l) == sorted(test_l)


# 归并排序
def merge_list(list_a, list_b):
    len_a, len_b = len(list_a), len(list_b)
    a = b = 0
    list_c = []
    while a < len_a and b < len_b:
        if list_a[a] < list_b[b]:
            list_c.append(list_a[a])
            a += 1
        else:
            list_c.append(list_b[b])
            b += 1
    if a < len_a:
        list_c.extend(list_a[a:])
    if b < len_b:
        list_c.extend(list_b[b:])
    return list_c


def merge_sort(arr):
    if len(arr) == 1:
        return arr
    mid = len(arr) // 2
    arr_left = merge_sort(arr[:mid])
    arr_right = merge_sort(arr[mid:])
    return merge_list(arr_left, arr_right)


@print_name
def test_merge_sort():
    test_l = list(range(20))
    random.shuffle(test_l)
    assert merge_sort(test_l) == sorted(test_l)


# 堆排序
def push_down(heap, size, u):
    t = u
    left, right = u * 2 + 1, u * 2 + 2
    if left < size and heap[left] > heap[t]:
        t = left
    if right < size and heap[right] > heap[t]:
        t = right
    if t != u:
        heap[u], heap[t] = heap[t], heap[u]
        push_down(heap, size, t)


def push_up(heap, u):
    father = (u - 1) // 2
    while father and heap[father] < heap[u]:
        heap[u], heap[father] = heap[father], heap[u]
        u = (u - 1) // 2


def heap_sort(heap):
    for i in range(len(heap)):
        push_up(heap, i)
    for i in range(len(heap)):
        heap[0], heap[len(heap)-1] = heap[len(heap)-1], heap[0]
        heap.pop()
        push_down(heap, len(heap), i)


@print_name
def test_heap_sort():
    test_l = list(range(20))
    random.shuffle(test_l)
    heap_sort(test_l)
    assert test_l == sorted(test_l)


# 计数排序
# 计数排序不是基于比较的排序算法，其核心在于将输入的数据值转化为键存储在额外开辟的数组空间中。
# 作为一种线性时间复杂度的排序，计数排序要求输入的数据必须是有确定范围的整数
def counting_sort(arr):
    count = [0 for i in range(len(arr))]
    for i in arr:
        count[i] += 1
    ans = []
    for i in range(len(count)):
        ans.extend([i]*count[i])
    return ans


@print_name
def test_counting_sort():
    test_l = list(range(20))
    random.shuffle(test_l)
    assert counting_sort(test_l) == sorted(test_l)


# 桶排序是计数排序的升级版。
# 它利用了函数的映射关系，高效与否的关键就在于这个映射函数的确定。
# 桶排序 (Bucket sort)的工作的原理：
# 假设输入数据服从均匀分布，将数据分到有限数量的桶里，每个桶再分别排序
# （有可能再使用别的排序算法或是以递归方式继续使用桶排序进行排）

# 基数排序(特殊的桶排序)
# 基数排序是按照低位先排序，然后收集；再按照高位排序，然后再收集；依次类推，直到最高位。
# 有时候有些属性是有优先级顺序的，先按低优先级排序，再按高优先级排序。
# 最后的次序就是高优先级高的在前，高优先级相同的低优先级高的在前。
def get_dig(a, b):
    while b:
        a //= 10
        b -= 1
    return a % 10


def radix_sort(arr):
    cnt = [[] for i in range(10)]
    for i in range(3):
        for j in range(10):
            cnt[j].clear()
        for j in arr:
            cnt[get_dig(j, i)].append(j)
        k = 0
        for j in range(10):
            for x in cnt[j]:
                arr[k] = x
                k += 1
    return arr


@print_name
def test_radix_sort():
    test_l = list(range(20))
    random.shuffle(test_l)
    assert radix_sort(test_l) == sorted(test_l)
