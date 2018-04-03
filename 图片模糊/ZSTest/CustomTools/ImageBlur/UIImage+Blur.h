//
//  UIImage+Blur.h
//  ZSTest
//
//  Created by zhoushuai on 16/5/11.
//  Copyright © 2016年 zhoushuai. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Accelerate/Accelerate.h>


@interface UIImage (Blur)

//MARK: - 使用CoreImage实现图片的高斯模糊
//1.coreImage的API存在CoreImage.framework库中。
//2.Core Image都提供了大量的滤镜（Filter），在OS X上有120多种Filter，而在iOS上也有90多。
/**
 *  使用CoreImage实现图片的高斯模糊
 *
 *  @param image 原始图片
 *  @param blur  模糊程度,默认为50,取值范围(0-100)
 *
 *  @return 默认使用高斯模糊的滤镜，返回经过模糊的图片
 */

+(UIImage *)getCoreBlurImage:(UIImage *)image
           blurNumber:(CGFloat)blur;

/**
 使用CoreImage实现图片的模糊

 @param image 原始图片对象
 @param filterName 模糊类型，默认使用高斯模糊的滤镜
 @param blur 模糊程度,默认为50,取值范围(0-100)
 @return 返回经过模糊的图片
 */
+(UIImage *)getCoreBlurImage:(UIImage *)image
           filterName:(NSString *)filterName
           blurNumber:(CGFloat)blur;



//MARK: - 使用VImage实现图片的高斯模糊
//1.使用vImage需要导入Accelerate下的Accelerate头文件。
//2.Accelerate主要是用来做数字信号处理、图像处理相关的向量、矩阵运算的库。
//3.图像可以认为是由向量或者矩阵数据构成的，Accelerate里既然提供了高效的数学运算API，自然就能方便我们对图像做各种各样的处理。
//4.模糊算法使用的是vImageBoxConvolve_ARGB8888这个函数。

/**
 *  vImage模糊图片
 *
 *  @param image 原始图片
 *  @param blur  模糊数值(0-1)
 *
 *  @return 重新绘制的新图片
 */
+ (UIImage *)getVImgBlurImage:(UIImage *)image withBlurLevel:(CGFloat)blur;



//MARK: - 使用UIBlurEffect实现毛玻璃效果
//只适用于iOS8.0以上
/**
 使用UIBlurEffect实现毛玻璃效果
 
 @param imgview 需要显示效果的视图
 */
+ (void)addBlurEffectToView:(UIView *)imgview;


/**
 使用UIBlurEffect实现毛玻璃效果

 @param imgview 需要显示效果的视图
 @param frame 显示的效果的区域
 @param alpha 透明度
 @param style 效果类型UIBlurEffectStyle
 */
+ (void)addBlurEffectToView:(UIView *)imgview
                      frame:(CGRect)frame
                      style:(UIBlurEffectStyle)style
                      alpha:(CGFloat)alpha;


//MARK: - 使用UIToolbar实现图片模糊
+ (void)addToolbarBlurToView:(UIView *)imgView;

+ (void)addToolbarBlurToView:(UIView *)imgView alpha:(CGFloat)alpha;

@end
