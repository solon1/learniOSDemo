//
//  ViewController.m
//  自定义pickerView
//
//  Created by solon on 16/4/23.
//  Copyright © 2016年 solon. All rights reserved.
//

#import "ViewController.h"
#import "SNPickerView.h"

#define SNScreenW ([UIScreen mainScreen].bounds.size.width)
#define SNScreenH ([UIScreen mainScreen].bounds.size.height)


@interface ViewController ()<SNPickerViewDelegate>

@property (nonatomic,weak) SNPickerView *pickerView;
/** showLabel */
@property (nonatomic,weak) UILabel *showLabel;

/** one */
@property (nonatomic,strong) NSString *one;
/** two */
@property (nonatomic,strong) NSString *two;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SNPickerView *picker = [[SNPickerView alloc]initWithFrame:CGRectMake(0, 300, SNScreenW, 44)];
    
    NSMutableArray *hourArray = [NSMutableArray array];
    NSMutableArray *minuteArray = [NSMutableArray array];
    
    for (int i = 1; i < 25; i++) {
        NSString *hour = [NSString stringWithFormat:@"%zd",i];
        [hourArray addObject:hour];
    }
    
    for (int i = 1; i < 61; i++) {
        NSString *minute = [NSString stringWithFormat:@"%zd",i];
        [minuteArray addObject:minute];
    }
    
    picker.delegate = self;
    picker.components = @[hourArray.copy,minuteArray.copy];
    picker.rowHeight = 40;
    
    UILabel *tipsLabel = [[UILabel alloc]init];
    tipsLabel.text = @"pickerView";
    [tipsLabel sizeToFit];
    tipsLabel.center = picker.center;
    
    picker.backgroundColor = [UIColor yellowColor];
    
    
    //将pickerView的值显示在label上
    UILabel *showLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, SNScreenW, 20)];
    showLabel.backgroundColor = [UIColor lightGrayColor];
    self.showLabel = showLabel;
    //给pickerView添加手势
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pickerViewTaped)];
    
    [picker addGestureRecognizer:tap];
    
    self.pickerView = picker;
    [self.view addSubview:picker];
    [self.view addSubview:tipsLabel];
    [self.view addSubview:showLabel];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - pickerViewDelegate

- (void)pickerView:(SNPickerView *)pickerView didClickSubmit:(UIBarButtonItem *)submit
{
    
    NSLog(@"submit");

}


- (void)pickerView:(SNPickerView *)pickerView didSelectComponent:(NSString *)one componentTwo:(NSString *)two inComponent:(NSInteger)component
{
    //无法同时传递2个值?????   WTF????
    if (component == 0) {
        self.one = one;
    }else{
        
        self.two = two;
    }

    
    self.showLabel.text = [NSString stringWithFormat:@"%@ -- %@",self.one,self.two];
}

- (void)pickerViewTaped
{
    [self.pickerView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
