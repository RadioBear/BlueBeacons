//
//  BeaconAdvertisementInfo.h
//  BlueBeacons
//
//  Created by YuGuoXian on 16/3/14.
//  Copyright © 2016年 RadioBear. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BRBBeaconAdvertisementInfo : NSObject

@property (strong,nonatomic) NSUUID *proximityUUID;
@property (strong,nonatomic) NSNumber *major;
@property (strong,nonatomic) NSNumber *minor;
@property (strong,nonatomic) NSNumber *measuredPower;

+ (instancetype) beaconAdvertisementInfoWithAdvertismentDataDictionary:(NSDictionary *)advertisementDataDictionary;
+ (instancetype) beaconAdvertisementInfoWithManufacturerAdvertisementData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END