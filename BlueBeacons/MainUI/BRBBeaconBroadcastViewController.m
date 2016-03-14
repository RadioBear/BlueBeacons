//
//  BRBBeaconBroadcastViewController.m
//  BlueBeacons
//
//  Created by YuGuoXian on 16/3/5.
//  Copyright © 2016年 RadioBear. All rights reserved.
//

#import "BRBBeaconBroadcastViewController.h"
#import "BRBBeaconBroadcast.h"
#import "BRBDefault.h"
#import "BRBAlert.h"
#import "BRBBeaconError.h"
#import "UINavigationController+TransparentNavigationController.h"
#import "BRBRoundButton.h"

#import <CoreLocation/CoreLocation.h>


NS_ASSUME_NONNULL_BEGIN

@interface BRBBeaconBroadcastViewController () <BRBBeaconBroadcastDelegate>

typedef NS_ENUM(NSInteger, ActionState) {
    ActionStateDeviceNotAvailable,
    ActionStateDeviceOff,
    ActionStateBroadcastOn,
    ActionStateBroadcastOff,
};

@property (assign, nonatomic) ActionState actionState;
@property (strong, nonatomic) BRBBeaconBroadcast *beaconBroadcast;
@property (strong, nonatomic, nullable) CLBeaconRegion *curBeaconRegion;

@property (copy, nonatomic) UIColor *beginNormalColor;
@property (copy, nonatomic) UIColor *beginHLColor;
@property (copy, nonatomic) UIColor *stopNormalColor;
@property (copy, nonatomic) UIColor *stopHLColor;

@property (weak, nonatomic) IBOutlet UILabel *labelUUIDInfo;
@property (weak, nonatomic) IBOutlet UILabel *labelMajorInfo;
@property (weak, nonatomic) IBOutlet UILabel *labelMinorInfo;
@property (weak, nonatomic) IBOutlet BRBRoundButton *btnAction;


#pragma make - Private Function

- (void)p_updateActionState;
- (void)p_refreshBeaconRegionInUI;
- (void)p_refreshBroadcastButtonInUI;

@end

@implementation BRBBeaconBroadcastViewController

#pragma mark - UIVIewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.beginNormalColor = [_btnAction buttonColorForState:UIControlStateNormal];
    self.beginHLColor = [_btnAction buttonColorForState:UIControlStateHighlighted];
    self.stopNormalColor = [UIColor redColor];
    self.stopHLColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
    
    self.beaconBroadcast = [[BRBBeaconBroadcast alloc] initWithDelegate:self queue:nil];
    
    self.curBeaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:[NSUUID UUID] major:1 minor:1 identifier:kBRBBeaconIdentifier];
    
    
    [self p_updateActionState];
    [self p_refreshBeaconRegionInUI];
    [self p_refreshBroadcastButtonInUI];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[self.navigationController presentTransparentNavigationBar];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //[self.navigationController hideTransparentNavigationBar];
    
    _beaconBroadcast.delegate = nil;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [_beaconBroadcast stopAdvertising];
}

#pragma mark - Button Action

- (IBAction)onActionButtonTouchUpInside:(BRBRoundButton *)sender {
    if (_beaconBroadcast == nil) {
        return ;
    }
    
    if (_beaconBroadcast.state == BRBBeaconBroadcastStateOff) {
        _beaconBroadcast.beaconRegion = _curBeaconRegion;
        [_beaconBroadcast startAdvertising];
    } else {
        [_beaconBroadcast stopAdvertising];
    }
    
}

#pragma mark - Action State

- (void)p_updateActionState {
    if (_beaconBroadcast == nil) {
        self.actionState = ActionStateDeviceNotAvailable;
        return ;
    }
    
    switch (_beaconBroadcast.deviceState) {
        case BRBBeaconBroadcastDeviceStateUnknown:
        case BRBBeaconBroadcastDeviceStateResetting:
        case BRBBeaconBroadcastDeviceStateUnsupported:
        case BRBBeaconBroadcastDeviceStateUnauthorized:
            self.actionState = ActionStateDeviceNotAvailable;
            break;
        case BRBBeaconBroadcastDeviceStatePoweredOff:
            self.actionState = ActionStateDeviceOff;
            break;
        case BRBBeaconBroadcastDeviceStatePoweredOn:
            if (_beaconBroadcast.state == BRBBeaconBroadcastStateOn) {
                 self.actionState = ActionStateBroadcastOn;
            } else {
                self.actionState = ActionStateBroadcastOff;
            }
            break;
        default:
            NSLog(@"p_updateActionState - can not process:%ld", (long)_beaconBroadcast.deviceState);
            break;
    }
   
}

