//
//  ViewController.m
//  录音Record
//
//  Created by solon on 16/7/1.
//  Copyright © 2016年 solon. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>


@interface ViewController ()<AVAudioRecorderDelegate>

@property (weak, nonatomic) IBOutlet UILabel *receivedLabel;

/** 录音声波监控定时器 */
@property (nonatomic,strong) NSTimer *timer;

/** 录音对象 */
@property (nonatomic,strong) AVAudioRecorder *audioRecorder;
/** 播放对象 */
@property (nonatomic,strong) AVAudioPlayer *audioPlayer;

@end

@implementation ViewController


#pragma mark - lazyloading
//使用懒加载创建录音机对象

- (AVAudioRecorder *)audioRecorder
{
    if (!_audioRecorder) {
        
        //录音保存路径
        NSString *recordPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        
//        NSURL *url = [NSURL URLWithString:[recordPath stringByAppendingPathComponent:@"record.caf"]];
        
        NSURL *url = [NSURL URLWithString:@"/Users/solon/Desktop/record.caf"];
        NSError *error = nil;
//        设置 
        NSMutableDictionary *settings = [NSMutableDictionary dictionary];
        //设置录音格式
        [settings setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
        //设置录音的采样率
        [settings setObject:@(8000) forKey:AVSampleRateKey];
        //设置音频通道
        [settings setObject:@(1) forKey:AVNumberOfChannelsKey];
        //设置每个采样点 one of: 8, 16, 24, 32 */
        [settings setObject:@(8) forKey:AVLinearPCMBitDepthKey];
        //设置是否使用浮点数采样
        [settings setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
        
        
        _audioRecorder = [[AVAudioRecorder alloc]initWithURL:url settings:settings error:&error];
        //设置代理
        _audioRecorder.delegate = self;
        //设置是否声波监控
        _audioRecorder.meteringEnabled = YES;
        
        if (error) {
            NSLog(@"录音发生错误 error : %@",error.localizedDescription);
            return nil;
        }
        
    }
    
    return _audioRecorder;
}

- (NSTimer *)timer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(audioPowerChange) userInfo:nil repeats:YES];
    }
    
    return _timer;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - privateMethod

- (void)audioPowerChange
{
    [self.audioRecorder updateMeters];
    float power = [self.audioRecorder averagePowerForChannel:0];
    NSLog(@"power - - %f",power + 160.0);
    self.receivedLabel.text = [NSString stringWithFormat:@"%.1f",power + 160.0];
}

//设置音频会话
- (void)setAudioSession
{
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    NSError *error = nil;
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    [audioSession setActive:YES error:&error];
    
    if (error) {
        NSLog(@"error -- %@",error.description);
    }
    
}

#pragma mark - UI事件
- (IBAction)startRecordAction:(UIButton *)sender {
    
    //首先判断是否正在录音
    if (![self.audioRecorder isRecording]) {
        [self.audioRecorder record];
        self.timer.fireDate = [NSDate distantPast];//打开定时器
    }
}
- (IBAction)stopRecordAction:(UIButton *)sender {
    
    [self.audioRecorder stop];
}
- (IBAction)resumeRecordAction:(UIButton *)sender {
}

- (IBAction)pauseRecordAction:(UIButton *)sender {
}


@end
