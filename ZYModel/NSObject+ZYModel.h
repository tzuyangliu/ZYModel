//
//  NSObject+ZYModel.h
//  ZYModel
//
//  Created by sheepliu on 16/3/29.
//  Copyright © 2016年 tzuyangliu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ZYModel <NSObject>
@optional
+ (NSDictionary<NSString*, id>*)mapper;
+ (NSArray *)whitelistProperty;
+ (NSArray *)blacklistProperty;
@end

@interface NSObject (ZYModel)

+ (instancetype)zy_modelWithJSON:(id)json;
+ (instancetype)zy_modelWithDictionary:(NSDictionary*)dictionary;

@end
