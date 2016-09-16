//
//  SNBluetoothHelper.h
//  BluetoothDev
//
//  Created by solon on 16/8/25.
//  Copyright © 2016年 solon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface SNBluetoothHelper : NSObject<CBCentralManagerDelegate,CBPeripheralDelegate>

@property (nonatomic,strong) CBCentralManager *manager;
@property (nonatomic,strong) CBPeripheral *connectedPeripheral;
@property (nonatomic,strong) CBCharacteristic *writeCharacteristic;
@property (nonatomic,strong) CBCharacteristic *readCharacteristic;
@property (nonatomic,strong) NSArray *currentAllServices;
@property (nonatomic,strong) NSArray *currentAllCharacteristics;
@property (nonatomic,strong) NSMutableArray *searchDevices;

@property (nonatomic,strong) NSString *kServiceUUID;
@property (nonatomic,strong) NSString *kReadCharacteristicUUID;
@property (nonatomic,strong) NSString *kWriteCharacteristicUUID;

@property (nonatomic,assign) BOOL connectStatus;


+ (instancetype)shareManager;

- (void)scanForPeripheral;
- (void)stopScanForPeripheral;
- (void)connectToPeripheral:(CBPeripheral *)peripheral;
- (void)writeValue:(NSData *)value;

@end
