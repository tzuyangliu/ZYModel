//
//  User.h
//  ZYModel
//
//  Created by sheepliu on 16/3/29.
//  Copyright © 2016年 tzuyangliu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
@property (assign, nonatomic) NSNumber *uid;
@property (strong, nonatomic, setter=setWhatEver:) NSString *name;
@end
