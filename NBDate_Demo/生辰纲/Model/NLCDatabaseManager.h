//
//  NLCDatabaseManager.h
//  生辰纲
//
//  Created by tarena on 15/12/24.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDatabase.h>

@interface NLCDatabaseManager : NSObject

+ (FMDatabase *)sharedDatabase;

@end
