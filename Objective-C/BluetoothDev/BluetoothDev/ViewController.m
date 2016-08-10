//
//  ViewController.m
//  BluetoothDev
//
//  Created by solon on 16/8/9.
//  Copyright © 2016年 solon. All rights reserved.
//

#import "ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface ViewController ()<CBCentralManagerDelegate,CBPeripheralDelegate>

@property (nonatomic,strong) CBCentralManager *SNCentralManager;
@property (nonatomic,strong) NSMutableArray<CBPeripheral *> *peripherals;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _SNCentralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
    

    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - buttonAction
- (IBAction)blueToothAction:(UIButton *)sender {
    
    /**
     *  用于扫描周边蓝牙外设
     *
     *  @param > 如果为nil将获取所有的蓝牙外设，一般根据外设的UUID指定
     *  如果扫描到蓝牙外设会调用代理方法didDiscoverPeripheral
     */
    [_SNCentralManager scanForPeripheralsWithServices:nil options:nil];

}


#pragma mark - CBCentralManagerDelegate
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    //每扫描到一个蓝牙外设就会返回peripheral，如果找到想要的设备
    //调用[myCentralManager stopScan];停止扫描节约性能
    if ([peripheral.name hasPrefix:@"s"]) {//扫描到想要的设备请求连接
        
        [self.peripherals addObject:peripheral];
        [_SNCentralManager connectPeripheral:peripheral options:nil];//连接成功后调用此方法didConnectPeripheral
    }
    NSLog(@"%@",peripheral.name);
}

#pragma mark - 蓝牙连接状态
//蓝牙链接成功后回调
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    //处理蓝牙外设的数据设置代理
    peripheral.delegate = self;
    NSLog(@"连接到设备名为%@ -- 成功",peripheral.name);
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"连接到设备名为%@ -- 失败 原因:%@",peripheral.name,error.localizedDescription);
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
        NSLog(@"连接到设备名为%@ -- 断开连接 原因:%@",peripheral.name,error.localizedDescription);
}



//中心设备蓝牙状态监听
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    /**
     CBCentralManagerStateUnknown = 0,
     CBCentralManagerStateResetting,
     CBCentralManagerStateUnsupported,
     CBCentralManagerStateUnauthorized,
     CBCentralManagerStatePoweredOff,
     CBCentralManagerStatePoweredOn,
     */
    switch (central.state) {
        case CBCentralManagerStateUnknown:
            NSLog(@"CBCentralManagerStateUnknown");
            break;
        case CBCentralManagerStateResetting:
            NSLog(@"CBCentralManagerStateResetting");
            break;
        case CBCentralManagerStateUnsupported:
            NSLog(@"CBCentralManagerStateUnsupported");
            break;
        case CBCentralManagerStateUnauthorized:
            NSLog(@"CBCentralManagerStateUnauthorized");
            break;
        case CBCentralManagerStatePoweredOff:
            NSLog(@"CBCentralManagerStatePoweredOff");
            break;
        case CBCentralManagerStatePoweredOn:
            NSLog(@"CBCentralManagerStatePoweredOn");
            break;
    }
}

@end
