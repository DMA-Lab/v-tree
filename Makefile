all: vtree_build vtree_demo

# 原文件中使用的是 g++. 由于 g++ 编译产生的信息太多, 为了方便查看, 使用 clang++ 编译.
# 另外, libmetis.so 依赖于 -lGKlib, 因此需要在编译时指定.
vtree_build: vtree_build.cpp
	clang++ -O3 vtree_build.cpp -lmetis -lGKlib -o vtree_build
vtree_demo: vtree_knn_demo.cpp
	clang++ -O3 vtree_knn_demo.cpp -lmetis -lGKlib -o vtree_knn_demo
