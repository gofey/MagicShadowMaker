//
//  ImageShadowView.m
//  MagicShadowMaker
//
//  Created by 厉国辉 on 2017/4/17.
//  Copyright © 2017年 Xschool. All rights reserved.
//

#import "ImageShadowView.h"
@implementation ImageShadowView
@synthesize image = _image;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self shadow];
        
    }
    return self;
}
- (void)setImage:(UIImage *)image{
    [super setImage:image];
    self.layer.shadowColor = [self mostColor:image].CGColor;
}

- (void)circleShadow{
    //阴影透明度
    UIView *bgView = [[UIView alloc] initWithFrame:self.frame];
    [self.superview addSubview:bgView];
    [self.superview sendSubviewToBack:bgView];
    self.layer.cornerRadius = self.frame.size.width / 2;
    self.layer.masksToBounds = YES;
    bgView.layer.shadowOpacity = 1;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2) radius:self.frame.size.width / 2 startAngle:0 endAngle:M_PI * 2 clockwise:NO];
    
    bgView.layer.shadowPath = path.CGPath;
    bgView.layer.shadowColor = [self mostColor:self.image].CGColor;
    //阴影偏移量
    bgView.layer.shadowOffset = CGSizeMake(0, 3);
    //阴影模糊半径
    bgView.layer.shadowRadius = 8;
}
//阴影方法
- (void)shadow{
    //阴影透明度
    self.layer.shadowOpacity = 1;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.layer.bounds];
    
    self.layer.shadowPath = path.CGPath;
    self.layer.shadowColor = [self mostColor:self.image].CGColor;
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
    if (data == NULL) return nil;
    NSCountedSet *cls = [NSCountedSet setWithCapacity:thumbSize.width * thumbSize.height];
    
    for (int x = 0; x < thumbSize.width; x++) {
        for (int y = 0; y < thumbSize.height; y++) {
            int offset = 4 * (x * y);
            int red = data[offset];
            int green = data[offset + 1];
            int blue = data[offset + 2];
            int alpha =  data[offset + 3];
            if (alpha > 0) {//去除透明
                if (red == 255 && green == 255 && blue == 255) {//去除白色
                }else{
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
    return [UIColor colorWithRed:([MaxColor[0] intValue]/255.0f) green:([MaxColor[1] intValue]/255.0f) blue:([MaxColor[2] intValue]/255.0f) alpha:([MaxColor[3] intValue]/255.0f)];
}

@end
