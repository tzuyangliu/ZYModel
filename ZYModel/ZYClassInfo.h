//
//  ZYClassInfo.h
//  ZYModel
//
//  Created by 刘子洋 on 16/3/31.
//  Copyright © 2016年 刘子洋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
typedef NS_ENUM(NSUInteger, ZYType){
    ZYTypeUnknown = 0,
    ZYTypeBool,
    ZYTypeInt8,
    ZYTypeUInt8,
    ZYTypeInt16,
    ZYTypeUInt16,
    ZYTypeInt32,
    ZYTypeUInt32,
    ZYTypeInt64,
    ZYTypeUInt64,
    ZYTypeFloat,
    ZYTypeDouble,
    ZYTypeLongDouble,
    ZYTypeNSUnknown = 100,
    ZYTypeNSString,
    ZYTypeNSMutableString,
    ZYTypeNSValue,
    ZYTypeNSNumber,
    ZYTypeNSDecimalNumber,
    ZYTypeNSData,
    ZYTypeNSMutableData,
    ZYTypeNSDate,
    ZYTypeNSURL,
    ZYTypeNSArray,
    ZYTypeNSMutableArray,
    ZYTypeNSDictionary,
    ZYTypeNSMutableDictionary,
    ZYTypeNSSet,
    ZYTypeNSMutableSet,
};

typedef NS_ENUM(NSUInteger, ZYEncodingNSType) {
    ZYEncodingTypeNSUnknown = 0,
    ZYEncodingTypeNSString,
    ZYEncodingTypeNSMutableString,
    ZYEncodingTypeNSValue,
    ZYEncodingTypeNSNumber,
    ZYEncodingTypeNSDecimalNumber,
    ZYEncodingTypeNSData,
    ZYEncodingTypeNSMutableData,
    ZYEncodingTypeNSDate,
    ZYEncodingTypeNSURL,
    ZYEncodingTypeNSArray,
    ZYEncodingTypeNSMutableArray,
    ZYEncodingTypeNSDictionary,
    ZYEncodingTypeNSMutableDictionary,
    ZYEncodingTypeNSSet,
    ZYEncodingTypeNSMutableSet,
};
typedef NS_ENUM(NSUInteger, ZYEncodingType) {
    ZYEncodingTypeUnknown = 0,
    ZYEncodingTypeBool = 2,
    ZYEncodingTypeInt8 = 3,
    ZYEncodingTypeUInt8 = 4,
    ZYEncodingTypeInt16 = 5,
    ZYEncodingTypeUInt16 = 6,
    ZYEncodingTypeInt32 = 7,
    ZYEncodingTypeUInt32 = 8,
    ZYEncodingTypeInt64 = 9,
    ZYEncodingTypeUInt64 = 10,
    ZYEncodingTypeFloat = 11,
    ZYEncodingTypeDouble = 12,
    ZYEncodingTypeLongDouble = 13,
    ZYEncodingTypeObject = 14,
};

@interface ZYClassPropertyInfo : NSObject {
@package
    objc_property_t _property;
    NSString* _name;
    ZYEncodingType _type;
    ZYEncodingNSType _nsType;
    ZYType _zyType;
    Class _cls;
    Class _containCls;
    BOOL _hasCustomContainCls;
    BOOL _isCNumber;
    SEL _setter;
    SEL _getter;
}
- (instancetype)initWithProperty:(objc_property_t)property;
@end
@interface ZYClassInfo : NSObject {
@package
    NSDictionary<NSString*, ZYClassPropertyInfo*>* _propertyInfos;
}
- (instancetype)initWithClass:(Class) class;
+ (instancetype)classInfoWithClass:(Class) class;
@end