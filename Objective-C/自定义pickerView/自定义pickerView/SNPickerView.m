//
//  SNPickerView.m
//  自定义pickerView
//
//  Created by solon on 16/4/23.
//  Copyright © 2016年 solon. All rights reserved.
//

#import "SNPickerView.h"


#define SNScreenW ([UIScreen mainScreen].bounds.size.width)
#define SNScreenH ([UIScreen mainScreen].bounds.size.height)

@interface SNPickerView()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nullable, nonatomic, readwrite, strong) __kindof UIView *inputView NS_AVAILABLE_IOS(3_2);
@property (nullable, nonatomic, readwrite, strong) __kindof UIView *inputAccessoryView NS_AVAILABLE_IOS(3_2);




@end

@implementation SNPickerView

- (NSMutableArray<NSString *> *)currentSelectedData
{
    if (!_currentSelectedData) {
        _currentSelectedData = [NSMutableArray array];
    }
    return _currentSelectedData;
}

- (NSArray<NSArray *> *)components
{
    if (!_components) {
        _components = [NSArray array];
    }
    return _components;
}
//系统默认是NO所以需要重写此方法
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

//初始化inputView
- (UIPickerView *)inputView
{
    
    if (!_inputView) {
        
        UIPickerView *pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, SNScreenH - 200, SNScreenW, 200)];
        pickerView.delegate = self;
        pickerView.dataSource = self;
        self.rowHeight = 40;
        
        return pickerView;
    }
    return _inputView;
}

- (UIToolbar *)inputAccessoryView
{
    if (!_inputAccessoryView) {
        
        UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, SNScreenW, 44)];
        
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithTitle:@"确认" style:UIBarButtonItemStyleDone target:self action:@selector(submitAction:)];
        
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelAction:)];
        
        
        toolBar.items = @[barItem,spaceItem,cancelItem];
        
        return toolBar;
    }
    
    return _inputAccessoryView;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.components.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
        return self.components[component].count;
}

#pragma mark - UIPickerViewDelegate

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return SNScreenW / self.components.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return self.rowHeight;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.components[component][row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"selected row - %zd \n seleced component -- %zd",row,component);
    NSString *oneStr = [[NSString alloc]init];
    NSString *twoStr = [[NSString alloc]init];

    if (component == 0) {
        oneStr = self.components[0][row];
    }else if (component == 1) {
        twoStr = self.components[1][row];
    }
    if ([self.delegate respondsToSelector:@selector(pickerView:didSelectComponent:componentTwo:)]) {
        [self.delegate pickerView:self didSelectComponent:oneStr componentTwo:twoStr];
    }
    
}


#pragma mark - privateMethod

- (void)submitAction:(UIBarButtonItem *)submit
{
    if ([self.delegate respondsToSelector:@selector(pickerView:didClickSubmit:)]) {
        [self.delegate pickerView:self didClickSubmit:submit];
    }
    [self resignFirstResponder];
}


- (void)cancelAction:(UIBarButtonItem *)cancel
{
    [self resignFirstResponder];
}
@end
