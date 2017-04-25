//
//  ImageShadowView.h
//  MagicShadowMaker
//
//  Created by 厉国辉 on 2017/4/17.
//  Copyright © 2017年 Xschool. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageShadowView : UIImageView

@property(nonatomic,assign)BOOL isShadow;
- (void)circleShadow;
@end
