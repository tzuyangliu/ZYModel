//
//  User.h
//  ZYModel
//
//  Created by sheepliu on 16/3/29.
//  Copyright © 2016年 tzuyangliu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Father;
@interface User : NSObject
@property (assign, nonatomic) NSNumber *uid;
@property (strong, nonatomic, setter=setWhatEver:) NSString *name;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) Father *father;
@end

@interface Father : User
@end
