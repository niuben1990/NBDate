//
//  NLCEvent.h
//  生辰纲
//
//  Created by tarena on 15/12/17.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    NLCEventTypeBirthday,
    NLCEventTypeOnceEvent,
    NLCEventTypeFestival
} NLCEventType;

@interface NLCEvent : NSObject
/** 事件类型 */
@property (nonatomic ,assign) NLCEventType type;
/** 事件时间 */
@property (nonatomic ,strong) NSString *year;
@property (nonatomic ,strong) NSString *month;
@property (nonatomic ,strong) NSString *day;
@property (nonatomic ,assign) BOOL isLunar;
/** 事件标题 */
@property (nonatomic ,strong) NSString *title;
/** 详情 */
@property (nonatomic ,strong) NSString *detail;
/** 头像 */
@property (nonatomic ,strong) NSString *headerImageString;
/** 和SQLite对应的id */
@property (nonatomic ,assign) NSInteger identifier;

@end
