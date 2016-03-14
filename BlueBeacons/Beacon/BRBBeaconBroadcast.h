//
//  BRBBeaconBroadcast.h
//  BlueBeacons
//
//  Created by YuGuoXian on 16/3/3.
//  Copyright © 2016年 RadioBear. All rights reserved.
//

#import <Foundation/Foundation.h>


@class CLBeaconRegion;
@class CBPeripheralManager;
@protocol BRBBeaconBroadcastDelegate;

// 状态
typedef NS_ENUM(NSInteger, BRBBeaconBroadcastState) {
    // 未开始广播
    BRBBeaconBroadcastStateOff = 0,
    // 开始广播
    BRBBeaconBroadcastStateOn,
};

// 设备状态
typedef NS_ENUM(NSInteger, BRBBeaconBroadcastDeviceState) {
    BRBBeaconBroadcastDeviceStateUnknown = 0,
    BRBBeaconBroadcastDeviceStateResetting,
    BRBBeaconBroadcastDeviceStateUnsupported,
    BRBBeaconBroadcastDeviceStateUnauthorized,
    BRBBeaconBroadcastDeviceStatePoweredOff,
    BRBBeaconBroadcastDeviceStatePoweredOn,
};


NS_ASSUME_NONNULL_BEGIN


@interface BRBBeaconBroadcast : NSObject

@property (assign, nonatomic, nullable) id<BRBBeaconBroadcastDelegate> delegate;
@property (assign, nonatomic, readonly) BRBBeaconBroadcastState state;
@property (assign, nonatomic, readonly) BRBBeaconBroadcastDeviceState deviceState;
@property (strong, nonatomic, nullable) CLBeaconRegion *beaconRegion;

- (instancetype) initWithDelegate:(nullable id<BRBBeaconBroadcastDelegate>) delegate
                            queue:(nullable dispatch_queue_t)queue;

- (instancetype) initWithBeaconRegion:(CLBeaconRegion*) region
                             delegate:(nullable id<BRBBeaconBroadcastDelegate>) delegate
                                queue:(nullable dispatch_queue_t)queue;

/*
 * 开始广播
 */
- (void)startAdvertising;

/*
 * 停止广播
 */
- (void) stopAdvertising;

@end


@protocol BRBBeaconBroadcastDelegate <NSObject>

@optional
- (void) beaconBroadcastDidUpdateState:(BRBBeaconBroadcast *)beaconBroadcast;

- (void) beaconBroadcastDidUpdateDeviceState:(BRBBeaconBroadcast *)beaconBroadcast;

- (void) beaconBroadcastDidStartAdvertising:(BRBBeaconBroadcast *)beaconBroadcast error:(nullable NSError *)error;

@end


NS_ASSUME_NONNULL_END