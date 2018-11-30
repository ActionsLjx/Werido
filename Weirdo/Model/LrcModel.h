//
//  LrcModel.h
//  ActionsMusic
//
//  Created by _LJX on 2017/12/6.
//  Copyright © 2017年 _LJX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LrcModel : NSObject
@property(nonatomic,strong)NSString *sentence;
@property(nonatomic,assign)float time;

-(instancetype)initWithDict:(NSArray *)dict;
+(instancetype)LrcWithDict:(NSArray *)dict;
@end
