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
@property (assign, nonatomic) Ivar ivar;
@property (strong, nonatomic) NSString* name;

- (instancetype)initWithIvar:(Ivar)ivar;

@end

@interface ZYClassProperty : NSObject
@property (assign, nonatomic) objc_property_t property ;
@property (strong, nonatomic) NSString* name;

@property (assign, nonatomic) SEL setter;

- (instancetype)initWithProperty:(objc_property_t)property;

@end

@interface ZYClassInfo : NSObject
@property (strong, nonatomic) NSDictionary<NSString*, ZYClassIvar*>* ivars;
@property (strong, nonatomic) NSDictionary<NSString*, ZYClassProperty*>* properties;

- (instancetype)initWithClass:(Class) class;
+ (instancetype)classInfoWithClass:(Class) class;

@end
