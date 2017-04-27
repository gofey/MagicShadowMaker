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
    _imgUrlArray = @[@"http://ooy23086i.bkt.clouddn.com/image9@2x.jpg",@"http://ooy23086i.bkt.clouddn.com/image10@2x.jpg",@"http://ooy23086i.bkt.clouddn.com/image11@2x.jpg",@"http://ooy23086i.bkt.clouddn.com/image12@2x.jpg"];
    self.view.backgroundColor = [UIColor whiteColor];
    ImageShadowView *imageView = [[ImageShadowView alloc] initWithFrame:CGRectMake(15, [UIScreen mainScreen].bounds.size.height / 2 - 50, 100, 100)];
    [self.view addSubview:imageView];
    imageView.cornerRadius = 50;
    
    imageView.image = [UIImage imageNamed:@"image0"];
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeImage:)];
    [imageView addGestureRecognizer:tap];
    self.view.backgroundColor = [UIColor yellowColor];
}
- (void)changeImage:(UITapGestureRecognizer *)tap{
    UIImageView *imageView = (UIImageView *)tap.view;
    _index++;
    if (_index > 12) {
        _index = 0;
    }
    imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"image%d",_index]];
//    [imageView sd_setImageWithURL:[NSURL URLWithString:_imgUrlArray[_index]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
