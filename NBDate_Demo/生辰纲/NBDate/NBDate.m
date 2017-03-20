//
//  NBDate.m
//  生辰纲
//
//  Created by tarena on 15/12/10.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "NBDate.h"



@interface NBDate ()

@property (nonatomic, strong) NSArray *chineseYears;

@end

@implementation NBDate

+ (NSCalendar *)gregorianCalendar
{
    return [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
}

#pragma mark --- currentDateTool
static NSDateComponents *current_Components;
+ (NSDateComponents *)currentComponents
{
    if (current_Components == nil) {
        current_Components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear |NSCalendarUnitWeekday fromDate:[NSDate date]];
    }

    return current_Components;
}

/// 当前天
+ (NSInteger)getCurrentDay
{
    return [self currentComponents].day;
}
/// 当前月份
+ (NSInteger)getCurrentMonth
{
    return [self currentComponents].month;
}
/// 当前年份
+ (NSInteger)getCurrentYear
{
    return [self currentComponents].year;
}
/// 当前是星期几
+ (NSInteger)getCurrentWeekday
{
    return [self currentComponents].weekday;
}
/// 当前月共有几天
+ (NSInteger)numberOfDaysInCurrentMonth
{
    return [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[NSDate date]].length;
}


#pragma mark --- customDateTool

+ (NSDateComponents *)componentsFromDate:(NSDate *)date
{
    NSDateComponents *date_components = [[self gregorianCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear |NSCalendarUnitWeekday fromDate:date];
    return date_components;
}

/// 指定月第一天是星期几
+ (NSInteger)getFirstWeekdayFromDate:(NSDate *)date
{
    NSDateComponents *components = [self componentsFromDate:date];
    NSInteger dateWeekday = components.weekday;
    NSInteger dateDay = components.day;
    if ((dateDay - dateWeekday) % 7 == 0){
        return 1;
    }else{
        if (dateDay < dateWeekday) {
            return dateWeekday - dateDay + 1;
        }else{
            return (7 - (dateDay - dateWeekday) % 7 + 1);
        }
    }
}

/// 指定月共有几天
+ (NSInteger)numberOfDaysInMonthWithDate:(NSDate *)date
{
    return [[self gregorianCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
}

/// 给定年、月、日，获取对应Date
+ (NSDate *)dateWithDay:(NSInteger)day withMonth:(NSInteger)month withYear:(NSInteger)year
{
    NSDateComponents *components = [NSDateComponents new];
    [components setDay:day];
    [components setMonth:month];
    [components setYear:year];
    
    return [[self gregorianCalendar] dateFromComponents:components];
}

/// 上一个月的日期
+ (NSDate *)lastMonthDate:(NSDate *)date
{
    NSCalendar *calendar = [self gregorianCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitWeekday | NSCalendarUnitMonth |NSCalendarUnitYear | NSCalendarUnitDay) fromDate:date];
    if ([components month] == 1) {
        [components setMonth:12];
        [components setYear:[components year] - 1];
    } else {
        [components setMonth:[components month] - 1];
    }
    NSDate *lastMonth = [calendar dateFromComponents:components];
    return lastMonth;
}

/// 下一个月的日期
+ (NSDate *)nextMonthDate:(NSDate *)date
{
    NSCalendar *calendar = [self gregorianCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitWeekday | NSCalendarUnitMonth |NSCalendarUnitYear | NSCalendarUnitDay) fromDate:date];
    if ([components month] == 12) {
        [components setMonth:1];
        [components setYear:[components year] + 1];
    } else {
        [components setMonth:[components month] + 1];
        
    }
    NSDate *nextMonth = [calendar dateFromComponents:components];
    return nextMonth;
}

/// 下一天的日期
+ (NSDate *)nextDayDate:(NSDate *)date {
    NSCalendar *calendar = [self gregorianCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitWeekday | NSCalendarUnitMonth |NSCalendarUnitYear | NSCalendarUnitDay) fromDate:date];
    if (components.day == [self numberOfDaysInMonthWithDate:date]) {
        components.day = 1;
        if (components.month == 12) {
            components.month = 1;
            components.year += 1;
        } else {
            components.month += 1;
        }
    } else {
        components.day += 1;
    }
    NSDate *nextDay = [calendar dateFromComponents:components];
    return nextDay;
}

/// 上一天的日期
+ (NSDate *)lastDayDate:(NSDate *)date {
    NSCalendar *calendar = [self gregorianCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitWeekday | NSCalendarUnitMonth |NSCalendarUnitYear | NSCalendarUnitDay) fromDate:date];
    if (components.day == 1) {
        components.day = [self numberOfDaysInMonthWithDate:[self lastMonthDate:date]];
        if (components.month == 1) {
            components.month = 12;
            components.year -= 1;
        } else {
            components.month -= 1;
        }
    } else {
        components.day -= 1;
    }
    NSDate *nextDay = [calendar dateFromComponents:components];
    return nextDay;
}

