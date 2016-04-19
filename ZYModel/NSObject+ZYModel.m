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



NS_INLINE void SetNSObjectToProperty(id target, ZYClassProperty *property, id value)
{
    id setterObject = nil;
    switch (property->_nsType)
    {
        case ZYEncodingTypeNSUnknown:
        {
            setterObject = [property->_cls zy_modelWithJSON:value];
            break;
        }
        case ZYEncodingTypeNSMutableString:
        {
            setterObject = [NSMutableString stringWithString:(NSString *)value];
            break;
        }
        // Array
        case ZYEncodingTypeNSArray:
        case ZYEncodingTypeNSMutableArray:
        {
            if (property->_containCls)
            {
                if ([value isKindOfClass:[NSArray class]])
                {
                    setterObject = [NSMutableArray array];
                    [(NSArray *)value enumerateObjectsUsingBlock:^(id  _Nonnull subContent, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([subContent isKindOfClass:property->_containCls])
                        {
                            [setterObject addObject:subContent];
                        }
                        else
                        {
                            id tempObject = [property->_containCls zy_modelWithJSON:subContent];
                            if (tempObject)
                            {
                                [setterObject addObject:tempObject];
                            }
                        }
                    }];
                    if (property->_nsType == ZYEncodingTypeNSArray)
                    {
                        setterObject = [setterObject copy];
                    }
                }
            }
            else
            {
                // TODO: 未完成
            }
            break;
        }
        // Dictionary
        case ZYEncodingTypeNSDictionary:
        case ZYEncodingTypeNSMutableDictionary:
        {
            if ([value isKindOfClass:[NSDictionary class]])
            {
                if (property->_containCls)
                {
                    setterObject = [NSMutableDictionary dictionary];
                    [(NSDictionary *)value enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull valueForKey, BOOL * _Nonnull stop) {
                        if ([valueForKey isKindOfClass:property->_containCls])
                        {
                            setterObject[key] = valueForKey;
                        }
                        else
                        {
                            id tempObject = [property->_containCls zy_modelWithJSON:valueForKey];
                            if (tempObject)
                            {
                                setterObject[key] = tempObject;
                            }
                        }
                    }];
                    if (property->_nsType == ZYEncodingTypeNSMutableDictionary)
                    {
                        setterObject = [setterObject copy];
                    }
                }
                else
                {
                    if (property->_nsType == ZYEncodingTypeNSDictionary)
                    {
                        setterObject = [value copy];
                    }
                    else
                    {
                        setterObject = [value mutableCopy];
                    }
                }
            }
            break;
        }
        case ZYEncodingTypeNSURL:
        {
            if ([value isKindOfClass:[NSURL class]])
            {
                setterObject = value;
            }
            else if ([value isKindOfClass:[NSString class]])
            {
                setterObject = [NSURL URLWithString:value];
            }
            break;
        }
        case ZYEncodingTypeNSDate:
        {
            // TODO: 未完成
            break;
        }
        case ZYEncodingTypeNSValue:
        {
            if ([value isKindOfClass:[NSValue class]]){
                setterObject = value;
            }
            break;
        }
        default:
        {
            setterObject = value;
            break;
        }
    }
    if (setterObject)
    {
        ((void (*)(id, SEL, id))(void*)objc_msgSend)((id)target, property->_setter, setterObject);
    }
}