#pragma mark - Refresh UI

- (void)p_refreshBeaconRegionInUI {
    
    if (_curBeaconRegion) {
        _labelUUIDInfo.text = _curBeaconRegion.proximityUUID.UUIDString;
        _labelMajorInfo.text = _curBeaconRegion.major.stringValue;
        _labelMinorInfo.text = _curBeaconRegion.minor.stringValue;
    } else {
        _labelUUIDInfo.text = NSLocalizedString(@"Not Set", nil);
        _labelMajorInfo.text = NSLocalizedString(@"Not Set", nil);
        _labelMinorInfo.text = NSLocalizedString(@"Not Set", nil);
    }
    
}

- (void)p_refreshBroadcastButtonInUI {
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    switch (_actionState) {
        case ActionStateDeviceNotAvailable:
            [_btnAction setTitle:NSLocalizedString(@"Not Avaliable", nil) forState:UIControlStateNormal];
            _btnAction.enabled = NO;
            break;
        case ActionStateDeviceOff:
            [_btnAction setTitle:NSLocalizedString(@"Device Off", nil) forState:UIControlStateNormal];
            _btnAction.enabled = NO;
            break;
        case ActionStateBroadcastOn:
            [_btnAction setTitle:NSLocalizedString(@"Stop", nil) forState:UIControlStateNormal];
            _btnAction.enabled = YES;
            [_btnAction setButtonColor:_stopNormalColor forState:UIControlStateNormal];
            [_btnAction setButtonColor:_stopHLColor forState:UIControlStateHighlighted];
            [_btnAction updateButtonColor];
            break;
        case ActionStateBroadcastOff:
            [_btnAction setTitle:NSLocalizedString(@"Begin", nil) forState:UIControlStateNormal];
            _btnAction.enabled = YES;
            [_btnAction setButtonColor:_beginNormalColor forState:UIControlStateNormal];
            [_btnAction setButtonColor:_beginHLColor forState:UIControlStateHighlighted];
            [_btnAction updateButtonColor];
            break;
        default:
            NSLog(@"p_refreshBroadcastButtonInUI - can not process:%ld", (long)_actionState);
            break;
    }

    [UIView commitAnimations];
}


#pragma mark - BRBBeaconBroadcastDelegate


- (void) beaconBroadcastDidUpdateState:(BRBBeaconBroadcast *)beaconBroadcast {
    [self p_updateActionState];
    [self p_refreshBroadcastButtonInUI];
}

- (void) beaconBroadcastDidUpdateDeviceState:(BRBBeaconBroadcast *)beaconBroadcast {
    [self p_updateActionState];
    [self p_refreshBroadcastButtonInUI];
}

- (void) beaconBroadcastDidStartAdvertising:(BRBBeaconBroadcast *)beaconBroadcast error:(nullable NSError *)error {
    if (error) {
        //NSLog(@"%@", error.localizedDescription);
        switch (error.code) {
            case BRBBeaconDeviceNotAvailableError:
                [BRBAlert showWithViewController:self title:NSLocalizedString(@"Broadcast Fail", nil) message:NSLocalizedString(@"Bluetooth device not available", nil) buttonText:NSLocalizedString(@"OK", nil)];
                break;
                
            case BRBBeaconRegionNullError:
            case BRBPeripheralManagerAdvertisingError:
                [BRBAlert showWithViewController:self title:NSLocalizedString(@"Broadcast Fail", nil) message:NSLocalizedString(@"Can not begin broadcast", nil) buttonText:NSLocalizedString(@"OK", nil)];
                break;
            default:
                NSLog(@"beaconBroadcastDidStartAdvertising - can not process:%ld", (long)error.code);
                break;
        }
    } else {
        // succeed
    }

}

@end

NS_ASSUME_NONNULL_END
