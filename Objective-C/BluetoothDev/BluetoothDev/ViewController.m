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

    
    _peripherals = [NSMutableArray array];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - buttonAction
- (IBAction)blueToothAction:(UIButton *)sender {
    
        _SNCentralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];

}

#pragma mark - CBCentralManagerDelegate
//中心设备蓝牙状态监听
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    
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
        case CBCentralManagerStatePoweredOn:{
            NSLog(@"CBCentralManagerStatePoweredOn");
            /**
             *  用于扫描周边蓝牙外设
             *
             *  @param > 如果为nil将获取所有的蓝牙外设，一般根据外设的UUID指定
             *  如果扫描到蓝牙外设会调用代理方法didDiscoverPeripheral
             */
            [_SNCentralManager scanForPeripheralsWithServices:nil options:nil];
            break;
            
        }
    }
}


- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    //每扫描到一个蓝牙外设就会返回peripheral，如果找到想要的设备
    //调用[myCentralManager stopScan];停止扫描节约性能
//    if ([peripheral.name hasPrefix:@"i"]) {//扫描到想要的设备请求连接
//        NSLog(@"包含Y字符串的外设");
//        
//        [self.peripherals addObject:peripheral];
//
//        [_SNCentralManager connectPeripheral:peripheral options:@{CBConnectPeripheralOptionNotifyOnNotificationKey : @(YES)}];//连接成功后调用此方法didConnectPeripheral
//    }

    /**
     *  查看是否每次连接外设的名字，identifier ，UUID会变化
     名字YQ1602002032
     identifier：<__NSConcreteUUID 0x155e14510> 31759B9D-3C75-6D88-0FB9-E5A101768355
     UUID ：三个服务 battery device information
     
     */
    
    [self.peripherals addObject:peripheral];
    [central connectPeripheral:peripheral options:nil];
    NSLog(@"peripheral name :%@ \n peripheral identifier : %@",peripheral.name,peripheral.identifier);
}

#pragma mark - 蓝牙连接状态
//蓝牙链接成功后回调
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    //处理蓝牙外设的数据设置代理
    peripheral.delegate = self;
    NSLog(@"连接到设备名为%@ -- 成功",peripheral.name);
    //发现外设服务回调peripheral:didDiscoverServices:
    [peripheral discoverServices:nil];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"连接到设备名为%@ -- 失败 原因:%@",peripheral.name,error.localizedDescription);
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
        NSLog(@"连接到设备名为%@ -- 断开连接 原因:%@",peripheral.name,error.localizedDescription);
}

#pragma mark - CBPeripheralDelegate
//发现服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error) {
        NSLog(@"discoverServices for : %@ with error %@",peripheral.name,error.localizedDescription);
        return;
    }
    
    for (CBService *service in peripheral.services) {
        NSLog(@"uuid - %@",service.UUID);
        //根据服务发现特征回调peripheral:didDiscoverCharacteristicsForService:error:
        [peripheral discoverCharacteristics:nil forService:service];
    }
    
}

//发现特征
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (error) {
        NSLog(@"error discovered characteristic serviceUUID : %@ with error %@",service.UUID,error.localizedDescription);
        return;
    }
    
    for (CBCharacteristic *characteristic in service.characteristics) {
        NSLog(@"service : %@ 的 characteristic : %@",service.UUID,characteristic.UUID);
        //读取characteristic 如果读取到会进入代理方法
        //peripheral:didUpdateValueForCharacteristic:error:
        [peripheral readValueForCharacteristic:characteristic];
        
        //发现characteristic的descriptors 发现后会调用代理方法
        //peripheral:didDiscoverDescriptorsForCharacteristic:error:
        [peripheral discoverDescriptorsForCharacteristic:characteristic];
    }
}


//读取characteristic的值
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"read characteristic erro : %@",error.localizedDescription);
        return;
    }
    NSLog(@"read data length - %zd  uuid : %@ value is - %@",characteristic.value.length,characteristic.UUID,characteristic.value);
}

//写数据
- (void)peripheral:(CBPeripheral *)peripheral writeValueForCharacteristic:(CBCharacteristic *)characteristic value:(NSData *)value
{
    //首先判断characteristic是否有读写权限
    /**
     typedef NS_OPTIONS(NSUInteger, CBCharacteristicProperties) {
     CBCharacteristicPropertyBroadcast												= 0x01,
     CBCharacteristicPropertyRead													= 0x02,
     CBCharacteristicPropertyWriteWithoutResponse									= 0x04,
     CBCharacteristicPropertyWrite													= 0x08,
     CBCharacteristicPropertyNotify													= 0x10,
     CBCharacteristicPropertyIndicate												= 0x20,
     CBCharacteristicPropertyAuthenticatedSignedWrites								= 0x40,
     CBCharacteristicPropertyExtendedProperties										= 0x80,
     CBCharacteristicPropertyNotifyEncryptionRequired NS_ENUM_AVAILABLE(NA, 6_0)		= 0x100,
     CBCharacteristicPropertyIndicateEncryptionRequired NS_ENUM_AVAILABLE(NA, 6_0)	= 0x200
     };
     */
    
    if (characteristic.properties & CBCharacteristicPropertyWrite) {
        [peripheral writeValue:value forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    }else {
        NSLog(@"characteristic %@ can't write",characteristic.UUID);
    }
}

//发现characteristic的descriptors
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"discover descriptors error - %@",error.localizedDescription);
        return;
    }
    for (CBDescriptor *d in characteristic.descriptors) {
        NSLog(@"characteristic uuid: %@ \n descriptor uuid : %@",characteristic.UUID,d.UUID);
    }
}
@end
