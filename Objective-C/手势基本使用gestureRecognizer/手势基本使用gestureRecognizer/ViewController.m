//
//  ViewController.m
//  手势基本使用gestureRecognizer
//
//  Created by solon on 16/4/20.
//  Copyright © 2016年 solon. All rights reserved.
//

#import "ViewController.h"

static NSInteger *count = 0;


@interface ViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic,weak) UIImageView *imageView;
/** tipsLabel */
@property (nonatomic,weak) UILabel *tipsLabel;

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
//    [self setupPinch];
//    [self setupRotation];
//    [self setupSwipe];
//    [self setupPan];
    [self setupScreenEdgePan];
//    [self setupLongpress];

}

#pragma mark - setupImageView

- (void)setupImageView
{
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gestureImage"]];
    imageView.bounds = CGRectMake(0, 0, 300, 240);
    imageView.center = self.view.center;
    imageView.userInteractionEnabled = YES;
    
    
    UILabel *tipsLabel = [[UILabel alloc]init];
    tipsLabel.textColor = [UIColor redColor];
    tipsLabel.font = [UIFont systemFontOfSize:15];
    tipsLabel.bounds = CGRectMake(0, 0, 200, 20);
    tipsLabel.center = CGPointMake(self.view.frame.size.width * 0.5, CGRectGetMaxY(imageView.frame) + 100);
    
    [self.view addSubview:imageView];
    [self.view addSubview:tipsLabel];
    self.imageView = imageView;
    self.tipsLabel = tipsLabel;
    
}

#pragma mark - addGestureRecognizer

//长按手势UILongPressGestureRecognizer
- (void)setupLongpress
{
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGesgureRecognizer:)];
    
    longPress.minimumPressDuration = 2.0f;//默认0.5s
    [self.imageView addGestureRecognizer:longPress];
    
}

//屏幕边缘滑动手势
- (void)setupScreenEdgePan
{
    UIScreenEdgePanGestureRecognizer *screenEdgePan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(screenEdgePanGestureRecognizer:)];
    screenEdgePan.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:screenEdgePan];
}

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

- (void)longPressGesgureRecognizer:(UILongPressGestureRecognizer *)sender
{
    //超过设定的间隔时间就会来到这里
    self.tipsLabel.text = @"longPressGesgureRecognizer";
}

- (void)screenEdgePanGestureRecognizer:(UIScreenEdgePanGestureRecognizer *)sender
{
    //因为此方法会调用很多次所以下面动画方法只是调用一次
    /**
     *  关于block什么时候使用weakself这篇回答写得挺好
     *  http://stackoverflow.com/questions/20030873/always-pass-weak-reference-of-self-into-block-in-arc
     
     *  weakSelf主要是解决循环引用问题,如果在当前控制器中包含一个blockA属性
     *  那么在blockA中调用self就必须使用weakself
     */
    self.tipsLabel.text = @"screenEdgePanGestureRecognizer";
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [UIView animateWithDuration:0.25 animations:^{
            self.imageView.transform = CGAffineTransformTranslate(self.imageView.transform, 50, 50);
        }];
    });
}

- (void)panGestureRecognizer:(UIPanGestureRecognizer *)sender
{
    self.tipsLabel.text = @"panGestureRecognizer";
    CGPoint moveP = [sender translationInView:self.imageView];
    self.imageView.transform = CGAffineTransformTranslate(self.imageView.transform, moveP.x, moveP.y);
    
    //同样需要复位
    [sender setTranslation:CGPointZero inView:self.imageView];
}

- (void)swipeGestureRecognizer:(UISwipeGestureRecognizer *)sender
{

    self.tipsLabel.text = @"swipeGestureRecognizer";
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {

        [UIView animateWithDuration:0.25 animations:^{
            self.imageView.transform = CGAffineTransformTranslate(self.imageView.transform, 50, 50);
        }];
    }
}

- (void)rotationGestureRecognizer:(UIRotationGestureRecognizer *)sender
{
    self.tipsLabel.text = @"rotationGestureRecognizer";
    self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, sender.rotation);
    
    sender.rotation = 0;
}
- (void)pinchGestureRecognizer:(UIPinchGestureRecognizer *)sender
{
    self.tipsLabel.text = @"pinchGestureRecognizer";
    self.imageView.transform = CGAffineTransformScale(self.imageView.transform, sender.scale, sender.scale);
    //每一次缩放需要将缩放值还原为1,否则缩放值将会越来越大或者越来越小
    sender.scale = 1;
}

- (void)tapGestureRecognizer:(UITapGestureRecognizer *)sender
{

    if (sender.state == UIGestureRecognizerStateEnded) {
        count ++;

        self.tipsLabel.text = [NSString stringWithFormat:@"%zd--tapGestureRecognizer",count];
        
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
