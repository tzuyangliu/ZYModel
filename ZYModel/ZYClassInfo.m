//
//  ZYClassInfo.m
//  ZYModel
//
//  Created by 刘子洋 on 16/3/31.
//  Copyright © 2016年 刘子洋. All rights reserved.
//

#import "NSObject+ZYModel.h"
#import "ZYClassInfo.h"

typedef struct{
    ZYType type;
    Class cls;
}ZYTypeInfo;

static __inline__ __attribute__((always_inline)) ZYEncodingNSType
ZYClassGetNSType(Class cls)
{
    if (!cls)
        return ZYEncodingTypeNSUnknown;
    if ([cls isSubclassOfClass:[NSMutableString class]])
        return ZYEncodingTypeNSMutableString;
    if ([cls isSubclassOfClass:[NSString class]])
        return ZYEncodingTypeNSString;
    if ([cls isSubclassOfClass:[NSDecimalNumber class]])
        return ZYEncodingTypeNSDecimalNumber;
    if ([cls isSubclassOfClass:[NSNumber class]])
        return ZYEncodingTypeNSNumber;
    if ([cls isSubclassOfClass:[NSValue class]])
        return ZYEncodingTypeNSValue;
    if ([cls isSubclassOfClass:[NSMutableData class]])
        return ZYEncodingTypeNSMutableData;
    if ([cls isSubclassOfClass:[NSData class]])
        return ZYEncodingTypeNSData;
    if ([cls isSubclassOfClass:[NSDate class]])
        return ZYEncodingTypeNSDate;
    if ([cls isSubclassOfClass:[NSURL class]])
        return ZYEncodingTypeNSURL;
    if ([cls isSubclassOfClass:[NSMutableArray class]])
        return ZYEncodingTypeNSMutableArray;
    if ([cls isSubclassOfClass:[NSArray class]])
        return ZYEncodingTypeNSArray;
    if ([cls isSubclassOfClass:[NSMutableDictionary class]])
        return ZYEncodingTypeNSMutableDictionary;
    if ([cls isSubclassOfClass:[NSDictionary class]])
        return ZYEncodingTypeNSDictionary;
    if ([cls isSubclassOfClass:[NSMutableSet class]])
        return ZYEncodingTypeNSMutableSet;
    if ([cls isSubclassOfClass:[NSSet class]])
        return ZYEncodingTypeNSSet;
    return ZYEncodingTypeNSUnknown;
}



static __inline__ __attribute__((always_inline)) BOOL
ZYEncodingGetIsCNumber(ZYEncodingType encodingType)
{
    switch (encodingType & ZYEncodingTypeMask) {
    case ZYEncodingTypeBool:
    case ZYEncodingTypeInt8:
    case ZYEncodingTypeUInt8:
    case ZYEncodingTypeInt16:
    case ZYEncodingTypeUInt16:
    case ZYEncodingTypeInt32:
    case ZYEncodingTypeUInt32:
    case ZYEncodingTypeInt64:
    case ZYEncodingTypeUInt64:
    case ZYEncodingTypeFloat:
    case ZYEncodingTypeDouble:
    case ZYEncodingTypeLongDouble:
        return YES;
    default:
        return NO;
    }
}

NS_INLINE BOOL ZYTypeGetIsCNumber(ZYType type){
    switch (type) {
        case ZYTypeBool:
        case ZYTypeInt8:
        case ZYTypeUInt8:
        case ZYTypeInt16:
        case ZYTypeUInt16:
        case ZYTypeInt32:
        case ZYTypeUInt32:
        case ZYTypeInt64:
        case ZYTypeUInt64:
        case ZYTypeFloat:
        case ZYTypeDouble:
        case ZYTypeLongDouble:
            return YES;
        default:
            return NO;
    }
}

