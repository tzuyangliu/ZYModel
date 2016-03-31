//
//  ZYClassStructure.m
//  ZYModel
//
//  Created by sheepliu on 16/3/31.
//  Copyright © 2016年 tzuyangliu. All rights reserved.
//

#import "ZYClassInfo.h"
#import "ZYClassInfoCache.h"

@implementation ZYClassIvar

- (instancetype)initWithIvar:(Ivar)ivar
{
    if (!ivar) return nil;
    self = [super init];
    if (self)
    {
        _ivar = ivar;
        const char *name = ivar_getName(ivar);
        if (name)
        {
            _name = [NSString stringWithUTF8String:name];
        }
    }
    return self;
}

@end

@implementation ZYClassProperty

- (instancetype)initWithProperty:(objc_property_t)property
{
    if (!property) return nil;
    self = [super init];
    if (self)
    {
        _property = property;
        const char *name = property_getName(property);
        if (name)
        {
            _name = [NSString stringWithUTF8String:name];
        }
        unsigned int attrCount;
        objc_property_attribute_t *attrs = property_copyAttributeList(property, &attrCount);
        for (unsigned int i = 0; i < attrCount; i++)
        {
            switch (attrs[i].name[0])
            {
                case 'S':
                {
                    if (attrs[i].value)
                    {
                        _setter = NSSelectorFromString([NSString stringWithUTF8String:attrs[i].value]);
                    }
                }
                default: break;
            }
        }
        if (attrs) {
            free(attrs);
            attrs = NULL;
        }
        if (_name.length) {
            if (!_setter) {
                _setter = NSSelectorFromString([NSString stringWithFormat:@"set%@%@:", [_name substringToIndex:1].uppercaseString, [_name substringFromIndex:1]]);
            }
        }
    }
    return self;
}

@end

@implementation ZYClassInfo

- (instancetype)initWithClass:(Class)class
{
    self = [super init];
    if (self)
    {
        _ivars = nil;
        _properties = nil;
        
        unsigned int propertyCount = 0;
        objc_property_t *properties = class_copyPropertyList(class, &propertyCount);
        if (properties) {
            NSMutableDictionary *propertyInfos = [NSMutableDictionary new];
            _properties = propertyInfos;
            for (unsigned int i = 0; i < propertyCount; i++) {
                ZYClassProperty *info = [[ZYClassProperty alloc] initWithProperty:properties[i]];
                if (info.name) propertyInfos[info.name] = info;
            }
            free(properties);
        }
        unsigned int ivarCount = 0;
        Ivar *ivars = class_copyIvarList(class, &ivarCount);
        if (ivars) {
            NSMutableDictionary *ivarInfos = [NSMutableDictionary new];
            _ivars = ivarInfos;
            for (unsigned int i = 0; i < ivarCount; i++) {
                ZYClassIvar *info = [[ZYClassIvar alloc] initWithIvar:ivars[i]];
                if (info.name) ivarInfos[info.name] = info;
            }
            free(ivars);
        }
        
        if (!_ivars) _ivars = @{};
        if (!_properties) _properties = @{};
    }
    return self;
}

+ (instancetype)classInfoWithClass:(Class)class
{
    return [ZYClassInfoCache classInfoWithClass:class];
}

@end
