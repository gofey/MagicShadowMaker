//
//  ViewController.m
//  MagicShadowMaker
//
//  Created by 厉国辉 on 2017/4/14.
//  Copyright © 2017年 Xschool. All rights reserved.
//

#import "ViewController.h"
#import "ImageShadowView.h"
#import "UIImageView+WebCache.h"
@interface ViewController ()

@end

@implementation ViewController
{
    int _index;
    NSArray *_imgUrlArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _index = 0;
//    _imgUrlArray = @[@"http://ooy23086i.bkt.clouddn.com/image9@2x.jpg",@"http://ooy23086i.bkt.clouddn.com/image10@2x.jpg",@"http://ooy23086i.bkt.clouddn.com/image11@2x.jpg",@"http://ooy23086i.bkt.clouddn.com/image12@2x.jpg"];
    self.view.backgroundColor = [UIColor whiteColor];
    ImageShadowView *imageView = [[ImageShadowView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 50, [UIScreen mainScreen].bounds.size.height / 2 - 50, 100, 100)];
    [self.view addSubview:imageView];
    imageView.cornerRadius = 10;
    
    imageView.image = [UIImage imageNamed:@"image0"];
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeImage:)];
    [imageView addGestureRecognizer:tap];
    
}
- (void)changeImage:(UITapGestureRecognizer *)tap{
    UIImageView *imageView = (UIImageView *)tap.view;
    _index++;
    if (_index > 12) {
        _index = 0;
    }
    imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"image%d",_index]];

//    self.view.backgroundColor = [self mostColor:[UIImage imageNamed:[NSString stringWithFormat:@"image%d",_index]]];
//    [imageView sd_setImageWithURL:[NSURL URLWithString:_imgUrlArray[_index]]];
}

//根据图片获取图片的主色调
- (UIColor*)mostColor:(UIImage*)image{

    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
    
    //第一步 先把图片缩小 加快计算速度. 但越小结果误差可能越大
    CGSize thumbSize = CGSizeMake(image.size.width / 2, image.size.height / 2);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 thumbSize.width,
                                                 thumbSize.height,
                                                 8,//bits per component
                                                 thumbSize.width*4,
                                                 colorSpace,
                                                 bitmapInfo);
    
    CGRect drawRect = CGRectMake(0, 0, thumbSize.width, thumbSize.height);
    CGContextDrawImage(context, drawRect, image.CGImage);
    CGColorSpaceRelease(colorSpace);

    //第二步 取每个点的像素值
    unsigned char* data = CGBitmapContextGetData (context);
    if (data == NULL)
        return nil;
    
    NSCountedSet *cls = [NSCountedSet setWithCapacity:thumbSize.width * thumbSize.height];
    
    for (int x = 0; x < thumbSize.width; x++) {
        for (int y = 0; y < thumbSize.height; y++) {
            int offset = 4 * (x * y);
            int red = data[offset];
            int green = data[offset + 1];
            int blue = data[offset + 2];
            int alpha =  data[offset + 3];
            if (alpha > 0) {
                //去除透明
                if (!(red == 255 && green == 255 && blue == 255)) {
                    //去除白色
                    NSArray *clr = @[@(red),@(green),@(blue),@(alpha)];
                    [cls addObject:clr];
                }
            }
        }
    }
    CGContextRelease(context);
    //第三步 找到出现次数最多的那个颜色
    NSEnumerator *enumerator = [cls objectEnumerator];
    NSArray *curColor = nil;
    NSArray *MaxColor = nil;
    NSUInteger MaxCount = 0;
    while ( (curColor = [enumerator nextObject]) != nil )
    {
        NSUInteger tmpCount = [cls countForObject:curColor];
        if ( tmpCount < MaxCount )
            continue;
        MaxCount = tmpCount;
        MaxColor = curColor;
    }
    
    //    NSLog(@"r:%f,g:%f,b:%f",[MaxColor[0] intValue]/255.0f,[MaxColor[1] intValue]/255.0f,[MaxColor[2] intValue]/255.0f);
    return [UIColor colorWithRed:([MaxColor[0] intValue]/255.0f) green:([MaxColor[1] intValue]/255.0f) blue:([MaxColor[2] intValue]/255.0f) alpha:([MaxColor[3] intValue]/255.0f)];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
