//
//  ZYModel.h
//  ZYModel
//
//  Created by sheepliu on 16/3/29.
//  Copyright © 2016年 tzuyangliu. All rights reserved.
//

/**
 
 ---支持的类型---
 
 NSObject 及其子类
 NSDate
 NSValue
 NSNumber ?还未支持 NSString -> NSNumber
 NSDecimalNumber ?同上
 NSData
 NSMutableData
 NSString
 NSMutableString
 NSSet
 NSMutableSet
 NSArray<T>
 NSMutableArray<T>
 NSDictionary<T,T>
 NSMutableDictionary<T,T>
 
 ---C系数值---
 
 bool
 int8_t __signed char
 uint8_t unsigned char
 int16_t short
 uint16_t unsigned short
 int32_t int
 uint32_t unsigned int
 int64_t long long
 uint64_t unsigned long long
 
 float
 double
 long double
 
 ---优化---
 
 class info / model meta cache
 IMP cache ?
 stack variables ?
 high performance lock
 runtime method
 force_inline
 c function
 low-level api (core foundation)
 efficency coding
 
 */

#import <Foundation/Foundation.h>

#if __has_include(<ZYModel / ZYModel.h>)
FOUNDATION_EXPORT double ZYModelVersionNumber;
FOUNDATION_EXPORT const unsigned char ZYModelVersionString[];
#import <ZYModel/NSObject+ZYModel.h>
#else
#import "NSObject+ZYModel.h"
#endif
