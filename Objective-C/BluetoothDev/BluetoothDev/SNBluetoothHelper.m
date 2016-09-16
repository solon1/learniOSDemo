//
//  SNBluetoothHelper.m
//  BluetoothDev
//
//  Created by solon on 16/8/25.
//  Copyright © 2016年 solon. All rights reserved.
//

#import "SNBluetoothHelper.h"

static SNBluetoothHelper * shareManager;

@implementation SNBluetoothHelper

+ (instancetype)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[self alloc] init];
    });
    
    return shareManager;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        self.searchDevices = [NSMutableArray array];
    }
    
    return self;
}


#pragma mark - CBCentralManagerDelegate
//中心设备蓝牙状态监听
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    
    switch (central.state) {
        case CBCentralManagerStateUnknown:
            NSLog(@"CBCentralManagerStateUnknown");
            self.searchDevices = nil;
            self.connectStatus = NO;
            break;
        case CBCentralManagerStateResetting:
            NSLog(@"CBCentralManagerStateResetting");
            self.searchDevices = nil;
            self.connectStatus = NO;
            break;
        case CBCentralManagerStateUnsupported:
            NSLog(@"CBCentralManagerStateUnsupported");
            self.searchDevices = nil;
            self.connectStatus = NO;
            break;
        case CBCentralManagerStateUnauthorized:
            NSLog(@"CBCentralManagerStateUnauthorized");
            self.searchDevices = nil;
            self.connectStatus = NO;
            break;
        case CBCentralManagerStatePoweredOff:
            NSLog(@"CBCentralManagerStatePoweredOff");
            self.searchDevices = nil;
            self.connectStatus = NO;
            break;
        case CBCentralManagerStatePoweredOn:{
            NSLog(@"CBCentralManagerStatePoweredOn");
            /**
             *  用于扫描周边蓝牙外设
             *
             *  @param > 如果为nil将获取所有的蓝牙外设，一般根据外设的UUID指定
             *  如果扫描到蓝牙外设会调用代理方法didDiscoverPeripheral
             *  如果不指定服务会搜索到外设所有的服务
             *
             *  options : @{CBCentralManagerScanOptionAllowDuplicatesKey : @YES}; 如果为真会禁用系统的过滤，比较费电
             */
            [central scanForPeripheralsWithServices:nil options:nil];
            break;
            
        }
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    BOOL isContained = NO;
    
    for (CBPeripheral *cbPeripheral in self.searchDevices) {
        
        if ([cbPeripheral isEqual:peripheral]) {
            isContained = YES;
        }
    }
    
    
    if (!isContained) {
        [self.searchDevices addObject:peripheral];
    }
}


- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    self.connectStatus = YES;
    [self.manager stopScan];
    peripheral.delegate = self;
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
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error) {
        NSLog(@"discoverServices for : %@ with error %@",peripheral.name,error.localizedDescription);
        return;
    }
    
    self.currentAllServices = peripheral.services;
    
    for (CBService *service in peripheral.services) {
        if ([service.UUID.UUIDString isEqualToString:self.kServiceUUID]) {
            [peripheral discoverCharacteristics:nil forService:service];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (error) {
        NSLog(@"Error with discover characteristics - %@",error.localizedDescription);
        return;
    }
    
    self.currentAllCharacteristics = service.characteristics;
    for (CBCharacteristic *characteristic in service.characteristics) {
        
        if ([characteristic.UUID.UUIDString isEqualToString:self.kReadCharacteristicUUID]) {
            self.readCharacteristic = characteristic;
            [peripheral readValueForCharacteristic:characteristic];
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }else if ([characteristic.UUID.UUIDString isEqualToString:self.kWriteCharacteristicUUID]) {
            self.writeCharacteristic = characteristic;
            
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
}

- (void)writeValue:(NSData *)value
{
    if (!self.writeCharacteristic) {
        NSLog(@"not characteristic can be write");
        return;
    }
    if (self.writeCharacteristic.properties & CBCharacteristicPropertyWrite) {
        [self.connectedPeripheral writeValue:value forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithResponse];
        NSLog(@"characteristic UUID : %@ 写入成功",self.writeCharacteristic.UUID);
        
        
    }else {
        NSLog(@"characteristic %@ can't write",self.writeCharacteristic.UUID);
    }
}

#pragma mark - private method
- (void)connectToPeripheral:(CBPeripheral *)peripheral
{
    self.connectedPeripheral = peripheral;
    [shareManager connectToPeripheral:peripheral];
}

@end
