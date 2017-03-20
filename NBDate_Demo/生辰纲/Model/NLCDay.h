//
//  NLCDay.h
//  生辰纲
//
//  Created by tarena on 15/12/14.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NLCDay : NSObject

@property (nonatomic, assign) NSInteger dayNum;
@property (nonatomic, assign) NSString *lunarDayName;
@property (nonatomic ,strong) NSString *lunarMonthName;
@property (nonatomic, assign) NSInteger monthNum;
@property (nonatomic, assign) NSInteger yearNum;
@property (nonatomic ,strong) NSString *lunarCalendarName;
@property (nonatomic, strong) NSMutableArray *eventsArray;
@property (nonatomic ,assign) NSInteger weekdayNum;
@property (nonatomic, strong) NSDate *date;
/**
 *  获取NLCDay的对象
 *
 *  @param date 指定天的date
 *
 *  @return NLCDay的对象
 */
+ (NLCDay *)dayWithDate:(NSDate *)date;
@end
