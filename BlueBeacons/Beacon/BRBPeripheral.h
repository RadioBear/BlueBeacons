//
//  BRBPeripheral.h
//  BlueBeacons
//
//  Created by YuGuoXian on 16/3/14.
//  Copyright © 2016年 RadioBear. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CBPeripheral;

NS_ASSUME_NONNULL_BEGIN

@interface BRBPeripheral : NSObject

@property (strong, nonatomic, readonly) CBPeripheral *peripheral;
@property (strong, nonatomic, readonly, nullable) NSString *name;


+ (instancetype) peripheraWithPeripheral:(CBPeripheral *)peripheral;

- (instancetype) initWithPeripheral:(CBPeripheral *)peripheral;

@end


NS_ASSUME_NONNULL_END