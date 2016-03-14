//
//  BRBBeaconCentral.m
//  BlueBeacons
//
//  Created by YuGuoXian on 16/3/12.
//  Copyright © 2016年 RadioBear. All rights reserved.
//

#import "BRBBeaconCentral.h"
#import "BRBBeaconError.h"
#import "BRBBeacon.h"
#import "BRBPeripheral.h"
#import "BRBBeaconAdvertisementInfo.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface BRBBeaconCentral () <CBCentralManagerDelegate>

#pragma mark - Private Member

@property (assign, nonatomic, nullable) dispatch_queue_t delegateQueue;
@property (assign, nonatomic, readwrite) BRBBeaconCentralState state;
@property (strong, nonatomic) CBCentralManager *centralManager;
@property (assign, nonatomic) BOOL hasIsScanningSelector;


#pragma mark - Private Function

- (void) p_commonInit;
- (void) p_chageState:(BRBBeaconCentralState) state;
- (dispatch_queue_t) p_getDelegateQueue;
- (void) p_delegateDidUpdateDeviceState;
- (void) p_delegateDidStartScanning;
- (void) p_delegateDidStartScanningWithError:(NSInteger) errorCode;

@end


@implementation BRBBeaconCentral

#pragma mark - Init

- (instancetype) initWithDelegate:(nullable id<BRBBeaconCentralDelegate>) delegate
                            queue:(nullable dispatch_queue_t)queue {
    if (self = [super init]) {
        [self p_commonInit];
        _delegate = delegate;
        _delegateQueue = queue;
    }
    return self;
}

- (void) p_commonInit {
    // public
    _delegate = nil;
    _state = BRBBeaconCentralStateOff;
    
    // private
    _delegateQueue = nil;
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
    [_centralManager addObserver:self forKeyPath:@"isScanning" options:NSKeyValueObservingOptionNew context:nil];
    _hasIsScanningSelector = [_centralManager respondsToSelector:@selector(isScanning)];
}

#pragma mark - Uninit

- (void)dealloc
{
    [_centralManager removeObserver:self forKeyPath:@"isScanning"];
}


#pragma mark - State


- (void) p_chageState:(BRBBeaconCentralState) state {
    
    if (_state == state) {
        return ;
    }
    
    // 改变
    self.state = state;
    
    // 通知
    if ([_delegate respondsToSelector:@selector(beaconCentralDidUpdateState:)]) {
        dispatch_async([self p_getDelegateQueue], ^{
            [_delegate beaconCentralDidUpdateState:self];
        });
    }
}

@dynamic deviceState;
- (BRBBeaconCentralDeviceState) deviceState {
    if (_centralManager == nil) {
        return BRBBeaconCentralDeviceStateUnknown;
    }

    switch (_centralManager.state) {
        case CBCentralManagerStateUnknown:
            return BRBBeaconCentralDeviceStateUnknown;
        case CBCentralManagerStateResetting:
            return BRBBeaconCentralDeviceStateResetting;
        case CBCentralManagerStateUnsupported:
            return BRBBeaconCentralDeviceStateUnsupported;
        case CBCentralManagerStateUnauthorized:
            return BRBBeaconCentralDeviceStateUnauthorized;
        case CBCentralManagerStatePoweredOff:
            return BRBBeaconCentralDeviceStatePoweredOff;
        case CBCentralManagerStatePoweredOn:
            return BRBBeaconCentralDeviceStatePoweredOn;
    }
    
    NSLog(@"There is not process state:%ld", (long)_centralManager.state);
    return BRBBeaconCentralDeviceStateUnknown;
}


#pragma mark - Advertising


/*
 * 开始搜索
 */
- (void)startScanning {
    
    if (self.deviceState != BRBBeaconCentralDeviceStatePoweredOn) {
        // 通知 BRBBeaconDeviceNotAvailableError
        [self p_delegateDidStartScanningWithError:BRBBeaconDeviceNotAvailableError];
        return;
    }
    
    @try {
        [_centralManager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES}];
    }
    @catch (NSException *exception) {
        // 通知 BRBCentralManagerScanningError
        [self p_delegateDidStartScanningWithError:BRBCentralManagerScanningError];
    }
    
    // 状态
    if (!_hasIsScanningSelector) {
        [self p_chageState:BRBBeaconCentralStateOn];
    }
}

