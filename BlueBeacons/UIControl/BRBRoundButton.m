//
//  BRBRoundButton.m
//  BlueBeacons
//
//  Created by YuGuoXian on 16/3/4.
//  Copyright © 2016年 RadioBear. All rights reserved.
//

#import "BRBRoundButton.h"
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@interface BRBRoundButton ()

#pragma mark - Private Member

@property (copy, nonatomic) IBInspectable UIColor *buttonColorNormal;
@property (copy, nonatomic, nullable) IBInspectable UIColor *buttonColorHighlighted;
@property (copy, nonatomic, nullable) IBInspectable UIColor *buttonColorFocused;
@property (copy, nonatomic, nullable) IBInspectable UIColor *buttonColorSelected;
@property (copy, nonatomic, nullable) IBInspectable UIColor *buttonColorDisabled;

#pragma mark - Private Function

- (instancetype) initWithFrame:(CGRect)frame roundType:(BRBRoundButtonType)type;

- (void) p_commonInit;

- (UIColor*) p_getButtonColor:(UIControlState)state;
- (void) p_updateColor;
- (void) p_updateColorForState:(UIControlState)state;

@end

NS_ASSUME_NONNULL_END



@implementation BRBRoundButton


#pragma mark - Factory Create

/*
 * 工厂函数
 */
+ (instancetype) buttonWithFrame:(CGRect)frame roundType:(BRBRoundButtonType)type {
    BRBRoundButton *newButton = [[BRBRoundButton alloc] initWithFrame:frame roundType:type];
    return newButton;
}

#pragma mark - Init

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self p_commonInit];
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame roundType:(BRBRoundButtonType)type {
    self = [super initWithFrame:frame];
    if (self) {
        [self p_commonInit];
        _roundButtonType = type;
    }
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self p_commonInit];
    }
    return self;
}

- (void) p_commonInit {
    _roundButtonType = BRBRoundButtonTypeFullRound;
    
    _buttonColorNormal = [UIColor whiteColor];
    _buttonColorHighlighted = nil;
    _buttonColorFocused = nil;
    _buttonColorSelected = nil;
    _buttonColorDisabled = nil;
}


#pragma mark - Shape

- (void) p_updateShape {
    switch (_roundButtonType) {
        case BRBRoundButtonTypeFullRound: {
            CGFloat height = CGRectGetHeight(self.bounds);
            CGFloat width = CGRectGetWidth(self.bounds);
            CGFloat min = MIN(width, height);
            self.layer.cornerRadius = ceil(min * 0.5f);
        }
            break;
            
        case BRBRoundButtonTypeHalfRound: {
            CGFloat height = CGRectGetHeight(self.bounds);
            CGFloat width = CGRectGetWidth(self.bounds);
            CGFloat min = MIN(width, height);
            self.layer.cornerRadius = ceil(min * 0.25f);
        }
            break;
            
        case BRBRoundButtonTypeSquare: {
            self.layer.cornerRadius = 0.0;
        }
            break;
    }
}

#pragma mark - Color

- (void)setButtonColor:(nullable UIColor *)color forState:(UIControlState)state {
    switch (state) {
        case UIControlStateNormal:
            self.buttonColorNormal = color;
            break;
            
        case UIControlStateHighlighted:
            self.buttonColorHighlighted = color;
            break;
            
        case UIControlStateSelected:
            self.buttonColorSelected = color;
            break;
            
        case UIControlStateDisabled:
            self.buttonColorDisabled = color;
            break;
            
        default:
            break;
    }
}

- (UIColor*) buttonColorForState:(UIControlState)state {
    switch (state) {
        case UIControlStateNormal:
            return _buttonColorNormal;
            
        case UIControlStateHighlighted:
            return _buttonColorHighlighted;
            
        case UIControlStateSelected:
            return _buttonColorSelected;
            
        case UIControlStateDisabled:
            return _buttonColorDisabled;
            
        default:
            return _buttonColorNormal;
    }
}

- (UIColor*) p_getButtonColor:(UIControlState)state {
    UIColor *returnColor = nil;
    switch (state) {
        case UIControlStateNormal:
            returnColor = _buttonColorNormal;
            break;
            
        case UIControlStateHighlighted:
            returnColor = _buttonColorHighlighted;
            break;
            
        case UIControlStateSelected:
            returnColor = _buttonColorSelected;
            break;
        
        case UIControlStateDisabled:
            returnColor = _buttonColorDisabled;
            break;
            
        default:
            returnColor = _buttonColorNormal;
            break;
    }
    
    if (returnColor == nil) {
        returnColor = _buttonColorNormal;
    }
    return returnColor;
}

- (void) updateButtonColor {
    [self p_updateColor];
}

- (void) p_updateColor {
    [self p_updateColorForState: self.state];
}

- (void) p_updateColorForState:(UIControlState)state {
    if (state & UIControlStateDisabled) {
        self.backgroundColor = [self p_getButtonColor:UIControlStateDisabled];
    } else if (state & UIControlStateHighlighted) {
        self.backgroundColor = [self p_getButtonColor:UIControlStateHighlighted];
    } else if (state & UIControlStateSelected) {
        self.backgroundColor = [self p_getButtonColor:UIControlStateSelected];
    } else if (state & UIControlStateFocused) {
        self.backgroundColor = [self p_getButtonColor:UIControlStateFocused];
    } else {
        self.backgroundColor = [self p_getButtonColor:UIControlStateNormal];
    }
}




#pragma mark - Override super

- (void) layoutSubviews {
    [super layoutSubviews];
    
    [self p_updateShape];
    [self p_updateColor];
}

- (void) setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    [self p_updateColor];
}


@end