/// 下一年的日期
+ (NSDate *)nextYearDate:(NSDate *)date
{
    NSCalendar *calendar = [self gregorianCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitWeekday | NSCalendarUnitMonth |NSCalendarUnitYear | NSCalendarUnitDay) fromDate:date];
    components.year += 1;
    NSDate *nextYear = [calendar dateFromComponents:components];
    return nextYear;
}

#pragma mark --- lunarDateTool
/// 获取指定日期对应的农历
+ (NSString *)lunarCalendarWithDate:(NSDate *)date andType:(NLCLunarDateType)type {
    
    NSArray *chineseYears = CHINESE_YEAR_ALL;
                             
    
    NSArray *chineseMonths = CHINESE_MONTH_ALL;
    
    
    NSArray *chineseDays = CHINESE_DAY_ALL;
    
    
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:date];
    
    NSString *y_str = [chineseYears objectAtIndex:localeComp.year-1];
    NSString *m_str = [chineseMonths objectAtIndex:localeComp.month-1];
    NSString *d_str = [chineseDays objectAtIndex:localeComp.day-1];
    
    NSString *chineseCal_str =[NSString stringWithFormat: @"%@年%@%@",y_str,m_str,d_str];
    switch (type) {
        case NLCLunarDateTypeDay:
            return d_str;
        case NLCLunarDateTypeMonth:
            return m_str;
        case NLCLunarDateTypeYear:
            return y_str;
        case NLCLunarDateTypeAll:
            return chineseCal_str;
            
        default:
            return nil;
    }
}

/// 农历日对应的阿拉伯数字
+ (NSInteger)arabicNumberOfLunarDay:(NSString *)day {
    NSArray *chineseDays = CHINESE_DAY_ALL;
    NSInteger lunarDay = 1;
    for (; lunarDay <= chineseDays.count; lunarDay++) {
        if ([day isEqualToString:chineseDays[lunarDay - 1]]) {
            break;
        }
    }
    return lunarDay;
}

/// 农历月份对应的阿拉伯数字
+ (NSInteger)arabicNumberOfLunarMonth:(NSString *)month {
    NSArray *chineseMonths = CHINESE_MONTH_ALL;
    NSInteger lunarMonth = 1;
    for (; lunarMonth <= chineseMonths.count; lunarMonth++) {
        if ([month isEqualToString:chineseMonths[lunarMonth - 1]]) {
            break;
        }
    }
    return lunarMonth;
}

/// 农历年份对应的阿拉伯数字
+ (NSInteger)arabicNumberOfLunarYear:(NSString *)year {
    NSArray *chineseYears = CHINESE_YEAR_ALL;
    NSInteger lunarYear = 1;
    for (; lunarYear <= chineseYears.count; lunarYear++) {
        if ([year isEqualToString:chineseYears[lunarYear - 1]]) {
            break;
        }
    }
    return lunarYear;
}

/// 给定农历年、月、日，获取对应的Date
+ (NSDate *)dateWithLunarDay:(NSString *)day withLunarMonth:(NSString *)month withLunarYear:(NSString *)year {
    
    NSInteger lunarYear = [self arabicNumberOfLunarYear:year];
    NSInteger lunarMonth = [self arabicNumberOfLunarMonth:month];
    NSInteger lunarDay = [self arabicNumberOfLunarDay:day];
    
    NSCalendar *lunarCalendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierChinese];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    
    NSDateComponents *components = [lunarCalendar components:unitFlags fromDate:[NSDate date]];
    components.day = lunarDay + 1;
    components.month = lunarMonth;
    components.year = lunarYear;
    
    NSDate *date = [lunarCalendar dateFromComponents:components];
    
    return date;
}

+ (NSInteger)numberOfLunarDaysInLunarMonth:(NSString *)month andLunarYear:(NSString *)year {
    
    NSInteger lunarMonth = [self arabicNumberOfLunarMonth:month];
    
    NSDate *date = [self dateWithLunarDay:@"廿九" withLunarMonth:month withLunarYear:year];
    
    NSCalendar *lunarCalendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierChinese];
    unsigned unitFlags = NSCalendarUnitMonth |  NSCalendarUnitDay;
    
    NSDateComponents *components = [lunarCalendar components:unitFlags fromDate:date];
    
    components.day += 1;
    if (components.month != lunarMonth) {
        return 29;
    } else {
        return 30;
    }
}

/// 农历下一年的日期
+ (NSDate *)nextLunarYear:(NSDate *)date {
    
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:date];
    
    localeComp.year += 1;
    
    NSDate *nextYearDate = [localeCalendar dateFromComponents:localeComp];
    return nextYearDate;
}

@end
