//
//  UIView+IBDesignable.m
//  BlueBeacons
//
//  Created by YuGuoXian on 16/3/7.
//  Copyright © 2016年 RadioBear. All rights reserved.
//

#import "UIView+IBDesignable.h"


NS_ASSUME_NONNULL_BEGIN

@implementation UIView (IBDesignable)

@dynamic shouldRasterize;

- (BOOL)shouldRasterize
{
    return self.layer.shouldRasterize;
}

- (void)setShouldRasterize:(BOOL)shouldRasterize
{
    self.layer.shouldRasterize = shouldRasterize;
    if (shouldRasterize) {
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    }
}

@dynamic masksToBounds;

- (BOOL)masksToBounds
{
    return self.layer.masksToBounds;
}

- (void)setMasksToBounds:(BOOL)masksToBounds
{
    self.layer.masksToBounds = masksToBounds;
}

@dynamic cornerRadius;

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
}

#pragma mark - border

@dynamic borderWidth;

- (CGFloat)borderWidth {
    return self.layer.borderWidth;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

@dynamic borderColor;

- (UIColor*) borderColor {
    return [[UIColor alloc] initWithCGColor:self.layer.borderColor];
}

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

#pragma mark - shadow

@dynamic shadowColor;

- (UIColor *)shadowColor
{
    return [UIColor colorWithCGColor:self.layer.shadowColor];
}

- (void)setShadowColor:(UIColor *)shadowColor
{
    self.layer.shadowColor = shadowColor.CGColor;
}

@dynamic shadowOpacity;

- (CGFloat)shadowOpacity
{
    return self.layer.shadowOpacity;
}

- (void)setShadowOpacity:(CGFloat)shadowOpacity
{
    self.layer.shadowOpacity = shadowOpacity;
}

@dynamic shadowRadius;

- (CGFloat)shadowRadius
{
    return self.layer.shadowRadius;
}

- (void)setShadowRadius:(CGFloat)shadowRadius
{
    self.layer.shadowRadius = shadowRadius;
}

@dynamic shadowOffset;

- (CGSize)shadowOffset
{
    return self.layer.shadowOffset;
}

- (void)setShadowOffset:(CGSize)shadowOffset
{
    self.layer.shadowOffset = shadowOffset;
}



@end

NS_ASSUME_NONNULL_END