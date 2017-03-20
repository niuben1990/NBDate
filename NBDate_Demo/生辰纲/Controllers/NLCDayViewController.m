//
//  NLCDayViewController.m
//  生辰纲
//
//  Created by tarena on 15/12/1.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "NLCDayViewController.h"
#import "NLCDay.h"
#import "NBDate.h"
#import <RESideMenu.h>


@interface NLCDayViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *eventTableView;
@property (weak, nonatomic) IBOutlet UILabel *solarCalendarLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekdaylabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableRightConstraint;

@property (nonatomic, strong) UIView *lunarView;
@property (nonatomic, strong) UIView *festivalLabel;
@property (nonatomic ,strong) NLCDay *day;
@property (nonatomic, strong) NSArray *textColorArray;


@end

@implementation NLCDayViewController

- (NSArray *)textColorArray
{
    if (_textColorArray == nil) {
        _textColorArray = @[[UIColor redColor], [UIColor magentaColor], [UIColor grayColor], [UIColor orangeColor], [UIColor cyanColor], [UIColor blueColor], [UIColor purpleColor]];
    }
    return _textColorArray;
}

- (NLCDay *)day
{
    if (!_day) {
        _day = [NLCDay dayWithDate:[NSDate date]];
    }
    return _day;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupLabel];
    
    [self setupEventTableView];
    
    [self addGestureRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dayDidChange:) name:@"didSelectDayItem" object:nil];

}

- (void)dayDidChange:(NSNotification *)noti
{
    self.day = noti.userInfo[@"day"];
    [self setupLabel];
}

- (void)setupEventTableView
{
    self.eventTableView.backgroundColor = [UIColor clearColor];
    self.eventTableView.delegate = self;
    self.eventTableView.dataSource = self;
//    self.eventTableView.separatorColor = [UIColor clearColor];
    self.eventTableView.showsVerticalScrollIndicator = NO;
    self.eventTableView.tableFooterView = [UIView new];
    self.tableRightConstraint.constant = SCREEN_WIDTH *0.3;
    
}

- (void)setupLabel
{
    if (self.lunarView) {
        [self.lunarView removeFromSuperview];
    }
    if (self.festivalLabel) {
        [self.festivalLabel removeFromSuperview];
    }
    self.lunarView = [self addLunarLabelWithContent:self.day.lunarCalendarName andLineMargin:5 andBrackets:NO];
    self.festivalLabel = [self addLunarLabelWithContent:@"大雪" andLineMargin:5 andBrackets:YES];
    
    self.lunarView.frame = CGRectMake(SCREEN_WIDTH*0.7 - CGRectGetWidth(self.lunarView.bounds)*0.5, 80, CGRectGetWidth(self.lunarView.bounds), CGRectGetHeight(self.lunarView.bounds));
    CGRect rect = self.festivalLabel.frame;
    rect.origin = CGPointMake(CGRectGetMaxX(self.lunarView.frame) + 60, 90);
    self.festivalLabel.frame = rect;
    
    [self.view addSubview:self.lunarView];
    [self.view addSubview:self.festivalLabel];
    
    self.solarCalendarLabel.text = [NSString stringWithFormat:@"%ld年%ld月%ld日", self.day.yearNum, self.day.monthNum, self.day.dayNum];
    self.weekdaylabel.text = @[@"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六"][self.day.weekdayNum - 1];
}

