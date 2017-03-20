//
//  NSObject+HUD.m
//  生辰纲
//
//  Created by tarena on 15/12/27.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "NSObject+HUD.h"
#import <MBProgressHUD.h>

@implementation NSObject (HUD)

//获取当前屏幕的最上方正在显示的那个view
- (UIView *)currentView{
    UIViewController *vc=[UIApplication sharedApplication].keyWindow.rootViewController;
    // vc: 导航控制器, 标签控制器, 普通控制器
    if ([vc isKindOfClass:[UITabBarController class]]) {
        vc = [(UITabBarController *)vc selectedViewController];
    }
    if ([vc isKindOfClass:[UINavigationController class]]) {
        vc = [(UINavigationController *)vc visibleViewController];
    }
    return vc.view;
}
/** 弹出文字提示 */
- (void)showAlert:(NSString *)text {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideAllHUDsForView:[self currentView] animated:YES];
        MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:[self currentView] animated:YES];
        progressHUD.mode = MBProgressHUDModeText;
        progressHUD.labelText = text;
        [progressHUD hide:YES afterDelay:1.5];
    });
}

@end
