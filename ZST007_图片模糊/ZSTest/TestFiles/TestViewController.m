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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.image = [UIImage imageNamed:@"3.jpg"];
    _imageView.image = self.image;
    _blurImgView.image = self.image.copy;
 }


//第一部分：===============================================
//自己总结的方法
//coreImgage
//耗费内存，速度慢
- (IBAction)chooseblurMethodOne:(id)sender {
    
    _blurImgView.image = [UIImage coreBlurImage:self.image withBlurNumber:50];
}

//VImgae
- (IBAction)chooseBlurMethodTwo:(id)sender {
    
    _blurImgView.image = [UIImage blurryImage:self.image withBlurLevel:0.6];
}


//第二部分：===============================================
//参考的代码:UIimage+ImageEffects
//参考链接：https://github.com/DreamcoffeeZS/UIImageBlur
//图片模糊
- (IBAction)chooseBlurMethodThree:(id)sender {
    
    _blurImgView.image = [self.image blurImage];
}

//区域模糊
- (IBAction)chooseBlurMethodFour:(id)sender {
    
    _blurImgView.image = [self.image blurImageAtFrame:CGRectMake(0, 0, self.image.size.width, self.image.size.height/2)];
}

//变灰色
- (IBAction)chooseBlurMethodFive:(id)sender {
    _blurImgView.image = [self.image grayScale];
}


//第三部分：===============================================
//参考简书
//iOS8新方法：使用UIVisualEffectView实现模糊，但是iOS8以后才可以使用
//情况1：直接将文本内容加在effectView(该情况下的文本内容不能与背景相符应);
- (IBAction)chooseBlurMethodSix:(id)sender {
    self.blurImgView.image = self.image;
    UIBlurEffect * blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    //创建模糊view
    UIVisualEffectView * effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
    effectView.frame = CGRectMake(0, 30, self.blurImgView.frame.size.width, 60);
    [self.blurImgView addSubview:effectView];
    //添加显示文本
    UILabel * lable = [[UILabel alloc]initWithFrame:effectView.bounds];
    lable.text = @"测试1";
    lable.textAlignment = NSTextAlignmentCenter;
    lable.font = [UIFont systemFontOfSize:12];
    [effectView.contentView addSubview:lable];
}

//情况2：加在effectView的子view中使文本与背景相符应;
- (IBAction)chooseBlurMethodSeven:(id)sender {
  
    self.blurImgView.image = self.image;
    UIBlurEffect * blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    //创建模糊view
    UIVisualEffectView * effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
    effectView.frame = CGRectMake(0, 30, self.blurImgView.frame.size.width, 30);
    [self.blurImgView addSubview:effectView];
    //添加显示文本
    UILabel * lable = [[UILabel alloc]initWithFrame:effectView.bounds];
    lable.text = @"测试2";
    lable.textAlignment = NSTextAlignmentCenter;
    lable.font = [UIFont systemFontOfSize:24];

    //创建模糊子view的UIVisualEffectView
    //1.创建出子模糊view
    UIVisualEffectView * subEffectView = [[UIVisualEffectView alloc]initWithEffect:[UIVibrancyEffect effectForBlurEffect:(UIBlurEffect *)effectView.effect]];
    //2.设定尺寸
    subEffectView.frame = effectView.bounds;
    //3.将子模糊view添加到effectView的contentView才能够生效
    [effectView.contentView addSubview:subEffectView];
    //4.添加要显示的view来达到特殊的效果
    [subEffectView.contentView addSubview:lable];
}



//第四部分：使用CDN服务器处理网络图片实现模糊，需要利用第三方平台，这里不再细述。


//恢复原图
- (IBAction)resetBlurImgView:(id)sender {
    for (UIView *view in self.blurImgView.subviews) {
        [view removeFromSuperview];
    }
    self.blurImgView.image = self.image;
    
    
}


@end