- (UIView *)addLunarLabelWithContent:(NSString *)content andLineMargin:(CGFloat)margin andBrackets:(BOOL)haveBrackets
{
    CGFloat y = 0;
    UIView *lunarLabelView = [UIView new];
    if (haveBrackets) {
        UIImageView* bracket = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 22, 9)];
        bracket.contentMode = UIViewContentModeScaleAspectFill;
        bracket.backgroundColor = [UIColor clearColor];
        bracket.image = [UIImage imageNamed:@"kuohao1.png"];
        [lunarLabelView addSubview:bracket];
        bracket.center = CGPointMake(lunarLabelView.frame.size.width/2.0, CGRectGetMidY(bracket.frame));
        y += 9;
    }
    for (int i = 0; i < content.length; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, y, 48, 48)];
        label.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:28];
        label.numberOfLines = 1;
        label.shadowColor = [UIColor colorWithRed:0x9a/255.0f green:0x9a/255.0f blue:0x9a/255.0f alpha:1];
        label.shadowOffset = CGSizeMake(0, 1);
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [content substringWithRange:NSMakeRange(i, 1)];
        [label sizeToFit];
        [label setCenter:CGPointMake(CGRectGetMidX(lunarLabelView.frame), CGRectGetMidY(label.frame))];
        [lunarLabelView addSubview:label];
        
        y = CGRectGetMaxY(label.frame) + margin;
        label = nil;
    }
    if (haveBrackets) {
        UIImageView* bracket = [[UIImageView alloc] initWithFrame:CGRectMake(0, y, 22, 9)];
        bracket.contentMode = UIViewContentModeScaleAspectFill;
        bracket.backgroundColor = [UIColor clearColor];
        bracket.image = [UIImage imageNamed:@"kuohao2.png"];
        [lunarLabelView addSubview:bracket];
        bracket.center = CGPointMake(lunarLabelView.frame.size.width/2.0, CGRectGetMidY(bracket.frame));
        y += 9;
    }
    [lunarLabelView sizeToFit];
    CGRect rect = lunarLabelView.frame;
    rect.size.height = y;
    lunarLabelView.frame = rect;
    return lunarLabelView;
}


#pragma mark --- setupGestureRecognizer
- (void)addGestureRecognizer
{
    UISwipeGestureRecognizer *upSwipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(upSwipe:)];
    UISwipeGestureRecognizer *downSwipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(downSwipe:)];
    
    upSwipeGR.direction = UISwipeGestureRecognizerDirectionUp;
    downSwipeGR.direction = UISwipeGestureRecognizerDirectionDown;
    
    [self.view addGestureRecognizer:upSwipeGR];
    [self.view addGestureRecognizer:downSwipeGR];
}

- (void)upSwipe:(UISwipeGestureRecognizer *)swipeGR
{
    [self gotoNextDay];
}

- (void)downSwipe:(UISwipeGestureRecognizer *)swipeGR
{
    [self gotoBeforeDay];
}
/** 翻到下一天 */
- (void)gotoNextDay
{
    [self setupAnimations:UIViewAnimationTransitionCurlUp];
    NSDate *date = [NBDate nextDayDate:self.day.date];
    [self refreshUIWithDate:date];
}
/** 翻到上一天 */
- (void)gotoBeforeDay
{
    [self setupAnimations:UIViewAnimationTransitionCurlDown];
    NSDate *date = [NBDate lastDayDate:self.day.date];
    [self refreshUIWithDate:date];
}
/** 刷新界面 */
- (void)refreshUIWithDate:(NSDate *)date {
    self.day = [NLCDay dayWithDate:date];
    [self setupLabel];
}

#pragma mark --- setupAnimations
/** 设置翻页动画 */
- (void)setupAnimations:(UIViewAnimationTransition)transition
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.7];
    [UIView setAnimationTransition:transition forView:self.view cache:YES];
    [UIView commitAnimations];
}

#pragma mark --- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eventCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eventCell"];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.imageView.image = [UIImage imageNamed:@"birthday"];
    cell.textLabel.text = @"陈生日";
    cell.textLabel.textColor = self.textColorArray[arc4random() % self.textColorArray.count];
    cell.textLabel.font = [UIFont systemFontOfSize:25];
    cell.userInteractionEnabled = NO;
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 15;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 8;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"生日";
    }else if (section == 1){
        return @"事项";
    }else{
        return @"节日";
    }
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
