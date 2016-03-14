//
//  BRBBeaconInfoTableViewCell.m
//  BlueBeacons
//
//  Created by YuGuoXian on 16/3/14.
//  Copyright © 2016年 RadioBear. All rights reserved.
//

#import "BRBBeaconInfoTableViewCell.h"

@interface BRBBeaconInfoTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *labelName;

@end

@implementation BRBBeaconInfoTableViewCell


- (void) setBeaconName:(NSString *)name {
    [_labelName setText:name];
}

@end
