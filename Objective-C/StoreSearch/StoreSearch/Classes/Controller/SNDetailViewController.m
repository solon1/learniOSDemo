//
//  SNDetailViewController.m
//  StoreSearch
//
//  Created by solon on 16/6/11.
//  Copyright © 2016年 solon. All rights reserved.
//

#import "SNDetailViewController.h"
#import "SNSearchResult.h"
#import "SNGradientView.h"
#import "UIImageView+AFNetworking.h"
@interface SNDetailViewController ()<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *popupView;
@property (weak, nonatomic) IBOutlet UIImageView *artworkImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *kindLabel;
@property (weak, nonatomic) IBOutlet UILabel *genreLabel;
@property (weak, nonatomic) IBOutlet UIButton *priceButton;


@end

@implementation SNDetailViewController
{
    SNGradientView *_gradientView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.popupView.layer.cornerRadius = 10.0f;
    UIImage *image = [[UIImage imageNamed:@"PriceButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.priceButton setBackgroundImage:image forState:UIControlStateNormal];
    self.view.tintColor = [UIColor colorWithRed:20/255.0f green:160/255.0f blue:160/255.0f alpha:1.0];
    //添加手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(close:)];
    tapGesture.cancelsTouchesInView = NO;
    tapGesture.delegate = self;
    
    [self.view addGestureRecognizer:tapGesture];
    // Do any additional setup after loading the view from its nib.
}


- (IBAction)openInStore:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.searchResult.storeURL]];
}

#pragma mark - 手势代理方法
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return (touch.view == self.view);
}

- (void)setSearchResult:(SNSearchResult *)searchResult
{
    _searchResult = searchResult;
    
    [self.artworkImageView setImageWithURL:[NSURL URLWithString:searchResult.artworkURL100] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
    self.nameLabel.text = searchResult.name;
    NSString *artistName = searchResult.artistName;
    if (searchResult.artistName == nil) {
        artistName = @"Unknow";
    }
    self.artistNameLabel.text = artistName;
    self.kindLabel.text = searchResult.kind;
    self.genreLabel.text = searchResult.genre;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setCurrencyCode:searchResult.currency];
    NSString *priceText;
    
    if ([searchResult.price floatValue] == 0.0f) {
        priceText = @"Free";
    }else {
        priceText = [formatter stringFromNumber:searchResult.price];
    }
    [self.priceButton setTitle:priceText forState:UIControlStateNormal];
}

- (IBAction)close:(UIButton *)sender {
    
    [self dismissFromParentViewController];
}

- (void)dismissFromParentViewController
{
    [self willMoveToParentViewController:nil];
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect rect = self.view.bounds;
        rect.origin.y += rect.size.height;
        self.view.frame = rect;
        _gradientView.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        [_gradientView removeFromSuperview];
    }];
    
}

- (void)presentInParentViewController:(UIViewController *)parentViewController
{
    _gradientView = [[SNGradientView alloc]initWithFrame:self.view.bounds];

    self.view.frame = parentViewController.view.bounds;
    [parentViewController.view addSubview:_gradientView];
    [parentViewController.view addSubview:self.view];
    [parentViewController addChildViewController:self];
    //渐变动画
    CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnimation.duration = 0.2f;
    fadeAnimation.fromValue = @0.0f;
    fadeAnimation.toValue = @1.0f;
    [_gradientView.layer addAnimation:fadeAnimation forKey:@"fadeAnimation"];
    
    
    //添加关键帧动画
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    bounceAnimation.duration = 0.4;
    bounceAnimation.delegate = self;
    
    bounceAnimation.values = @[@0.7,@1.2,@0.9,@1.0];
    bounceAnimation.keyTimes = @[@0.0,@0.334,@0.666,@1.0];
    
    bounceAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    [self.view.layer addAnimation:bounceAnimation forKey:@"bounceAnimation"];
    
    
    
    
//    [self didMoveToParentViewController:parentViewController];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self didMoveToParentViewController:self.parentViewController];
}

- (void)dealloc
{
    [self.artworkImageView cancelImageDownloadTask];
}


@end