/*
 * 停止搜索
 */
- (void) stopScanning {
    
    if (_hasIsScanningSelector) {
        if (_centralManager.isScanning) {
            [_centralManager stopScan];
        }
    } else {
        [_centralManager stopScan];
    }
    
    // 状态
    if (!_hasIsScanningSelector) {
        [self p_chageState:BRBBeaconCentralStateOff];
    }
}

#pragma mark - Delegate

- (dispatch_queue_t) p_getDelegateQueue {
    if (_delegateQueue == nil) {
        return dispatch_get_main_queue();
    }
    return _delegateQueue;
}

- (void) p_delegateDidUpdateDeviceState {
    if ([_delegate respondsToSelector:@selector(beaconCentralDidUpdateDeviceState:)]) {
        dispatch_async([self p_getDelegateQueue], ^{
            [_delegate beaconCentralDidUpdateDeviceState:self];
        });
    }
}

- (void) p_delegateDidStartScanning {
    if ([_delegate respondsToSelector:@selector(beaconCentralDidStartScanning:error:)]) {
        dispatch_async([self p_getDelegateQueue], ^{
            [_delegate beaconCentralDidStartScanning:self error:nil];
        });
    }
}

- (void) p_delegateDidStartScanningWithError:(NSInteger) errorCode {
    if ([_delegate respondsToSelector:@selector(beaconCentralDidStartScanning:error:)]) {
        dispatch_async([self p_getDelegateQueue], ^{
            [_delegate beaconCentralDidStartScanning:self error:[BRBBeaconError beaconErrorWithCode:errorCode]];
        });
    }
}

- (void) p_delegateDidDiscoverBeacon:(BRBBeacon *)beacon {
    if ([_delegate respondsToSelector:@selector(beaconCentral:didDiscoverBeacon:)]) {
        dispatch_async([self p_getDelegateQueue], ^{
            [_delegate beaconCentral:self didDiscoverBeacon:beacon];
        });
    }
}

- (void) p_delegateDidDiscoverPeripheral:(BRBPeripheral *)peripheral {
    if ([_delegate respondsToSelector:@selector(beaconCentral:didDiscoverPeripheral:)]) {
        dispatch_async([self p_getDelegateQueue], ^{
            [_delegate beaconCentral:self didDiscoverPeripheral:peripheral];
        });
    }
}

#pragma mark - CBCentralManagerDelegate

- (void) centralManagerDidUpdateState:(CBCentralManager *)central {
    if (central.state == CBCentralManagerStatePoweredOff || central.state == CBCentralManagerStateUnauthorized) {
        [self stopScanning];
    }
    
    // 通知
    [self p_delegateDidUpdateDeviceState];
}

- (void) centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI {
    
    BRBBeaconAdvertisementInfo *advertisementInfo = [BRBBeaconAdvertisementInfo beaconAdvertisementInfoWithAdvertismentDataDictionary:advertisementData];
    
    if (advertisementInfo) {
        BRBBeacon *beacon = [BRBBeacon beaconWithPeripheral:peripheral BeaconAdvertisementInfo:advertisementInfo];
        if (beacon) {
            // 通知
            [self p_delegateDidDiscoverBeacon:beacon];
        }
    } else {
        BRBPeripheral *brbperipheral = [BRBPeripheral peripheraWithPeripheral:peripheral];
        if (brbperipheral) {
            // 通知
            [self p_delegateDidDiscoverPeripheral:brbperipheral];
        }
    }
    
}


#pragma mark - KVO

- (void) observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSString*, id> *)change context:(nullable void *)context
{
    BOOL process = NO;
    if(object == _centralManager && [keyPath isEqualToString:@"isScanning"])
    {
        if ([[change objectForKey:@"new"] boolValue]) {
            [self p_chageState:BRBBeaconCentralStateOn];
        } else {
            [self p_chageState:BRBBeaconCentralStateOff];
        }
        process = YES;
    }
    
    if (!process) {
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}

@end


NS_ASSUME_NONNULL_END