//
//  SNAudioSession.m
//  DecodeAudio
//
//  Created by solon on 16/7/15.
//  Copyright © 2016年 solon. All rights reserved.
//

#import "SNAudioSession.h"
#import <AudioToolbox/AudioToolbox.h>

NSString *const SNAudioSessionRouteChangeNotification = @"SNAudioSessionRouteChangeNotification";
NSString *const SNAudioSessionRouteChangeReason = @"SNAudioSessionRouteChangeReason";
NSString *const SNAudioSessionInterruptionNotification = @"SNAudioSessionInterruptionNotification";
NSString *const SNAudioSessionInterruptionStateKey = @"SNAudioSessionInterruptionStateKey";
NSString *const SNAudioSessionInterruptionTypeKey = @"SNAudioSessionInterruptionTypeKey";

@implementation SNAudioSession

//音频中断回调方法,传入的参数一个附带对象，一个中断状态值
static void SNAudioSessionInterruptionListener(void *inClientData, UInt32 inInterruptionState){
    
    AudioSessionInterruptionType interruptionType = kAudioSessionInterruptionType_ShouldNotResume;
    UInt32 interruptionTypeSize = sizeof(interruptionType);
    
    AudioSessionGetProperty(kAudioSessionProperty_InterruptionType, &interruptionTypeSize, &interruptionType);
    
    NSDictionary *userInfo = @{SNAudioSessionInterruptionStateKey : @(inInterruptionState),SNAudioSessionInterruptionTypeKey : @(interruptionType)};
    
    __unsafe_unretained SNAudioSession *audioSession = (__bridge SNAudioSession *)inClientData;
    [[NSNotificationCenter defaultCenter] postNotificationName:SNAudioSessionInterruptionNotification object:audioSession userInfo:userInfo];
}

//监听耳机插拔RouteChange
static void SNAudioSessionRouteChangeListener(void *inClientData,AudioSessionPropertyID InPropertyID,UInt32 inPropertyValueSize, const void *inPropertyValue){
    
    if (InPropertyID != kAudioSessionProperty_AudioRoute) {
        return;
    }
    CFDictionaryRef routeChangeDictionary = inPropertyValue;
    CFNumberRef routeChangeReasonRef = CFDictionaryGetValue(routeChangeDictionary, CFSTR(kAudioSession_AudioRouteChangeKey_Reason));
    UInt32 routeChangeReason;
    CFNumberGetValue(routeChangeReasonRef, kCFNumberSInt32Type, &routeChangeReason);
    
    NSDictionary *userInfo = @{SNAudioSessionRouteChangeNotification : @(routeChangeReason)
                               };
    __unsafe_unretained SNAudioSession *audioSession = (__bridge SNAudioSession *)inClientData;
    [[NSNotificationCenter defaultCenter] postNotificationName:SNAudioSessionRouteChangeNotification object:audioSession userInfo:userInfo];
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static SNAudioSession *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc]init];
    });
    
    return sharedInstance;
}

//音频对话初始化

- (instancetype)init
{
    if (self = [super init]) {
        [self initializeAudioSession];
    }
    return self;
}

- (void)dealloc
{
    AudioSessionRemovePropertyListenerWithUserData(kAudioSessionProperty_AudioRouteChange, SNAudioSessionRouteChangeListener, (__bridge void *)self);
}



#pragma mark - privateMethod

- (void)initializeAudioSession
{
    /**
     *  前两个参数表示AudioSession运行在主线程,第三个是中断回调方法，第四个是中断时附带的对象
     */
    AudioSessionInitialize(NULL, NULL, SNAudioSessionInterruptionListener, (__bridge void*)self);
    //耳机插拔监听
    AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange, SNAudioSessionRouteChangeListener, (__bridge void*)self);
    
}


@end
