//
//  NLCEventDataTool.m
//  生辰纲
//
//  Created by tarena on 15/12/24.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "NLCEventDataTool.h"
#import "NLCDatabaseManager.h"
#import "NLCEvent.h"
#import "NBDate.h"

@implementation NLCEventDataTool
/** 解析事件数据 */
+ (NSArray *)parseEventWithType:(NLCEventType)type {
    NSMutableArray *mutableArray = [NSMutableArray array];
    FMDatabase *database = [NLCDatabaseManager sharedDatabase];
    FMResultSet *resultSet = [database executeQuery:@"select * from Event where Type=?", @(type)];
    while ([resultSet next]) {
        NLCEvent *event = [NLCEvent new];
        event.type = type;
        event.year = [resultSet stringForColumn:@"Year"];
        event.month = [resultSet stringForColumn:@"Month"];
        event.day = [resultSet stringForColumn:@"Day"];
        event.headerImageString = [resultSet stringForColumn:@"HeaderImageString"];
        event.title = [resultSet stringForColumn:@"Title"];
        event.detail =[resultSet stringForColumn:@"Detail"];
        event.identifier = [resultSet intForColumn:@"id"];
        event.isLunar = [resultSet intForColumn:@"IsLunar"];
        [mutableArray addObject:event];
    }
    [database closeOpenResultSets];
    [database close];
    
    for (int i = 0; i < mutableArray.count; i++) {
        for (int j = 0; j < mutableArray.count; j++) {
            if ([self numberOfDaysEventTimeToCurrentDayWithEvent:mutableArray[i]] < [self numberOfDaysEventTimeToCurrentDayWithEvent:mutableArray[j]]) {
                NLCEvent *event = mutableArray[j];
                mutableArray[j] = mutableArray[i];
                mutableArray[i] = event;
            }
        }
    }
    
    return [mutableArray copy];
}
/** 插入数据 */
+ (void)insertEventToSQLiteWithEvent:(NLCEvent *)event {
    FMDatabase *database = [NLCDatabaseManager sharedDatabase];
    [database executeUpdate:@"insert into Event(Type, Year, Month, Day, IsLunar, Title, Detail, HeaderImageString) values(?,?,?,?,?,?,?,?)", @(event.type), event.year, event.month, event.day, @(event.isLunar), event.title, event.detail, event.headerImageString];
    [database close];
}

/** 生成缩略图 */
+ (UIImage *) thumbnaiWithImage:(UIImage *) image size:(CGSize) size
{
    UIImage *newImage = nil;
    if (nil == image) {
        newImage = nil;
    }else{
        UIGraphicsBeginImageContext(size);
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newImage;
}

/** 使用base64将图片转变成字符串 */
+ (NSString *)base64WithImage:(UIImage *)image {
    NSData *data = UIImageJPEGRepresentation(image, 0.05);
    NSString *base64Str = [data base64EncodedStringWithOptions:0];
    return base64Str;
}


/** base64转图片 */
+ (UIImage *)imageParseWithBase64:(NSString *)base64Str {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:base64Str options:0];
    UIImage *image = [UIImage imageWithData:data];
    return image;
}

