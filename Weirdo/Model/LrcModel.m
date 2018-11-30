//
//  LrcModel.m
//  ActionsMusic
//
//  Created by _LJX on 2017/12/6.
//  Copyright © 2017年 _LJX. All rights reserved.
//

#import "LrcModel.h"

@implementation LrcModel
-(instancetype)initWithDict:(NSArray *)dict{
    if(self = [super init]){
        float time;
        float mit,sed,hao;
        NSString *flag = @"";
        
        //提取时间单位：分钟
        NSString *timestr = [NSString stringWithFormat:@"%@",dict];
        if ([timestr length]<7) {
            _time= 0;
            _sentence = nil;
        }
        else{
            flag = [timestr substringWithRange:NSMakeRange(1, 2)];
            mit = [flag floatValue];
            //提取时间单位：秒
            flag = [timestr substringWithRange:NSMakeRange(4, 2)];
            sed = [flag floatValue];
            //提取时间单位：毫秒
            flag = [timestr substringWithRange:NSMakeRange(7, 2)];
            hao = [flag floatValue];
            //歌词出现的时间点：time
            time = (mit*60+sed+hao/100);
            _time = time;
            NSString *lrcc = [timestr substringFromIndex:10];
            _sentence = lrcc;
        }
        
    }
    return self;
}

+(instancetype)LrcWithDict:(NSArray *)dict{
    return [[self alloc]initWithDict:dict];
}

@end
