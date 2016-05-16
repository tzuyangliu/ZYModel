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
+ (NSDictionary<NSString*, id>*)zy_propertyToJsonKeyMapper;
+ (NSArray *)zy_whitelistProperties;
+ (NSArray *)zy_blacklistProperties;
+ (NSDictionary<NSString *, Class> *)zy_containerPropertyClassMapper;
@end

@interface NSObject (ZYModel)

- (void)zy_setPropertiesWithJson:(id)json;
- (void)zy_setPropertiesWithDictionary:(NSDictionary*)dictionary;

+ (instancetype)zy_modelWithJson:(id)json;
+ (instancetype)zy_modelWithDictionary:(NSDictionary*)dictionary;

- (NSDictionary *)zy_modelJson;

+ (NSArray *)zy_modelArrayWithJson:(id)json;

@end
