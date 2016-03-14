//
//  BRBPeripheral.m
//  BlueBeacons
//
//  Created by YuGuoXian on 16/3/14.
//  Copyright © 2016年 RadioBear. All rights reserved.
//

#import "BRBPeripheral.h"
#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@interface BRBPeripheral ()

@property (strong, nonatomic, readwrite) CBPeripheral *peripheral;

@end

@implementation BRBPeripheral

#pragma mark - Factory

+ (instancetype) peripheraWithPeripheral:(CBPeripheral *)peripheral {
    BRBPeripheral *brbperipheral = [[BRBPeripheral alloc] initWithPeripheral:peripheral];
    return brbperipheral;
}

#pragma mark - Init

- (instancetype) initWithPeripheral:(CBPeripheral *)peripheral {
    if (self = [super init]) {
        _peripheral = peripheral;
    }
    return self;
}

#pragma mark - Peripheral

@dynamic name;
- (nullable NSString *)name {
    return [_peripheral name];
}

@end


NS_ASSUME_NONNULL_END