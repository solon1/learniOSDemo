//
//  ViewController.m
//  ClientPortal
//
//  Created by solon on 16/8/21.
//  Copyright © 2016年 solon. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncSocket.h"

@interface ViewController ()<GCDAsyncSocketDelegate>

@property (weak, nonatomic) IBOutlet UILabel *connectStatusLabel;
@property (nonatomic,strong) GCDAsyncSocket *clientSocket;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)connectAction:(UIButton *)sender {
    self.clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *error = nil;
    
    [self.clientSocket connectToHost:@"127.0.0.1" onPort:5388 error:&error];
    if (error) {
        NSLog(@"发送连接请求 失败 %@",error.localizedDescription);
    }else {
        NSLog(@"发送连接请求 成功");
    }
}

#pragma mark - GCDAsyncSocketDelegate
//如果连接成功
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    self.connectStatusLabel.text = @"连接";
    self.connectStatusLabel.textColor = [UIColor greenColor];
    //连接成功后可以读取数据
    [sock readDataWithTimeout:-1 tag:0];
}

//连接失败
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    self.connectStatusLabel.text = @"未连接";
    self.connectStatusLabel.textColor = [UIColor redColor];
}
//读取服务端响应数据
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{

    
}

- (IBAction)sendImageAction:(UIButton *)sender {
    
    NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"imageTest"], 1.0f);
    [self.clientSocket writeData:imageData withTimeout:-1 tag:0];
}


- (IBAction)sendTextAction:(UIButton *)sender {
}

@end
