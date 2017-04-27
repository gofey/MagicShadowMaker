//
//  ImageShadowView.h
//  MagicShadowMaker
//
//  Created by 厉国辉 on 2017/4/17.
//  Copyright © 2017年 Xschool. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageShadowView : UIView

@property(nonatomic,strong)UIImage *image;

@property(nonatomic)CGFloat cornerRadius;

@property(nonatomic)CGSize shadowOffSet;

@property(nonatomic)CGFloat shadowRadius;

@end
