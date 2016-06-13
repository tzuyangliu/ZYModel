//
//  NSObject+ZYModel.m
//  ZYModel
//
//  Created by 刘子洋 on 16/3/29.
//  Copyright © 2016年 刘子洋. All rights reserved.
//
#import "NSObject+ZYModel.h"
#import "ZYClassInfo.h"
#import "ZYModelTransformInfo.h"
#import <objc/objc-runtime.h>
NS_INLINE NSDateFormatter *ZYGetDateFormatter() {
  static dispatch_once_t onceToken;
  static NSDateFormatter *formatter;
  dispatch_once(&onceToken, ^{
    formatter = [[NSDateFormatter alloc] init];
    [formatter
        setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    formatter.dateFormat = @"EE MMM dd HH:mm:ss ZZZ yyyy";
  });
  return formatter;
}
NS_INLINE void SetNSObjectToProperty(id target,
                                     ZYModelPropertyTransformInfo *property,
                                     id value) {
  id setterObject = nil;
  ZYType nsType = property->_type;
  switch (nsType) {
  case ZYTypeNSUnknown: {
    setterObject = [property->_cls zy_modelWithJson:value];
    break;
  }
  case ZYTypeNSString:
  case ZYTypeNSMutableString: {
    if ([value isKindOfClass:[NSString class]]) {
      BOOL mutable = [value isKindOfClass:[NSMutableString class]];
      if ((mutable && nsType == ZYTypeNSString) ||
          (!mutable && nsType == ZYTypeNSMutableString)) {
        setterObject = (nsType == ZYTypeNSString)
                           ? ((NSString *)value).copy
                           : ((NSString *)value).mutableCopy;
      } else {
        setterObject = value;
      }
    } else if ([value isKindOfClass:[NSAttributedString class]]) {
      setterObject = (nsType == ZYTypeNSString)
                         ? ((NSAttributedString *)value).string
                         : ((NSAttributedString *)value).string.mutableCopy;
    } else if ([value isKindOfClass:[NSNumber class]]) {
      setterObject = (nsType == ZYTypeNSString)
                         ? ((NSNumber *)value).stringValue
                         : ((NSNumber *)value).stringValue.mutableCopy;
    }
    break;
  }
  case ZYTypeNSArray:
  case ZYTypeNSMutableArray: {
    NSArray *array = nil;
    if ([value isKindOfClass:[NSArray class]]) {
      array = value;
    } else if ([value isKindOfClass:[NSSet class]]) {
      array = ((NSSet *)value).allObjects;
    }
    if (array) {
      if (property->_containCls) {
        NSMutableArray *finalArray = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(id _Nonnull subContent,
                                            NSUInteger idx,
                                            BOOL *_Nonnull stop) {
          if ([subContent isKindOfClass:property->_containCls]) {
            [finalArray addObject:subContent];
          } else {
            id tempObject = [property->_containCls zy_modelWithJson:subContent];
            if (tempObject) {
              [finalArray addObject:tempObject];
            }
          }
        }];
        setterObject = (nsType == ZYTypeNSArray) ? finalArray.copy : finalArray;
      } else {
        setterObject = (nsType == ZYTypeNSArray) ? array : array.mutableCopy;
      }
    }
    break;
  }
  case ZYTypeNSDictionary:
  case ZYTypeNSMutableDictionary: {
    if ([value isKindOfClass:[NSDictionary class]]) {
      if (property->_containCls) {
        setterObject = [NSMutableDictionary dictionary];
        [(NSDictionary *)value
            enumerateKeysAndObjectsUsingBlock:^(
                id _Nonnull key, id _Nonnull valueForKey, BOOL *_Nonnull stop) {
              if ([valueForKey isKindOfClass:property->_containCls]) {
                setterObject[key] = valueForKey;
              } else {
                id tempObject =
                    [property->_containCls zy_modelWithJson:valueForKey];
                if (tempObject) {
                  setterObject[key] = tempObject;
                }
              }
            }];
        if (property->_type == ZYTypeNSDictionary) {
          setterObject = [setterObject copy];
        }
      } else {
        setterObject =
            (nsType == ZYTypeNSDictionary) ? [value copy] : [value mutableCopy];
      }
    }
    break;
  }
  case ZYTypeNSURL: {
    if ([value isKindOfClass:[NSURL class]]) {
      setterObject = value;
    } else if ([value isKindOfClass:[NSString class]]) {
      setterObject = [NSURL URLWithString:value];
    }
    break;
  }
  case ZYTypeNSDate: {
    if ([value isKindOfClass:[NSDate class]]) {
      setterObject = value;
    } else if ([value isKindOfClass:[NSString class]]) {
      NSDate *date = [ZYGetDateFormatter() dateFromString:(NSString *)value];
      if (date) {
        setterObject = date;
      }
    }
    break;
  }
  case ZYTypeNSValue: {
    if ([value isKindOfClass:[NSValue class]]) {
      setterObject = value;
    }
    break;
  }
  case ZYTypeNSData:
  case ZYTypeNSMutableData: {
    if ([value isKindOfClass:[NSData class]]) {
      setterObject = (nsType == ZYTypeNSData) ? ((NSData *)value).copy
                                              : ((NSData *)value).mutableCopy;
    } else if ([value isKindOfClass:[NSString class]]) {
      NSData *data = [(NSString *)value dataUsingEncoding:NSUTF8StringEncoding];
      setterObject = (nsType == ZYTypeNSData) ? data : data.mutableCopy;
    }
    break;
  }
  case ZYTypeNSSet:
  case ZYTypeNSMutableSet: {
    NSSet *set = nil;
    if ([value isKindOfClass:[NSSet class]]) {
      set = ((NSSet *)value).copy;
    } else if ([value isKindOfClass:[NSArray class]]) {
      set = [NSSet setWithArray:(NSArray *)value];
    }
    if (set) {
      if (property->_containCls) {
        NSMutableSet *finalSet = [NSMutableSet set];
        [set enumerateObjectsUsingBlock:^(id _Nonnull item,
                                          BOOL *_Nonnull stop) {
          if ([item isKindOfClass:property->_containCls]) {
            [finalSet addObject:item];
          } else if ([item isKindOfClass:[NSDictionary class]]) {
            id obj = [property->_containCls zy_modelWithDictionary:item];
            if (obj) {
              [finalSet addObject:obj];
            }
          }
        }];
        setterObject = (nsType == ZYTypeNSSet) ? finalSet.copy : finalSet;
      } else {
        setterObject = (nsType == ZYTypeNSSet) ? set : set.mutableCopy;
      }
    }
    break;
  }
  case ZYTypeNSNumber:
  case ZYTypeNSDecimalNumber: {
    if ([value isKindOfClass:[NSNumber class]]) {
      setterObject = value;
    } else if ([value isKindOfClass:[NSString class]]) {
    }
    break;
  }
  default: {
    setterObject = value;
    break;
  }
  }
  if (setterObject) {
    ((void (*)(id, SEL, id))(void *)objc_msgSend)((id)target, property->_setter,
                                                  setterObject);
  }
}
NS_INLINE void SetCNumberToProperty(id target,
                                    ZYModelPropertyTransformInfo *property,
                                    NSNumber *number) {
  switch (property->_type) {
  case ZYTypeBool: {
    ((void (*)(id, SEL, BOOL))(void *)objc_msgSend)(
        (id)target, property->_setter, number.boolValue);
    break;
  }
  case ZYTypeInt8: {
    ((void (*)(id, SEL, int8_t))(void *)objc_msgSend)(
        (id)target, property->_setter, (int8_t)number.charValue);
    break;
  }
  case ZYTypeUInt8: {
    ((void (*)(id, SEL, int8_t))(void *)objc_msgSend)(
        (id)target, property->_setter, (uint8_t)number.unsignedCharValue);
    break;
  }
  case ZYTypeInt16: {
    ((void (*)(id, SEL, int16_t))(void *)objc_msgSend)(
        (id)target, property->_setter, (int16_t)number.shortValue);
    break;
  }
  case ZYTypeUInt16: {
    ((void (*)(id, SEL, uint16_t))(void *)objc_msgSend)(
        (id)target, property->_setter, (uint16_t)number.unsignedShortValue);
    break;
  }
  case ZYTypeInt32: {
    ((void (*)(id, SEL, int32_t))(void *)objc_msgSend)(
        (id)target, property->_setter, (int32_t)number.intValue);
    break;
  }
  case ZYTypeUInt32: {
    ((void (*)(id, SEL, uint32_t))(void *)objc_msgSend)(
        (id)target, property->_setter, (uint32_t)number.unsignedIntValue);
    break;
  }
  case ZYTypeInt64: {
    ((void (*)(id, SEL, int64_t))(void *)objc_msgSend)(
        (id)target, property->_setter, number.longLongValue);
    break;
  }
  case ZYTypeUInt64: {
    ((void (*)(id, SEL, uint64_t))(void *)objc_msgSend)(
        (id)target, property->_setter, number.unsignedLongLongValue);
    break;
  }
  case ZYTypeFloat: {
    float floatValue = number.floatValue;
    if (isnan(floatValue) || isinf(floatValue))
      floatValue = 0;
    ((void (*)(id, SEL, float))(void *)objc_msgSend)(
        (id)target, property->_setter, (float)floatValue);
    break;
  }
  case ZYTypeDouble: {
    double doubleValue = number.doubleValue;
    if (isnan(doubleValue) || isinf(doubleValue))
      doubleValue = 0;
    ((void (*)(id, SEL, double))(void *)objc_msgSend)(
        (id)target, property->_setter, (double)doubleValue);
    break;
  }
  case ZYTypeLongDouble: {
    long double longDoubleValue = (long double)number.doubleValue;
    if (isnan(longDoubleValue) || isinf(longDoubleValue))
      longDoubleValue = 0;
    ((void (*)(id, SEL, long double))(void *)objc_msgSend)(
        (id)target, property->_setter, (long double)longDoubleValue);
    break;
  }
  default:
    break;
  }
}
NS_INLINE void SetValueToProperty(id target,
                                  ZYModelPropertyTransformInfo *property,
                                  id value) {
  if (property->_isCNumber) {
    SetCNumberToProperty(target, property, value);
  } else {
    SetNSObjectToProperty(target, property, value);
  }
}
@implementation NSObject (ZYModel)
+ (NSDictionary *)zy_propertyToJsonKeyMapper {return nil;}
+ (NSArray *)zy_whitelistProperties {return nil;}
+ (NSArray *)zy_blacklistProperties {return nil;}
+ (NSDictionary *)zy_containerPropertyClassMapper {return nil;}
#pragma mark -
+ (NSArray *)_zy_arrayWithJSON:(id)json {
  if (!json || json == (id)kCFNull)
    return nil;
  if ([json isKindOfClass:[NSArray class]]) {
    return json;
  }
  BOOL isData = [json isKindOfClass:[NSData class]];
  BOOL isString = [json isKindOfClass:[NSString class]];
  if (isData || isString) {
    NSData *data = nil;
    if (isString) {
      data = [(NSString *)json dataUsingEncoding:NSUTF8StringEncoding];
    } else {
      data = json;
    }
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data
                                                     options:kNilOptions
                                                       error:NULL];
    if ([array isKindOfClass:[NSArray class]]) {
      return array;
    }
  }
  return nil;
}
+ (NSDictionary *)_zy_dictionaryWithJSON:(id)json {
  if (!json || json == (id)kCFNull)
    return nil;
  if ([json isKindOfClass:[NSDictionary class]]) {
    return json;
  }
  BOOL isData = [json isKindOfClass:[NSData class]];
  BOOL isString = [json isKindOfClass:[NSString class]];
  if (isData || isString) {
    NSData *data = nil;
    if (isString) {
      data = [(NSString *)json dataUsingEncoding:NSUTF8StringEncoding];
    } else {
      data = json;
    }
    NSDictionary *dictionary =
        [NSJSONSerialization JSONObjectWithData:data
                                        options:kNilOptions
                                          error:NULL];
    if ([dictionary isKindOfClass:[NSDictionary class]]) {
      return dictionary;
    }
  }
  return nil;
}
- (void)zy_setPropertiesWithJson:(id)json {
  NSDictionary *dictionary = [[self class] _zy_dictionaryWithJSON:json];
  if (dictionary) {
    [self zy_setPropertiesWithDictionary:dictionary];
  }
}
typedef struct {
  void *modelTransformInfo;
  void *model;
  void *dictionary;
} ZYModelSetContext;
NS_INLINE void ModelSetWithPropertyTransformInfoArrayFunction(
    const void *_propertyTransformInfo, void *_context) {
  ZYModelSetContext *context = _context;
  __unsafe_unretained NSDictionary *dictionary =
      (__bridge NSDictionary *)(context->dictionary);
  __unsafe_unretained ZYModelPropertyTransformInfo *propertyTransformInfo =
      (__bridge ZYModelPropertyTransformInfo *)(_propertyTransformInfo);
  if (!propertyTransformInfo->_setter)
    return;
  id value = nil;
  value = [dictionary objectForKey:propertyTransformInfo->_jsonKey];
  if (value) {
    __unsafe_unretained id model = (__bridge id)(context->model);
    SetValueToProperty(model, propertyTransformInfo, value);
  }
}
NS_INLINE NSNumber *ModelCreateNumberFromPropertyTransformInfo(
    __unsafe_unretained id model,
    __unsafe_unretained ZYModelPropertyTransformInfo *propertyTransformInfo) {
  SEL getter = propertyTransformInfo->_getter;
  switch (propertyTransformInfo->_type) {
  case ZYTypeBool: {
    return @(((bool (*)(id, SEL))(void *)objc_msgSend)((id)model, getter));
  }
  case ZYTypeInt8: {
    return @(((int8_t (*)(id, SEL))(void *)objc_msgSend)((id)model, getter));
  }
  case ZYTypeUInt8: {
    return @(((uint8_t (*)(id, SEL))(void *)objc_msgSend)((id)model, getter));
  }
  case ZYTypeInt16: {
    return @(((int16_t (*)(id, SEL))(void *)objc_msgSend)((id)model, getter));
  }
  case ZYTypeUInt16: {
    return @(((uint16_t (*)(id, SEL))(void *)objc_msgSend)((id)model, getter));
  }
  case ZYTypeInt32: {
    return @(((int32_t (*)(id, SEL))(void *)objc_msgSend)((id)model, getter));
  }
  case ZYTypeUInt32: {
    return @(((uint32_t (*)(id, SEL))(void *)objc_msgSend)((id)model, getter));
  }
  case ZYTypeInt64: {
    return @(((int64_t (*)(id, SEL))(void *)objc_msgSend)((id)model, getter));
  }
  case ZYTypeUInt64: {
    return @(((uint64_t (*)(id, SEL))(void *)objc_msgSend)((id)model, getter));
  }
  case ZYTypeFloat: {
    float num = ((float (*)(id, SEL))(void *)objc_msgSend)((id)model, getter);
    if (isnan(num) || isinf(num))
      return nil;
    return @(num);
  }
  case ZYTypeDouble: {
    double num = ((double (*)(id, SEL))(void *)objc_msgSend)((id)model, getter);
    if (isnan(num) || isinf(num))
      return nil;
    return @(num);
  }
  case ZYTypeLongDouble: {
    double num =
        ((long double (*)(id, SEL))(void *)objc_msgSend)((id)model, getter);
    if (isnan(num) || isinf(num))
      return nil;
    return @(num);
  }
  default:
    return nil;
  }
  return nil;
}
static id ModelToJson(NSObject *model) {
  if (!model || model == (id)kCFNull ||
      [model isKindOfClass:[NSString class]] ||
      [model isKindOfClass:[NSNumber class]]) {
    return model;
  }
  if ([model isKindOfClass:[NSDictionary class]]) {
    if ([NSJSONSerialization isValidJSONObject:model]) {
      return model;
    }
    NSMutableDictionary *newDict = [NSMutableDictionary dictionary];
    [(NSDictionary *)model
        enumerateKeysAndObjectsUsingBlock:^(NSString *key, id _Nonnull obj,
                                            BOOL *_Nonnull stop) {
          NSString *stringKey =
              [key isKindOfClass:[NSString class]] ? key : key.description;
          if (!stringKey)
            return;
          id jsonObj = ModelToJson(obj);
          if (!jsonObj)
            jsonObj = (id)kCFNull;
          newDict[stringKey] = jsonObj;
        }];
    return newDict;
  }
  if ([model isKindOfClass:[NSSet class]]) {
    NSArray *array = ((NSSet *)model).allObjects;
    if ([NSJSONSerialization isValidJSONObject:array])
      return array;
    NSMutableArray *newArray = [NSMutableArray new];
    for (id obj in array) {
      if ([obj isKindOfClass:[NSString class]] ||
          [obj isKindOfClass:[NSNumber class]]) {
        [newArray addObject:obj];
      } else {
        id jsonObj = ModelToJson(obj);
        if (jsonObj && jsonObj != (id)kCFNull)
          [newArray addObject:jsonObj];
      }
    }
    return newArray;
  }
  if ([model isKindOfClass:[NSArray class]]) {
    if ([NSJSONSerialization isValidJSONObject:model])
      return model;
    NSMutableArray *newArray = [NSMutableArray new];
    for (id obj in (NSArray *)model) {
      if ([obj isKindOfClass:[NSString class]] ||
          [obj isKindOfClass:[NSNumber class]]) {
        [newArray addObject:obj];
      } else {
        id jsonObj = ModelToJson(obj);
        if (jsonObj && jsonObj != (id)kCFNull)
          [newArray addObject:jsonObj];
      }
    }
    return newArray;
  }
  if ([model isKindOfClass:[NSURL class]]) {
    return ((NSURL *)model).absoluteString;
  }
  if ([model isKindOfClass:[NSAttributedString class]]) {
    return ((NSAttributedString *)model).string;
  }
  if ([model isKindOfClass:[NSDate class]]) {
    NSDateFormatter *dateFormatter = ZYGetDateFormatter();
    NSString *dateString = [dateFormatter stringFromDate:(NSDate *)model];
    return dateString;
  }
  if ([model isKindOfClass:[NSData class]])
    return nil;
  ZYModelTransformInfo *modelTransformInfo =
      [ZYModelTransformInfo modelTransformInfoWithClass:[model class]];
  if (!modelTransformInfo) {
    return nil;
  }
  NSMutableDictionary *newDict = [NSMutableDictionary dictionary];
  for (ZYModelPropertyTransformInfo *propertyTransformInfo in modelTransformInfo
           ->_propertyTransformInfos) {
    NSString *jsonKey = propertyTransformInfo->_jsonKey;
    id jsonValue = nil;
    if (propertyTransformInfo->_isCNumber) {
      jsonValue = ModelCreateNumberFromPropertyTransformInfo(
          model, propertyTransformInfo);
    } else if (propertyTransformInfo->_type) {
      id v = ((id (*)(id, SEL))(void *)objc_msgSend)(
          (id)model, propertyTransformInfo->_getter);
      jsonValue = ModelToJson(v);
    }
    if (jsonValue) {
      newDict[jsonKey] = jsonValue;
    }
  }
  return newDict;
}
- (void)zy_setPropertiesWithDictionary:(NSDictionary *)dictionary {
  Class cls = [self class];
  ZYModelTransformInfo *modelTransformInfo =
      [ZYModelTransformInfo modelTransformInfoWithClass:cls];
  ZYModelSetContext context = {0};
  context.modelTransformInfo = (__bridge void *)(modelTransformInfo);
  context.model = (__bridge void *)(self);
  context.dictionary = (__bridge void *)(dictionary);
  CFArrayApplyFunction(
      (CFArrayRef)modelTransformInfo->_propertyTransformInfos,
      CFRangeMake(0, modelTransformInfo->_propertyTransformInfos.count),
      ModelSetWithPropertyTransformInfoArrayFunction, &context);
}
+ (instancetype)zy_modelWithJson:(id)json {
  NSObject *obj = [[self class] new];
  [obj zy_setPropertiesWithJson:json];
  return obj;
}
+ (instancetype)zy_modelWithDictionary:(NSDictionary *)dictionary {
  if ((!dictionary) || dictionary == (id)kCFNull)
    return nil;
  if (![dictionary isKindOfClass:[NSDictionary class]])
    return nil;
  NSObject *obj = [[self class] new];
  [obj zy_setPropertiesWithDictionary:dictionary];
  return obj;
}
- (id)zy_modelJson {
  id json = ModelToJson(self);
  if ([json isKindOfClass:[NSArray class]] ||
      [json isKindOfClass:[NSDictionary class]]) {
    return json;
  } else {
    return nil;
  }
}
+ (NSMutableArray *)zy_modelMutableArrayWithJson:(id)json {
  NSMutableArray *objectArray = [NSMutableArray array];
  NSArray *array = [self _zy_arrayWithJSON:json];
  for (id subJson in array) {
    id obj = [self zy_modelWithJson:subJson];
    if (obj) {
      [objectArray addObject:obj];
    }
  }
  return objectArray;
}
+ (NSArray *)zy_modelArrayWithJson:(id)json {
  return [[self zy_modelMutableArrayWithJson:json] copy];
}
@end