//
//  ZYModelMeta.h
//  ZYModel
//
//  Created by sheepliu on 16/3/31.
//  Copyright © 2016年 tzuyangliu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZYClassInfo;
@interface ZYModelMeta : NSObject
{
    @package
    ZYClassInfo *_classInfo;
    NSDictionary *_mapper;
}

- (instancetype)initWithClass:(Class)cls;
+ (instancetype)metaWithClass:(Class)cls;

@end
