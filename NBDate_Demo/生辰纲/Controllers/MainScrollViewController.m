//
//  MainScrollViewController.m
//  生辰纲
//
//  Created by tarena on 15/12/1.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "MainScrollViewController.h"
#import "NLCDayViewController.h"
#import "NLCMonthViewController.h"
#import "PagedFlowView.h"
#import <Masonry.h>
#import <RESideMenu.h>


@interface MainScrollViewController ()<PagedFlowViewDataSource, PagedFlowViewDelegate>

@property (nonatomic, strong) PagedFlowView *pageFlowView;
@property (nonatomic, strong) NLCDayViewController *dayViewController;
@property (nonatomic, strong) NLCMonthViewController *monthViewController;
@property (nonatomic, strong) UIButton *addButton;

@end

@implementation MainScrollViewController

- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_addButton setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        [self.view addSubview:_addButton];
        [_addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.bottom.mas_equalTo(-23);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        [_addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

- (NLCDayViewController *)dayViewController
{
    if (!_dayViewController) {
        _dayViewController = [[NLCDayViewController alloc] initWithNibName:@"NLCDayViewController" bundle:nil];
    }
    return _dayViewController;
}

- (NLCMonthViewController *)monthViewController
{
    if (!_monthViewController) {
        _monthViewController = [[NLCMonthViewController alloc] initWithNibName:@"NLCMonthViewController" bundle:nil];
    }
    return _monthViewController;
}

- (void)addButtonClick {
    [self.sideMenuViewController presentLeftMenuViewController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupPageFlowView];
    
    self.addButton.hidden = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(monthViewDidSelectDay) name:@"didSelectDayItem" object:nil];
}


- (void)monthViewDidSelectDay
{
    [self.pageFlowView scrollToPage:0];
}

- (void)setupPageFlowView
{
    self.pageFlowView = [[PagedFlowView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.pageFlowView.delegate = self;
    self.pageFlowView.dataSource = self;
    self.pageFlowView.minimumPageAlpha = 1;
    self.pageFlowView.minimumPageScale = 1;
    [self.view addSubview:self.pageFlowView];
}

#pragma mark --- PagedFlowViewDataSource
- (NSInteger)numberOfPagesInFlowView:(PagedFlowView *)flowView
{
    return 2;
}

- (UIView *)flowView:(PagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index
{
    if (index == 0) {
        return self.dayViewController.view;
    }else{
        return self.monthViewController.view;
    }
}

- (CGSize)sizeForPageInFlowView:(PagedFlowView *)flowView
{
    return self.view.bounds.size;
}

@end
