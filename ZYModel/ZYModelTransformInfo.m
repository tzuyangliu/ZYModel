//
//  ZYModelTransformInfo.m
//  ZYModel
//
//  Created by 刘子洋 on 16/3/31.
//  Copyright © 2016年 刘子洋. All rights reserved.
//

#import "ZYModelTransformInfo.h"
#import "ZYClassInfo.h"
#import "NSObject+ZYModel.h"

@implementation ZYModelPropertyTransformInfo

- (instancetype)initWithClassPropertyInfo:(ZYClassPropertyInfo *)classProperty jsonKey:(NSString *)jsonKey
{
    self = [super init];
    if (self)
    {
        _classProperty = classProperty;
        _jsonKey = jsonKey;
    }
    return self;
}

@end

@implementation ZYModelTransformInfo

- (instancetype)initWithClass:(Class)cls
{
    if (!cls) return nil;
    self = [super init];
    if (self)
    {
        Class curCls = cls;
        _propertyMetas = [NSMutableArray array];
        NSArray *whitelistProperties = [cls zy_whitelistProperties];
        NSArray *blacklistProperties = [cls zy_blacklistProperties];
        while (curCls && [curCls superclass] != nil)
        {
            id<ZYModel> modelCls = (id<ZYModel>)curCls;
            NSDictionary *userMapper = [modelCls zy_propertyToJsonKeyMapper];
            _classInfo = [ZYClassInfo classInfoWithClass:curCls];
            NSDictionary* propertyDictionary = _classInfo->_properties;
            NSArray *propertyNames = propertyDictionary.allKeys;
            for (NSString *propertyName in propertyNames)
            {
                if (whitelistProperties.count && ![whitelistProperties containsObject:propertyName]) continue;
                if ([blacklistProperties containsObject:propertyName]) continue;
                NSString *jsonKey;
                if ([userMapper.allKeys containsObject:propertyName])
                {
                    jsonKey = userMapper[propertyName];
                }
                else
                {
                    jsonKey = propertyName;
                }
                ZYModelPropertyTransformInfo *propertyMeta = [[ZYModelPropertyTransformInfo alloc]
                                                     initWithClassPropertyInfo:propertyDictionary[propertyName]
                                                     jsonKey:jsonKey];
                [_propertyMetas addObject:propertyMeta];
            }
            curCls = [curCls superclass];
        }
    }
    return self;
}

+ (instancetype)metaWithClass:(Class)cls
{
    if (!cls) return nil;
    static CFMutableDictionaryRef cache;
    static dispatch_once_t onceToken;
    static dispatch_semaphore_t lock;
    dispatch_once(&onceToken, ^{
        cache = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        lock = dispatch_semaphore_create(1);
    });
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    ZYModelTransformInfo *meta = CFDictionaryGetValue(cache, (__bridge const void *)(cls));
    dispatch_semaphore_signal(lock);
    if (!meta){
        meta = [[ZYModelTransformInfo alloc] initWithClass:cls];
        if (meta) {
            dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
            CFDictionarySetValue(cache, (__bridge const void *)(cls), (__bridge const void *)(meta));
            dispatch_semaphore_signal(lock);
        }
    }
    return meta;
}


@end
