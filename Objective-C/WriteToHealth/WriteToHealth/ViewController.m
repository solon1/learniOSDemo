//
//  ViewController.m
//  WriteToHealth
//
//  Created by solon on 16/7/21.
//  Copyright © 2016年 solon. All rights reserved.
//

#import "ViewController.h"
#import <HealthKit/HealthKit.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *stepsTextField;
/** healthStore */
@property (nonatomic,strong) HKHealthStore *healthStore;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)submitAction:(UIButton *)sender {
    
    NSSet *sampleType = [self dataTypesToWrite];
    
    self.healthStore = [[HKHealthStore alloc] init];
    [self.healthStore requestAuthorizationToShareTypes:sampleType readTypes:sampleType completion:^(BOOL success, NSError * _Nullable error) {
        
        NSLog(@"error -- %@",error.localizedDescription);
    }];
    
}


- (NSSet *)dataTypesToWrite {
    //    HKQuantityType *expiratoryVolunme1Type = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierForcedExpiratoryVolume1];
    //    HKQuantityType *activeEnergyBurnType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    //    HKQuantityType *heightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    //    HKQuantityType *weightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
//    HKQuantityType *pefType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierPeakExpiratoryFlowRate];
//    HKQuantityType *FVCType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierForcedVitalCapacity];
//    HKQuantityType *FEV1Type = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierForcedExpiratoryVolume1];
    //    return [NSSet setWithObjects:expiratoryVolunme1Type, activeEnergyBurnType, heightType, weightType,pefType, nil];
    HKQuantityType *steps = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
//    return [NSSet setWithObjects:pefType,FVCType,FEV1Type, nil];
    return [NSSet setWithObject:steps];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
