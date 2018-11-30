//
//  LocalNotification.m
//  Weirdo
//
//  Created by _LJX on 2018/9/16.
//  Copyright © 2018年 _Ljx. All rights reserved.
//

#import "LocalNotification.h"

@implementation LocalNotification
+ (void)createLocalizedUserNotificationWithTitle:(NSString *)title WithSubtitle:(NSString *)subtitle WithBody:(NSString *)body WithBadge:(NSNumber*)badge WithAfterTime:(NSTimeInterval )time {
    
    // 设置触发条件 UNNotificationTrigger
    UNTimeIntervalNotificationTrigger *timeTrigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:time repeats:NO];
    
    // 创建通知内容 UNMutableNotificationContent, 注意不是 UNNotificationContent ,此对象为不可变对象。
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = title;
    content.subtitle = subtitle;
    content.body = body;
    content.badge = badge;
    content.sound = [UNNotificationSound defaultSound];
    //    content.userInfo = @{@"key1":@"value1",@"key2":@"value2"};
    
    // 创建通知标示
    NSString *requestIdentifier = @"Dely.X.time";
    
    // 创建通知请求 UNNotificationRequest 将触发条件和通知内容添加到请求中
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifier content:content trigger:timeTrigger];
    
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    // 将通知请求 add 到 UNUserNotificationCenter
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (!error) {
            
        }
    }];
    
}


+(void)createDateNotif{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.hour = 23;
    components.minute = 45; // components 日期
    UNCalendarNotificationTrigger *calendarTrigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:YES];
    // 创建通知内容 UNMutableNotificationContent, 注意不是 UNNotificationContent ,此对象为不可变对象。
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"时间不早了";
//    content.subtitle = nil;
    content.body = @"记得早点休息🌛";
    content.badge = @0;
    content.sound = [UNNotificationSound defaultSound];
    //    content.userInfo = @{@"key1":@"value1",@"key2":@"value2"};
    
    // 创建通知标示
    NSString *requestIdentifier = @"Dely.X.time";
    
    // 创建通知请求 UNNotificationRequest 将触发条件和通知内容添加到请求中
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifier content:content trigger:calendarTrigger];
    
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    // 将通知请求 add 到 UNUserNotificationCenter
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (!error) {
            
        }
    }];
  
}


@end
