# V-Tree: Efficient kNN Search on Moving Objects with Road-Network Constraints

This project consists of an implementation of V-Tree, which is designed to support kNN search on moving objects with
road-network constraints.

## 安装指南

笔者在此记录一下使用 V-Tree 代码中的问题，以便日后参考。当前系统环境为 Archlinux (2024/6/20)，偏好使用 clang 进行编译。

1. 首先安装依赖 [METIS](https://github.com/DMA-Lab/METIS)，而 METIS 又依赖于 [GKlib](https://github.com/KarypisLab/GKlib)
   ，因此需要参考它们的 README 操作。需要注意，这两个程序默认的安装位置是 `~/local`，该路径并不是一个常见的安装路径，建议在安装时使用：
   ```shell
   $ make config shared=1 prefix=/usr/local
   $ make
   $ sudo make install 
   ```
   对 `/usr/local` 的读写需要管理员权限。

2. 按照 [@TsinghuaDatabaseGroup ](https://github.com/TsinghuaDatabaseGroup) 给出的使用方式，编译：

    ```shell
   $ make
   ```

   这份 fork 中对 makefile 进行了适当地修改。由于 `libmetis.so` 依赖 GKlib，因此需要在编译时指定 `-lGKlib`
   。链接器将链接 `/usr/local/lib/libGKlib.a`。
   修改后的编译命令指令如下：
    ```shell
    $ clang++ -O3 vtree_build.cpp -lmetis -lGKlib -o vtree_build
    $ clang++ -O3 vtree_knn_demo.cpp -lmetis -lGKlib -o vtree_knn_demo
    ```
   按照编译器的规则，依赖库（`-lGKlib`）需要放在更后面。

## 使用方式

构建vtree索引。

```shell
$ ./vtree_build ./input_edge_file ./output_file
```

使用 `./vtree_build` 程序，输入边文件路径 `./input_edge_file`，输出文件路径 `./output_file` 来构建 VTree 索引。

加载VTree并运行KNN测试。

```shell
./vtree_knn_demo ./VTree_file $K(int) $car_percent(int) $change_percent(int) $query_per_update
```

使用`./vtree_knn_demo` 程序，输入VTree文件路径`./VTree_file`，及以下参数：

- `K(int)`：表示K邻域的数量。
- `car_percent(int)`：表示道路网络中运行车辆的数量。
- `change_percent(int)`：表示每次查询之间车辆改变到其他顶点的百分比。
- `query_per_update`：表示两次更新之间的查询数量。

代码中包含了一些注释。

## 示例

这是原仓库给出的示例，不知道为什么运行后报错。

```shell
$ ./vtree_build NW.vedge NW.vtree
$ ./vtree_knn_demo NW.vtree 10 0.01 0.002 6
```

## 输入文件格式

The edge file is consist of two pars. First line is the overall information of the
 graph. The other line is the detail edge information.
    

    1089933 2545844    //The first line of the input file shows the number of vertices and edges.
    1 2 1157            //The first row is the origin, the second row is destination, the third row is the weight of the edge.
    1 6 5413
    2 1 1157
    2 3 2394
    2 7 3857
    ...

The VTree input is directed graph. If an undirected graph is used, it also supports that.
!The parameter RevE needs to be true when the undirected graph is used.
!If the number of graph is not 
In our code, we did not assert the input graph is connected graph
But connected graph must be guaranteed before METIS partition the graph
Hence, it is suggested you have to pre-process the input road network for your own dataset

## [Some useful parameter of the source code]
-----
Partition_Part       // the fanout of the vtree

Naive_Split_Limit    // the max number of the leaf node, which is τ+1 in the article.

NWFIX                // if the number of edge starts from 0 Set `NWFIX = true`, otherwise set it to false.

-----

For better understanding of our code, we provide example(Northwest USA Road Network dataset)
File use: (Note the file input format)
        NW.vedge (graph edge file)
simple run is run 

    bash run_demo.sh

## Licence

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