/** 下次事件到当前天数 */
+ (NSInteger)numberOfDaysEventTimeToCurrentDayWithEvent:(NLCEvent *)event {
    if (event.isLunar) {
        
        NSString *curYear = [NBDate lunarCalendarWithDate:[NSDate date] andType:NLCLunarDateTypeYear];
        NSString *curMonth = [NBDate lunarCalendarWithDate:[NSDate date] andType:NLCLunarDateTypeMonth];
        NSString *curDay = [NBDate lunarCalendarWithDate:[NSDate date] andType:NLCLunarDateTypeDay];
        
        NSInteger curYearNum = [NBDate arabicNumberOfLunarYear:curYear];
        NSInteger curMonthNum = [NBDate arabicNumberOfLunarMonth:curMonth];
        NSInteger curDayNum = [NBDate arabicNumberOfLunarDay:curDay];
        
        NSInteger eventMonthNum = [NBDate arabicNumberOfLunarMonth:event.month];
        NSInteger eventDayNum = [NBDate arabicNumberOfLunarDay:event.day];
        
        NSInteger sum = 0;
        
        if (eventDayNum == curDayNum && eventMonthNum == curMonthNum) {
            return 0;
        } else if ((eventMonthNum == curMonthNum && eventDayNum < curDayNum) || eventMonthNum < curMonthNum){
            
            for (NSInteger i = curMonthNum+1; i <= 12; i++) {
                sum += [NBDate numberOfLunarDaysInLunarMonth:CHINESE_MONTH_ALL[i-1] andLunarYear:curYear];
            }
            for (int i = 1; i < eventMonthNum; i++) {
                sum += [NBDate numberOfLunarDaysInLunarMonth:CHINESE_MONTH_ALL[i-1] andLunarYear:CHINESE_YEAR_ALL[curYearNum]];
            }
            sum += eventDayNum-1;
            sum += [NBDate numberOfLunarDaysInLunarMonth:curMonth andLunarYear:curYear] - curDayNum;
            return sum;
        } else if (eventMonthNum == curMonthNum && eventDayNum > curDayNum) {
            
            return eventDayNum - curDayNum;
            
        } else {
            for (NSInteger i = curMonthNum + 1; i < eventMonthNum; i++) {
                sum += [NBDate numberOfLunarDaysInLunarMonth:CHINESE_MONTH_ALL[i-1] andLunarYear:curYear];
            }
            sum += eventDayNum-1;
            sum += [NBDate numberOfLunarDaysInLunarMonth:curMonth andLunarYear:curYear] - curDayNum;
            return sum;
        }
    } else {
        NSInteger curYearNum = [NBDate getCurrentYear];
        NSInteger curMonthNum = [NBDate getCurrentMonth];
        NSInteger curDayNum = [NBDate getCurrentDay];
        
        NSInteger eventMonthNum = [event.month integerValue];
        NSInteger eventDayNum = [event.day integerValue];
        
        NSInteger sum = 0;
        
        if (eventDayNum == curDayNum && eventMonthNum == curMonthNum) {
            
            return 0;
            
        } else if ((eventMonthNum == curMonthNum && eventDayNum < curDayNum) || eventMonthNum < curMonthNum) {
            
            for (NSInteger i = curMonthNum+1; i <= 12; i++) {
                if (i == 2) {
                    NSDate *date = [NBDate dateWithDay:1 withMonth:2 withYear:curYearNum];
                    sum += [NBDate numberOfDaysInMonthWithDate:date];
                } else if (i == 4 || i == 6 || i == 9 || i == 11) {
                    sum += 30;
                } else {
                    sum += 31;
                }
            }
            for (int i = 1; i < eventMonthNum; i++) {
                if (i == 2) {
                    NSDate *date = [NBDate dateWithDay:1 withMonth:2 withYear:curYearNum+1];
                    sum += [NBDate numberOfDaysInMonthWithDate:date];
                } else if (i == 4 || i == 6 || i == 9 || i == 11) {
                    sum += 30;
                } else {
                    sum += 31;
                }
            }
            sum += eventDayNum-1;
            NSDate *date = [NBDate dateWithDay:1 withMonth:curMonthNum withYear:curYearNum];
            sum += [NBDate numberOfDaysInMonthWithDate:date] - curDayNum;
            return sum;
            
        } else if (eventMonthNum == curMonthNum && eventDayNum > curDayNum) {
            
            return eventDayNum - curDayNum;
            
        } else {
            
            for (NSInteger i = curMonthNum + 1; i < eventMonthNum; i++) {
                if (i == 2) {
                    NSDate *date = [NBDate dateWithDay:1 withMonth:2 withYear:curYearNum];
                    sum += [NBDate numberOfDaysInMonthWithDate:date];
                } else if (i == 4 || i == 6 || i == 9 || i == 11) {
                    sum += 30;
                } else {
                    sum += 31;
                }
            }
            sum += eventDayNum-1;
            NSDate *date = [NBDate dateWithDay:1 withMonth:curMonthNum withYear:curYearNum];
            sum += [NBDate numberOfDaysInMonthWithDate:date] - curDayNum;
            return sum;
        }
    }
}




@end
