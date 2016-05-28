//
//  AppDelegate.h
//  StoreSearch
//
//  Created by solon on 16/5/28.
//  Copyright © 2016年 solon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNSearchViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
/** 搜索控制器 */
@property (nonatomic,strong) SNSearchViewController *searchContrller;

@end

