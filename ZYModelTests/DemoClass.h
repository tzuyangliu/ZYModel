//
//  DemoClass.h
//  ZYModel
//
//  Created by sheepliu on 4/21/16.
//  Copyright © 2016 tzuyangliu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DemoContainerClass : NSObject
@property (strong, nonatomic) NSString *name;
@end

@interface DemoClass : NSObject
// CNumber
@property (assign, nonatomic) bool cBoolTrue;
@property (assign, nonatomic) bool cBoolFalse;
@property (assign, nonatomic) BOOL ocBoolTrue;
@property (assign, nonatomic) BOOL ocBoolFalse;
@property (assign, nonatomic) int8_t int8;
@property (assign, nonatomic) uint8_t uint8;
@property (assign, nonatomic) int16_t int16;
@property (assign, nonatomic) uint16_t uint16;
@property (assign, nonatomic) int32_t int32;
@property (assign, nonatomic) uint32_t uint32;
@property (assign, nonatomic) int64_t int64;
@property (assign, nonatomic) uint64_t uint64;
@property (assign, nonatomic) float floatValue;
@property (assign, nonatomic) double doubleValue;
@property (assign, nonatomic) long double longDoubleValue;
// NS-
@property (strong, nonatomic) NSDate *nsDate;
@property (strong, nonatomic) NSValue *nsValue;
@property (strong, nonatomic) NSNumber *nsNumber;
@property (strong, nonatomic) NSData *nsData;
@property (strong, nonatomic) NSData *nsMutableData;
@property (strong, nonatomic) NSString *nsString;
@property (strong, nonatomic) NSString *nsMutableString;
// NSSet
@property (strong, nonatomic) NSSet<NSNumber *> *nsSet;
@property (strong, nonatomic) NSMutableSet<NSNumber *> *nsMutableSet;
@property (strong, nonatomic) NSSet<DemoContainerClass *> *nsDemoClassSet;
// NSArray
@property (strong, nonatomic) NSArray<NSNumber *> *nsArray;
@property (strong, nonatomic) NSMutableArray<NSNumber *> *nsMutableArray;
@property (strong, nonatomic) NSArray<DemoContainerClass *> *nsDemoClassArray;
// NSDictionary
@property (strong, nonatomic) NSDictionary<NSString *, NSNumber *> *nsDictionary;
@property (strong, nonatomic) NSMutableDictionary<NSString *, NSNumber *> *nsMutableDictionary;
@property (strong, nonatomic) NSDictionary<NSString *, DemoContainerClass *> *nsDemoClassDictionary;
// Property With Custom Class
@property (strong, nonatomic) DemoContainerClass *customClass;
// Auto Mapping
@property (strong, nonatomic) NSString *autoMappingString;
@end


@interface InheritClass : DemoClass
@end
