//
//  BRBBeaconBroadcast.m
//  BlueBeacons
//
//  Created by YuGuoXian on 16/3/3.
//  Copyright © 2016年 RadioBear. All rights reserved.
//

#import "BRBBeaconBroadcast.h"
#import "BRBBeaconError.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>


NS_ASSUME_NONNULL_BEGIN


@interface BRBBeaconBroadcast () <CBPeripheralManagerDelegate>

#pragma mark - Private Member

@property (assign, nonatomic, nullable) dispatch_queue_t delegateQueue;
@property (assign, nonatomic, readwrite) BRBBeaconBroadcastState state;
@property (strong, nonatomic) CBPeripheralManager *peripheralManager;


#pragma mark - Private Function

- (void) p_commonInit;
- (void) p_chageState:(BRBBeaconBroadcastState) state;
- (dispatch_queue_t) p_getDelegateQueue;
- (void) p_delegateDidStartAdvertising;
- (void) p_delegateDidStartAdvertisingWithError:(NSInteger) errorCode;
- (void) p_delegateDidUpdateDeviceState;

@end



@implementation BRBBeaconBroadcast


#pragma mark - Init

- (instancetype) initWithDelegate:(nullable id<BRBBeaconBroadcastDelegate>) delegate
                            queue:(nullable dispatch_queue_t)queue {
    if (self = [super init]) {
        [self p_commonInit];
        _delegate = delegate;
        _delegateQueue = queue;
    }
    return self;
}

- (instancetype) initWithBeaconRegion:(CLBeaconRegion*) region
                             delegate:(nullable id<BRBBeaconBroadcastDelegate>) delegate
                                queue:(nullable dispatch_queue_t)queue {
    if (self = [super init]) {
        [self p_commonInit];
        _beaconRegion = region;
        _delegate = delegate;
        _delegateQueue = queue;
    }
    return self;
}

- (void) p_commonInit {
    _delegate = nil;
    _state = BRBBeaconBroadcastStateOff;
    _beaconRegion = nil;
    
    // private
    _delegateQueue = nil;
    _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
}

#pragma mark - State


- (void) p_chageState:(BRBBeaconBroadcastState) state {
    
    if (_state == state) {
        return ;
    }
    
    // 改变
    self.state = state;
    
    // 通知
    if ([_delegate respondsToSelector:@selector(beaconBroadcastDidUpdateState:)]) {
        dispatch_async([self p_getDelegateQueue], ^{
            [_delegate beaconBroadcastDidUpdateState:self];
        });
    }
}

@dynamic deviceState;
- (BRBBeaconBroadcastDeviceState) deviceState {
    if (_peripheralManager == nil) {
        return BRBBeaconBroadcastDeviceStateUnknown;
    }
    
    switch (_peripheralManager.state) {
        case CBPeripheralManagerStateUnknown:
            return BRBBeaconBroadcastDeviceStateUnknown;
        case CBPeripheralManagerStateResetting:
            return BRBBeaconBroadcastDeviceStateResetting;
        case CBPeripheralManagerStateUnsupported:
            return BRBBeaconBroadcastDeviceStateUnsupported;
        case CBPeripheralManagerStateUnauthorized:
            return BRBBeaconBroadcastDeviceStateUnauthorized;
        case CBPeripheralManagerStatePoweredOff:
            return BRBBeaconBroadcastDeviceStatePoweredOff;
        case CBPeripheralManagerStatePoweredOn:
            return BRBBeaconBroadcastDeviceStatePoweredOn;
    }
    
    NSLog(@"There is not process state:%ld", (long)_peripheralManager.state);
    return BRBBeaconBroadcastDeviceStateUnknown;
}

#pragma mark - Advertising


/*
 * 开始广播
 */
- (void)startAdvertising {
    if (_beaconRegion == nil) {
        // 通知 BRBBeaconRegionNullError
        [self p_delegateDidStartAdvertisingWithError:BRBBeaconRegionNullError];
        return;
    }
    
    if (self.deviceState != BRBBeaconBroadcastDeviceStatePoweredOn) {
        // 通知 BRBBeaconDeviceNotAvailableError
        [self p_delegateDidStartAdvertisingWithError:BRBBeaconDeviceNotAvailableError];
        return;
    }
    
    NSDictionary *beaconRegionData = [_beaconRegion peripheralDataWithMeasuredPower:nil];
    [_peripheralManager startAdvertising:beaconRegionData];
}

/*
 * 停止广播
 */
- (void) stopAdvertising {
    
    if (_peripheralManager.isAdvertising) {
        [_peripheralManager stopAdvertising];
    }
    
    [self p_chageState:BRBBeaconBroadcastStateOff];
}

#pragma mark - Delegate

- (dispatch_queue_t) p_getDelegateQueue {
    if (_delegateQueue == nil) {
        return dispatch_get_main_queue();
    }
    return _delegateQueue;
}

- (void) p_delegateDidStartAdvertising {
    if ([_delegate respondsToSelector:@selector(beaconBroadcastDidStartAdvertising:error:)]) {
        dispatch_async([self p_getDelegateQueue], ^{
            [_delegate beaconBroadcastDidStartAdvertising:self error:nil];
        });
    }
}

- (void) p_delegateDidStartAdvertisingWithError:(NSInteger) errorCode {
    if ([_delegate respondsToSelector:@selector(beaconBroadcastDidStartAdvertising:error:)]) {
        dispatch_async([self p_getDelegateQueue], ^{
            [_delegate beaconBroadcastDidStartAdvertising:self error:[BRBBeaconError beaconErrorWithCode:errorCode]];
        });
    }
}

- (void) p_delegateDidUpdateDeviceState {
    if ([_delegate respondsToSelector:@selector(beaconBroadcastDidUpdateDeviceState:)]) {
        dispatch_async([self p_getDelegateQueue], ^{
            [_delegate beaconBroadcastDidUpdateDeviceState:self];
        });
    }
}


#pragma mark - CBPeripheralManagerDelegate

- (void) peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {

    if (peripheral.state == CBPeripheralManagerStatePoweredOff || peripheral.state == CBPeripheralManagerStateUnauthorized) {
        [self stopAdvertising];
    }
    
    // 通知
    [self p_delegateDidUpdateDeviceState];
}

// 开始向外广播数据  当startAdvertising被执行的时候调用这个代理方法
- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(nullable NSError *)error {
    if (error != nil) {
        // 通知 BRBPeripheralManagerAdvertisingError
        [self p_delegateDidStartAdvertisingWithError:BRBPeripheralManagerAdvertisingError];
    } else {
        [self p_chageState:BRBBeaconBroadcastStateOn];
        // 通知
        [self p_delegateDidStartAdvertising];
    }
}

@end


NS_ASSUME_NONNULL_END
