//
//  serverListener.m
//  serverPortal
//
//  Created by solon on 16/8/21.
//  Copyright © 2016年 solon. All rights reserved.
//

#import "serverListener.h"
#import "GCDAsyncSocket.h"


@interface serverListener()<GCDAsyncSocketDelegate>

@property (nonatomic,strong) GCDAsyncSocket *serverSocket;
@property (nonatomic,strong) NSMutableArray *clientSockets;

@end
@implementation serverListener

- (NSMutableArray *)clientSockets
{
    if (!_clientSockets) {
        _clientSockets = [NSMutableArray array];
    }
    return _clientSockets;
}



- (void)stop
{
    
}

- (void)start
{
    //创建socket对象
    GCDAsyncSocket *serverSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
    self.serverSocket = serverSocket;
    //绑定并监听
    NSError *error = nil;
    //调用下面方法如果成功会回调代理方法socket:didAcceptNewSocket:
    [serverSocket acceptOnPort:5388 error:&error];
    if (error) {
        NSLog(@"端口号冲突 %@",error.localizedDescription);
    }else {
        NSLog(@"服务端启动成功");
    }
}

- (void)socket:(GCDAsyncSocket *)serverSocket didAcceptNewSocket:(GCDAsyncSocket *)clientSocket
{
    //连接后将客户端保存起来
    [self.clientSockets addObject:clientSocket];
    
    //读取客户端数据
    [clientSocket readDataWithTimeout:-1 tag:0];
}


- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSLog(@"读取到数据 - datalength - %zd",data.length);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMdd";
    
    NSString *path = [@"/Users/solon/Desktop/Temp" stringByAppendingPathComponent:[formatter stringFromDate:[NSDate date]]];
    [data writeToFile:path atomically:YES];
}
@end
