//
//  BRBBeaconCentral.h
//  BlueBeacons
//
//  Created by YuGuoXian on 16/3/12.
//  Copyright © 2016年 RadioBear. All rights reserved.
//

#import <Foundation/Foundation.h>


@class BRBBeacon;
@class BRBPeripheral;

// 状态
typedef NS_ENUM(NSInteger, BRBBeaconCentralState) {
    // 未开始搜索
    BRBBeaconCentralStateOff = 0,
    // 开始搜索
    BRBBeaconCentralStateOn,
};

// 设备状态
typedef NS_ENUM(NSInteger, BRBBeaconCentralDeviceState) {
    BRBBeaconCentralDeviceStateUnknown = 0,
    BRBBeaconCentralDeviceStateResetting,
    BRBBeaconCentralDeviceStateUnsupported,
    BRBBeaconCentralDeviceStateUnauthorized,
    BRBBeaconCentralDeviceStatePoweredOff,
    BRBBeaconCentralDeviceStatePoweredOn,
};


NS_ASSUME_NONNULL_BEGIN

@protocol BRBBeaconCentralDelegate;


@interface BRBBeaconCentral : NSObject

@property (assign, nonatomic, nullable) id<BRBBeaconCentralDelegate> delegate;
@property (assign, nonatomic, readonly) BRBBeaconCentralState state;
@property (assign, nonatomic, readonly) BRBBeaconCentralDeviceState deviceState;


- (instancetype) initWithDelegate:(nullable id<BRBBeaconCentralDelegate>) delegate
                            queue:(nullable dispatch_queue_t)queue;

- (void)startScanning;
- (void) stopScanning;

@end


@protocol BRBBeaconCentralDelegate <NSObject>

@optional
- (void) beaconCentralDidUpdateState:(BRBBeaconCentral *)beaconCentral;

- (void) beaconCentralDidUpdateDeviceState:(BRBBeaconCentral *)beaconCentral;

- (void) beaconCentralDidStartScanning:(BRBBeaconCentral *)beaconCentral error:(nullable NSError *)error;

- (void) beaconCentral:(BRBBeaconCentral *)beaconCentral didDiscoverBeacon:(BRBBeacon *)beacon;

- (void) beaconCentral:(BRBBeaconCentral *)beaconCentral didDiscoverPeripheral:(BRBPeripheral *)peripheral;

@end


NS_ASSUME_NONNULL_END