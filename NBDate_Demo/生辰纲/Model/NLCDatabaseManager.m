//
//  NLCDatabaseManager.m
//  生辰纲
//
//  Created by tarena on 15/12/24.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "NLCDatabaseManager.h"


@implementation NLCDatabaseManager

+ (FMDatabase *)sharedDatabase {
    static FMDatabase *database = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *databaseFilePath = [documentPath stringByAppendingPathComponent:@"eventDatabase.db"];
        database = [FMDatabase databaseWithPath:databaseFilePath];
    });
    [database open];
    return database;
}

@end
