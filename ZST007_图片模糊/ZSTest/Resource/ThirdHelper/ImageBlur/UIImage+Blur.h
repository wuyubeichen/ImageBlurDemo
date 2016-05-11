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

/**
 *  CoreImage图片高斯模糊
 *
 *  @param image 图片
 *  @param blur  模糊数值(默认是10)
 *
 *  @return 重新绘制的新图片
 */

+(UIImage *)coreBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;


/**
 *  vImage模糊图片
 *
 *  @param image 原始图片
 *  @param blur  模糊数值(0-1)
 *
 *  @return 重新绘制的新图片
 */
+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;





@end
