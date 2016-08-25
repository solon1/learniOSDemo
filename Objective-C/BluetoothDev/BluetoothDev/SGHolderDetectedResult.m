//
//  SGHolderDetectedResult.m
//  BluetoothDev
//
//  Created by solon on 16/8/23.
//  Copyright © 2016年 solon. All rights reserved.
//

#import "SGHolderDetectedResult.h"
#import <objc/runtime.h>

@implementation SGHolderDetectedResult

- (NSArray *)properties
{
    unsigned int count = 0;//属性总数
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    NSMutableArray *properties = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        objc_property_t property = propertyList[i];//取出每一个属性
        char const *cPropertyName = property_getName(property);
        NSString *ocPropertyName = [[NSString alloc] initWithCString:cPropertyName encoding:NSUTF8StringEncoding];
        [properties addObject:ocPropertyName];
        
    }
    //释放
    free(propertyList);
    return properties.copy;
}


- (instancetype)initWithDetectedResultString:(NSString *)result
{

    self = [super init];
    if (self) {
        
        NSArray *results = [NSArray new];//将检测值字符串分离为数组
        
        if ([result containsString:@"db_sk_report_info_b1"]) {
            results = [result componentsSeparatedByString:@","];
        }
        
        
        for (int i = 0; i < results.count; i++) {
            NSString *propertyName = [self properties][i];
            [self setValue:results[i] forKeyPath:propertyName];
        }
    }
    
    
    
    return self;
}

+ (instancetype)holderDetectedResultWithResultString:(NSString *)result
{
    
    return [[self alloc] initWithDetectedResultString:result];
}

- (void)setPefGroup:(NSString *)pefGroup
{
    _pefGroup = pefGroup;
    NSArray *pefGroups = [self decodePefGroup];
    self.pefGroups = pefGroups;
}

//将600组pef解码转换为数组
- (NSArray *)decodePefGroup{
    
    NSMutableArray *pefGroups = [NSMutableArray array];
    
    CGFloat fvc = 0.f;
    int pef_value = 0;
    int pef_value_sum=0;
    int step = ('9' - '0' + 1) + ('Z' - 'A' + 1);//进制数36
    char ch,ch2;
    
    for(int i=0;i < _pefGroup.length/2;i++ ){
        
        ch = [_pefGroup characterAtIndex:i * 2];
        
        if(ch > '9'){
            ch -= 'A' - ('9' + 1);
        }
        ch2 = [_pefGroup characterAtIndex:i * 2 + 1];
        
        if(ch2 > '9'){
            ch2 -= 'A' - ('9' + 1);
        }
        //把字符串进制转换为 数字
        pef_value	= (ch - '0') * step + (ch2 - '0');
        NSNumber *pefNumber = [NSNumber numberWithInt:pef_value];
        [pefGroups addObject:pefNumber];
        
        pef_value_sum += pef_value;
        
        fvc = (CGFloat)pef_value_sum / 100/60;
    }
    return pefGroups.copy;
}
@end
