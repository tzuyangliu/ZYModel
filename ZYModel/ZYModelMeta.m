//
//  ZYModelMeta.m
//  ZYModel
//
//  Created by sheepliu on 16/3/31.
//  Copyright © 2016年 tzuyangliu. All rights reserved.
//

#import "ZYModelMeta.h"
#import "ZYClassInfo.h"
#import "NSObject+ZYModel.h"

@implementation ZYModelMeta

- (instancetype)initWithClass:(Class)cls
{
    if (!cls) return nil;
    self = [super init];
    if (self)
    {
        Class curCls = cls;
        _modelContainerPropertyGenericClassMap = [cls modelContainerPropertyGenericClass];
        NSMutableDictionary *tempJsonKeyToSetterMapper = [NSMutableDictionary dictionary];
        NSArray *whitelistProperties = [cls whitelistProperties];
        NSArray *blacklistProperties = [cls blacklistProperties];
        while (curCls && [curCls superclass] != nil)
        {
            id<ZYModel> modelCls = (id<ZYModel>)curCls;
            NSDictionary *userMapper = [modelCls mapper];
            _classInfo = [ZYClassInfo classInfoWithClass:curCls];
            NSDictionary* propertyDictionary = _classInfo->_properties;
            NSArray *propertyNames = propertyDictionary.allKeys;
            for (NSString *propertyName in propertyNames)
            {
                if (whitelistProperties.count && ![whitelistProperties containsObject:propertyName]) continue;
                if ([blacklistProperties containsObject:propertyName]) continue;
                ZYClassProperty *property = propertyDictionary[propertyName];
                NSString *jsonKey;
                if ([userMapper.allKeys containsObject:propertyName])
                {
                    jsonKey = userMapper[propertyName];
                }
                else
                {
                    jsonKey = propertyName;
                }
                tempJsonKeyToSetterMapper[jsonKey] = property;
            }
            curCls = [curCls superclass];
        }
        _jsonKeyToSetterMapper = [tempJsonKeyToSetterMapper copy];
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
    ZYModelMeta *meta = CFDictionaryGetValue(cache, (__bridge const void *)(cls));
    dispatch_semaphore_signal(lock);
//    if (!meta || meta->_classInfo.needUpdate)
    if (!meta){
        meta = [[ZYModelMeta alloc] initWithClass:cls];
        if (meta) {
            dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
            CFDictionarySetValue(cache, (__bridge const void *)(cls), (__bridge const void *)(meta));
            dispatch_semaphore_signal(lock);
        }
    }
    return meta;
}


@end
