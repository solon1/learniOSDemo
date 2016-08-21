//
//  main.m
//  serverPortal
//
//  Created by solon on 16/8/21.
//  Copyright © 2016年 solon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "serverListener.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        serverListener *listener = [[serverListener alloc] init];
        [listener start];
        [[NSRunLoop mainRunLoop] run];
        
    }
    return 0;
}
