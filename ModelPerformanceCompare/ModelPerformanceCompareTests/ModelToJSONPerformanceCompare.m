//
//  ModelToJSONPerformanceCompare.m
//  ModelPerformanceCompare
//
//  Created by 刘子洋 on 16/5/23.
//  Copyright © 2016年 Ziyang Liu. All rights reserved.
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
@interface ModelToJSONPerformanceCompare : XCTestCase
@property (strong, nonatomic) NSDictionary* json;
@property (strong, nonatomic) FEMMapping *fe_mapping;
@end
@implementation ModelToJSONPerformanceCompare
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
    [super tearDown];
}
static const NSUInteger kRepeatTimes = 1000;
- (void)testMantlePerformace
{
    id json = self.json;
    MTWeiboStatus *weiboStatus = [MTLJSONAdapter modelOfClass:[MTWeiboStatus class] fromJSONDictionary:json error:nil];
    [self measureBlock:^{
        for (NSInteger i = 0; i < kRepeatTimes; i++){
            __unused id json = [MTLJSONAdapter JSONDictionaryFromModel:weiboStatus error:nil];
        }
    }];
}
- (void)testJSONModelPerformace
{
    id json = self.json;
    JSWeiboStatus *weiboStatus = [[JSWeiboStatus alloc]initWithDictionary:json error:nil];
    [self measureBlock:^{
        for (NSInteger i = 0; i < kRepeatTimes; i++){
            __unused id json = [weiboStatus toDictionary];
        }
    }];
}
- (void)testFastEasyMappingPerformace
{
    id json = self.json;
    id mapping = self.fe_mapping;
    FEWeiboStatus *weibo = [FEWeiboStatus new];
    [FEMDeserializer fillObject:weibo fromRepresentation:json mapping:mapping];
    [self measureBlock:^{
        for (NSInteger i = 0; i < kRepeatTimes; i++){
            __unused id json = [FEMSerializer serializeObject:weibo usingMapping:mapping];
        }
    }];
}
- (void)testYYModelPerformace
{
    id json = self.json;
    YYWeiboStatus *weiboStatus = [YYWeiboStatus yy_modelWithJSON:json];
    [self measureBlock:^{
        for (NSInteger i = 0; i < kRepeatTimes; i++){
            __unused id json = [weiboStatus yy_modelToJSONObject];
        }
    }];
}
- (void)testMJExtensionPerformace
{
    id json = self.json;
    YYWeiboStatus *weiboStatus = [YYWeiboStatus mj_objectWithKeyValues:json];
    [self measureBlock:^{
        for (NSInteger i = 0; i < kRepeatTimes; i++){
            __unused id json = [weiboStatus mj_JSONObject];
        }
    }];
}
- (void)testZYModelPerformance
{
    id json = self.json;
    YYWeiboStatus *weiboStatus = [YYWeiboStatus zy_modelWithJson:json];
    [self measureBlock:^{
        for (NSInteger i = 0; i < kRepeatTimes; i++){
            __unused id json = [weiboStatus zy_modelJson];
        }
    }];
}
@end