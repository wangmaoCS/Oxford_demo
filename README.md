# Content-based Image Retrieval Demo with Oxford5k Dataset

## Environment
Centos 7.0 + Matlab + [Yael image retrieval library](https://gforge.inria.fr/frs/download.php/file/34218/yael_matlab_linux64_v438.tar.gz)

## Dataset
  !Please prepare the data file and set the right **data_dir** and **img_path** before running this code.
- image data: download the image file of [Oxford5k dataset](http://www.robots.ox.ac.uk/~vgg/data/oxbuildings/oxbuild_images.tgz)
- feature data: download the local feature(sift), visual word, codebook and geometric information data from [ICCV2013 data](ftp://ftp.irisa.fr/local/texmex/corpus/iccv2013/)(ftp://ftp.irisa.fr/local/texmex/corpus/iccv2013/)
  - gnd_oxford.mat: the groundtruth data for 55 queries, the file name of each image and the index of queries.
  - oxford_geom_sift.float: the geometric information (the shape parameter of ellipse region).
  - oxford_nsift.uint32: the size of SIFT feature for each image.
  - oxford_sift.uin8: the SIFT feature vector for each local feature extracted from images.
  - directory *clust_preprocessed/*
    - oxford_codebook.fvecs: the codebook for Oxford5k dataset
    - oxford_vw.int32: the visual word information for each SIFT feature (quantized by the codebook)
  
## Code
- wm_0_compute_threshold.m : computing the threshold in Hamming Embedding retrieval framework
- wm_1_build_ivf: building the inverted index file to store local features of database images
- wm_2_query: retrieving the inverted index for query images
- wm_3_display_matches: displaying the matched local features between query and database image
- wm_4_sv: based on the initial retrieval results from *wm_2_query*, refining the results by spatial verification



## 运行环境
Centos7.0 操作系统+Matlab+[Yael图像检索库](https://gforge.inria.fr/frs/download.php/file/34218/yael_matlab_linux64_v438.tar.gz)，其中Yael库需要加入到Matlab的路径中

## 数据集
在运行代码之前需要下载好数据文件并设置好自己的**data_dir** 和**img_path**
- 图像数据: 下载图片集[Oxford5k dataset](http://www.robots.ox.ac.uk/~vgg/data/oxbuildings/oxbuild_images.tgz)
- 特征数据: 下载Oxford5k的特征数据集[ICCV2013 data](ftp://ftp.irisa.fr/local/texmex/corpus/iccv2013/)(ftp://ftp.irisa.fr/local/texmex/corpus/iccv2013/)，由已有的论文[To aggregate or not to aggregate: Selective match kernels for image search](http://hal.inria.fr/docs/00/86/46/84/PDF/iccv13_tolias.pdf)提供，其中各个文件的解释如下：
  - gnd_oxford.mat: Oxford5k数据集的groundtruth文件，包含55个查询在数据库中的索引以及所有图片的文件名
  - oxford_geom_sift.float: 从图片上所提取到的局部特征的几何信息（中心点和形状参数矩阵），每个局部特征覆盖一个椭圆形区域
  - oxford_nsift.uint32: 每个图片上所提取到的局部特征数目
  - oxford_sift.uin8: 从图片集上提取到的所有局部特征的128维SIFT特征向量
  - 子目录 *clust_preprocessed/*
    - oxford_codebook.fvecs: 词汇表文件，用于进行特征量化
    - oxford_vw.int32: SIFT特征量化得到的视觉单词信息
  
## 代码
- wm_0_compute_threshold.m : 计算HE检索模型中的阈值
- wm_1_build_ivf: 使用所有数据库特征构建倒排索引文件
- wm_2_query: 从倒排索引文件中检索出查询的初始结果
- wm_3_display_matches: 展示查询与结果之间的局部区域匹配关系
- wm_4_sv: 基于初始结果，使用空间校验对*wm_2_query*得到的初始结果进行优化


## 结果
初始检索得到的结果如下（左边为查询，右边为第二个检索结果） ![oxford_initial_match](https://github.com/wangmaoCS/Oxford_demo/blob/master/q1_db2_matches.jpg)

经过空间校验之后的结果 ![oxford_sp_match](https://github.com/wangmaoCS/Oxford_demo/blob/master/q1_db2_matches_sv.jpg)