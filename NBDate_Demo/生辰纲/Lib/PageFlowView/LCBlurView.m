//
//  LCBlurView.m
//  LCalendar
//
//  Created by haowenliang on 14-3-21.
//  Copyright (c) 2014年 dpsoft. All rights reserved.
//

#import "LCBlurView.h"

@interface LCBlurView ()
@property (nonatomic, strong) UIToolbar * blurBar;
@end

@implementation LCBlurView


#pragma mark - Init functions

// general initializer
- (id)init {
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

// use with Storyboard
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}


- (void)setupView {
    [self setClipsToBounds:YES];
    self.backgroundColor = [UIColor clearColor];
    self.alpha = 0.98;
    if (![self blurBar]) {  // lazy instantiate
        self.blurBar = [[UIToolbar alloc] initWithFrame:[self bounds]];
        [self.layer insertSublayer:[self.blurBar layer] atIndex:0];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.blurBar setFrame:[self bounds]];
}

#pragma mark - Blur view functions

- (void) setBlurColor:(UIColor *)blurColor {
    [self setBackgroundColor:blurColor];
}

/**
 * Note about setBlurAlpha: You can't change the alpha if the background doesn't have a color set to it
 */
- (void) setBlurAlpha:(CGFloat)alphaValue{
    size_t numComponents = CGColorGetNumberOfComponents([[self backgroundColor] CGColor]);
    if (numComponents == 4){
        const CGFloat *components = CGColorGetComponents([[self backgroundColor] CGColor]);
        CGFloat red = components[0];
        CGFloat green = components[1];
        CGFloat blue = components[2];
        [self setBackgroundColor:[UIColor colorWithRed:red green:green blue:blue alpha:alphaValue]];
    }else{
        [self setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:alphaValue]];
    }
}

@end
