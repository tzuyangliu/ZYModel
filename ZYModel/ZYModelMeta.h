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
@interface ZYModelMeta : NSObject
{
    @package
    ZYClassInfo *_classInfo;
    NSDictionary<NSString *, ZYClassProperty *> *_jsonKeyToSetterMapper;
}

- (instancetype)initWithClass:(Class)cls;
+ (instancetype)metaWithClass:(Class)cls;

@end
