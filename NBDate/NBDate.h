//
//  NBDate.h
//  生辰纲
//
//  Created by tarena on 15/12/10.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CHINESE_YEAR_ALL @[@"甲子", @"乙丑", @"丙寅", @"丁卯", @"戊辰", @"己巳", @"庚午", @"辛未", @"壬申", @"癸酉", @"甲戌", @"乙亥", @"丙子", @"丁丑", @"戊寅", @"己卯", @"庚辰", @"辛己", @"壬午", @"癸未", @"甲申", @"乙酉", @"丙戌", @"丁亥", @"戊子", @"己丑", @"庚寅", @"辛卯", @"壬辰", @"癸巳", @"甲午", @"乙未", @"丙申", @"丁酉", @"戊戌", @"己亥", @"庚子", @"辛丑", @"壬寅", @"癸丑", @"甲辰", @"乙巳", @"丙午", @"丁未", @"戊申", @"己酉", @"庚戌", @"辛亥", @"壬子", @"癸丑", @"甲寅", @"乙卯", @"丙辰", @"丁巳", @"戊午", @"己未", @"庚申", @"辛酉", @"壬戌", @"癸亥"]
#define CHINESE_MONTH_ALL @[@"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月", @"九月", @"十月", @"冬月", @"腊月"]
#define CHINESE_DAY_ALL @[@"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十", @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十", @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十"]

/// 返回农历的格式
typedef enum {
    NLCLunarDateTypeDay,
    NLCLunarDateTypeMonth,
    NLCLunarDateTypeYear,
    NLCLunarDateTypeAll
} NLCLunarDateType;

@interface NBDate : NSObject

+ (NSDateComponents *)currentComponents;

+ (NSInteger)getCurrentDay;

+ (NSInteger)getCurrentMonth;

+ (NSInteger)getCurrentYear;

+ (NSInteger)getCurrentWeekday;

/// 指定月第一天是星期几
+ (NSInteger)getFirstWeekdayFromDate:(NSDate *)date;
/// 当前月共有几天
+ (NSInteger)numberOfDaysInCurrentMonth;
/// 指定日期的dateComponents
+ (NSDateComponents *)componentsFromDate:(NSDate *)date;
/// 获取指定日期对应的农历
+ (NSString *)lunarCalendarWithDate:(NSDate *)date andType:(NLCLunarDateType)type;
/// 指定月共有几天
+ (NSInteger)numberOfDaysInMonthWithDate:(NSDate *)date;
/// 指定农历月公有几天
+ (NSInteger)numberOfLunarDaysInLunarMonth:(NSString *)month andLunarYear:(NSString *)year;
/// 给定年、月、日，获取对应Date
+ (NSDate *)dateWithDay:(NSInteger)day withMonth:(NSInteger)month withYear:(NSInteger)year;
/// 给定农历年、月、日，获取对应的Date
+ (NSDate *)dateWithLunarDay:(NSString *)day withLunarMonth:(NSString *)month withLunarYear:(NSString *)year;
/// 上一个月的日期
+ (NSDate *)lastMonthDate:(NSDate *)date;
/// 下一个月的日期
+ (NSDate *)nextMonthDate:(NSDate *)date;
/// 下一天的日期
+ (NSDate *)nextDayDate:(NSDate *)date;
/// 上一天的日期
+ (NSDate *)lastDayDate:(NSDate *)date;
/// 下一年的日期
+ (NSDate *)nextYearDate:(NSDate *)date;
/// 农历下一年的日期
+ (NSDate *)nextLunarYear:(NSDate *)date;
/// 农历日对应的阿拉伯数字
+ (NSInteger)arabicNumberOfLunarDay:(NSString *)day;
/// 农历月份对应的阿拉伯数字
+ (NSInteger)arabicNumberOfLunarMonth:(NSString *)month;
/// 农历年份对应的阿拉伯数字
+ (NSInteger)arabicNumberOfLunarYear:(NSString *)year;
@end
