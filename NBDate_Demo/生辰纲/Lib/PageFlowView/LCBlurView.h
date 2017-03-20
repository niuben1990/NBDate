//
//  LCBlurView.h
//  LCalendar
//
//  Created by haowenliang on 14-3-21.
//  Copyright (c) 2014年 dpsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface LCBlurView : UIView

- (void) setBlurColor:(UIColor *)blurColor;
- (void) setBlurAlpha:(CGFloat)alphaValue;

@end
