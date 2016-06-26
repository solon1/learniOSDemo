//
//  ViewController.m
//  正则表达式的使用
//
//  Created by solon on 16/6/26.
//  Copyright © 2016年 solon. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self regularExpression];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)regularExpression
{
    /**
     *  正则表达式维基
     *  https://www.wikiwand.com/zh/%E6%AD%A3%E5%88%99%E8%A1%A8%E8%BE%BE%E5%BC%8F
     */
    
    //创建目标字符串
    NSString *target = @"zheng1ze2biao3da";
    
    //匹配到0-9所有数字的字符串
    NSString *pattern = @"[0-9]";
    
    NSError *error = nil;
    //创建正则表达式对象
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    
    if (error) {
        NSLog(@"error - %@",error);
    }
    
    //使用创建好的正则表达式对象匹配目标字符串返回一个数组
    NSArray *results = [regularExpression matchesInString:target options:NSMatchingReportProgress range:NSMakeRange(0, target.length)];
    //遍历结果
    for (NSTextCheckingResult *result in results) {
        //根据结果字符串的范围从目标字符串中取出字符串
        NSRange rang = result.range;
        NSString *subString = [target substringWithRange:rang];
        NSLog(@"subString -- %@",subString);
    }
    
    //判断是否匹配成功
    if (results.count) {
        NSLog(@"匹配成功");
    }else {
        NSLog(@"匹配不成功");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
