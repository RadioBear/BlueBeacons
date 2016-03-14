//
//  BRBAlert.m
//  BlueBeacons
//
//  Created by YuGuoXian on 16/3/9.
//  Copyright © 2016年 RadioBear. All rights reserved.
//

#import "BRBAlert.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

/*
 *  System Versioning Preprocessor Macros
 */

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


@implementation BRBAlertButton

#pragma mark - Create Factory

+ (instancetype) buttonWithTitle:(NSString*)title {
    return [[BRBAlertButton alloc] initWithTitle:title];
}

+ (instancetype) buttonWithTitle:(NSString*)title style:(BRBAlertButtonStyle)style {
    return [[BRBAlertButton alloc] initWithTitle:title style:style];
}

#pragma mark - Init

- (instancetype) initWithTitle:(NSString*)title {
    return [self initWithTitle:title style:BRBAlertButtonStyleDefault handler:nil];
}

- (instancetype) initWithTitle:(NSString*)title style:(BRBAlertButtonStyle)style {
    return [self initWithTitle:title style:style handler:nil];
}

- (instancetype) initWithTitle:(NSString*)title style:(BRBAlertButtonStyle)style handler:(nullable BRBAlertButtonHandler)handler {
    if (self = [super init]) {
        _title = [title copy];
        _style = style;
        _handler = handler;
    }
    return self;
}

#pragma mark - Style

- (UIAlertActionStyle)getAlertActionStyle {
    switch (_style) {
        case BRBAlertButtonStyleDefault:
            return UIAlertActionStyleDefault;
            
        case BRBAlertButtonStyleCancel:
            return UIAlertActionStyleCancel;
            
        case BRBAlertButtonStyleDestructive:
            return UIAlertActionStyleDestructive;
    }
}


@end


static NSInteger const UIAlertViewWrapperPropertyKey = 0;

@interface UIAlertViewWrapper : NSObject <UIAlertViewDelegate>

@property (strong, nonatomic) NSMutableArray *buttons;

- (instancetype)initWithButtons:(NSMutableArray *)buttons;


@end

@implementation UIAlertViewWrapper

#pragma mark - Init

- (instancetype)initWithButtons:(NSMutableArray *)buttons {
    if (self = [super init]) {
        _buttons = buttons;
    }
    return self;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (_buttons != nil && buttonIndex >= 0 && buttonIndex < _buttons.count) {
        BRBAlertButton* button = _buttons[buttonIndex];
        if (button && button.handler) {
            button.handler();
        }
    }
}

@end


#pragma mark - BRBAlert

@interface BRBAlert ()

@property (weak, nonatomic) UIViewController *viewController;
@property (strong, nonatomic) NSMutableArray *buttons;

@end


@implementation BRBAlert

+ (void)showWithViewController:(UIViewController *)viewController title:(nullable NSString *)title  message:(nullable NSString *)message buttonText:(NSString *)buttonText {
    if (SYSTEM_VERSION_GREATER_THAN(@"8.0")) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:buttonText
                                                            style:UIAlertActionStyleDefault
                                                          handler:nil]];
        [viewController presentViewController:alertController animated:YES completion:nil];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:buttonText otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma mark - Init

- (instancetype)initWithViewController:(UIViewController *)viewController title:(nullable NSString *)title message:(nullable NSString *)message {
    if (self = [super init]) {
        _viewController = viewController;
        _title = [title copy];
        _message = [message copy];
        _buttons = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addButton:(BRBAlertButton *)button {
    [_buttons addObject:button];
}



- (void)show {
    if (SYSTEM_VERSION_GREATER_THAN(@"8.0")) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:_title message:_message preferredStyle:UIAlertControllerStyleAlert];
        for (BRBAlertButton *button in _buttons) {
            [alertController addAction:[UIAlertAction actionWithTitle:_title
                                                                style:[button getAlertActionStyle]
                                                              handler:button.handler == nil ? nil : ^(UIAlertAction *action) {
                                                                  button.handler();
                                                              }
                                        ]];
        }
        [_viewController presentViewController:alertController animated:YES completion:nil];
    } else {
        UIAlertViewWrapper *wrapper = [[UIAlertViewWrapper alloc] initWithButtons:_buttons];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:_title message:_message delegate:wrapper cancelButtonTitle:nil otherButtonTitles:nil];
        for (BRBAlertButton *button in _buttons) {
            [alertView addButtonWithTitle:button.title];
        }
        objc_setAssociatedObject(alertView, &UIAlertViewWrapperPropertyKey, wrapper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [alertView show];
    }
}

@end


NS_ASSUME_NONNULL_END