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

@property (nonatomic,weak) UIView *secondHand;
@property (nonatomic,strong) NSTimer *timer;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setupLayerView];
//    [self imageForView];
    [self hideFourView];
    self.view.backgroundColor = [UIColor grayColor];
//    [self stretchImageForView];
//    [self drawWithDelegate];
//    [self setClockView];
    
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - zPosition应用
- (void)usezPositionInTwoViews
{
    UIView *viewOne = [UIView alloc] initWithFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
}

#pragma mark - anchorPoint示例
//通过设置钟表的指针解释anchorPoint的应用场景
- (void)setClockView
{
    UIView *backView             = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    backView.center              = self.view.center;
    backView.backgroundColor     = [UIColor whiteColor];
    backView.layer.cornerRadius  = 100.0;
    backView.layer.masksToBounds = YES;
    [self.view addSubview:backView];
    //指针
    UIView *secondHand             = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2, 90)];
    secondHand.backgroundColor = [UIColor redColor];
    secondHand.center              = CGPointMake(100, 100);
    [backView addSubview:secondHand];
    self.secondHand = secondHand;
    secondHand.layer.anchorPoint = CGPointMake(0.5, 0.9);//调整anchorPoint使秒钟围绕正确的中心点旋转
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick) userInfo:nil repeats:YES];
    [self tick];
}

- (void)tick
{
    //转换时间到，时分秒
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger units = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [calendar components:units fromDate:[NSDate date]];
    //计算时分秒的角度
//    CGFloat hoursAngle = components.hour / 12.0f * M_PI * 2;
//    CGFloat minuteAngle = components.minute / 60.f * M_PI * 2;
    CGFloat secondAngle = components.second / 60.f * M_PI * 2;
    
    self.secondHand.transform = CGAffineTransformMakeRotation(secondAngle);
}



#pragma mark - CALayer代理绘制
- (void)drawWithDelegate
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    view.backgroundColor = [UIColor whiteColor];
    view.center = self.view.center;
    [self.view addSubview:view];
    
    CALayer *blueLayer = [CALayer layer];
    blueLayer.frame = CGRectMake(50, 50, 100, 100);
    blueLayer.backgroundColor = [UIColor blueColor].CGColor;
    blueLayer.delegate = self;
    blueLayer.contentsScale = [UIScreen mainScreen].scale;
    [view.layer addSublayer:blueLayer];
    [blueLayer display];
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    CGContextSetLineWidth(ctx, 10.0);
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextStrokeEllipseInRect(ctx, layer.bounds);
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

- (void)hideFourView
{
    self.layerView.hidden = YES;
    self.viewTwo.hidden = YES;
    self.viewThree.hidden = YES;
    self.viewFour.hidden = YES;
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
