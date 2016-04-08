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
+ (NSArray *)whitelistProperties;
+ (NSArray *)blacklistProperties;
+ (NSDictionary<NSString *, Class> *)modelContainerPropertyGenericClass;
@end

@interface NSObject (ZYModel)

- (void)zy_setPropertiesWithJSON:(id)json;
- (void)zy_setPropertiesWithDictionary:(NSDictionary*)dictionary;

+ (instancetype)zy_modelWithJSON:(id)json;
+ (instancetype)zy_modelWithDictionary:(NSDictionary*)dictionary;

+ (NSArray *)zy_modelArrayWithJSON:(id)json;
//+ (NSArray *)zy_modelArrayWithDictionaryArray:(NSArray<NSDictionary *> *)array;

@end
