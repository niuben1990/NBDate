//
//  NLCDay.m
//  生辰纲
//
//  Created by tarena on 15/12/14.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "NLCDay.h"
#import "NBDate.h"

@interface NLCDay ()

@property (nonatomic, strong) NSDateComponents *components;


@end

@implementation NLCDay

+ (NLCDay *)dayWithDate:(NSDate *)date
{
    NLCDay *day = [NLCDay new];
    day.date = date;
    day.components = [NBDate componentsFromDate:date];
    day.dayNum = day.components.day;
    day.monthNum = day.components.month;
    day.yearNum = day.components.year;
    day.weekdayNum = day.components.weekday;
    day.lunarDayName = [NBDate lunarCalendarWithDate:date andType:NLCLunarDateTypeDay];
    day.lunarMonthName = [NBDate lunarCalendarWithDate:date andType:NLCLunarDateTypeMonth];
    day.lunarCalendarName = [NBDate lunarCalendarWithDate:date andType:NLCLunarDateTypeAll];
    return day;
}

@end
