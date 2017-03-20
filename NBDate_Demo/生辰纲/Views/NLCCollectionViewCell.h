//
//  NLCCollectionViewCell.h
//  生辰纲
//
//  Created by tarena on 15/12/12.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NLCCollectionViewCell : UICollectionViewCell

@property (nonatomic ,strong) NSString *dayStr;
@property (nonatomic ,strong) NSString *lunarDayStr;
@property (nonatomic ,assign) BOOL isToday;

@end
