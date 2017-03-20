//
//  NLCBirthdayTableViewCell.h
//  生辰纲
//
//  Created by tarena on 15/12/25.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NLCBirthdayTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *gender;
@property (weak, nonatomic) IBOutlet UILabel *birthday;
@property (weak, nonatomic) IBOutlet UILabel *nextTime;
@property (nonatomic ,assign) NSInteger idNum;

@end
