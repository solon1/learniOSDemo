//
//  SNChartView.m
//  SNChart
//
//  Created by solon on 16/5/2.
//  Copyright © 2016年 solon. All rights reserved.
//

#import "SNChartView.h"

@implementation SNChartView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    
    return self;
}



- (void)drawRect:(CGRect)rect {
    
    //获取当前上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIBezierPath *path = [[UIBezierPath alloc]init];
    [[UIColor cyanColor] set];
    NSValue *startPointVal = self.points[0];
    CGPoint startPoint = startPointVal.CGPointValue;
    
    [path moveToPoint:startPoint];

    //遍历所有点
    for (int i = 0; i < self.points.count - 1; i++) {
        
        //画曲线
        NSValue *pointVal = self.points[i];
        NSValue *nextPointVal = self.points[i+1];
        CGPoint point = pointVal.CGPointValue;
        CGPoint nextPoint = nextPointVal.CGPointValue;
        
        CGPoint controlPoint1 = CGPointMake((point.x + nextPoint.x) * 0.5, point.y);
        CGPoint controlPoint2 = CGPointMake((point.x + nextPoint.x) * 0.5, nextPoint.y);
        
        [path addCurveToPoint:nextPoint controlPoint1:controlPoint1 controlPoint2:controlPoint2];
        [path stroke];
        //画圆点
        CGPoint arcPoint = [self.points[i] CGPointValue];
        CGContextAddArc(ctx, arcPoint.x, arcPoint.y, 3, 0, M_PI * 2, 0);
        CGContextFillPath(ctx);
        
    }
    
}


- (void)setPoints:(NSArray<NSValue *> *)points
{
    _points = points;
    //当赋值数组时刷新界面
    [self setNeedsDisplay];
}

//练习曲线和圆的demo
- (void)quizDemo{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIBezierPath *path = [[UIBezierPath alloc]init];
    [[UIColor cyanColor] set];
    //设置起始点
    [path moveToPoint:CGPointMake(50, 100)];
    
    //画二次贝瑟尔曲线
    //    [path addQuadCurveToPoint:<#(CGPoint)#> controlPoint:<#(CGPoint)#>]
    
    /**
     *  水平的画三次贝瑟尔曲线
     *
     *  @param CGPoint 第一个是终点,第二参数是控制点1第二个是控制点2
     *
     */
    CGPoint endPoint = CGPointMake(150, 20);
    CGPoint control1 = CGPointMake(100, 100);
    CGPoint control2 = CGPointMake(100, 20);
    
    [path addCurveToPoint:endPoint controlPoint1:control1 controlPoint2:control2];
    
    path.lineWidth = 2.5f;
    [path stroke];
    
    
    //画圆点
    CGContextAddArc(context, 50, 100, 3, 0, M_PI * 2, 0);
    CGContextAddArc(context, 150, 20, 3, 0, M_PI * 2, 0);
    
    CGContextFillPath(context);
    
    
}

@end
