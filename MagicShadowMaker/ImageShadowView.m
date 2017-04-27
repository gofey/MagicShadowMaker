//
//  ImageShadowView.m
//  MagicShadowMaker
//
//  Created by 厉国辉 on 2017/4/17.
//  Copyright © 2017年 Xschool. All rights reserved.
//

#import "ImageShadowView.h"

@interface ImageShadowView()

@property(nonatomic,strong)UIImageView *imgView;

@end
@implementation ImageShadowView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self shadow];
        
    }
    return self;
}

#pragma mark - 重写set方法
- (void)setImage:(UIImage *)image{
    dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(q, ^{
        //设置阴影颜色
        UIColor *color = [self mostColor:image];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //赋值
            self.layer.shadowColor = color.CGColor;
            self.imgView.image = image;
        });
    });
}

- (void)setShadowOffSet:(CGSize)shadowOffSet{
    self.layer.shadowOffset = shadowOffSet;
}

- (void)setCornerRadius:(CGFloat)cornerRadius{
    self.imgView.layer.cornerRadius = cornerRadius;
    self.imgView.clipsToBounds = YES;

    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:cornerRadius];
    self.layer.shadowPath = path.CGPath;
}

- (void)setShadowRadius:(CGFloat)shadowRadius{
    self.layer.shadowRadius = shadowRadius;
}

#pragma mark - 重写get方法
- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _imgView.clipsToBounds = YES;
        [self addSubview:_imgView];
        
    }
    return _imgView;
}

#pragma mark - 阴影方法
- (void)shadow{
    //阴影透明度
    self.layer.shadowOpacity = 1;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.layer.bounds];
    
    self.layer.shadowPath = path.CGPath;
    self.layer.shadowColor = [self mostColor:_image].CGColor;
    //阴影偏移量
    self.layer.shadowOffset = CGSizeMake(0, 5);
    //阴影模糊半径
    self.layer.shadowRadius = 8;
}

//根据图片获取图片的主色调
- (UIColor*)mostColor:(UIImage*)image{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
#else
    int bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif
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
        if ( tmpCount < MaxCount ) continue;
        MaxCount = tmpCount;
        MaxColor = curColor;
    }
    
//    NSLog(@"r:%f,g:%f,b:%f",[MaxColor[0] intValue]/255.0f,[MaxColor[1] intValue]/255.0f,[MaxColor[2] intValue]/255.0f);
    return [UIColor colorWithRed:([MaxColor[0] intValue]/255.0f) green:([MaxColor[1] intValue]/255.0f) blue:([MaxColor[2] intValue]/255.0f) alpha:([MaxColor[3] intValue]/255.0f)];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
