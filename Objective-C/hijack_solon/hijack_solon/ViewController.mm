//
//  ViewController.m
//  hijack_solon
//
//  Created by solon on 16/6/24.
//  Copyright © 2016年 solon. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "HiJackMgr.h"


@interface ViewController ()<HiJackDelegate>
@property (retain, nonatomic) IBOutlet UILabel *receiveDataLabel;

@end

@implementation ViewController{
    HiJackMgr *_hiJackMgr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _hiJackMgr = [[HiJackMgr alloc]init];
    [_hiJackMgr setDelegate:self];
//    [self setupAVSession];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)jumpToHiJack:(id)sender {
        [self.navigationController pushViewController:_hiJackMgr animated:YES];
    
}


- (int)receive:(UInt8)data
{

    NSLog(@"RECEIVE:%d",(data > 127 ? 1 : 0));
    return 0;
}

- (void)setupAVSession
{
//    AVAudioSession *session = [AVAudioSession sharedInstance];
//    
//    NSError *error = nil;
//    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
