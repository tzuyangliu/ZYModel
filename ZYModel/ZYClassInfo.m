//
//  ZYClassInfo.m
//  ZYModel
//
//  Created by 刘子洋 on 16/3/31.
//  Copyright © 2016年 刘子洋. All rights reserved.
//

#import "NSObject+ZYModel.h"
#import "ZYClassInfo.h"
NS_INLINE BOOL ZYTypeGetHasContainClass(ZYType type){
    switch (type) {
        case ZYTypeNSSet:
        case ZYTypeNSMutableSet:
        case ZYTypeNSArray:
        case ZYTypeNSMutableArray:
        case ZYTypeNSDictionary:
        case ZYTypeNSMutableDictionary:
            return YES;
        default:
            return NO;
    }
}
NS_INLINE BOOL ZYTypeGetIsCNumber(ZYType type)
{
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
NS_INLINE Class ZYTypeGetClass(const char* typeEncoding){
    size_t len = strlen(typeEncoding);
    if (len > 3) {
        char name[len - 2];
        name[len - 3] = '\0';
        memcpy(name, typeEncoding + 2, len - 3);
        return objc_getClass(name);
    }
    return nil;
}
NS_INLINE ZYType ZYClassGetType(const char* typeEncoding){
    char* type = (char*)typeEncoding;
    if (!type) return ZYTypeUnknown;
    size_t len = strlen(type);
    if (len == 0) return ZYTypeUnknown;
    len = strlen(type);
    if (len == 0) return ZYTypeUnknown;
    switch (*type) {
        case 'B':
            return ZYTypeBool;
        case 'c':
            return ZYTypeInt8;
        case 'C':
            return ZYTypeUInt8;
        case 's':
            return ZYTypeInt16;
        case 'S':
            return ZYTypeUInt16;
        case 'i':
            return ZYTypeInt32;
        case 'I':
            return ZYTypeUInt32;
        case 'l':
            return ZYTypeInt32;
        case 'L':
            return ZYTypeUInt32;
        case 'q':
            return ZYTypeInt64;
        case 'Q':
            return ZYTypeUInt64;
        case 'f':
            return ZYTypeFloat;
        case 'd':
            return ZYTypeDouble;
        case 'D':
            return ZYTypeLongDouble;
        case '@': {
            if (!(len == 2 && *(type + 1) == '?')){
                Class cls = ZYTypeGetClass(typeEncoding);
                if (!cls) return ZYTypeNSUnknown;
                if ([cls isSubclassOfClass:[NSMutableString class]])
                    return ZYTypeNSMutableString;
                if ([cls isSubclassOfClass:[NSString class]])
                    return ZYTypeNSString;
                if ([cls isSubclassOfClass:[NSDecimalNumber class]])
                    return ZYTypeNSDecimalNumber;
                if ([cls isSubclassOfClass:[NSNumber class]])
                    return ZYTypeNSNumber;
                if ([cls isSubclassOfClass:[NSValue class]])
                    return ZYTypeNSValue;
                if ([cls isSubclassOfClass:[NSMutableData class]])
                    return ZYTypeNSMutableData;
                if ([cls isSubclassOfClass:[NSData class]])
                    return ZYTypeNSData;
                if ([cls isSubclassOfClass:[NSDate class]])
                    return ZYTypeNSDate;
                if ([cls isSubclassOfClass:[NSURL class]])
                    return ZYTypeNSURL;
                if ([cls isSubclassOfClass:[NSMutableArray class]])
                    return ZYTypeNSMutableArray;
                if ([cls isSubclassOfClass:[NSArray class]])
                    return ZYTypeNSArray;
                if ([cls isSubclassOfClass:[NSMutableDictionary class]])
                    return ZYTypeNSMutableDictionary;
                if ([cls isSubclassOfClass:[NSDictionary class]])
                    return ZYTypeNSDictionary;
                if ([cls isSubclassOfClass:[NSMutableSet class]])
                    return ZYTypeNSMutableSet;
                if ([cls isSubclassOfClass:[NSSet class]])
                    return ZYTypeNSSet;
                return ZYTypeNSUnknown;
            }
        }
        default:
            return ZYTypeUnknown;
    }
}
@implementation ZYClassPropertyInfo
- (instancetype)initWithProperty:(objc_property_t)property
{
    if (!property) return nil;
    self = [super init];
    if (self) {
        _property = property;
        const char* name = property_getName(property);
        if (name) {
            _name = [NSString stringWithUTF8String:name];
        }
        unsigned int attrCount;
        NSString *setterString = nil;
        NSString *getterString = nil;
        objc_property_attribute_t* attrs = property_copyAttributeList(property, &attrCount);
        for (unsigned int i = 0; i < attrCount; i++) {
            switch (attrs[i].name[0]) {
            case 'T': {
                if (attrs[i].value) {
                    _type = ZYClassGetType(attrs[i].value);
                    _cls = ZYTypeGetClass(attrs[i].value);
                    _isCNumber = ZYTypeGetIsCNumber(_type);
                    _isContainerClass = ZYTypeGetHasContainClass(_type);
                }
                break;
            }
            case 'S': {
                if (attrs[i].value) {
                    setterString = [NSString stringWithUTF8String:attrs[i].value];
                }
                break;
            }
            case 'G': {
                if (attrs[i].value) {
                    getterString = [NSString stringWithUTF8String:attrs[i].value];
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
            if (!setterString) {
                setterString = [NSString
                    stringWithFormat:@"set%@%@:",
                    [_name substringToIndex:1].uppercaseString,
                    [_name substringFromIndex:1]];
            }
            if (!getterString) {
                getterString = _name;
            }
        }
        _setter = NSSelectorFromString(setterString);
        _getter = NSSelectorFromString(getterString);
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
                if (info->_isContainerClass) {
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
    if (!cls) return nil;
    static CFMutableDictionaryRef classCache;
    static dispatch_once_t onceToken;
    static dispatch_semaphore_t lock;
    dispatch_once(&onceToken, ^{
        classCache = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0,
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