NS_INLINE ZYTypeInfo ZYClassGetType(const char* typeEncoding){
    Class cls = nil;
    ZYType resultType = ZYTypeUnknown;
    char* type = (char*)typeEncoding;
    if (!type) resultType = ZYTypeUnknown;
    size_t len = strlen(type);
    if (len == 0) resultType = ZYTypeUnknown;
    len = strlen(type);
    if (len == 0) resultType = ZYTypeUnknown;
    switch (*type) {
        case 'B':
            resultType = ZYTypeBool;
        case 'c':
            resultType = ZYTypeInt8;
        case 'C':
            resultType = ZYTypeUInt8;
        case 's':
            resultType = ZYTypeInt16;
        case 'S':
            resultType = ZYTypeUInt16;
        case 'i':
            resultType = ZYTypeInt32;
        case 'I':
            resultType = ZYTypeUInt32;
        case 'l':
            resultType = ZYTypeInt32;
        case 'L':
            resultType = ZYTypeUInt32;
        case 'q':
            resultType = ZYTypeInt64;
        case 'Q':
            resultType = ZYTypeUInt64;
        case 'f':
            resultType = ZYTypeFloat;
        case 'd':
            resultType = ZYTypeDouble;
        case 'D':
            resultType = ZYTypeLongDouble;
        case '@': {
            if (!(len == 2 && *(type + 1) == '?'))
            {
                size_t len = strlen(typeEncoding);
                if (len > 3) {
                    char name[len - 2];
                    name[len - 3] = '\0';
                    memcpy(name, typeEncoding + 2, len - 3);
                    cls = objc_getClass(name);
                }
                if (!cls)
                    resultType = ZYTypeNSUnknown;
                if ([cls isSubclassOfClass:[NSMutableString class]])
                    resultType = ZYTypeNSMutableString;
                if ([cls isSubclassOfClass:[NSString class]])
                    resultType = ZYTypeNSString;
                if ([cls isSubclassOfClass:[NSDecimalNumber class]])
                    resultType = ZYTypeNSDecimalNumber;
                if ([cls isSubclassOfClass:[NSNumber class]])
                    resultType = ZYTypeNSNumber;
                if ([cls isSubclassOfClass:[NSValue class]])
                    resultType = ZYTypeNSValue;
                if ([cls isSubclassOfClass:[NSMutableData class]])
                    resultType = ZYTypeNSMutableData;
                if ([cls isSubclassOfClass:[NSData class]])
                    resultType = ZYTypeNSData;
                if ([cls isSubclassOfClass:[NSDate class]])
                    resultType = ZYTypeNSDate;
                if ([cls isSubclassOfClass:[NSURL class]])
                    resultType = ZYTypeNSURL;
                if ([cls isSubclassOfClass:[NSMutableArray class]])
                    resultType = ZYTypeNSMutableArray;
                if ([cls isSubclassOfClass:[NSArray class]])
                    resultType = ZYTypeNSArray;
                if ([cls isSubclassOfClass:[NSMutableDictionary class]])
                    resultType = ZYTypeNSMutableDictionary;
                if ([cls isSubclassOfClass:[NSDictionary class]])
                    resultType = ZYTypeNSDictionary;
                if ([cls isSubclassOfClass:[NSMutableSet class]])
                    resultType = ZYTypeNSMutableSet;
                if ([cls isSubclassOfClass:[NSSet class]])
                    resultType = ZYTypeNSSet;
                resultType = ZYTypeNSUnknown;
            }
        }
        default:
            resultType = ZYTypeUnknown;
    }
    ZYTypeInfo typeInfo = {.type = resultType, .cls = cls};
    return typeInfo;
}

static __inline__ __attribute__((always_inline)) ZYEncodingType
ZYEncodingGetType(const char* typeEncoding)
{
    char* type = (char*)typeEncoding;
    if (!type)
        return ZYEncodingTypeUnknown;
    size_t len = strlen(type);
    if (len == 0)
        return ZYEncodingTypeUnknown;
    len = strlen(type);
    if (len == 0)
        return ZYEncodingTypeUnknown;

    switch (*type) {
    case 'B':
        return ZYEncodingTypeBool;
    case 'c':
        return ZYEncodingTypeInt8;
    case 'C':
        return ZYEncodingTypeUInt8;
    case 's':
        return ZYEncodingTypeInt16;
    case 'S':
        return ZYEncodingTypeUInt16;
    case 'i':
        return ZYEncodingTypeInt32;
    case 'I':
        return ZYEncodingTypeUInt32;
    case 'l':
        return ZYEncodingTypeInt32;
    case 'L':
        return ZYEncodingTypeUInt32;
    case 'q':
        return ZYEncodingTypeInt64;
    case 'Q':
        return ZYEncodingTypeUInt64;
    case 'f':
        return ZYEncodingTypeFloat;
    case 'd':
        return ZYEncodingTypeDouble;
    case 'D':
        return ZYEncodingTypeLongDouble;
    case '@': {
        if (!(len == 2 && *(type + 1) == '?'))
            return ZYEncodingTypeObject;
    }
    default:
        return ZYEncodingTypeUnknown;
    }
}

@implementation ZYClassPropertyInfo

