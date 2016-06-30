//
//  ViewController.m
//  JSPath_APP热修复
//
//  Created by solon on 16/6/26.
//  Copyright © 2016年 solon. All rights reserved.
//

#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self useJSContext];
    [self callJavaScriptDemo1];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)callJavaScriptDemo1
{
    //放js文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"extension" ofType:@"js"];
    //取出路径中的js代码
    NSString *extensionJS = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    JSContext *context = [[JSContext alloc]init];
    [context evaluateScript:extensionJS];
    
    JSValue *funcDemo = context[@"funDemo"];
    JSValue *result = [funcDemo callWithArguments:@[@(5)]];

    NSLog(@"result --- %d",[result toInt32]);
}



- (void)useJSContext
{
    JSContext *context = [[JSContext alloc] init];
    [context evaluateScript:@"function add(a,b) { return a+b; }"];
    
    JSValue *add = context[@"add"];
    NSLog(@"Func :%@",add);
    
    JSValue *sum = [add callWithArguments:@[@(21),@(7)]];
    NSLog(@"sum = %d",[sum toInt32]);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
