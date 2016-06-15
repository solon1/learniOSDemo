//
//  SNGradientView.m
//  StoreSearch
//
//  Created by solon on 16/6/13.
//  Copyright © 2016年 solon. All rights reserved.
//

#import "SNGradientView.h"

@implementation SNGradientView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGFloat components[8] = {0.0f,0.0f,0.0f,0.7f,
                             0.0f,0.0f,0.0f,0.3f};
    CGFloat location[2] = {0.0f,1.0f};
    
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, location, 2);
    CGColorSpaceRelease(colorSpace);
    
    CGFloat x = CGRectGetMaxX(self.bounds);
    CGFloat y = CGRectGetMaxY(self.bounds);
    
    CGPoint point = CGPointMake(x, y);
    
    CGFloat radius = MAX(x, y);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawRadialGradient(context, gradient, point, 0, point, radius, kCGGradientDrawsAfterEndLocation);
    
    CGGradientRelease(gradient);
    
}

@end
