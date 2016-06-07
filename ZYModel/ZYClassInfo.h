//
//  ZYClassInfo.h
//  ZYModel
//
//  Created by 刘子洋 on 16/3/31.
//  Copyright © 2016年 刘子洋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

/// Foundation Class Type
// 已支持的在后面会有勾
typedef NS_ENUM(NSUInteger, ZYEncodingNSType) {
    ZYEncodingTypeNSUnknown = 0, //√ 这种是自定义类型
    ZYEncodingTypeNSString, //√
    ZYEncodingTypeNSMutableString, //√
    ZYEncodingTypeNSValue, //√
    ZYEncodingTypeNSNumber,
    ZYEncodingTypeNSDecimalNumber,
    ZYEncodingTypeNSData, //√
    ZYEncodingTypeNSMutableData, //√
    ZYEncodingTypeNSDate, //√
    ZYEncodingTypeNSURL, //√
    ZYEncodingTypeNSArray, //√
    ZYEncodingTypeNSMutableArray, //√
    ZYEncodingTypeNSDictionary, //√
    ZYEncodingTypeNSMutableDictionary, //√
    ZYEncodingTypeNSSet, //√
    ZYEncodingTypeNSMutableSet, //√
};

typedef NS_OPTIONS(NSUInteger, ZYEncodingType) {
    ZYEncodingTypeMask = 0xFF, ///< mask of type value
    ZYEncodingTypeUnknown = 0, ///< unknown
    ZYEncodingTypeVoid = 1, ///< void
    ZYEncodingTypeBool = 2, ///< bool
    ZYEncodingTypeInt8 = 3, ///< char / BOOL
    ZYEncodingTypeUInt8 = 4, ///< unsigned char
    ZYEncodingTypeInt16 = 5, ///< short
    ZYEncodingTypeUInt16 = 6, ///< unsigned short
    ZYEncodingTypeInt32 = 7, ///< int
    ZYEncodingTypeUInt32 = 8, ///< unsigned int
    ZYEncodingTypeInt64 = 9, ///< long long
    ZYEncodingTypeUInt64 = 10, ///< unsigned long long
    ZYEncodingTypeFloat = 11, ///< float
    ZYEncodingTypeDouble = 12, ///< double
    ZYEncodingTypeLongDouble = 13, ///< long double
    ZYEncodingTypeObject = 14, ///< id
    ZYEncodingTypeClass = 15, ///< Class
    ZYEncodingTypeSEL = 16, ///< SEL
    ZYEncodingTypeBlock = 17, ///< block
    ZYEncodingTypePointer = 18, ///< void*
    ZYEncodingTypeStruct = 19, ///< struct
    ZYEncodingTypeUnion = 20, ///< union
    ZYEncodingTypeCString = 21, ///< char*
    ZYEncodingTypeCArray = 22, ///< char[10] (for example)

    ZYEncodingTypeQualifierMask = 0xFF00, ///< mask of qualifier
    ZYEncodingTypeQualifierConst = 1 << 8, ///< const
    ZYEncodingTypeQualifierIn = 1 << 9, ///< in
    ZYEncodingTypeQualifierInout = 1 << 10, ///< inout
    ZYEncodingTypeQualifierOut = 1 << 11, ///< out
    ZYEncodingTypeQualifierBycopy = 1 << 12, ///< bycopy
    ZYEncodingTypeQualifierByref = 1 << 13, ///< byref
    ZYEncodingTypeQualifierOneway = 1 << 14, ///< oneway

    ZYEncodingTypePropertyMask = 0xFF0000, ///< mask of property
    ZYEncodingTypePropertyReadonly = 1 << 16, ///< readonly
    ZYEncodingTypePropertyCopy = 1 << 17, ///< copy
    ZYEncodingTypePropertyRetain = 1 << 18, ///< retain
    ZYEncodingTypePropertyNonatomic = 1 << 19, ///< nonatomic
    ZYEncodingTypePropertyWeak = 1 << 20, ///< weak
    ZYEncodingTypePropertyCustomGetter = 1 << 21, ///< getter=
    ZYEncodingTypePropertyCustomSetter = 1 << 22, ///< setter=
    ZYEncodingTypePropertyDynamic = 1 << 23, ///< @dynamic
};

@interface ZYClassPropertyInfo : NSObject {
@package
    objc_property_t _property;
    NSString* _name;
    ZYEncodingType _type;
    ZYEncodingNSType _nsType;
    NSString* _typeEncoding;
    // Class
    Class _cls;
    Class _containCls;
    BOOL _hasCustomContainCls;
    // CNumber
    BOOL _isCNumber;
    // Setter
    NSString* _setterString;
    SEL _setter;
    // Getter
    NSString* _getterString;
    SEL _getter;
}
- (instancetype)initWithProperty:(objc_property_t)property;
@end

@interface ZYClassInfo : NSObject {
@package
    NSDictionary<NSString*, ZYClassPropertyInfo*>* _properties;
}
- (instancetype)initWithClass:(Class) class;
+ (instancetype)classInfoWithClass:(Class) class;
@end
