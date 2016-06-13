//
//  ZYModelTransformInfo.m
//  ZYModel
//
//  Created by 刘子洋 on 16/3/31.
//  Copyright © 2016年 刘子洋. All rights reserved.
//
#import "NSObject+ZYModel.h"
#import "ZYClassInfo.h"
#import "ZYModelTransformInfo.h"
@implementation ZYModelPropertyTransformInfo
- (instancetype)initWithClassPropertyInfo:(ZYClassPropertyInfo*)classProperty
                                  jsonKey:(NSString*)jsonKey
{
    self = [super init];
    if (self) {
        _cls = classProperty->_cls;
        _containCls = classProperty->_containCls;
        _setter = classProperty->_setter;
        _getter = classProperty->_getter;
        _type = classProperty->_type;
        _isCNumber = classProperty->_isCNumber;
        _isContainerCls = classProperty->_isContainerClass;
        _jsonKey = jsonKey;
    }
    return self;
}
@end
@implementation ZYModelTransformInfo
- (instancetype)initWithClass:(Class)cls
{
    if (!cls)
        return nil;
    self = [super init];
    if (self) {
        Class curCls = cls;
        _propertyTransformInfos = [NSMutableArray array];
        NSArray* whitelistProperties = [cls zy_whitelistProperties];
        NSArray* blacklistProperties = [cls zy_blacklistProperties];
        while (curCls && [curCls superclass] != nil) {
            id<ZYModel> modelCls = (id<ZYModel>)curCls;
            NSDictionary* userMapper = [modelCls zy_propertyToJsonKeyMapper];
            ZYClassInfo* classInfo = [ZYClassInfo classInfoWithClass:curCls];
            NSDictionary* propertyDictionary = classInfo->_propertyInfos;
            NSArray* propertyNames = propertyDictionary.allKeys;
            for (NSString* propertyName in propertyNames) {
                if (whitelistProperties.count && ![whitelistProperties containsObject:propertyName])
                    continue;
                if ([blacklistProperties containsObject:propertyName])
                    continue;
                NSString* jsonKey;
                if ([userMapper.allKeys containsObject:propertyName]) {
                    jsonKey = userMapper[propertyName];
                }
                else {
                    jsonKey = propertyName;
                }
                ZYModelPropertyTransformInfo* propertyTransformInfos =
                    [[ZYModelPropertyTransformInfo alloc]
                        initWithClassPropertyInfo:propertyDictionary[propertyName]
                                          jsonKey:jsonKey];
                [_propertyTransformInfos addObject:propertyTransformInfos];
            }
            curCls = [curCls superclass];
        }
    }
    return self;
}
+ (instancetype)modelTransformInfoWithClass:(Class)cls
{
    if (!cls)
        return nil;
    static CFMutableDictionaryRef cache;
    static dispatch_once_t onceToken;
    static dispatch_semaphore_t lock;
    dispatch_once(&onceToken, ^{
        cache = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0,
            &kCFTypeDictionaryKeyCallBacks,
            &kCFTypeDictionaryValueCallBacks);
        lock = dispatch_semaphore_create(1);
    });
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    ZYModelTransformInfo* modelTransformInfo = CFDictionaryGetValue(cache, (__bridge const void*)(cls));
    dispatch_semaphore_signal(lock);
    if (!modelTransformInfo) {
        modelTransformInfo = [[ZYModelTransformInfo alloc] initWithClass:cls];
        if (modelTransformInfo) {
            dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
            CFDictionarySetValue(cache, (__bridge const void*)(cls),
                (__bridge const void*)(modelTransformInfo));
            dispatch_semaphore_signal(lock);
        }
    }
    return modelTransformInfo;
}
@end