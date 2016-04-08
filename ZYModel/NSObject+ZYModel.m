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

// 虚函数们
+ (NSDictionary*)mapper
{
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

+ (NSArray *)_zy_arrayWithJSON:(id)json
{
    if (!json || json == (id)kCFNull) return nil;
    if ([json isKindOfClass:[NSArray class]])
    {
        return json;
    }
    BOOL isData = [json isKindOfClass:[NSData class]];
    BOOL isString = [json isKindOfClass:[NSString class]];
    if (isData || isString)
    {
        NSData *data = nil;
        if (isString)
        {
            data = [(NSString *)json dataUsingEncoding : NSUTF8StringEncoding];
        }
        else
        {
            data = json;
        }
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:NULL];
        if ([array isKindOfClass:[NSArray class]])
        {
            return array;
        }
    }
    return nil;
}

+ (NSDictionary *)_zy_dictionaryWithJSON:(id)json {
    if (!json || json == (id)kCFNull) return nil;
    if ([json isKindOfClass:[NSDictionary class]])
    {
        return json;
    }
    BOOL isData = [json isKindOfClass:[NSData class]];
    BOOL isString = [json isKindOfClass:[NSString class]];
    if (isData || isString)
    {
        NSData *data = nil;
        if (isString)
        {
            data = [(NSString *)json dataUsingEncoding : NSUTF8StringEncoding];
        }
        else
        {
            data = json;
        }
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:NULL];
        if ([dictionary isKindOfClass:[NSDictionary class]])
        {
            return dictionary;
        }
    }
    return nil;
}

- (void)zy_setPropertiesWithJSON:(id)json
{
    NSDictionary *dictionary = [[self class] _zy_dictionaryWithJSON:json];
    if (dictionary)
    {
        [self zy_setPropertiesWithDictionary:dictionary];
    }
}

- (void)zy_setPropertiesWithDictionary:(NSDictionary*)dictionary
{
    Class cls = [self class];
    ZYModelMeta *meta = [ZYModelMeta metaWithClass:cls];
    NSDictionary *mapper = meta->_jsonKeyToSetterMapper;
    for (NSString *jsonKey in dictionary.allKeys){
        if ([mapper objectForKey:jsonKey])
        {
            id content = dictionary[jsonKey];
            id setterObject = nil;
            ZYClassProperty *property = mapper[jsonKey];
            switch (property->_nsType)
            {
                case ZYEncodingTypeNSUnknown:
                {
                    setterObject = [property->_cls zy_modelWithJSON:content];
                    break;
                }
                case ZYEncodingTypeNSMutableString:
                {
                    setterObject = [NSMutableString stringWithString:(NSString *)content];
                    break;
                }
                case ZYEncodingTypeNSArray:
                {
                    setterObject = [property->_cls zy_modelArrayWithJSON:content];
                    break;
                }
                case ZYEncodingTypeNSMutableArray:
                {
                    setterObject = [[property->_cls zy_modelArrayWithJSON:content] mutableCopy];
                    break;
                }
                case ZYEncodingTypeNSMutableDictionary:
                {
                    setterObject = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)content];
                    break;
                }
                default:
                {
                    setterObject = content;
                    break;
                }
            }
            ((void (*)(id, SEL, id))(void*)objc_msgSend)((id)self, property->_setter, setterObject);
        }
    }
}

+ (instancetype)zy_modelWithJSON:(id)json
{
    NSObject* obj = [[self class] new];
    [obj zy_setPropertiesWithJSON:json];
    return obj;
}

+ (instancetype)zy_modelWithDictionary:(NSDictionary*)dictionary
{
    if ((!dictionary) || dictionary == (id)kCFNull) return nil;
    if (![dictionary isKindOfClass:[NSDictionary class]]) return nil;
    NSObject* obj = [[self class] new];
    [obj zy_setPropertiesWithDictionary:dictionary];
    return obj;
}

+ (NSMutableArray *)zy_modelMutableArrayWithJSON:(id)json
{
    NSMutableArray *objectArray = [NSMutableArray array];
    NSArray *array = [self _zy_arrayWithJSON:json];
    for (id subJson in array){
        id obj = [self zy_modelWithJSON:subJson];
        if (obj)
        {
            [objectArray addObject:obj];
        }
    }
    return objectArray;
}

+ (NSArray *)zy_modelArrayWithJSON:(id)json
{
    return [[self zy_modelMutableArrayWithJSON:json] copy];
}

@end
