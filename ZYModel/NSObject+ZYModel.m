//
//  NSObject+ZYModel.m
//  ZYModel
//
//  Created by sheepliu on 16/3/29.
//  Copyright © 2016年 tzuyangliu. All rights reserved.
//

#import "NSObject+ZYModel.h"
#import <objc/objc-runtime.h>
#import "ZYClassInfo.h"

@implementation NSObject (ZYModel)

+ (NSDictionary *)mapper
{
    NSLog(@"Warning: Child Class did not implement the -(NSDictionary *)mapper method");
    return nil;
}

- (void)setValuesWithDictionary:(NSDictionary *)dictionary
{
    // 获取映射字典
    id<ZYModel> cls = (id<ZYModel>)[self class];
    NSDictionary *mapperDictionary = [cls mapper];
    // 获取类结构信息
    ZYClassInfo *clsInfo = [ZYClassInfo classInfoWithClass:[self class]];
    // 获取属性列表
    NSDictionary *propertyDictionary = clsInfo.properties;
    // 获取JSON键列表
    NSArray *mapperKeys = dictionary.allKeys;
    for (NSString *propertyName in propertyDictionary.allKeys)
    {
        // 获取属性对应的JSON键
        NSString *contentKey;
        if ([mapperDictionary.allKeys containsObject:propertyName])
        {
            contentKey = mapperDictionary[propertyName];
        }
        else
        {
            contentKey = propertyName;
        }
        if (![mapperKeys containsObject:contentKey])
        {
            continue;
        }
        // 设置属性
        ZYClassProperty *property = propertyDictionary[propertyName];
        id content = dictionary[contentKey];
        ((void (*)(id, SEL, id))(void *)objc_msgSend)((id)self, property.setter, content);
    }
}

+ (instancetype)zy_modelWithJSON:(id)json
{
    NSObject *obj = [[self class] new];
    [obj setValuesWithDictionary:json];
    return obj;
}

+ (instancetype)zy_modelWithDictionary:(NSDictionary *)dictionary
{
    return nil;
}

@end
