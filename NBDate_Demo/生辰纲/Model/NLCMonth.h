//
//  NLCMonth.h
//  生辰纲
//
//  Created by tarena on 15/12/15.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NLCMonth : NSObject

@property (nonatomic, assign) NSInteger firstWeekday;
@property (nonatomic ,strong) NSMutableArray *allDaysArray;
@property (nonatomic ,assign) NSInteger daysCount;
@property (nonatomic ,assign) NSInteger month;
@property (nonatomic ,assign) NSInteger year;

/**
 *  创建NLCMonth对象
 *
 *  @param date 指定月任意date均可
 *
 *  @return NLCMonth对象
 */
+ (NLCMonth *)monthWithDate:(NSDate *)date;

@end