- (instancetype)initWithProperty:(objc_property_t)property
{
    if (!property)
        return nil;
    self = [super init];
    if (self) {
        _property = property;
        const char* name = property_getName(property);
        if (name) {
            _name = [NSString stringWithUTF8String:name];
        }
        unsigned int attrCount;
        objc_property_attribute_t* attrs = property_copyAttributeList(property, &attrCount);
        for (unsigned int i = 0; i < attrCount; i++) {
            switch (attrs[i].name[0]) {
            case 'T': {
                if (attrs[i].value) {
//                    ZYTypeInfo typeInfo = ZYClassGetType(attrs[i].value);
//                    _zyType = typeInfo.type;
                    _type = ZYEncodingGetType(attrs[i].value);
                    _isCNumber = ZYEncodingGetIsCNumber(_type);
                    if ((_type & ZYEncodingTypeMask) == ZYEncodingTypeObject) {
                        size_t len = strlen(attrs[i].value);
                        if (len > 3) {
                            char name[len - 2];
                            name[len - 3] = '\0';
                            memcpy(name, attrs[i].value + 2, len - 3);
                            _cls = objc_getClass(name);
                        }
                    }
                    if ((_type & ZYEncodingTypeMask) == ZYEncodingTypeObject) {
                        _nsType = ZYClassGetNSType(_cls);
                        if (_nsType == ZYEncodingTypeNSSet || _nsType == ZYEncodingTypeNSMutableSet || _nsType == ZYEncodingTypeNSArray || _nsType == ZYEncodingTypeNSMutableArray || _nsType == ZYEncodingTypeNSDictionary || _nsType == ZYEncodingTypeNSMutableDictionary) {
                            _hasCustomContainCls = YES;
                        }
                    }
                }
                break;
            }
            case 'S': {
                if (attrs[i].value) {
                    _setterString = [NSString stringWithUTF8String:attrs[i].value];
                }
                break;
            }
            case 'G': {
                if (attrs[i].value) {
                    _getterString = [NSString stringWithUTF8String:attrs[i].value];
                }
            }
            default:
                break;
            }
        }
        if (attrs) {
            free(attrs);
            attrs = NULL;
        }
        if (_name.length) {
            if (!_setterString) {
                _setterString = [NSString
                    stringWithFormat:@"set%@%@:",
                    [_name substringToIndex:1].uppercaseString,
                    [_name substringFromIndex:1]];
            }
            if (!_getterString) {
                _getterString = _name;
            }
        }
        _setter = NSSelectorFromString(_setterString);
        _getter = NSSelectorFromString(_getterString);
    }
    return self;
}

@end

@implementation ZYClassInfo

- (instancetype)initWithClass:(Class)cls
{
    self = [super init];
    if (self) {
        _propertyInfos = nil;
        NSDictionary* containerPropertyClassMapper =
            [(id<ZYModel>)cls zy_containerPropertyClassMapper];
        unsigned int propertyCount = 0;
        objc_property_t* properties = class_copyPropertyList(cls, &propertyCount);
        if (properties) {
            NSMutableDictionary* propertyInfos = [NSMutableDictionary new];
            _propertyInfos = propertyInfos;
            for (unsigned int i = 0; i < propertyCount; i++) {
                ZYClassPropertyInfo* info =
                    [[ZYClassPropertyInfo alloc] initWithProperty:properties[i]];
                if (info->_name)
                    propertyInfos[info->_name] = info;
                if (info->_hasCustomContainCls) {
                    info->_containCls = containerPropertyClassMapper[info->_name];
                }
            }
            free(properties);
        }
        if (!_propertyInfos)
            _propertyInfos = @{};
    }
    return self;
}

+ (instancetype)classInfoWithClass:(Class)cls
{
    if (!cls)
        return nil;
    static CFMutableDictionaryRef classCache;
    static CFMutableDictionaryRef metaCache;
    static dispatch_once_t onceToken;
    static dispatch_semaphore_t lock;
    dispatch_once(&onceToken, ^{
        classCache = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0,
            &kCFTypeDictionaryKeyCallBacks,
            &kCFTypeDictionaryValueCallBacks);
        metaCache = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0,
            &kCFTypeDictionaryKeyCallBacks,
            &kCFTypeDictionaryValueCallBacks);
        lock = dispatch_semaphore_create(1);
    });
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    ZYClassInfo* info = CFDictionaryGetValue(classCache, (__bridge const void*)(cls));
    dispatch_semaphore_signal(lock);
    if (!info) {
        info = [[ZYClassInfo alloc] initWithClass:cls];
        if (info) {
            dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
            CFDictionarySetValue(classCache, (__bridge const void*)(cls),
                (__bridge const void*)(info));
            dispatch_semaphore_signal(lock);
        }
    }
    return info;
}

@end
