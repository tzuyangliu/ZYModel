//
//  ZYClassInfo.m
//  ZYModel
//
//  Created by 刘子洋 on 16/3/31.
//  Copyright © 2016年 刘子洋. All rights reserved.
//

#import "ZYClassInfo.h"
#import "NSObject+ZYModel.h"

static __inline__ __attribute__((always_inline)) ZYEncodingNSType ZYClassGetNSType(Class cls) {
    if (!cls) return ZYEncodingTypeNSUnknown;
    if ([cls isSubclassOfClass:[NSMutableString class]]) return ZYEncodingTypeNSMutableString;
    if ([cls isSubclassOfClass:[NSString class]]) return ZYEncodingTypeNSString;
    if ([cls isSubclassOfClass:[NSDecimalNumber class]]) return ZYEncodingTypeNSDecimalNumber;
    if ([cls isSubclassOfClass:[NSNumber class]]) return ZYEncodingTypeNSNumber;
    if ([cls isSubclassOfClass:[NSValue class]]) return ZYEncodingTypeNSValue;
    if ([cls isSubclassOfClass:[NSMutableData class]]) return ZYEncodingTypeNSMutableData;
    if ([cls isSubclassOfClass:[NSData class]]) return ZYEncodingTypeNSData;
    if ([cls isSubclassOfClass:[NSDate class]]) return ZYEncodingTypeNSDate;
    if ([cls isSubclassOfClass:[NSURL class]]) return ZYEncodingTypeNSURL;
    if ([cls isSubclassOfClass:[NSMutableArray class]]) return ZYEncodingTypeNSMutableArray;
    if ([cls isSubclassOfClass:[NSArray class]]) return ZYEncodingTypeNSArray;
    if ([cls isSubclassOfClass:[NSMutableDictionary class]]) return ZYEncodingTypeNSMutableDictionary;
    if ([cls isSubclassOfClass:[NSDictionary class]]) return ZYEncodingTypeNSDictionary;
    if ([cls isSubclassOfClass:[NSMutableSet class]]) return ZYEncodingTypeNSMutableSet;
    if ([cls isSubclassOfClass:[NSSet class]]) return ZYEncodingTypeNSSet;
    return ZYEncodingTypeNSUnknown;
}

static __inline__ __attribute__((always_inline)) BOOL ZYEncodingGetIsCNumber(ZYEncodingType encodingType)
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
        case ZYEncodingTypeLongDouble:return YES;
        default: return NO;
    }
}

