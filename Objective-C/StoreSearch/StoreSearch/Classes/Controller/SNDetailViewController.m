//
//  SNDetailViewController.m
//  StoreSearch
//
//  Created by solon on 16/6/11.
//  Copyright © 2016年 solon. All rights reserved.
//

#import "SNDetailViewController.h"
#import "SNSearchResult.h"
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
    
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void)dealloc
{
    [self.artworkImageView cancelImageDownloadTask];
}


@end
