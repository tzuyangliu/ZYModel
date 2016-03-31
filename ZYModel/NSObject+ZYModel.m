//
//  NSObject+ZYModel.m
//  ZYModel
//
//  Created by sheepliu on 16/3/29.
//  Copyright © 2016年 tzuyangliu. All rights reserved.
//

#import "NSObject+ZYModel.h"
#import "ZYClassInfo.h"
#import "ZYModelMeta.h"
#import <objc/objc-runtime.h>

@implementation NSObject (ZYModel)

+ (NSDictionary*)mapper
{
    NSLog(@"Warning: Child Class did not implement the -(NSDictionary *)mapper method");
    return nil;
}

+ (NSArray *)whitelistProperties
{
    return nil;
}

+ (NSArray *)blacklistProperties
{
    return nil;
}

- (void)setPropertiesWithDictionary:(NSDictionary*)dictionary
{
    Class cls = [self class];
    ZYModelMeta *meta = [ZYModelMeta metaWithClass:cls];
    NSDictionary *mapper = meta->_jsonKeyToSetterMapper;
    for (NSString *jsonKey in dictionary.allKeys){
        if ([mapper objectForKey:jsonKey])
        {
            id content = dictionary[jsonKey];
            ((void (*)(id, SEL, id))(void*)objc_msgSend)((id)self, NSSelectorFromString(mapper[jsonKey]), content);
        }
    }
}

+ (instancetype)zy_modelWithJSON:(id)json
{
    NSObject* obj = [[self class] new];
    [obj setPropertiesWithDictionary:json];
    return obj;
}

+ (instancetype)zy_modelWithDictionary:(NSDictionary*)dictionary
{
    return nil;
}

@end
