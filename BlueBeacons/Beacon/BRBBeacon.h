//
//  BRBBeacon.h
//  BlueBeacons
//
//  Created by YuGuoXian on 16/3/13.
//  Copyright © 2016年 RadioBear. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BRBPeripheral.h"

@class BRBBeaconAdvertisementInfo;

NS_ASSUME_NONNULL_BEGIN

@interface BRBBeacon : BRBPeripheral

@property (strong,nonatomic) NSUUID *proximityUUID;
@property (strong,nonatomic) NSNumber *major;
@property (strong,nonatomic) NSNumber *minor;
@property (strong,nonatomic) NSNumber *measuredPower;
@property (strong,nonatomic) NSNumber *RSSI;


+ (instancetype) beaconWithPeripheral:(CBPeripheral *)peripheral AdvertismentDataDictionary:(NSDictionary *)advertisementDataDictionary;
+ (instancetype) beaconWithPeripheral:(CBPeripheral *)peripheral BeaconAdvertisementInfo:(BRBBeaconAdvertisementInfo *)advertisementInfo;

@end

NS_ASSUME_NONNULL_END