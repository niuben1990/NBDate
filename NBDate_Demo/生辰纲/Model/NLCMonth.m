//
//  NLCMonth.m
//  生辰纲
//
//  Created by tarena on 15/12/15.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "NLCMonth.h"
#import "NLCDay.h"
#import "NBDate.h"



@implementation NLCMonth

- (NSMutableArray *)allDaysArray
{
    if (!_allDaysArray) {
        _allDaysArray = [NSMutableArray array];
    }
    return _allDaysArray;
}

+ (NLCMonth *)monthWithDate:(NSDate *)date
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy";
    NSUInteger yearNum = [formatter stringFromDate:date].integerValue;
    formatter.dateFormat = @"MM";
    NSUInteger monthNum = [formatter stringFromDate:date].integerValue;
    
    NLCMonth *month = [NLCMonth new];
    month.firstWeekday = [NBDate getFirstWeekdayFromDate:date];
    month.daysCount = [NBDate numberOfDaysInMonthWithDate:date];
    for (int i = 0; i < month.daysCount; i++) {
        NSDate *dayDate = [NBDate dateWithDay:i+1 withMonth:monthNum withYear:yearNum];
        NLCDay *day = [NLCDay dayWithDate:dayDate];
        [month.allDaysArray addObject:day];
    }
    month.month = [month.allDaysArray[0] monthNum];
    month.year = [month.allDaysArray[0] yearNum];
    return month;
}

@end
