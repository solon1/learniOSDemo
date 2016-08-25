//
//  ViewController.m
//  BluetoothDev
//
//  Created by solon on 16/8/9.
//  Copyright © 2016年 solon. All rights reserved.
//

#import "ViewController.h"
#import "SGHolderDetectedResult.h"
#import <CoreBluetooth/CoreBluetooth.h>

static NSString * const sixHundredValues = @"1I1P1W242C2L2V373M424J515I606G6U767H7Q7Z888H8P8Y969B9F9I9L9O9Q9R9S9S9S9S9R9R9Q9P9P9P9P9P9P9P9O9P9P9P9P9O9O9O9O9O9O9O9O9O9P9P9P9P9P9P9P9P9P9P9P9P9P9P9P9P9P9P9P9Q9Q9Q9Q9Q9Q9P9P9P9P9P9P9P9O9N9M9L9J9I9F9D9A95918W8P8H81755P3W28130G07000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";

@interface ViewController ()<CBCentralManagerDelegate,CBPeripheralDelegate>

@property (nonatomic,strong) CBCentralManager *SNCentralManager;
@property (nonatomic,strong) NSMutableArray<CBPeripheral *> *peripherals;
@property (weak, nonatomic) IBOutlet UILabel *receivedLabel;
@property (weak, nonatomic) IBOutlet UITextField *writeDataTextField;
@property (nonatomic,strong) CBCharacteristic *characteristic;
@property (nonatomic,strong) NSMutableString *allReceivedValues;

@property (nonatomic,strong) NSMutableArray *pefGroups;

@end

@implementation ViewController



- (IBAction)sendAction:(UIButton *)sender {
    
    NSString *valueStr = self.writeDataTextField.text;
    NSData *value = [NSData dataWithBytes:[valueStr UTF8String] length:valueStr.length];
    CBPeripheral *peripheral = self.peripherals.firstObject;
    [self peripheral:peripheral writeValueForCharacteristic:self.characteristic value:value];
    
}

- (NSMutableArray *)pefGroups
{
    if (!_pefGroups) {
        _pefGroups = [NSMutableArray array];
    }
    return _pefGroups;
}

- (NSMutableString *)allReceivedValues
{
    if (!_allReceivedValues) {
        _allReceivedValues = [[NSMutableString alloc] init];
    }
    return _allReceivedValues;
}

//保存检测人检测结果
//void saveHolderDetectedGrap(HolderDetectedResult holderDetectedResult) throws Exception {
//    //转为字符串
//    String str_grap =holderDetectedResult.getPefGrap();
//
//    //字符串有值
//    if(!StringUtils.isEmpty(str_grap)){
//        //
//        List<HolderDetectedGrap>  graplst=new ArrayList<HolderDetectedGrap>();
//        HolderDetectedGrap  obj_grap=null;
//        BigDecimal fvc=null;
//        int pef_value=0;
//        int pef_value_sum=0;
//        int step = ('9' - '0' + 1) + ('Z' - 'A' + 1);//进制数36
//        char ch,ch2;
//        long starttime=new Date().getTime();
//        for(int i=0;i<str_grap.length()/2;i++ ){
//            ch=str_grap.charAt(i*2);
//            if(ch > '9'){
//                ch -= 'A' - ('9' + 1);
//            }
//            ch2=str_grap.charAt(i*2+1);
//            if(ch2 > '9'){
//                ch2 -= 'A' - ('9' + 1);
//            }
//            //把字符串进制转换为 数字
//            pef_value	=(ch- '0') * step + (ch2-'0');
//
//            pef_value_sum+=pef_value;
//
//            obj_grap=new HolderDetectedGrap();
//            obj_grap.setDetectedDate(holderDetectedResult.getDetectedDate());
//            obj_grap.setPefValue(BigDecimal.valueOf(pef_value));
//            obj_grap.setOrder(i+1);
//
//            fvc = new BigDecimal(Double.valueOf(pef_value_sum)/100/60)
//            .setScale(4, BigDecimal.ROUND_HALF_UP);//后面是保留4位小数四舍五入
//
//            obj_grap.setFvcValue(fvc);//pef/100/60
//            graplst.add(obj_grap);
//        }
//
//        holderDetectedResult.setDetectedGraps(graplst);
//
//        detectedResultDao.merge(holderDetectedResult);
//        System.out.println("saveHolderDetectedGrap use time :"+(new Date().getTime()-starttime)/1000);
//    }
//}



