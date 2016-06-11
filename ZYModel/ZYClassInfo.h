//
//  ZYClassInfo.h
//  ZYModel
//
//  Created by 刘子洋 on 16/3/31.
//  Copyright © 2016年 刘子洋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
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
typedef NS_OPTIONS(NSUInteger, ZYEncodingType) {
  ZYEncodingTypeMask = 0xFF, ///< mask of type value
  ZYEncodingTypeUnknown = 0, ///< unknown

  ZYEncodingTypeBool = 2,        ///< bool
  ZYEncodingTypeInt8 = 3,        ///< char / BOOL
  ZYEncodingTypeUInt8 = 4,       ///< unsigned char
  ZYEncodingTypeInt16 = 5,       ///< short
  ZYEncodingTypeUInt16 = 6,      ///< unsigned short
  ZYEncodingTypeInt32 = 7,       ///< int
  ZYEncodingTypeUInt32 = 8,      ///< unsigned int
  ZYEncodingTypeInt64 = 9,       ///< long long
  ZYEncodingTypeUInt64 = 10,     ///< unsigned long long
  ZYEncodingTypeFloat = 11,      ///< float
  ZYEncodingTypeDouble = 12,     ///< double
  ZYEncodingTypeLongDouble = 13, ///< long double
  ZYEncodingTypeObject = 14,     ///< id
};

@interface ZYClassPropertyInfo : NSObject {
@package
  objc_property_t _property;
  NSString *_name;
  ZYEncodingType _type;
  ZYEncodingNSType _nsType;
  // Class
  Class _cls;
  Class _containCls;
  BOOL _hasCustomContainCls;
  // CNumber
  BOOL _isCNumber;
  // Setter
  NSString *_setterString;
  SEL _setter;
  // Getter
  NSString *_getterString;
  SEL _getter;
}
- (instancetype)initWithProperty:(objc_property_t)property;
@end

@interface ZYClassInfo : NSObject {
@package
  NSDictionary<NSString *, ZYClassPropertyInfo *> *_propertyInfos;
}
- (instancetype)initWithClass:(Class) class;
+ (instancetype)classInfoWithClass:(Class) class;
@end
