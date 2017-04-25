//
//  ViewController.m
//  MagicShadowMaker
//
//  Created by 厉国辉 on 2017/4/14.
//  Copyright © 2017年 Xschool. All rights reserved.
//

#import "ViewController.h"
#import "ImageShadowView.h"
@interface ViewController ()

@end

@implementation ViewController
{
    int _index;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _index = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    ImageShadowView *imageView = [[ImageShadowView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 50, [UIScreen mainScreen].bounds.size.height / 2 - 50, 100, 100)];
    [self.view addSubview:imageView];
    imageView.image = [UIImage imageNamed:@"image0"];
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeImage:)];
    [imageView addGestureRecognizer:tap];
    self.view.backgroundColor = [UIColor yellowColor];
//    imageView.is
}
- (void)changeImage:(UITapGestureRecognizer *)tap{
    UIImageView *imageView = (UIImageView *)tap.view;
    _index++;
    if (_index > 12) {
        _index = 0;
    }
    
    imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"image%d",_index]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
