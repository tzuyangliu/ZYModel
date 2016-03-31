//
//  ZYClassInfoCache.h
//  ZYModel
//
//  Created by sheepliu on 16/3/31.
//  Copyright © 2016年 tzuyangliu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYClassInfo.h"

@interface ZYClassInfoCache : NSObject

+ (ZYClassInfo *)classInfoWithClass:(Class)cls;

@end
