//
//  NLCCalendarLayout.m
//  生辰纲
//
//  Created by tarena on 15/12/12.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "NLCCalendarLayout.h"

@implementation NLCCalendarLayout

#define ITEM_WIDTH SCREEN_WIDTH/7.0-20
#define ITEM_HEIGHT (SCREEN_HEIGHT-80)/6.0-20
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.itemSize = CGSizeMake(ITEM_WIDTH, ITEM_HEIGHT);
        self.minimumLineSpacing = 20;
        self.minimumInteritemSpacing = 20;
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return self;
}

@end
