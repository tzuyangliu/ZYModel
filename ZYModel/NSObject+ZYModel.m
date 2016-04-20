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

NS_INLINE NSDateFormatter *GlobalDateFormatter()
{
    static dispatch_once_t onceToken;
    static NSDateFormatter *formatter;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EE MMM dd HH:mm:ss ZZZ yyyy";
    });
    return formatter;
}

NS_INLINE void SetNSObjectToProperty(id target, ZYClassProperty *property, id value)
{
    id setterObject = nil;
    ZYEncodingNSType nsType = property->_nsType;
    switch (nsType)
    {
        case ZYEncodingTypeNSUnknown:
        {
            setterObject = [property->_cls zy_modelWithJson:value];
            break;
        }
        // String
        // 可以接受的类型：NSString / NSMutableString / NSAttributedString / NSNumber
        case ZYEncodingTypeNSString:
        case ZYEncodingTypeNSMutableString:
        {
            if ([value isKindOfClass:[NSString class]])
            {
                BOOL mutable = [value isKindOfClass:[NSMutableString class]];
                if ((mutable && nsType == ZYEncodingTypeNSString)
                    || (!mutable && nsType == ZYEncodingTypeNSMutableString))
                {
                    setterObject = (nsType == ZYEncodingTypeNSString)
                    ?((NSString *)value).copy
                    :((NSString *)value).mutableCopy;
                }
                else
                {
                    setterObject = value;
                }
            }
            else if ([value isKindOfClass:[NSAttributedString class]])
            {
                setterObject = (nsType == ZYEncodingTypeNSString)
                ?((NSAttributedString *)value).string
                :((NSAttributedString *)value).string.mutableCopy;
            }
            else if ([value isKindOfClass:[NSNumber class]])
            {
                setterObject = (nsType == ZYEncodingTypeNSString)
                ? ((NSNumber *)value).stringValue
                : ((NSNumber *)value).stringValue.mutableCopy;
            }
            break;
        }
        // Array
        case ZYEncodingTypeNSArray:
        case ZYEncodingTypeNSMutableArray:
        {
            NSArray *array = nil;
            if ([value isKindOfClass:[NSArray class]])
            {
                array = value;
            }
            else if ([value isKindOfClass:[NSSet class]])
            {
                array = ((NSSet *)value).allObjects;
            }
            if (array)
            {
                if (property->_containCls)
                {
                    NSMutableArray *finalArray = [NSMutableArray array];
                    [array enumerateObjectsUsingBlock:^(id  _Nonnull subContent, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([subContent isKindOfClass:property->_containCls])
                        {
                            [finalArray addObject:subContent];
                        }
                        else
                        {
                            id tempObject = [property->_containCls zy_modelWithJson:subContent];
                            if (tempObject)
                            {
                                [finalArray addObject:tempObject];
                            }
                        }
                    }];
                    setterObject = (nsType == ZYEncodingTypeNSArray)
                    ?finalArray.copy
                    :finalArray;
                }
                else
                {
                    setterObject = (nsType == ZYEncodingTypeNSArray)
                    ?array
                    :array.mutableCopy;
                }
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
                            id tempObject = [property->_containCls zy_modelWithJson:valueForKey];
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
                    setterObject = (nsType == ZYEncodingTypeNSDictionary)
                    ? [value copy]
                    : [value mutableCopy];
                }
            }
            break;
        }
        // URL
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
        // Date
        case ZYEncodingTypeNSDate:
        {
            if ([value isKindOfClass:[NSDate class]])
            {
                setterObject = value;
            }
            else if ([value isKindOfClass:[NSString class]])
            {
                NSDate *date = [GlobalDateFormatter() dateFromString:(NSString *)value];
                if (date)
                {
                    setterObject = date;
                }
            }
            break;
        }
        // Value
        case ZYEncodingTypeNSValue:
        {
            if ([value isKindOfClass:[NSValue class]]){
                setterObject = value;
            }
            break;
        }
        // Data
        case ZYEncodingTypeNSData:
        case ZYEncodingTypeNSMutableData:
        {
            if ([value isKindOfClass:[NSData class]]){
                setterObject = (nsType == ZYEncodingTypeNSData)
                ?((NSData *)value).copy
                :((NSData *)value).mutableCopy;
            }
            else if ([value isKindOfClass:[NSString class]])
            {
                NSData *data = [(NSString *)value dataUsingEncoding:NSUTF8StringEncoding];
                setterObject = (nsType == ZYEncodingTypeNSData)
                ?data
                :data.mutableCopy;
            }
            break;
        }
        // Set
        case ZYEncodingTypeNSSet:
        case ZYEncodingTypeNSMutableSet:
        {
            NSSet *set = nil;
            if ([value isKindOfClass:[NSSet class]])
            {
                set = ((NSSet *)value).copy;
            }
            else if ([value isKindOfClass:[NSArray class]])
            {
                set = [NSSet setWithArray:(NSArray *)value];
            }
            if (set)
            {
                if (property->_hasCustomContainCls)
                {
                    NSMutableSet *finalSet = [NSMutableSet set];
                    [set enumerateObjectsUsingBlock:^(id  _Nonnull item, BOOL * _Nonnull stop) {
                        if ([item isKindOfClass:property->_containCls])
                        {
                            [finalSet addObject:item];
                        }
                        else if ([item isKindOfClass:[NSDictionary class]]){
                            id obj = [property->_containCls zy_modelWithDictionary:item];
                            if (obj)
                            {
                                [finalSet addObject:obj];
                            }
                        }
                    }];
                    setterObject = (nsType == ZYEncodingTypeNSSet)
                    ?finalSet.copy
                    :finalSet;
                }
                else
                {
                    setterObject = (nsType == ZYEncodingTypeNSSet)
                    ?set
                    :set.mutableCopy;
                }
            }
            break;
        }
        case ZYEncodingTypeNSNumber:
        case ZYEncodingTypeNSDecimalNumber:
        {
            if ([value isKindOfClass:[NSNumber class]])
            {
                setterObject = value;
            }
            else if ([value isKindOfClass:[NSString class]])
            {
                // NSString -> NSNumber
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
            float floatValue = number.floatValue;
            if (isnan(floatValue) || isinf(floatValue)) floatValue = 0;
            ((void (*)(id, SEL, float))(void *) objc_msgSend)((id)target, property->_setter, (float)floatValue);
            break;
        }
        case ZYEncodingTypeDouble:
        {
            double doubleValue = number.doubleValue;
            if (isnan(doubleValue) || isinf(doubleValue)) doubleValue = 0;
            ((void (*)(id, SEL, double))(void *) objc_msgSend)((id)target, property->_setter, (double)doubleValue);
            break;
        }
        case ZYEncodingTypeLongDouble:
        {
            long double longDoubleValue = (long double)number.doubleValue;
            if (isnan(longDoubleValue) || isinf(longDoubleValue)) longDoubleValue = 0;
            ((void (*)(id, SEL, long double))(void *) objc_msgSend)((id)target, property->_setter, (long double)longDoubleValue);
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

+ (NSDictionary*)zy_propertyToJsonKeyMapper
{
    return nil;
}

+ (NSArray *)zy_whitelistProperties
{
    return nil;
}

+ (NSArray *)zy_blacklistProperties
{
    return nil;
}

+ (NSDictionary *)zy_containerPropertyGenericClass
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

- (void)zy_setPropertiesWithJson:(id)json
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
    ModelSetContext context = {0};
    context.modelMeta = (__bridge void *)(meta);
    context.model = (__bridge void *)(self);
    context.dictionary = (__bridge void *)(dictionary);
    CFArrayApplyFunction((CFArrayRef)meta->_propertyMetas,
                         CFRangeMake(0, meta->_propertyMetas.count),
                         ModelSetWithPropertyMetaArrayFunction,
                         &context);
}

+ (instancetype)zy_modelWithJson:(id)json
{
    NSObject* obj = [[self class] new];
    [obj zy_setPropertiesWithJson:json];
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

+ (NSMutableArray *)zy_modelMutableArrayWithJson:(id)json
{
    NSMutableArray *objectArray = [NSMutableArray array];
    NSArray *array = [self _zy_arrayWithJSON:json];
    for (id subJson in array){
        id obj = [self zy_modelWithJson:subJson];
        if (obj)
        {
            [objectArray addObject:obj];
        }
    }
    return objectArray;
}

+ (NSArray *)zy_modelArrayWithJson:(id)json
{
    return [[self zy_modelMutableArrayWithJson:json] copy];
}

@end
