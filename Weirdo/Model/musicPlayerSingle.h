//
//  musicPlayerSingle.h
//  Weirdo
//
//  Created by _LJX on 2018/9/14.
//  Copyright © 2018年 _Ljx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
@interface musicPlayerSingle : NSObject

@property(nonatomic,strong)AVAudioPlayer *player;
@property(nonatomic,strong)NSArray *songsList;
@property(nonatomic,assign)NSInteger songID;
@property(nonatomic,assign)NSInteger number;

+(instancetype)shareInstance;
-(void)musicPlay;
-(void)musicNext;
-(void)musicBefore;
@end
