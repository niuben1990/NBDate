//
//  NLCMonthViewController.m
//  生辰纲
//
//  Created by tarena on 15/12/3.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "NLCMonthViewController.h"
#import "NBDate.h"
#import "NLCCollectionViewCell.h"
#import "NLCDay.h"
#import "NLCMonth.h"
#import "MainScrollViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface NLCMonthViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UIImageView *datePickerIndicatorView;
@property (weak, nonatomic) IBOutlet UIView *yearAndMonthView;
@property (weak, nonatomic) IBOutlet UICollectionView *dayLayoutCollectionView;
@property (nonatomic, strong) NSDate *date;

@property (nonatomic, strong) NLCDay *day;
@property (nonatomic, strong) NLCMonth *month;
@property (weak, nonatomic) IBOutlet UIView *datePickerView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation NLCMonthViewController

- (NLCMonth *)month
{
    if (!_month) {
        _month = [NLCMonth monthWithDate:self.date];
    }
    return _month;
}

- (NSDate *)date
{
    if (!_date) {
        _date = [NSDate date];
    }
    return _date;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupYearAndMonthLabel];
    
    [self setupCollectionView];
    
    [self addGestureRecognizer];
}

#pragma mark setupGestureRecognizer
- (void)addGestureRecognizer
{
    UISwipeGestureRecognizer *upSwipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(upSwipe:)];
    UISwipeGestureRecognizer *downSwipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(downSwipe)];
    
    upSwipeGR.direction = UISwipeGestureRecognizerDirectionUp;
    downSwipeGR.direction = UISwipeGestureRecognizerDirectionDown;
    
    
    [self.dayLayoutCollectionView addGestureRecognizer:upSwipeGR];
    [self.dayLayoutCollectionView addGestureRecognizer:downSwipeGR];
}

- (void)upSwipe:(UISwipeGestureRecognizer *)GR
{
    [self goNextMonth];
}

- (void)downSwipe
{
    [self goLastMonth];
}
/// 跳转到下一个月
- (void)goNextMonth
{
    [self performAnimations:kCATransitionFromTop];
    self.date = [NBDate nextMonthDate:self.date];
    [self refreshUI];
}
/// 跳转到上一个月
- (void)goLastMonth
{
    [self performAnimations:kCATransitionFromBottom];
    self.date = [NBDate lastMonthDate:self.date];
    [self refreshUI];
}
/// 刷新界面
- (void)refreshUI
{
    self.month = nil;
    [self.dayLayoutCollectionView reloadData];
    self.yearLabel.text = @(self.month.year).stringValue;
    self.monthLabel.text = @(self.month.month).stringValue;
}


- (void)setupCollectionView
{
    self.dayLayoutCollectionView.dataSource = self;
    self.dayLayoutCollectionView.delegate = self;
    [self.dayLayoutCollectionView registerClass:[NLCCollectionViewCell class] forCellWithReuseIdentifier:@"collectionCell"];
    self.dayLayoutCollectionView.backgroundColor = [UIColor clearColor];
}

#pragma mark --- UICollectionViewDelegate/DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 42;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NLCCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];

    
    if ((indexPath.item >= self.month.firstWeekday - 1) && (indexPath.item <= self.month.daysCount + self.month.firstWeekday - 2)) {
        NSInteger daysIndex = indexPath.item - self.month.firstWeekday + 1;
        self.day = self.month.allDaysArray[daysIndex];
        if ([self.day.lunarDayName isEqualToString: @"初一"]) {
            cell.lunarDayStr = self.day.lunarMonthName;
        } else {
            cell.lunarDayStr = self.day.lunarDayName;
        }
        cell.dayStr = [NSString stringWithFormat:@"%ld", self.day.dayNum];

        if (self.day.dayNum == [NBDate getCurrentDay] && self.day.monthNum == [NBDate getCurrentMonth] && self.day.yearNum == [NBDate getCurrentYear]) {
            cell.isToday = YES;
        }else{
            cell.isToday = NO;
        }
        self.day = nil;
    }else{
        cell.dayStr = @"";
        cell.lunarDayStr = @"";
        cell.isToday = NO;
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.item >= self.month.firstWeekday - 1) && (indexPath.item <= self.month.daysCount + self.month.firstWeekday - 2)) {
        self.day = self.month.allDaysArray[indexPath.item - self.month.firstWeekday + 1];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectDayItem" object:nil userInfo:@{@"day":self.day}];
        self.day = nil;
    }
}


# pragma mark --- setupHeadView
- (void)setupYearAndMonthLabel
{
    self.yearLabel.text = [NSString stringWithFormat:@"%ld", [NBDate getCurrentYear]];
    self.monthLabel.text = [NSString stringWithFormat:@"%ld", [NBDate getCurrentMonth]];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openDatePicker)];
    [self.yearAndMonthView addGestureRecognizer:tapGR];
    
    
}

- (void)openDatePicker
{
    self.datePickerView.hidden = !self.datePickerView.hidden;
}

#pragma mark --- IBAction
- (IBAction)backCurrentMonth:(id)sender {
    if (self.datePickerView.hidden == NO) {
        return;
    }
    if (self.month.month == [NBDate getCurrentMonth] && self.month.year == [NBDate getCurrentYear]) {
        return;
    }
    [self performAnimations:kCATransitionFromBottom];
    self.date = [NSDate date];
    [self refreshUI];
}

- (IBAction)closeDatePicker:(id)sender {
    self.datePickerView.hidden = YES;
}
- (IBAction)finishChooseNewDate:(id)sender {
    self.date = self.datePicker.date;
    self.datePickerView.hidden = YES;
    [self refreshUI];
    if (self.month.month == [NBDate getCurrentMonth] && self.month.year == [NBDate getCurrentYear]) {
        return;
    }
    [self performAnimations:kCATransitionFromBottom];
}

#pragma mark --- setupAnimations
- (void)performAnimations:(NSString *)transition{
    CATransition *catransition = [CATransition animation];
    catransition.duration = 0.35;
    [catransition setTimingFunction:UIViewAnimationCurveEaseInOut];
    catransition.type = kCATransitionPush; //choose your animation
    catransition.subtype = transition;
    [self.dayLayoutCollectionView.layer addAnimation:catransition forKey:nil];

//    [dayLayoutHouseView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - HEADER_VIEW_HEIGHT)];
//    [baseViewHoldingTranslate addSubview:dayLayoutHouseView];
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
