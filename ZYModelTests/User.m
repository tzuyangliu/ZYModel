//
//  User.m
//  ZYModel
//
//  Created by sheepliu on 16/3/29.
//  Copyright © 2016年 tzuyangliu. All rights reserved.
//

#import "User.h"
#import "NSObject+ZYModel.h"

@implementation User

+ (NSDictionary *)mapper
{
    return @{@"name": @"user_name",
             @"uid": @"user_uid",
             @"gender": @"user_gender",
             @"address": @"user_address",
             };
}

- (NSString *)description
{
    NSMutableString *result = [NSMutableString string];
    [result appendString:NSStringFromClass([self class])];
    [result appendString:@" {"];
    
    [result appendString:[NSString stringWithFormat:@"\nuid: %@", self.uid]];
    [result appendString:[NSString stringWithFormat:@"\nname: %@", self.name]];
    [result appendString:[NSString stringWithFormat:@"\ngender: %@", self.gender]];
    [result appendString:[NSString stringWithFormat:@"\naddress: %@", self.address]];
    
    [result appendString:@"\n}"];
    return result;
}

@end
