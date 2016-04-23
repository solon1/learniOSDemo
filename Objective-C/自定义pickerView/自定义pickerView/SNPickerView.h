//
//  SNPickerView.h
//  自定义pickerView
//
//  Created by solon on 16/4/23.
//  Copyright © 2016年 solon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SNPickerView;

@protocol SNPickerViewDelegate <NSObject>

@optional
- (void)pickerView:(SNPickerView *)pickerView didClickSubmit:(UIBarButtonItem *)submit;

//默认为2个component并通过代理传值
- (void)pickerView:(SNPickerView *)pickerView didSelectComponent:(NSString *)one componentTwo:(NSString *)two;

@end

@interface SNPickerView : UIView

/** 接收外部传入的数据,数组大小代表需要分几块展示数据 */
@property (nonatomic,strong) NSArray<NSArray*> *components;

/** picker的rowheight */
@property (nonatomic,assign) CGFloat rowHeight;

/** 选择row返回的数组数据 */
@property (nonatomic,strong) NSMutableArray<NSString*> *currentSelectedData;

/** delegate */
@property (nonatomic,weak) id<SNPickerViewDelegate> delegate;

@end
