//
//  BRBAlert.h
//  BlueBeacons
//
//  Created by YuGuoXian on 16/3/9.
//  Copyright © 2016年 RadioBear. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIViewController;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,BRBAlertButtonStyle) {
    BRBAlertButtonStyleDefault = 0,
    BRBAlertButtonStyleCancel,
    BRBAlertButtonStyleDestructive,
};

typedef void (^BRBAlertButtonHandler)(void);

@interface BRBAlertButton : NSObject

@property (copy, nonatomic,) NSString *title;
@property (assign, nonatomic) BRBAlertButtonStyle style;
@property (strong, nonatomic, nullable) BRBAlertButtonHandler handler;

+ (instancetype) buttonWithTitle:(NSString*)title;
+ (instancetype) buttonWithTitle:(NSString*)title style:(BRBAlertButtonStyle)style;

- (instancetype) initWithTitle:(NSString*)title;
- (instancetype) initWithTitle:(NSString*)title style:(BRBAlertButtonStyle)style;
- (instancetype) initWithTitle:(NSString*)title style:(BRBAlertButtonStyle)style handler:(nullable BRBAlertButtonHandler)handler;

@end

@interface BRBAlert : NSObject

@property (copy, nonatomic, nullable) NSString *title;
@property (copy, nonatomic, nullable) NSString *message;

+ (void)showWithViewController:(UIViewController *)viewController title:(nullable NSString *)title  message:(nullable NSString *)message buttonText:(NSString *)buttonText;

- (instancetype)initWithViewController:(UIViewController *)viewController title:(nullable NSString *)title message:(nullable NSString *)message;
- (void)addButton:(BRBAlertButton *)button;
- (void)show;

@end


NS_ASSUME_NONNULL_END