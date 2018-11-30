//
//  musicPlayerSingle.m
//  Weirdo
//
//  Created by _LJX on 2018/9/14.
//  Copyright © 2018年 _Ljx. All rights reserved.
//

#import "musicPlayerSingle.h"

static musicPlayerSingle *musicPlayerShare = nil;

@implementation musicPlayerSingle

+(instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        musicPlayerShare = [[musicPlayerSingle alloc]init];
        
    });
    return musicPlayerShare;
}



-(NSArray *)songsList{
    if (_songsList == nil) {
        _songsList = [[NSArray alloc]initWithObjects:@"天空之城",@"没那么简单", nil];
    }
    return _songsList;
}

-(instancetype)init{
    if (self = [super init]) {
        [self songsList];
        _songID = 0;
        _number = 0;
        NSURL *flieUrl = [[NSBundle mainBundle]URLForResource:_songsList[_songID] withExtension:@"mp3"];
        _player = [[AVAudioPlayer alloc]initWithContentsOfURL:flieUrl error:nil];
        [_player prepareToPlay];
        
    }
    return  self;
}



-(void)musicPlay{
    
    _player.isPlaying?[_player pause]:[_player play];
    
}


-(void)musicNext{
        _number = 0;
    if (_songsList.count-1>_songID) {
        _songID = _songID + 1;
    }
    else{
        _songID = 0;
    }
    NSURL *flieUrl = [[NSBundle mainBundle]URLForResource:_songsList[_songID] withExtension:@"mp3"];
    _player = [[AVAudioPlayer alloc]initWithContentsOfURL:flieUrl error:nil];
    [_player prepareToPlay];
    [_player play];
}

-(void)musicBefore{
        _number = 0;
    if (_songID==1) {
        _songID = 0;
        
    }
    else{
        _songID = 1;
    }
    NSURL *flieUrl = [[NSBundle mainBundle]URLForResource:_songsList[_songID] withExtension:@"mp3"];
    _player = [[AVAudioPlayer alloc]initWithContentsOfURL:flieUrl error:nil];
    [_player prepareToPlay];
    [_player play];
}






@end
