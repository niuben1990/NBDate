//
//  NLCLeftMenuViewController.m
//  生辰纲
//
//  Created by tarena on 15/12/21.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "NLCLeftMenuViewController.h"
#import "MainScrollViewController.h"
#import <RESideMenu.h>

@interface NLCLeftMenuViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *allButtons;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *allInsertButtons;

@property (weak, nonatomic) IBOutlet UIButton *gotoCalendarButton;

@end

@implementation NLCLeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)eventList:(UIButton *)sender {
    
    UIStoryboard *stroyBoard =[UIStoryboard storyboardWithName:@"NLCEventList" bundle:nil];
    UITabBarController *tabBar = stroyBoard.instantiateInitialViewController;
    tabBar.selectedIndex = [self.allButtons indexOfObject:sender];
    
    [self.sideMenuViewController setContentViewController:tabBar];
    [self.sideMenuViewController hideMenuViewController];
    
    self.gotoCalendarButton.hidden = NO;
}

- (IBAction)gotoCalendarButtonClick:(id)sender {
    
    MainScrollViewController *scrollViewController = [MainScrollViewController new];
    [self.sideMenuViewController setContentViewController:scrollViewController];
    [self.sideMenuViewController hideMenuViewController];
    
    self.gotoCalendarButton.hidden = YES;
}

- (IBAction)insertEvent:(UIButton *)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