static __inline__ __attribute__((always_inline)) ZYEncodingType ZYEncodingGetType(const char *typeEncoding) {
    char *type = (char *)typeEncoding;
    if (!type) return ZYEncodingTypeUnknown;
    size_t len = strlen(type);
    if (len == 0) return ZYEncodingTypeUnknown;
    
    ZYEncodingType qualifier = 0;
    bool prefix = true;
    while (prefix) {
        switch (*type) {
            case 'r': {
                qualifier |= ZYEncodingTypeQualifierConst;
                type++;
            } break;
            case 'n': {
                qualifier |= ZYEncodingTypeQualifierIn;
                type++;
            } break;
            case 'N': {
                qualifier |= ZYEncodingTypeQualifierInout;
                type++;
            } break;
            case 'o': {
                qualifier |= ZYEncodingTypeQualifierOut;
                type++;
            } break;
            case 'O': {
                qualifier |= ZYEncodingTypeQualifierBycopy;
                type++;
            } break;
            case 'R': {
                qualifier |= ZYEncodingTypeQualifierByref;
                type++;
            } break;
            case 'V': {
                qualifier |= ZYEncodingTypeQualifierOneway;
                type++;
            } break;
            default: { prefix = false; } break;
        }
    }
    
    len = strlen(type);
    if (len == 0) return ZYEncodingTypeUnknown | qualifier;
    
    switch (*type) {
        case 'v': return ZYEncodingTypeVoid | qualifier;
        case 'B': return ZYEncodingTypeBool | qualifier;
        case 'c': return ZYEncodingTypeInt8 | qualifier;
        case 'C': return ZYEncodingTypeUInt8 | qualifier;
        case 's': return ZYEncodingTypeInt16 | qualifier;
        case 'S': return ZYEncodingTypeUInt16 | qualifier;
        case 'i': return ZYEncodingTypeInt32 | qualifier;
        case 'I': return ZYEncodingTypeUInt32 | qualifier;
        case 'l': return ZYEncodingTypeInt32 | qualifier;
        case 'L': return ZYEncodingTypeUInt32 | qualifier;
        case 'q': return ZYEncodingTypeInt64 | qualifier;
        case 'Q': return ZYEncodingTypeUInt64 | qualifier;
        case 'f': return ZYEncodingTypeFloat | qualifier;
        case 'd': return ZYEncodingTypeDouble | qualifier;
        case 'D': return ZYEncodingTypeLongDouble | qualifier;
        case '#': return ZYEncodingTypeClass | qualifier;
        case ':': return ZYEncodingTypeSEL | qualifier;
        case '*': return ZYEncodingTypeCString | qualifier;
        case '^': return ZYEncodingTypePointer | qualifier;
        case '[': return ZYEncodingTypeCArray | qualifier;
        case '(': return ZYEncodingTypeUnion | qualifier;
        case '{': return ZYEncodingTypeStruct | qualifier;
        case '@': {
            if (len == 2 && *(type + 1) == '?')
                return ZYEncodingTypeBlock | qualifier;
            else
                return ZYEncodingTypeObject | qualifier;
        }
        default: return ZYEncodingTypeUnknown | qualifier;
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
        for (unsigned int i = 0; i < attrCount; i++)
        {
            switch (attrs[i].name[0])
            {
                case 'T':
                {
                    if (attrs[i].value)
                    {
                        _typeEncoding = [NSString stringWithUTF8String:attrs[i].value];
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
                        if ((_type & ZYEncodingTypeMask) == ZYEncodingTypeObject)
                        {
                            _nsType = ZYClassGetNSType(_cls);
                            if (_nsType == ZYEncodingTypeNSSet
                                ||_nsType == ZYEncodingTypeNSMutableSet
                                ||_nsType == ZYEncodingTypeNSArray
                                || _nsType == ZYEncodingTypeNSMutableArray
                                || _nsType == ZYEncodingTypeNSDictionary
                                || _nsType == ZYEncodingTypeNSMutableDictionary)
                            {
                                _hasCustomContainCls = YES;
                            }
                        }
                    }
                    break;
                }
                case 'S':
                {
                    if (attrs[i].value)
                    {
                        _setterString = [NSString stringWithUTF8String:attrs[i].value];
                    }
                    break;
                    
                }
                case 'G':
                {
                    if (attrs[i].value)
                    {
                        _getterString = [NSString stringWithUTF8String:attrs[i].value];
                    }
                }
                default:
                    break;
            }
        }
        if (attrs)
        {
            free(attrs);
            attrs = NULL;
        }
        if (_name.length) {
            if (!_setterString)
            {
                _setterString = [NSString stringWithFormat:@"set%@%@:", [_name substringToIndex:1].uppercaseString, [_name substringFromIndex:1]];
            }
            if (!_getterString)
            {
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
        _properties = nil;
        NSDictionary *modelContainerPropertyGenericClassMap = [(id<ZYModel>)cls zy_containerPropertyClassMapper];
        unsigned int propertyCount = 0;
        objc_property_t* properties = class_copyPropertyList(cls, &propertyCount);
        if (properties) {
            NSMutableDictionary* propertyInfos = [NSMutableDictionary new];
            _properties = propertyInfos;
            for (unsigned int i = 0; i < propertyCount; i++) {
                ZYClassPropertyInfo* info = [[ZYClassPropertyInfo alloc] initWithProperty:properties[i]];
                if (info->_name)
                    propertyInfos[info->_name] = info;
                if (info->_hasCustomContainCls)
                {
                    info->_containCls = modelContainerPropertyGenericClassMap[info->_name];
                }
            }
            free(properties);
        }
        if (!_properties)
            _properties = @{};
    }
    return self;
}

+ (instancetype)classInfoWithClass : (Class)cls
{
    if (!cls)
        return nil;
    static CFMutableDictionaryRef classCache;
    static CFMutableDictionaryRef metaCache;
    static dispatch_once_t onceToken;
    static dispatch_semaphore_t lock;
    dispatch_once(&onceToken, ^{
        classCache = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        metaCache = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        lock = dispatch_semaphore_create(1);
    });
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    ZYClassInfo* info = CFDictionaryGetValue(classCache, (__bridge const void*)(cls));
    dispatch_semaphore_signal(lock);
    if (!info) {
        info = [[ZYClassInfo alloc] initWithClass:cls];
        if (info) {
            dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
            CFDictionarySetValue(classCache, (__bridge const void*)(cls), (__bridge const void*)(info));
            dispatch_semaphore_signal(lock);
        }
    }
    return info;
}

@end
