//
//  DemoClass.m
//  ZYModel
//
//  Created by sheepliu on 4/21/16.
//  Copyright © 2016 tzuyangliu. All rights reserved.
//

#import "DemoClass.h"

@implementation DemoContainerClass

+ (NSDictionary *)zy_propertyToJsonKeyMapper
{
    return @{@"name": @"name",};
}

@end

@implementation DemoClass

+ (NSDictionary *)zy_propertyToJsonKeyMapper
{
    return @{
             @"cBoolTrue": @"c_bool_true",
             @"cBoolFalse": @"c_bool_false",
             @"ocBoolTrue": @"oc_bool_true",
             @"ocBoolFalse": @"oc_bool_false",
             @"int8": @"int8",
             @"uint8": @"uint8",
             @"int16": @"int16",
             @"uint16": @"uint16",
             @"int32": @"int32",
             @"uint32": @"uint32",
             @"int64": @"int64",
             @"uint64": @"uint64",
             @"floatValue": @"c_float",
             @"doubleValue": @"c_double",
             @"longDoubleValue": @"c_long_double",
             @"nsDate": @"ns_date",
             @"nsNumber": @"ns_number",
             @"nsValue": @"ns_value",
             @"nsData": @"ns_data",
             @"nsMutableData": @"ns_mutable_data",
             @"nsString": @"ns_string",
             @"nsMutableString": @"ns_mutable_string",
             @"nsSet": @"ns_set",
             @"nsMutableSet": @"ns_mutable_set",
             @"nsDemoClassSet": @"ns_democlass_set",
             @"nsArray": @"ns_array",
             @"nsMutableArray": @"ns_mutable_array",
             @"nsDemoClassArray": @"ns_democlass_array",
             @"nsDictionary": @"ns_dictionary",
             @"nsMutableDictionary": @"ns_mutable_dictionary",
             @"nsDemoClassDictionary": @"ns_democlass_dictionary",
             @"customClass": @"custom_class",
             };
}

+ (NSDictionary *)zy_containerPropertyClassMapper {
    return @{
             @"nsSet" : [NSNumber class],
             @"nsMutableSet": [NSNumber class],
             @"nsDemoClassSet" : [DemoContainerClass class],
             @"nsArray" : [NSNumber class],
             @"nsMutableArray": [NSNumber class],
             @"nsDemoClassArray" : [DemoContainerClass class],
             @"nsDictionary" : [NSNumber class],
             @"nsMutableDictionary": [NSNumber class],
             @"nsDemoClassDictionary" : [DemoContainerClass class],
             };
}

@end

@implementation InheritClass
@end
