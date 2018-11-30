//
//  NSDictionary+JXExtension.m
//  Weirdo
//
//  Created by _LJX on 2018/8/22.
//  Copyright © 2018年 _Ljx. All rights reserved.
//

#import "NSDictionary+JXExtension.h"

@implementation NSDictionary (JXExtension)

+(NSDictionary *)readLocalJsonWithName:(NSString *)name{
    
    NSString *path = [[NSBundle mainBundle]pathForResource:name ofType:@"json"];
    
    NSData *data = [[NSData alloc]initWithContentsOfFile:path];
    
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}
@end
