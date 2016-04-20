//
//  ModelPerformanceCompareTests.m
//  ModelPerformanceCompareTests
//
//  Created by sheepliu on 4/19/16.
//  Copyright © 2016 Ziyang Liu. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YYModel.h"
#import "ZYModel.h"
#import "MJExtension.h"
#import "YYWeiboModel.h"

@interface ModelPerformanceCompareTests : XCTestCase
@property (strong, nonatomic) NSDictionary* json;
@end

@implementation ModelPerformanceCompareTests

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
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
//    YYWeiboStatus *weiboStatus = [YYWeiboStatus mj_objectWithKeyValues:self.json];
//    NSLog(@"%@", weiboStatus.createdAt);
}

static const NSUInteger kRepeatTimes = 1000;

- (void)testYYModelPerformace
{
    id json = self.json;
    [self measureBlock:^{
        for (NSInteger i = 0; i < kRepeatTimes; i++){
            __unused YYWeiboStatus *weiboStatus = [YYWeiboStatus yy_modelWithJSON:json];
        }
    }];
}

- (void)testMJExtensionPerformace
{
    id json = self.json;
    [self measureBlock:^{
        for (NSInteger i = 0; i < kRepeatTimes; i++){
            __unused YYWeiboStatus *weiboStatus = [YYWeiboStatus mj_objectWithKeyValues:json];
        }
    }];
}

- (void)testZYModelPerformance
{
    id json = self.json;
    [self measureBlock:^{
        for (NSInteger i = 0; i < kRepeatTimes; i++){
            __unused YYWeiboStatus *weiboStatus = [YYWeiboStatus zy_modelWithJson:json];
        }
    }];
}

@end
