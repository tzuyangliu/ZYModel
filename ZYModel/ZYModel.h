//
//  ZYModel.h
//  ZYModel
//
//  Created by 刘子洋 on 16/3/29.
//  Copyright © 2016年 刘子洋. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __has_include(<ZYModel / ZYModel.h>)
FOUNDATION_EXPORT double ZYModelVersionNumber;
FOUNDATION_EXPORT const unsigned char ZYModelVersionString[];
#import <ZYModel/NSObject+ZYModel.h>
#else
#import "NSObject+ZYModel.h"
#endif
