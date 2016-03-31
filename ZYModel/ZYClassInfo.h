//
//  ZYClassStructure.h
//  ZYModel
//
//  Created by sheepliu on 16/3/31.
//  Copyright © 2016年 tzuyangliu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface ZYClassIvar : NSObject
{
    @package
    Ivar _ivar;
    NSString *_name;
}
- (instancetype)initWithIvar:(Ivar)ivar;
@end

@interface ZYClassProperty : NSObject
{
    @package
    objc_property_t _property;
    NSString *_name;
    
    NSString *_setterString;
    SEL _setter;
}
- (instancetype)initWithProperty:(objc_property_t)property;
@end

@interface ZYClassInfo : NSObject
{
    @package
    NSDictionary<NSString*, ZYClassIvar*>* _ivars;
    NSDictionary<NSString*, ZYClassProperty*>* _properties;
}
- (instancetype)initWithClass:(Class) class;
+ (instancetype)classInfoWithClass:(Class) class;
@end
