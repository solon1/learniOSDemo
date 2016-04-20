//
//  ViewController.m
//  手势基本使用gestureRecognizer
//
//  Created by solon on 16/4/20.
//  Copyright © 2016年 solon. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic,weak) UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
     官方文档中所有的手势
     The concrete subclasses of UIGestureRecognizer are the following:
     
     UITapGestureRecognizer
     
     UIPinchGestureRecognizer
     
     UIRotationGestureRecognizer
     
     UISwipeGestureRecognizer
     
     UIPanGestureRecognizer
     
     UIScreenEdgePanGestureRecognizer
     
     UILongPressGestureRecognizer
     
     */
    [self setupImageView];
//    [self setupTap];

}

#pragma mark - setupImageView

- (void)setupImageView
{
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gestureImage"]];
    imageView.bounds = CGRectMake(0, 0, 300, 240);
    imageView.center = self.view.center;
    imageView.userInteractionEnabled = YES;
    
    [self.view addSubview:imageView];
    self.imageView = imageView;
    [self setupTap];
    [self setupPinch];
    
}

#pragma mark - addGestureRecognizer

//捏合手势

- (void)setupPinch
{
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchGestureRecognizer:)];
    [self.imageView addGestureRecognizer:pinch];
}

//点按手势

- (void)setupTap
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureRecognizer:)];
    tap.delegate = self;
    [self.imageView addGestureRecognizer:tap];
}




#pragma mark - privateMethod

- (void)pinchGestureRecognizer:(UIPinchGestureRecognizer *)sender
{
    self.imageView.transform = CGAffineTransformScale(self.imageView.transform, sender.scale, sender.scale);
    //每一次缩放需要将缩放值还原为1,否则缩放值将会越来越大或者越来越小
    sender.scale = 1;
}

- (void)tapGestureRecognizer:(UITapGestureRecognizer *)sender
{

    if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"%s",__func__);
    }
}



#pragma mark - UIGestureRecognizerDelegate

//设置点按范围

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    //touch 的一些常用属性
//    NSLog(@"tapCount --- %lu",touch.tapCount);
//    NSLog(@"timestamp --- %f",touch.timestamp);
//
//    NSLog(@"previousLocation --- %@",NSStringFromCGPoint([touch previousLocationInView:self.imageView]));
//    NSLog(@"location --- %@",NSStringFromCGPoint([touch locationInView:self.imageView]));
    
    CGPoint currentPoint = [touch locationInView:self.imageView];
    if (currentPoint.x > self.imageView.frame.size.width * 0.5) {
        return NO;
    }else {
        return YES;
    }

    
}

//允许多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


@end
