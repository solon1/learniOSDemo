//
//  ViewController.m
//  SNChart
//
//  Created by solon on 16/5/2.
//  Copyright © 2016年 solon. All rights reserved.
//

#import "ViewController.h"
#import "SNChartView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    SNChartView *chart = [[SNChartView alloc]init];
    chart.frame = CGRectMake(20, 100, 250, 300);
    NSValue *point1 = [NSValue valueWithCGPoint:CGPointMake(10, 150)];
    NSValue *point2 = [NSValue valueWithCGPoint:CGPointMake(50, 10)];
    NSValue *point3 = [NSValue valueWithCGPoint:CGPointMake(100, 200)];
    NSValue *point4 = [NSValue valueWithCGPoint:CGPointMake(200, 250)];

    chart.points = @[point1,point2,point3,point4];
    [self.view addSubview:chart];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
