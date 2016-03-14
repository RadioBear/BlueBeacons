//
//  UINavigationController+TransparentNavigationController.m
//  BlueBeacons
//
//  Created by YuGuoXian on 16/3/7.
//  Copyright © 2016年 RadioBear. All rights reserved.
//

#import "UINavigationController+TransparentNavigationController.h"

@implementation UINavigationController (TransparentNavigationController)

- (void)presentTransparentNavigationBar
{
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setTranslucent:YES];
    [self.navigationBar setShadowImage:[UIImage new]];
    [self setNavigationBarHidden:NO animated:YES];
}

- (void)hideTransparentNavigationBar
{
    [self setNavigationBarHidden:YES animated:NO];
    [self.navigationBar setBackgroundImage:[[UINavigationBar appearance] backgroundImageForBarMetrics:UIBarMetricsDefault] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setTranslucent:[[UINavigationBar appearance] isTranslucent]];
    [self.navigationBar setShadowImage:[[UINavigationBar appearance] shadowImage]];
}

@end
