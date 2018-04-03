//
//  UIImage+Blur.m
//  ZSTest
//
//  Created by zhoushuai on 16/5/11.
//  Copyright © 2016年 zhoushuai. All rights reserved.
//

#import "UIImage+Blur.h"

@implementation UIImage (Blur)
//MARK: - 使用CoreImage实现图片的高斯模糊

/**
 *  使用CoreImage实现图片的高斯模糊
 *
 *  @param image 原始图片
 *  @param blur  模糊程度,默认为50,取值范围(0-100)
 *
 *  @return 返回经过模糊的图片
 */

+(UIImage *)getCoreBlurImage:(UIImage *)image
               blurNumber:(CGFloat)blur{
    if(!image){
        return nil;
    }
    //默认模糊度50
    if (blur < 0) {
        blur = 50;
    }
    //获取图片资源
    CIImage  *inputImage=[CIImage imageWithCGImage:image.CGImage];
    //设置filter，高斯模糊的滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    //将图片输入到滤镜中
    [filter setValue:inputImage forKey:kCIInputImageKey];
    
    //设置模糊程度,默认为10,取值范围(0-100)
    [filter setValue:@(blur) forKey: @"inputRadius"];
    
    //将处理好的图片取出
    CIImage *result=[filter valueForKey:kCIOutputImageKey];
    
    //context
    CIContext *context = [CIContext contextWithOptions:nil];
    
    //获取CGImage句柄,也就是从数据流中取出图片
    CGImageRef outImage = [context createCGImage: result fromRect:[inputImage extent]];
    //最终得到图片
    UIImage *blurImage=[UIImage imageWithCGImage:outImage];
    //释放CGImage句柄
    CGImageRelease(outImage);
    
    return blurImage;
}

/**
 使用CoreImage实现图片的模糊
 
 @param image 原始图片对象
 @param filterName 模糊类型名称，默认使用高斯模糊
 @param blur 模糊程度,默认为50,取值范围(0-100)
 @return 返回经过模糊的图片
 */
+(UIImage *)getCoreBlurImage:(UIImage *)image
               filterName:(NSString *)filterName
               blurNumber:(CGFloat)blur{
    if(!image){
        return nil;
    }
    //默认模糊度50
    if (blur < 0) {
        blur = 50;
    }
    //获取图片资源
    CIImage  *inputImage=[CIImage imageWithCGImage:image.CGImage];
    //设置filter，默认使用高斯模糊的滤镜
    if(filterName.length == 0){
        filterName = @"CIGaussianBlur";
    }
    CIFilter *filter = [CIFilter filterWithName:filterName];
    //将图片输入到滤镜中
    [filter setValue:inputImage forKey:kCIInputImageKey];
    
    //设置模糊程度,默认为10,取值范围(0-100)
    [filter setValue:@(blur) forKey: @"inputRadius"];
    
    //将处理好的图片取出
    CIImage *result=[filter valueForKey:kCIOutputImageKey];
    
    //context
    CIContext *context = [CIContext contextWithOptions:nil];
    
    //获取CGImage句柄,也就是从数据流中取出图片
    CGImageRef outImage = [context createCGImage: result fromRect:[inputImage extent]];
    //最终得到图片
    UIImage *blurImage=[UIImage imageWithCGImage:outImage];
    //释放CGImage句柄
    CGImageRelease(outImage);
    
    return blurImage;
}







//MARK: - 使用VImage实现图片的高斯模糊

+ (UIImage *)getVImgBlurImage:(UIImage *)image withBlurLevel:(CGFloat)blur
{
    if (image==nil)
    {
        NSLog(@"error:为图片添加模糊效果时，未能获取原始图片");
        return nil;
    }
    //模糊度,
    if ((blur < 0.1f) || (blur > 2.0f)) {
        blur = 0.5f;
    }
    
    //boxSize必须大于0
    int boxSize = (int)(blur * 100);
    boxSize -= (boxSize % 2) + 1;
    NSLog(@"boxSize:%i",boxSize);
    
    CGImageRef img = image.CGImage;
    
    //图像缓存,输入缓存，输出缓存
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    //像素缓存
    void *pixelBuffer;
    
    //数据源提供者，Defines an opaque type that supplies Quartz with data.
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    // provider’s data.
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    //宽，高，字节/行，data
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    //像数缓存，字节行*图片高
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    // 第三个中间的缓存区,抗锯齿的效果
    void *pixelBuffer2 = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    vImage_Buffer outBuffer2;
    outBuffer2.data = pixelBuffer2;
    outBuffer2.width = CGImageGetWidth(img);
    outBuffer2.height = CGImageGetHeight(img);
    outBuffer2.rowBytes = CGImageGetBytesPerRow(img);
    //Convolves a region of interest within an ARGB8888 source image by an implicit M x N kernel that has the effect of a box filter.
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer2, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    error = vImageBoxConvolve_ARGB8888(&outBuffer2, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    //NSLog(@"字节组成部分：%zu",CGImageGetBitsPerComponent(img));
    //颜色空间DeviceRGB
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //用图片创建上下文,CGImageGetBitsPerComponent(img),7,8
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             CGImageGetBitmapInfo(image.CGImage));
    
    //根据上下文，处理过的图片，重新组件
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    free(pixelBuffer2);
    CFRelease(inBitmapData);
    //CGColorSpaceRelease(colorSpace);   //多余的释放
    CGImageRelease(imageRef);
    return returnImage;
}



//MARK: - 使用UIBlurEffect实现毛玻璃效果
//只适用于iOS8.0以上

/**
 使用UIBlurEffect实现毛玻璃效果
 
 @param imgview 需要显示效果的视图
 */
+ (void)addBlurEffectToView:(UIView *)imgview{
    UIBlurEffect * blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    //创建模糊view
    UIVisualEffectView * effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
    effectView.frame = imgview.bounds;
    [imgview addSubview:effectView];
}


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
                      alpha:(CGFloat)alpha{
    UIBlurEffect * blur = [UIBlurEffect effectWithStyle:style];
    //创建模糊view
    UIVisualEffectView * effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
    //指定需要显示效果的区域位置
    effectView.frame = frame;
    //设置透明度
    effectView.alpha = alpha;
    [imgview addSubview:effectView];
}


//MARK: - 使用UIToolbar实现图片模糊
+ (void)addToolbarBlurToView:(UIView *)imgView {
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:imgView.bounds];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    [imgView addSubview:toolbar];
}

+ (void)addToolbarBlurToView:(UIView *)imgView alpha:(CGFloat)alpha{
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:imgView.bounds];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    [imgView addSubview:toolbar];
    toolbar.alpha = alpha;
}

 @end
