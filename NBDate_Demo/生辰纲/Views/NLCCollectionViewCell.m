//
//  NLCCollectionViewCell.m
//  生辰纲
//
//  Created by tarena on 15/12/12.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "NLCCollectionViewCell.h"
#import "NBDate.h"

#define TEXT_COLOR [UIColor colorWithRed:0x3b/255.0 green:0x3e/255.0 blue:0x3f/255.0 alpha:1]

@interface NLCCollectionViewCell ()

@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *lunarDayLabel;
@property (nonatomic, strong) UIImageView *todayImageView;
@end

@implementation NLCCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 2 * frame.size.height / 3.0)];
        self.dayLabel.font = [UIFont fontWithName:@"TimesNewRomanPSMT" size:24];
        self.dayLabel.textColor = TEXT_COLOR;
        self.dayLabel.textAlignment = NSTextAlignmentCenter;
        
        
        self.lunarDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.dayLabel.frame)-5, frame.size.width, frame.size.height / 3.0)];
        self.lunarDayLabel.font = [UIFont systemFontOfSize:12];
        self.lunarDayLabel.textAlignment = NSTextAlignmentCenter;
        self.lunarDayLabel.textColor = TEXT_COLOR;
        [self.contentView addSubview:self.lunarDayLabel];
    }
    return self;
}

- (void)setDayStr:(NSString *)dayStr
{
    self.dayLabel.text = dayStr;
}

- (void)setLunarDayStr:(NSString *)lunarDayStr
{
    self.lunarDayLabel.text = lunarDayStr;
}

- (void)setIsToday:(BOOL)isToday
{
    _isToday = isToday;
    if (_isToday) {
        [self.contentView addSubview:self.todayImageView];
    }else{
        [self.todayImageView removeFromSuperview];
    }
    [self.contentView addSubview:self.dayLabel];
}

- (UIImageView *)todayImageView {
	if(_todayImageView == nil) {
		_todayImageView = [[UIImageView alloc] init];
        _todayImageView.image = [UIImage imageNamed:@"today_bg"];
        _todayImageView.frame = CGRectMake(0, 0, self.bounds.size.width, 2 * self.bounds.size.height / 3.0);
        _todayImageView.contentMode = UIViewContentModeScaleAspectFit;
	}
	return _todayImageView;
}

@end
