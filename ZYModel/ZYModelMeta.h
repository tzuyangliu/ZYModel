//
//  ZYModelMeta.h
//  ZYModel
//
//  Created by sheepliu on 16/3/31.
//  Copyright © 2016年 tzuyangliu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZYClassInfo;
@class ZYClassProperty;

@interface ZYModelPropertyMeta : NSObject
{
    @package
    ZYClassProperty *_classProperty;
    NSString *_jsonKey;
}

- (instancetype)initWithClassProperty:(ZYClassProperty *)classProperty jsonKey:(NSString *)jsonKey;

@end

@interface ZYModelMeta : NSObject
{
    @package
    ZYClassInfo *_classInfo;
    NSDictionary<NSString *, NSString *> *_mapper;
    NSDictionary<NSString *, Class> *_modelContainerPropertyGenericClassMap;
    
    NSMutableArray<ZYModelPropertyMeta *> *_propertyMetas;
}

- (instancetype)initWithClass:(Class)cls;
+ (instancetype)metaWithClass:(Class)cls;

@end
