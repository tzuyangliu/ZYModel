//
//  ZYModelPerformaceTest.m
//  ModelPerformanceCompare
//
//  Created by 刘子洋 on 16/5/22.
//  Copyright © 2016年 Ziyang Liu. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ZYModel.h"
#import "YYWeiboModel.h"

@interface ZYModelPerformaceTest : XCTestCase
@property (strong, nonatomic) NSDictionary* json;
@end

@implementation ZYModelPerformaceTest

- (void)setUp {
    [super setUp];
    NSError* error = nil;
    NSString* filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"weibo"
                                                                          ofType:@"json"];
    NSData* dataFromFile = [NSData dataWithContentsOfFile:filePath];
    NSDictionary* data = [NSJSONSerialization JSONObjectWithData:dataFromFile
                                                         options:kNilOptions
                                                           error:&error];
    self.json = data;
}

- (void)tearDown {
    [super tearDown];
}

static const NSUInteger kRepeatTimes = 1000;

- (void)testJSONToModelPerformance {
    id json = self.json;
    [self measureBlock:^{
        for (NSInteger i = 0; i < kRepeatTimes; i++){
            __unused YYWeiboStatus *weiboStatus = [YYWeiboStatus zy_modelWithJson:json];
        }
    }];
}

- (void)testModelToJSONPerformance {
    id json = self.json;
    YYWeiboStatus *weiboStatus = [YYWeiboStatus zy_modelWithJson:json];
    [self measureBlock:^{
        for (NSInteger i = 0; i < kRepeatTimes; i++){
            __unused id json = [weiboStatus zy_modelJson];
        }
    }];
}

@end
