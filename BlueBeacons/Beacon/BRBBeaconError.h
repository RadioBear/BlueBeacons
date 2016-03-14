//
//  BRBBeaconError.h
//  BlueBeacons
//
//  Created by YuGuoXian on 16/3/12.
//  Copyright © 2016年 RadioBear. All rights reserved.
//

#import <Foundation/Foundation.h>


// 错误代码
typedef NS_ENUM(NSInteger, BRBBeaconErrorCode) {
    BRBBeaconRegionNullError = 1000500,
    BRBBeaconDeviceNotAvailableError,
    BRBPeripheralManagerAdvertisingError,
    BRBCentralManagerScanningError,
};

@interface BRBBeaconError : NSError

+ (instancetype) beaconErrorWithCode:(NSInteger)code;

@end
