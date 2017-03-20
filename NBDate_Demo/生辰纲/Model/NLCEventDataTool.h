//
//  NLCEventDataTool.h
//  生辰纲
//
//  Created by tarena on 15/12/24.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NLCEvent.h"

@interface NLCEventDataTool : NSObject

/** 解析事件数据 */
+ (NSArray *)parseEventWithType:(NLCEventType)type;
/** 插入数据 */
+ (void)insertEventToSQLiteWithEvent:(NLCEvent *)event;
/** base64编码转图片 */
+ (UIImage *)imageParseWithBase64:(NSString *)base64Str;
/** 使用base64将图片转变成字符串 */
+ (NSString *)base64WithImage:(UIImage *)image;
/** 下次事件到当前天数 */
+ (NSInteger)numberOfDaysEventTimeToCurrentDayWithEvent:(NLCEvent *)event;
/** 生成缩略图 */
+ (UIImage *) thumbnaiWithImage:(UIImage *)image size:(CGSize)size;
@end
