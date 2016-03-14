//
//  BRBRoundButton.h
//  BlueBeacons
//
//  Created by YuGuoXian on 16/3/4.
//  Copyright © 2016年 RadioBear. All rights reserved.
//

#import <UIKit/UIKit.h>


// 形状enum
typedef NS_ENUM(NSInteger, BRBRoundButtonType) {
    // 圆
    BRBRoundButtonTypeFullRound,
    // 圆角
    BRBRoundButtonTypeHalfRound,
    // 方
    BRBRoundButtonTypeSquare,
    
};


NS_ASSUME_NONNULL_BEGIN

IB_DESIGNABLE
@interface BRBRoundButton : UIButton


+ (instancetype) buttonWithFrame:(CGRect)frame roundType:(BRBRoundButtonType) type;

/*
 * 形状
 */
#if TARGET_INTERFACE_BUILDER
@property (assign, nonatomic) IBInspectable NSInteger roundButtonType;
#else
@property (assign, nonatomic) BRBRoundButtonType roundButtonType;
#endif

- (void)setButtonColor:(nullable UIColor *)color forState:(UIControlState)state;
- (UIColor*) buttonColorForState:(UIControlState)state;
- (void) updateButtonColor;

@end

NS_ASSUME_NONNULL_END
