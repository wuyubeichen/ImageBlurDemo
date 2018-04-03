# ImageBlurDemo

此Demo主要测试了coreIamge、Accelerate、UIBlurEffect、UIToolBar几种常用的图片模糊的处理方式。


1. 使用CoreImage实现图片的高斯模糊
coreImage的API存在CoreImage.framework库中，Core Image都提供了大量的滤镜，在OS X上有120多种Filter，而在iOS上也有90多种。



2. 使用VImage实现图片的高斯模糊
使用vImage需要导入Accelerate下的Accelerate头文件。Accelerate主要是用来做数字信号处理、图像处理相关的向量、矩阵运算的库。图像可以认为是由向量或者矩阵数据构成的，Accelerate里既然提供了高效的数学运算API，自然就能方便我们对图像做各种各样的处理。模糊算法使用的是vImageBoxConvolve_ARGB8888这个函数。

3. 使用UIBlurEffect实现毛玻璃效果
只适用于iOS8.0以上



4. 使用UIToolbar实现图片模糊


测试demo截图：

<img src="https://github.com/DreamcoffeeZS/ImageBlurDemo/blob/master/Screenshots/tetBlurImage.png" width="375" height="667">

