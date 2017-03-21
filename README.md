# NBDate
一款提供农历日期与阴历日期相互转换的工具
### CocoaPods

[CocoaPods](http://cocoapods.org) is the recommended way to add NBDate to your project.

1. Add a pod entry for NBDate to your Podfile `pod 'NBDate'`
2. Install the pod(s) by running `pod install`.
3. Include NBDate wherever you need it with `#import <NBDate.h>`.


## Usage

+ (NSDateComponents *)currentComponents;

+ (NSInteger)getCurrentDay;

+ (NSInteger)getCurrentMonth;

+ (NSInteger)getCurrentYear;

+ (NSInteger)getCurrentWeekday;

* 指定月第一天是星期几
+ (NSInteger)getFirstWeekdayFromDate:(NSDate *)date;

* 当前月共有几天
+ (NSInteger)numberOfDaysInCurrentMonth;

* 指定日期的dateComponents
+ (NSDateComponents *)componentsFromDate:(NSDate *)date;

* 获取指定日期对应的农历
+ (NSString *)lunarCalendarWithDate:(NSDate *)date andType:(NLCLunarDateType)type;

* 指定月共有几天
+ (NSInteger)numberOfDaysInMonthWithDate:(NSDate *)date;

* 指定农历月公有几天
+ (NSInteger)numberOfLunarDaysInLunarMonth:(NSString *)month andLunarYear:(NSString *)year;

* 给定年、月、日，获取对应Date
+ (NSDate *)dateWithDay:(NSInteger)day withMonth:(NSInteger)month withYear:(NSInteger)year;

* 给定农历年、月、日，获取对应的Date
+ (NSDate *)dateWithLunarDay:(NSString *)day withLunarMonth:(NSString *)month withLunarYear:(NSString *)year;

* 上一个月的日期
+ (NSDate *)lastMonthDate:(NSDate *)date;

* 下一个月的日期
+ (NSDate *)nextMonthDate:(NSDate *)date;

* 下一天的日期
+ (NSDate *)nextDayDate:(NSDate *)date;

* 上一天的日期
+ (NSDate *)lastDayDate:(NSDate *)date;

* 下一年的日期
+ (NSDate *)nextYearDate:(NSDate *)date;

* 农历下一年的日期
+ (NSDate *)nextLunarYear:(NSDate *)date;

* 农历日对应的阿拉伯数字
+ (NSInteger)arabicNumberOfLunarDay:(NSString *)day;

* 农历月份对应的阿拉伯数字
+ (NSInteger)arabicNumberOfLunarMonth:(NSString *)month;

* 农历年份对应的阿拉伯数字
+ (NSInteger)arabicNumberOfLunarYear:(NSString *)year;
