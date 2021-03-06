//
//  JSONToModelPerformanceCompare.m
//  JSONToModelPerformanceCompare
//
//  Created by 刘子洋 on 4/19/16.
//  Copyright © 2016 刘子洋. All rights reserved.
//

#import <XCTest/XCTest.h>
// ZYModel
#import "YYWeiboModel.h"
#import "ZYModel.h"
// MJExtension
#import "MJExtension.h"
// YYModel
#import "YYModel.h"
// FastEasyMapping
#import "FEWeiboModel.h"
#import "FastEasyMapping.h"
// Mantle
#import "MTWeiboModel.h"
#import "Mantle.h"
// JSONModel
#import "JSONModel.h"
#import "JSWeiboModel.h"
@interface JSONToModelPerformanceCompare : XCTestCase
@property(strong, nonatomic) NSDictionary *json;
@property(strong, nonatomic) FEMMapping *fe_mapping;
@end
@implementation JSONToModelPerformanceCompare
- (void)setUp {
  [super setUp];
  NSError *error = nil;
  NSString *filePath =
      [[NSBundle bundleForClass:[self class]] pathForResource:@"weibo"
                                                       ofType:@"json"];
  NSData *dataFromFile = [NSData dataWithContentsOfFile:filePath];
  NSDictionary *data = [NSJSONSerialization JSONObjectWithData:dataFromFile
                                                       options:kNilOptions
                                                         error:&error];
  self.json = data;

  self.fe_mapping = [FEWeiboStatus defaultMapping];
}
- (void)tearDown {
  [super tearDown];
}
static const NSUInteger kRepeatTimes = 1000;
- (void)testMantlePerformace {
  id json = self.json;
  [self measureBlock:^{
    for (NSInteger i = 0; i < kRepeatTimes; i++) {
      __unused MTWeiboStatus *weiboStatus =
          [MTLJSONAdapter modelOfClass:[MTWeiboStatus class]
                    fromJSONDictionary:json
                                 error:nil];
    }
  }];
}
- (void)testJSONModelPerformace {
  id json = self.json;
  [self measureBlock:^{
    for (NSInteger i = 0; i < kRepeatTimes; i++) {
      __unused JSWeiboStatus *weiboStatus =
          [[JSWeiboStatus alloc] initWithDictionary:json error:nil];
    }
  }];
}
- (void)testFastEasyMappingPerformace {
  id json = self.json;
  id mapping = self.fe_mapping;
  [self measureBlock:^{
    for (NSInteger i = 0; i < kRepeatTimes; i++) {
      FEWeiboStatus *weibo = [FEWeiboStatus new];
      [FEMDeserializer fillObject:weibo
               fromRepresentation:json
                          mapping:mapping];
    }
  }];
}
- (void)testYYModelPerformace {
  id json = self.json;
  [self measureBlock:^{
    for (NSInteger i = 0; i < kRepeatTimes; i++) {
      __unused YYWeiboStatus *weiboStatus =
          [YYWeiboStatus yy_modelWithJSON:json];
    }
  }];
}
- (void)testMJExtensionPerformace {
  id json = self.json;
  [self measureBlock:^{
    for (NSInteger i = 0; i < kRepeatTimes; i++) {
      __unused YYWeiboStatus *weiboStatus =
          [YYWeiboStatus mj_objectWithKeyValues:json];
    }
  }];
}
- (void)testZYModelPerformance {
  id json = self.json;
  [self measureBlock:^{
    for (NSInteger i = 0; i < kRepeatTimes; i++) {
      __unused YYWeiboStatus *weiboStatus =
          [YYWeiboStatus zy_modelWithJson:json];
    }
  }];
}
@end