NS_INLINE void SetCNumberToProperty(id target, ZYClassProperty *property, NSNumber *number)
{
    switch (property->_type)
    {
        case ZYEncodingTypeBool:
        {
            ((void (*)(id, SEL, BOOL))(void*)objc_msgSend)((id)target, property->_setter, number.boolValue);
            break;
        }
        case ZYEncodingTypeInt8:
        {
            ((void (*)(id, SEL, int8_t))(void*)objc_msgSend)((id)target, property->_setter, (int8_t)number.charValue);
            break;
        }
        case ZYEncodingTypeUInt8:
        {
            ((void (*)(id, SEL, int8_t))(void*)objc_msgSend)((id)target, property->_setter, (uint8_t)number.unsignedCharValue);
            break;
        }
        case ZYEncodingTypeInt16:
        {
            ((void (*)(id, SEL, int16_t))(void*)objc_msgSend)((id)target, property->_setter, (int16_t)number.shortValue);
            break;
        }
        case ZYEncodingTypeUInt16:
        {
            ((void (*)(id, SEL, uint16_t))(void*)objc_msgSend)((id)target, property->_setter, (uint16_t)number.unsignedShortValue);
            break;
        }
        case ZYEncodingTypeInt32:
        {
            ((void (*)(id, SEL, int32_t))(void*)objc_msgSend)((id)target, property->_setter, (int32_t)number.intValue);
            break;
        }
        case ZYEncodingTypeUInt32:
        {
            ((void (*)(id, SEL, uint32_t))(void*)objc_msgSend)((id)target, property->_setter, (uint32_t)number.unsignedIntValue);
            break;
        }
        case ZYEncodingTypeInt64:
        {
            ((void (*)(id, SEL, int64_t))(void*)objc_msgSend)((id)target, property->_setter, number.longLongValue);
            break;
        }
        case ZYEncodingTypeUInt64:
        {
            ((void (*)(id, SEL, uint64_t))(void*)objc_msgSend)((id)target, property->_setter, number.unsignedLongLongValue);
            break;
        }
        case ZYEncodingTypeFloat:
        {
            
            break;
        }
        default:
            break;
    }
}

NS_INLINE void SetValueToProperty(id target, ZYClassProperty *property, id value)
{
    if (property->_isCNumber)
    {
        SetCNumberToProperty(target, property, value);
    }
    else
    {
        SetNSObjectToProperty(target, property, value);
    }
}

@implementation NSObject (ZYModel)

#pragma mark - Virtual Methods

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

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return nil;
}

#pragma mark -

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

typedef struct {
    void *modelMeta;  ///< ZYModelMeta
    void *model;      ///< id (self)
    void *dictionary; ///< NSDictionary (json)
} ModelSetContext;

static void ModelSetWithPropertyMetaArrayFunction(const void *_propertyMeta, void *_context) {
    ModelSetContext *context = _context;
    __unsafe_unretained NSDictionary *dictionary = (__bridge NSDictionary *)(context->dictionary);
    __unsafe_unretained ZYModelPropertyMeta *propertyMeta = (__bridge ZYModelPropertyMeta *)(_propertyMeta);
    if (!propertyMeta->_classProperty->_setter) return;
    id value = nil;
    value = [dictionary objectForKey:propertyMeta->_jsonKey];

    if (value) {
        __unsafe_unretained id model = (__bridge id)(context->model);
        SetValueToProperty(model, propertyMeta->_classProperty, value);
    }
}

- (void)zy_setPropertiesWithDictionary:(NSDictionary*)dictionary
{
    Class cls = [self class];
    ZYModelMeta *meta = [ZYModelMeta metaWithClass:cls];

//    NSDictionary *mapper = meta->_jsonKeyToSetterMapper;
//    NSArray *properties = mapper.allValues;
    
    ModelSetContext context = {0};
    context.modelMeta = (__bridge void *)(meta);
    context.model = (__bridge void *)(self);
    context.dictionary = (__bridge void *)(dictionary);

    CFArrayApplyFunction((CFArrayRef)meta->_propertyMetas,
                         CFRangeMake(0, meta->_propertyMetas.count),
                         ModelSetWithPropertyMetaArrayFunction,
                         &context);

//    [dictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull jsonKey, id  _Nonnull content, BOOL * _Nonnull stop) {
//        if ([mapper objectForKey:jsonKey]){
//            id content = dictionary[jsonKey];
//            ZYClassProperty *property = mapper[jsonKey];
//            SetValueToProperty(self, property, content);
//        }
//    }];
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
