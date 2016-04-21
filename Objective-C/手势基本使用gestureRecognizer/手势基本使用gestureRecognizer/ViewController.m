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
    [self setupPinch];
    [self setupRotation];
//    [self setupSwipe];
    [self setupPan];


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

    
}

#pragma mark - addGestureRecognizer

//拖拽手势
- (void)setupPan
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureRecognizer:)];
    pan.delegate = self;
    [self.imageView addGestureRecognizer:pan];
}

//滑动手势
- (void)setupSwipe
{
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGestureRecognizer:)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    
    swipe.delegate = self;
    [self.imageView addGestureRecognizer:swipe];
}

//旋转手势
- (void)setupRotation
{
    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rotationGestureRecognizer:)];
    rotation.delegate = self;
    [self.imageView addGestureRecognizer:rotation];
}

//捏合手势

- (void)setupPinch
{
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchGestureRecognizer:)];
    pinch.delegate = self;
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

- (void)panGestureRecognizer:(UIPanGestureRecognizer *)sender
{
    CGPoint moveP = [sender translationInView:self.imageView];
    self.imageView.transform = CGAffineTransformTranslate(self.imageView.transform, moveP.x, moveP.y);
    
    //同样需要复位
    [sender setTranslation:CGPointZero inView:self.imageView];
}

- (void)swipeGestureRecognizer:(UISwipeGestureRecognizer *)sender
{


    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {

        [UIView animateWithDuration:0.25 animations:^{
            self.imageView.transform = CGAffineTransformTranslate(self.imageView.transform, 50, 50);
        }];
    }
}

- (void)rotationGestureRecognizer:(UIRotationGestureRecognizer *)sender
{
    self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, sender.rotation);
    
    sender.rotation = 0;
}
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
    
//    CGPoint currentPoint = [touch locationInView:self.imageView];
//    if (currentPoint.x > self.imageView.frame.size.width * 0.5) {
//        return NO;
//    }else {
//        return YES;
//    }
    
    
    return YES;
}

//允许多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


@end
