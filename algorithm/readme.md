> 暂时写一些，以后慢慢加

## 图论

### 最短路

n 为点数，m 为边数

* 单源头
    - 边权都是正数
        + 朴素 Dijkstra O(n^2)
        + 堆优化版的 Dijkstra O(mlogn)
    - 存在负权边
        + Bellman-Ford O(nm) (有边数限制)
        + SPFA 一般 O(m)，最坏 O(nm)
* 多源头
    - Floyd O(n^3)
