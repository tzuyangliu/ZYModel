//
//  ZYModelMeta.h
//  ZYModel
//
//  Created by sheepliu on 16/3/31.
//  Copyright © 2016年 tzuyangliu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZYClassInfo;
@class ZYClassPropertyInfo;

@interface ZYModelPropertyTransformInfo : NSObject
{
    @package
    ZYClassPropertyInfo *_classProperty;
    NSString *_jsonKey;
}

- (instancetype)initWithClassPropertyInfo:(ZYClassPropertyInfo *)classProperty jsonKey:(NSString *)jsonKey;

@end

@interface ZYModelTransformInfo : NSObject
{
    @package
    ZYClassInfo *_classInfo;
    NSDictionary<NSString *, NSString *> *_mapper;
    NSDictionary<NSString *, Class> *_modelContainerPropertyGenericClassMap;
    
    NSMutableArray<ZYModelPropertyTransformInfo *> *_propertyMetas;
}

- (instancetype)initWithClass:(Class)cls;
+ (instancetype)metaWithClass:(Class)cls;

@end
