//
//  UIView+IBDesignable.h
//  BlueBeacons
//
//  Created by YuGuoXian on 16/3/7.
//  Copyright © 2016年 RadioBear. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

IB_DESIGNABLE
@interface UIView (IBDesignable)

@property (assign, nonatomic) IBInspectable BOOL shouldRasterize;

@property (assign, nonatomic) IBInspectable BOOL masksToBounds;

@property (assign, nonatomic) IBInspectable CGFloat cornerRadius;

@property (assign, nonatomic) IBInspectable CGFloat borderWidth;

@property (copy, nonatomic) IBInspectable UIColor *borderColor;

@property (copy, nonatomic) IBInspectable UIColor *shadowColor;

@property (assign, nonatomic) IBInspectable CGFloat shadowOpacity;

@property (assign, nonatomic) IBInspectable CGFloat shadowRadius;

@property (assign, nonatomic) IBInspectable CGSize shadowOffset;

@end


NS_ASSUME_NONNULL_END