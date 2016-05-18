//
//  ModelPerformanceCompareTests.m
//  ModelPerformanceCompareTests
//
//  Created by sheepliu on 4/19/16.
//  Copyright © 2016 Ziyang Liu. All rights reserved.
//

#import <XCTest/XCTest.h>
// ZYModel
#import "ZYModel.h"
#import "YYWeiboModel.h"
// MJExtension
#import "MJExtension.h"
// YYModel
#import "YYModel.h"
// FastEasyMapping
#import "FastEasyMapping.h"
#import "FEWeiboModel.h"
// Mantle
#import "Mantle.h"
#import "MTWeiboModel.h"
// JSONModel
#import "JSONModel.h"
#import "JSWeiboModel.h"

@interface ModelPerformanceCompareTests : XCTestCase
@property (strong, nonatomic) NSDictionary* json;
@property (strong, nonatomic) FEMMapping *fe_mapping;
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
    
    self.fe_mapping = [FEWeiboStatus defaultMapping];
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

- (void)testMantlePerformace
{
    id json = self.json;
    [self measureBlock:^{
        for (NSInteger i = 0; i < kRepeatTimes; i++){
            __unused MTWeiboStatus *weiboStatus = [MTLJSONAdapter modelOfClass:[MTWeiboStatus class] fromJSONDictionary:json error:nil];
        }
    }];
}

- (void)testJSONModelPerformace
{
    id json = self.json;
    [self measureBlock:^{
        for (NSInteger i = 0; i < kRepeatTimes; i++){
            __unused JSWeiboStatus *weiboStatus = [[JSWeiboStatus alloc]initWithDictionary:json error:nil];
        }
    }];
}

- (void)testFastEasyMappingPerformace
{
    id json = self.json;
    id mapping = self.fe_mapping;
    [self measureBlock:^{
        for (NSInteger i = 0; i < kRepeatTimes; i++){
            FEWeiboStatus *weibo = [FEWeiboStatus new];
            [FEMDeserializer fillObject:weibo fromRepresentation:json mapping:mapping];
        }
    }];
}

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
    // 这货没解析NSDate，强行让它解析
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
