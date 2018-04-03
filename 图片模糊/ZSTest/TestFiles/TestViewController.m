//
//  TestViewController.m
//  Test
//
//  Created by zhoushuai on 16/3/7.
//  Copyright © 2016年 zhoushuai. All rights reserved.
//

#import "TestViewController.h"
//两个图片模糊的类目文件
#import "UIImage+Blur.h"
#import "UIImage+ImageEffects.h"

@interface TestViewController ()

@property(nonatomic,strong)UIImage *image;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIImageView *blurImgView;

@end

@implementation TestViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.image = [UIImage imageNamed:@"3.jpg"];
    _imageView.image = self.image;
    _blurImgView.image = self.image.copy;
 }






#pragma mark - Respond To Events
//使用各种方法模糊图片
- (IBAction)onBlurImgBtnClick:(UIButton *)sender {
    NSString *methodStr = [NSString stringWithFormat:@"testBlurImgMthod%ld",sender.tag];
    SEL sel = NSSelectorFromString(methodStr);
    [self performSelector:sel withObject:nil];
}


//恢复原图
- (IBAction)resetBlurImgView:(id)sender {
    for (UIView *view in self.blurImgView.subviews) {
        [view removeFromSuperview];
    }
    self.blurImgView.image = self.image;
}

#pragma mark - private Methods
//1.coreImgage，耗费内存，速度慢
- (void)testBlurImgMthod1{
    _blurImgView.image = [UIImage getCoreBlurImage:self.image blurNumber:20];
    //_blurImgView.image = [UIImage getCoreBlurImage:self.image filterName:nil blurNumber:70];
}

//2.VImage,较coreImgage，性能更佳
- (void)testBlurImgMthod2{
    _blurImgView.image = [UIImage getVImgBlurImage:self.image withBlurLevel:0.6];
}



//3.iOS8新方法：使用UIVisualEffectView实现模糊，但是iOS8以后才可以使用
- (void)testBlurImgMthod3{
    //默认整个视图使用UIBlurEffectStyleLight模糊
    //[UIImage addBlurEffectToView:self.blurImgView];
    
    //指定区域，指定style
    [UIImage addBlurEffectToView:self.blurImgView frame:CGRectMake(0, 0, 100, 100) style:UIBlurEffectStyleDark alpha:0.5];
}

//4.使用UIToolBar实现模糊
- (void)testBlurImgMthod4{
    [UIImage addToolbarBlurToView:self.blurImgView];
}


//5.第二部分：
//使用了第三方：UIimage+ImageEffects:
//5.1、UIimage+ImageEffects:高斯模糊
- (void)testBlurImgMthod5{
    _blurImgView.image = [self.image blurImage];
}


//5.2、UIimage+ImageEffects:区域模糊
- (void)testBlurImgMthod6{
    _blurImgView.image = [self.image blurImageAtFrame:CGRectMake(0, 0, self.image.size.width, self.image.size.height/2)];
}

//5.3、UIimage+ImageEffects:变灰色
- (void)testBlurImgMthod7{
    _blurImgView.image = [self.image grayScale];
}


//使用CDN服务器也能处理网络图片实现模糊，需要利用第三方平台，这里不再细述。

@end
