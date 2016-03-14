//
//  BRBBeaconError.m
//  BlueBeacons
//
//  Created by YuGuoXian on 16/3/12.
//  Copyright © 2016年 RadioBear. All rights reserved.
//

#import "BRBBeaconError.h"

static NSString *const kErrorDomain = @"com.BerryBear.BeaconError";


@implementation BRBBeaconError

#pragma mark - Factroy Create

+ (instancetype) beaconErrorWithCode:(NSInteger)code {
     return[BRBBeaconError errorWithDomain:kErrorDomain code:code userInfo:nil];
}

@end
