//
//  BRBBeaconCentralViewController.m
//  BlueBeacons
//
//  Created by YuGuoXian on 16/3/12.
//  Copyright © 2016年 RadioBear. All rights reserved.
//

#import "BRBBeaconCentralViewController.h"
#import "BRBBeaconCentral.h"
#import "BRBBeaconInfoTableViewCell.h"
#import "BRBBeacon.h"

@interface BRBBeaconCentralViewController () <BRBBeaconCentralDelegate>

@property (strong, nonatomic) BRBBeaconCentral *beaconCentral;
@property (strong, nonatomic) NSMutableArray *beacons;
@property (strong, nonatomic) NSMutableArray *peripherals;

@end

@implementation BRBBeaconCentralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    self.beaconCentral = [[BRBBeaconCentral alloc] initWithDelegate:self queue:nil];

    self.beacons = [NSMutableArray array];
    self.peripherals = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_beacons count] + [_peripherals count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *const beaconCellIdentifier = @"BeaconCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:beaconCellIdentifier forIndexPath:indexPath];
    BRBBeaconInfoTableViewCell *beaconCell = (BRBBeaconInfoTableViewCell *)cell;
    // Configure the cell...
    
    BRBPeripheral *peripheral = _peripherals[indexPath.row];
    [beaconCell setBeaconName:[peripheral name]];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - BRBBeaconCentralDelegate

- (void) beaconCentralDidUpdateDeviceState:(BRBBeaconCentral *)beaconCentral {
    if (beaconCentral.deviceState == BRBBeaconCentralDeviceStatePoweredOn) {
        [beaconCentral startScanning];
    }
}

- (void) beaconCentral:(BRBBeaconCentral *)beaconCentral didDiscoverBeacon:(BRBBeacon *)beacon {
    
    [_beacons addObject:beacon];
}

- (void) beaconCentral:(BRBBeaconCentral *)beaconCentral didDiscoverPeripheral:(BRBPeripheral *)peripheral {
    
    [_peripherals addObject:peripheral];
    [self.tableView reloadData];
}

@end
