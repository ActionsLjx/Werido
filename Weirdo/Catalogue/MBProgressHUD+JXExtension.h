//
//  MBProgressHUD+JXExtension.h
//  Weirdo
//
//  Created by monstar on 2018/10/12.
//  Copyright © 2018年 _Ljx. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (JXExtension)
+ (void)showSuccess:(NSString *)success;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

+ (void)showError:(NSString *)error;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message;
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;

+ (void)hideHUD;
+ (void)hideHUDForView:(UIView *)view;

@end
