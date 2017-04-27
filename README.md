# MagicShadowMaker
仿照一个安卓端效果做的，可以根据图片的主题色显示不同的阴影

https://github.com/gofey/MagicShadowMaker/show.mp4
https://github.com/gofey/MagicShadowMaker/show1@2x.png
https://github.com/gofey/MagicShadowMaker/show2@2x.png
https://github.com/gofey/MagicShadowMaker/show3@2x.png

使用方式很简单

    ImageShadowView *imageView = [[ImageShadowView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 50, [UIScreen mainScreen].bounds.size.height / 2 - 50, 100, 100)];
    [self.view addSubview:imageView];
    imageView.cornerRadius = 50;
    imageView.image = [UIImage imageNamed:@"image0"];

需要改变阴影半径或者阴影偏移，可以设置shadowOffSet，shadowRadius属性

甚至可以自己定制自己想要的阴影颜色
imageView.layer.shadowColor = [UIColor redColor].CGColor//需要基于layer层改变

觉得图片不需要，可以不设置图片，也就变成了一个单纯的阴影背景，你可以往里面添加内容，让其做你的阴影背景，效果也是一样的，但是注意要把frame设置的和你想要添加背景的view设置成一样，CornerRadius等属性也要一样，如下

    ImageShadowView *imageView = [[ImageShadowView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 50, [UIScreen mainScreen].bounds.size.height / 2 - 50, 100, 100)];
    [self.view addSubview:imageView];
    imageView.cornerRadius = 10;
    
    
    UIView *contentView = [[UIView alloc] initWithFrame:imageView.frame];
    [self.view addSubview:contentView];
    contentView.layer.cornerRadius = 10;//切圆角
    contentView.layer.masksToBounds = YES;
    contentView.backgroundColor = [UIColor whiteColor];//很重要,一定要设置背景色，不然会看到后边阴影的颜色
    imageView.layer.shadowColor = [UIColor redColor].CGColor;//阴影颜色设置
    
效果：



