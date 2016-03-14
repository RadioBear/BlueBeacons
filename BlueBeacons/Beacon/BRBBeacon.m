//
//  BRBBeacon.m
//  BlueBeacons
//
//  Created by YuGuoXian on 16/3/13.
//  Copyright © 2016年 RadioBear. All rights reserved.
//

#import "BRBBeacon.h"
#import "BRBBeaconAdvertisementInfo.h"
#import <CoreBluetooth/CoreBluetooth.h>

//static NSString *const HGBeaconAdvertismentManufacturerDataKey = @"kCBAdvDataAppleBeaconKey";

NS_ASSUME_NONNULL_BEGIN

@interface BRBBeacon ()


- (instancetype) initWithPeripheral:(CBPeripheral *)peripheral BeaconAdvertisementInfo:(BRBBeaconAdvertisementInfo *)advertisementInfo;

@end


@implementation BRBBeacon

#pragma mark - Factory

+ (instancetype) beaconWithPeripheral:(CBPeripheral *)peripheral AdvertismentDataDictionary:(NSDictionary *)advertisementDataDictionary {
    BRBBeaconAdvertisementInfo *advertisementInfo = [BRBBeaconAdvertisementInfo beaconAdvertisementInfoWithAdvertismentDataDictionary:advertisementDataDictionary];
    if (advertisementInfo == nil) {
        return nil;
    }
    
    BRBBeacon *beacon = [[BRBBeacon alloc] initWithPeripheral:peripheral BeaconAdvertisementInfo:advertisementInfo];
    return beacon;
}

+ (instancetype) beaconWithPeripheral:(CBPeripheral *)peripheral BeaconAdvertisementInfo:(BRBBeaconAdvertisementInfo *)advertisementInfo {
    BRBBeacon *beacon = [[BRBBeacon alloc] initWithPeripheral:peripheral BeaconAdvertisementInfo:advertisementInfo];
    return beacon;
}

#pragma mark - Init


- (instancetype) initWithPeripheral:(CBPeripheral *)peripheral BeaconAdvertisementInfo:(BRBBeaconAdvertisementInfo *)advertisementInfo {
    
    if (self = [super initWithPeripheral:peripheral]) {
        _proximityUUID = advertisementInfo.proximityUUID;
        _major = advertisementInfo.major;
        _minor = advertisementInfo.minor;
        _measuredPower = advertisementInfo.measuredPower;
    }
    return self;
}




@end

NS_ASSUME_NONNULL_END
