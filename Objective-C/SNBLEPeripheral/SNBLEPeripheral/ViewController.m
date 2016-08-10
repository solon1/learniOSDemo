//
//  ViewController.m
//  SNBLEPeripheral
//
//  Created by solon on 16/8/9.
//  Copyright © 2016年 solon. All rights reserved.
//

#import "ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>

static NSString * const characteristicUUID1Str = @"1268B306-8BFD-472F-BC93-2F0CB687889F";
static NSString * const characteristicUUID2Str = @"A34A239B-B911-460D-99A3-6A91C56622A5";
static NSString * const serviceUUIDStr = @"519ADA84-E427-4E55-BBF5-517B49BDBDE8";

@interface ViewController ()<CBPeripheralManagerDelegate>

@property (nonatomic,strong) CBPeripheralManager *peripheralManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //蓝牙外设打开成功后会进入代理方法更新状态
    
    _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - CBPeripheralDelegate

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    switch (peripheral.state) {
        case CBPeripheralManagerStateUnknown:
            NSLog(@"CBPeripheralManagerStateUnknown");
            break;
        case CBPeripheralManagerStateResetting:
            NSLog(@"CBPeripheralManagerStateResetting");
            break;
        case CBPeripheralManagerStateUnsupported:
            NSLog(@"CBPeripheralManagerStateUnsupported");
            break;
        case CBPeripheralManagerStateUnauthorized:
            NSLog(@"CBPeripheralManagerStateUnauthorized");
            break;
        case CBPeripheralManagerStatePoweredOff:
            NSLog(@"CBPeripheralManagerStatePoweredOff");
            break;
        case CBPeripheralManagerStatePoweredOn:{
            NSLog(@"CBPeripheralManagerStatePoweredOn");
            NSLog(@"设备已经打开可以进行连接");
            [self setup];
        }
            break;
    }
    
}

//发布服务到本地数据库回调
- (void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error
{
    NSLog(@"add service");
    if (error) {
        NSLog(@"publish error - %@",error.localizedDescription);
    }
}
//开始发布广播回调
- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error
{
    NSLog(@"start Advertising");
    if (error) {
        NSLog(@"advertising error - %@",error.localizedDescription);
    }
}


#pragma mark - privateMethod
- (void)setup{
    //特征的uuid
    //这里设置外设服务和特征为一个树状结构，2个特征一个主服务
    
    CBUUID *characteristicUUID1 = [CBUUID UUIDWithString:characteristicUUID1Str];
    CBUUID *characteristicUUID2 = [CBUUID UUIDWithString:characteristicUUID2Str];
    /**
     创建特征
     
     value因为服务被缓存后为只读，设置nil在后面可以动态写入内容
     */
    CBMutableCharacteristic *characteristic1 = [[CBMutableCharacteristic alloc] initWithType:characteristicUUID1 properties:CBCharacteristicPropertyRead value:nil permissions:CBAttributePermissionsReadable];
    CBMutableCharacteristic *characteristic2 = [[CBMutableCharacteristic alloc] initWithType:characteristicUUID2 properties:CBCharacteristicPropertyWrite value:nil permissions:CBAttributePermissionsWriteable];
    //服务的UUID
    CBUUID *serviceUUID = [CBUUID UUIDWithString:serviceUUIDStr];
    CBMutableService *service = [[CBMutableService alloc] initWithType:serviceUUID primary:YES];
    //将上面创建的特征添加到服务中
    service.characteristics = @[characteristic1,characteristic2];
    //创建好服务后需要将服务发布到本地数据库中
    //发布同时会调用代理方法peripheralManager:didAddService:error:
    [_peripheralManager addService:service];
    
    //将服务广播给有兴趣的central端,字典内只包含两个值
    //这里添加多个服务UUID为一个数组，如果只传单个会报错
    //当开始广播数据回调代理方法peripheralManagerDidStartAdvertising:error:
    NSDictionary *advertisingDic = @{
                                     CBAdvertisementDataLocalNameKey : @"SolonPu",
                                     CBAdvertisementDataServiceUUIDsKey : @[service.UUID]
                                     };
    [_peripheralManager startAdvertising:advertisingDic];
    
}


@end
