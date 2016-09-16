//
//  ViewController.m
//  CoreAnimation
//
//  Created by solon on 16/9/15.
//  Copyright © 2016年 solon. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *layerView;
@property (weak, nonatomic) IBOutlet UIView *viewTwo;
@property (weak, nonatomic) IBOutlet UIView *viewThree;
@property (weak, nonatomic) IBOutlet UIView *viewFour;


@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setupLayerView];
//    [self imageForView];
    self.view.backgroundColor = [UIColor grayColor];
//    [self stretchImageForView];
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}


#pragma mark - CALayer代理绘制
- (void)drawWithDelegate
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    view.center = self.view.center;
    
}

#pragma mark - contentsCenter图片拉升
- (void)stretchImageForView
{
    UIImage *image = [UIImage imageNamed:@"quater"];
    UIView *sView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 250)];
    sView.center = self.view.center;
    
    [self.view addSubview:sView];
    
    [self addStretchbleImage:image withContentsRect:CGRectMake(0.25, 0.25, 0.5, 0.5) toLayer:sView.layer];
    
}

- (void)addStretchbleImage:(UIImage *)image withContentsRect:(CGRect)rect toLayer:(CALayer *)layer
{
    layer.contents = (__bridge id)image.CGImage;
    layer.contentsCenter = rect;
}

#pragma mark - contentsRect属性使用
- (void)imageForView
{
    UIImage *image = [UIImage imageNamed:@"quater"];
    
    [self addSpritesImage:image withContectsRect:CGRectMake(0, 0, 0.5, 0.5) toLayer:self.layerView.layer];
    [self addSpritesImage:image withContectsRect:CGRectMake(0, 0.5, 0.5, 0.5) toLayer:self.viewTwo.layer];
    [self addSpritesImage:image withContectsRect:CGRectMake(0.5, 0, 0.5, 0.5) toLayer:self.viewThree.layer];
    [self addSpritesImage:image withContectsRect:CGRectMake(0.5, 0.5, 0.5, 0.5) toLayer:self.viewFour.layer];
}

- (void)addSpritesImage:(UIImage *)image withContectsRect:(CGRect)rect toLayer:(CALayer *)layer
{
    layer.contents = (__bridge id)image.CGImage;
    layer.contentsGravity = kCAGravityResizeAspect;
    layer.contentsRect = rect;
}

#pragma mark - 第一节图层树与寄宿图
- (void)setupLayerView
{
    UIView *layerView = [UIView new];
    layerView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        view.center = self.view.center;
        view.backgroundColor = [UIColor whiteColor];
        
        view;
    });
    [self.view addSubview:layerView];
    //寄宿图layer中都有一个id类型的contents属性
    UIImage *image = [UIImage imageNamed:@"1.pic"];
    layerView.layer.contents = (__bridge id)image.CGImage;
    layerView.layer.contentsGravity = kCAGravityCenter;
    layerView.layer.contentsScale = image.scale;
    layerView.layer.masksToBounds = YES;
    //CAlayer
//    CALayer *blueLayer = [CALayer layer];
//    blueLayer.frame  = CGRectMake(50, 50, 100, 100);
//    blueLayer.backgroundColor = [UIColor blueColor].CGColor;
//    [layerView.layer addSublayer:blueLayer];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
