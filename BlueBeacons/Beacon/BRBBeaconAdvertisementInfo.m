//
//  BeaconAdvertisementInfo.m
//  BlueBeacons
//
//  Created by YuGuoXian on 16/3/14.
//  Copyright © 2016年 RadioBear. All rights reserved.
//

#import "BRBBeaconAdvertisementInfo.h"
#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN


@implementation BRBBeaconAdvertisementInfo

#pragma mark - Factory

+ (instancetype) beaconAdvertisementInfoWithAdvertismentDataDictionary:(NSDictionary *)advertisementDataDictionary {
    NSData *data = (NSData *)[advertisementDataDictionary objectForKey:CBAdvertisementDataManufacturerDataKey];
    if (data) {
        return [self beaconAdvertisementInfoWithManufacturerAdvertisementData:data];
    }
    return nil;
}


+ (instancetype) beaconAdvertisementInfoWithManufacturerAdvertisementData:(NSData *)data {
    if ([data length] < 25) {
        return nil;
    }
    
    u_int16_t companyIdentifier,major,minor = 0;
    
    int8_t measuredPower,dataType, dataLength = 0;
    char uuidBytes[17] = {0};
    
    // 第1,2字节 公司标识
    NSRange companyIDRange = NSMakeRange(0,2);
    [data getBytes:&companyIdentifier range:companyIDRange];
    if (companyIdentifier != 0x4C) {
        return nil;
    }
    
    // 第3字节 ibeacon标识位
    NSRange dataTypeRange = NSMakeRange(2,1);
    [data getBytes:&dataType range:dataTypeRange];
    if (dataType != 0x02) {
        return nil;
    }
    
    // 第4字节 数据长度（指的是uuid + major + minor的长度）
    NSRange dataLengthRange = NSMakeRange(3,1);
    [data getBytes:&dataLength range:dataLengthRange];
    if (dataLength != 0x15) {
        return nil;
    }
    
    // 第5-20字节 uuid
    NSRange uuidRange = NSMakeRange(4, 16);
    // 第21，22字节 major
    NSRange majorRange = NSMakeRange(20, 2);
    // 第23，24字节 minor
    NSRange minorRange = NSMakeRange(22, 2);
    // 第25字节 ibeacon发出的信号强度（补码值），用来作为和RSSI一起测距的基准
    NSRange powerRange = NSMakeRange(24, 1);
    [data getBytes:&uuidBytes range:uuidRange];
    [data getBytes:&major range:majorRange];
    major = (major >> 8) | (major << 8);
    [data getBytes:&minor range:minorRange];
    minor = (minor >> 8) | (minor << 8);
    [data getBytes:&measuredPower range:powerRange];
    
    NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDBytes:(const unsigned char*)&uuidBytes];
    BRBBeaconAdvertisementInfo *beaconAdvertisementInfo = [[BRBBeaconAdvertisementInfo alloc] initWithProximityUUID:proximityUUID
                                                                                                        major:[NSNumber numberWithUnsignedInteger:major]
                                                                                                        minor:[NSNumber numberWithUnsignedInteger:minor]
                                                                                                measuredPower:[NSNumber numberWithShort:measuredPower]];
    return beaconAdvertisementInfo;
}

#pragma mark - Init

- (instancetype) initWithProximityUUID:(NSUUID *)proximityUUID major:(NSNumber *)major minor:(NSNumber *)minor measuredPower:(NSNumber *)power {
    if (self = [super init]) {
        _proximityUUID = proximityUUID;
        _major = major;
        _minor = minor;
        _measuredPower = power;
    }
    return self;
}

@end

NS_ASSUME_NONNULL_END
