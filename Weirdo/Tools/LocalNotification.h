//
//  LocalNotification.h
//  Weirdo
//
//  Created by _LJX on 2018/9/16.
//  Copyright © 2018年 _Ljx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>
@interface LocalNotification : NSObject
+ (void)createLocalizedUserNotificationWithTitle:(NSString *)title
                                    WithSubtitle:(NSString *)subtitle
                                        WithBody:(NSString *)body
                                       WithBadge:(NSNumber*)badge
                                   WithAfterTime:(NSTimeInterval )time;

+(void)createDateNotif;
@end