- (void)viewDidLoad {
    [super viewDidLoad];
//    SGHolderDetectedResult *result = [[SGHolderDetectedResult alloc] init];
//    result.pefGroup = sixHundredValues;
//    NSLog(@"hhhh \n%@",result.pefGroups);
    

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
    if ([peripheral.name containsString:@"B1163"]) {
        
        [central connectPeripheral:peripheral options:nil];
        NSLog(@"peripheral name :%@ \n peripheral identifier : %@",peripheral.name,peripheral.identifier.UUIDString);
    }
}

#pragma mark - 蓝牙连接状态
//蓝牙链接成功后回调
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    //处理蓝牙外设的数据设置代理
    peripheral.delegate = self;
    NSLog(@"连接到设备名为%@ -- 成功",peripheral.name);
    [central stopScan];//连接到设备停止扫描设备
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
        NSLog(@"uuid - %@",service.UUID.UUIDString);
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
        NSLog(@"service : %@ 的 characteristic : %@",service.UUID.UUIDString,characteristic.UUID.UUIDString);
        //读取characteristic 如果读取到会进入代理方法
        //peripheral:didUpdateValueForCharacteristic:error:
        [peripheral readValueForCharacteristic:characteristic];
       
        //发现characteristic的descriptors 发现后会调用代理方法
        //peripheral:didDiscoverDescriptorsForCharacteristic:error:
        [peripheral discoverDescriptorsForCharacteristic:characteristic];
        if (![characteristic.UUID.UUIDString isEqualToString:@"FFE1"]) {
            return;
        }
        
        //订阅想要的特征的值会进入代理
        //peripheral:didUpdateNotificationStateForCharacteristic:error:
        self.characteristic = characteristic;
        [peripheral setNotifyValue:YES forCharacteristic:characteristic];
    }
}

//订阅想要的特征的值会进入代理
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"didupdate notification error %@",error.localizedDescription);
        return;
    }

    NSString *valueStr = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
    self.receivedLabel.text = valueStr;
}

//读取characteristic的值
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"read characteristic erro : %@",error.localizedDescription);
        return;
    }
//    if ([characteristic.UUID.UUIDString isEqualToString:@"0000FFE1-0000-1000-8000-00805F9B34FB"]) {
//        NSString *readValueStr = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
//    if (![characteristic.UUID.UUIDString isEqualToString:@"FFE1"]) {
//        return;
//    }
    
    NSData *charData = characteristic.value;
    
//    Byte *byteNu = (Byte *)[charData bytes];
    NSString *byteStr = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
    

        
        NSLog(@"read data length - %zd  uuid : %@ value is - %@",charData.length,characteristic.UUID.UUIDString,byteStr);

    [self.allReceivedValues appendString:byteStr ? byteStr :@""];

    
    if ([byteStr containsString:@"\n"]) {
        
        //判断是否是需要解析的数据
        if ([self.allReceivedValues containsString:@"db_sk_report_info_b1"]) {
            SGHolderDetectedResult *detectedResult = [SGHolderDetectedResult holderDetectedResultWithResultString:self.allReceivedValues];
            NSLog(@"detected commandCode - %@",detectedResult.commandCode);
            NSLog(@"pefgroupCount - %@",detectedResult.pefGroups);
        }
        
    }
    

//        NSString *valueStr = @"solon 666666";
//        NSData *value = [NSData dataWithBytes:[valueStr UTF8String] length:valueStr.length];
//        [self peripheral:peripheral writeValueForCharacteristic:characteristic value:value];
//    }
    
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
        NSLog(@"characteristic UUID : %@ 写入成功",characteristic.UUID);
        
        
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
