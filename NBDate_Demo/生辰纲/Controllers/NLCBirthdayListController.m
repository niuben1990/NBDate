//
//  NLCBirthdayListController.m
//  生辰纲
//
//  Created by tarena on 15/12/25.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "NLCBirthdayListController.h"
#import "NLCEventDataTool.h"
#import "NLCBirthdayTableViewCell.h"
#import "NLCInsertEventViewController.h"

@interface NLCBirthdayListController ()

@property (nonatomic, strong) NSArray *allBirthdayArray;

@end

@implementation NLCBirthdayListController

- (NSArray *)allBirthdayArray {
    if (!_allBirthdayArray) {
        _allBirthdayArray = [NLCEventDataTool parseEventWithType:NLCEventTypeBirthday];
    }
    return _allBirthdayArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(databaseDidChange) name:@"eventDidInsert" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"eventDidInsert" object:nil];
}

- (void)databaseDidChange {
    self.allBirthdayArray = nil;
    NSLog(@"%@",[NSThread currentThread]);
    [self.tableView reloadData];
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
    return self.allBirthdayArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NLCBirthdayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"birthdayEventCell" forIndexPath:indexPath];
    NLCEvent *event = self.allBirthdayArray[indexPath.row];
    cell.name.text = event.title;
    cell.gender.text = event.detail;
    if ([event.detail isEqualToString:@"男"]) {
        cell.backgroundColor = [UIColor colorWithRed:122/255.0 green:1 blue:46/255.0 alpha:0.29];
    } else {
        cell.backgroundColor = [UIColor colorWithRed:211/255.0 green:76/255.0 blue:1 alpha:0.24];
    }
    cell.headerImageView.image = [NLCEventDataTool imageParseWithBase64:event.headerImageString];
    
    cell.nextTime.text = [NSString stringWithFormat:@"%ld", [NLCEventDataTool numberOfDaysEventTimeToCurrentDayWithEvent:event]];
    if (event.isLunar == YES) {
        cell.birthday.text = [NSString stringWithFormat:@"%@年%@%@", event.year, event.month, event.day];
    } else {
        cell.birthday.text = [NSString stringWithFormat:@"%@-%@-%@", event.year, event.month, event.day];
    }
    cell.headerImageView.layer.cornerRadius = 10;
    cell.headerImageView.layer.masksToBounds = YES;
    cell.idNum = event.identifier;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString: @"InsertBirthdaySegue"]) {
        NLCInsertEventViewController *viewController = segue.destinationViewController;
        viewController.eventType = NLCEventTypeBirthday;
    }
}

- (IBAction)edit:(id)sender {
    self.tableView.editing = !self.tableView.editing;
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

@end
