//
//  ZYModelTests.m
//  ZYModelTests
//
//  Created by sheepliu on 16/3/29.
//  Copyright © 2016年 tzuyangliu. All rights reserved.
//

#import "DemoClass.h"
#import "ZYModel.h"
#import <XCTest/XCTest.h>

@interface ZYModelBasicTests : XCTestCase
@property (strong, nonatomic) NSDictionary* json;
@end

@implementation ZYModelBasicTests

- (void)setUp
{
    [super setUp];

    NSError* error = nil;
    NSString* filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"demo"
                                                                          ofType:@"json"];
    NSData* dataFromFile = [NSData dataWithContentsOfFile:filePath];
    NSDictionary* data = [NSJSONSerialization JSONObjectWithData:dataFromFile
                                                         options:kNilOptions
                                                           error:&error];
    self.json = data;
}

- (void)tearDown
{
    self.json = nil;

    [super tearDown];
}

#pragma mark - Function Test

- (void)testCNumbersWithDemoClassObject:(DemoClass *)obj
{
    // bool
    XCTAssert(sizeof(obj.cBoolTrue) == sizeof(bool));
    XCTAssert(obj.cBoolTrue == true);
    XCTAssert(obj.cBoolFalse == false);
    
    // BOOL
    XCTAssert(sizeof(obj.ocBoolTrue) == sizeof(BOOL));
    XCTAssert(obj.ocBoolTrue == YES);
    XCTAssert(obj.ocBoolFalse == NO);
    
    // int8
    XCTAssert(sizeof(obj.int8) == sizeof(int8_t));
    XCTAssert(obj.int8 == 1);
    
    // uint8
    XCTAssert(sizeof(obj.uint8) == sizeof(uint8_t));
    XCTAssert(obj.uint8 == 1);
    
    // int16
    XCTAssert(sizeof(obj.int16) == sizeof(int16_t));
    XCTAssert(obj.int16 == 1);
    
    // uint16
    XCTAssert(sizeof(obj.uint16) == sizeof(uint16_t));
    XCTAssert(obj.uint16 == 1);
    
    // int32
    XCTAssert(sizeof(obj.int32) == sizeof(int32_t));
    XCTAssert(obj.int32 == 1);
    
    // uint32
    XCTAssert(sizeof(obj.uint32) == sizeof(uint32_t));
    XCTAssert(obj.uint32 == 1);
    
    // int64
    XCTAssert(sizeof(obj.int64) == sizeof(int64_t));
    XCTAssert(obj.int64 == 1);
    
    // uint64
    XCTAssert(sizeof(obj.uint64) == sizeof(uint64_t));
    XCTAssert(obj.uint64 == 1);
    
    // float
    XCTAssert(sizeof(obj.floatValue) == sizeof(float));
    XCTAssert(obj.floatValue == 1.0);
    
    // double
    XCTAssert(sizeof(obj.doubleValue) == sizeof(double));
    XCTAssert(obj.doubleValue == 1.0);
    
    // long double
    XCTAssert(sizeof(obj.longDoubleValue) == sizeof(long double));
    XCTAssert(obj.longDoubleValue == 1.0);
    
    // NSDate
    XCTAssertNotNil(obj.date);
}

- (void)testJsonToModel
{
    id json = self.json;
    DemoClass *obj = [DemoClass zy_modelWithJson:json];
    [self testCNumbersWithDemoClassObject:obj];
}

- (void)testModelToJson
{
    NSDictionary *json = self.json;
    DemoClass *obj = [DemoClass zy_modelWithJson:json];
    __unused NSDictionary *modelJson = [obj zy_modelJson];
    
//    XCTAssert([json isEqualToDictionary:modelJson]);
}

@end
