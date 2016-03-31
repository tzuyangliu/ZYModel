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
//        mapper.allKeys.count;
//        if ([mapper.allKeys containsObject:jsonKey]){
        
//        }
//        {
        if ([mapper objectForKey:jsonKey])
        {
            id content = dictionary[jsonKey];
            ((void (*)(id, SEL, id))(void*)objc_msgSend)((id)self, NSSelectorFromString(mapper[jsonKey]), content);
        }
        
//        }
    }
//    
//    // 获取映射字典
//    NSDictionary* mapperDictionary = meta->_mapper;
//    // 获取类结构信息
//    ZYClassInfo* clsInfo = meta->_classInfo;
//    // 获取属性列表
//    NSDictionary* propertyDictionary = clsInfo->_properties;
//    // 获取JSON键列表
//    NSArray* mapperKeys = dictionary.allKeys;
//    for (NSString* propertyName in propertyDictionary.allKeys) {
//        // 获取属性对应的JSON键
//        NSString* contentKey;
//        if ([mapperDictionary.allKeys containsObject:propertyName]) {
//            contentKey = mapperDictionary[propertyName];
//        }
//        else {
//            contentKey = propertyName;
//        }
//        if (![mapperKeys containsObject:contentKey]) {
//            continue;
//        }
//        // 设置属性
//        ZYClassProperty* property = propertyDictionary[propertyName];
//        id content = dictionary[contentKey];
//        ((void (*)(id, SEL, id))(void*)objc_msgSend)((id)self, property->_setter, content);
//    }
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
