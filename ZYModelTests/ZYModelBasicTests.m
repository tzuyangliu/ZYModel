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
@property (strong, nonatomic) NSDictionary *json;
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

- (void)checkCNumbersWithDemoClassObject:(DemoClass *)obj
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
}

- (void)checkNSClassWithDemoClassObject:(DemoClass *)obj
{
    // NSDate
    XCTAssertNotNil(obj.nsDate);
    XCTAssert([obj.nsDate isKindOfClass:[NSDate class]]);
    
    // NSValue
    XCTAssert([obj.nsValue isKindOfClass:[NSValue class]]);
    XCTAssert([obj.nsValue isEqual:@123]);
    
    // NSNumber
    XCTAssert([obj.nsNumber isKindOfClass:[NSNumber class]]);
    XCTAssert([obj.nsNumber isEqual:[NSNumber numberWithInteger:123456]]);
    
    // NSData
    XCTAssert([obj.nsData isKindOfClass:[NSData class]]);
    XCTAssertNotNil(obj.nsData);
    
    // NSMutableData
    XCTAssert([obj.nsMutableData isKindOfClass:[NSMutableData class]]);
    XCTAssertNotNil(obj.nsMutableData);
    
    // NSString
    XCTAssert([obj.nsString isKindOfClass:[NSString class]]);
    XCTAssert([obj.nsString isEqual:@"I'm a string"]);
    
    // NSMutableString
    XCTAssert([obj.nsMutableString isKindOfClass:[NSMutableString class]]);
    XCTAssert([obj.nsMutableString isEqual:@"I'm a string"]);
    
    // NSSet
    XCTAssert([obj.nsSet isKindOfClass:[NSSet class]]);
    XCTAssert(obj.nsSet.count == 3);
    XCTAssert([obj.nsSet.anyObject isKindOfClass:[NSNumber class]]);
    
    // NSMutableSet
    XCTAssert([obj.nsMutableSet isKindOfClass:[NSMutableSet class]]);
    XCTAssert(obj.nsMutableSet.count == 3);
    XCTAssert([obj.nsMutableSet.anyObject isKindOfClass:[NSNumber class]]);
    
    // NSSet With DemoContainerClass inside
    XCTAssert([obj.nsDemoClassSet isKindOfClass:[NSSet class]]);
    XCTAssert(obj.nsDemoClassSet.count == 3);
    XCTAssert([obj.nsDemoClassSet.anyObject isKindOfClass:[DemoContainerClass class]]);
    
    // NSArray
    XCTAssert([obj.nsArray isKindOfClass:[NSArray class]]);
    XCTAssert(obj.nsArray.count == 3);
    XCTAssert([obj.nsArray.firstObject isKindOfClass:[NSNumber class]]);
    
    // NSMutableArray
    XCTAssert([obj.nsMutableArray isKindOfClass:[NSMutableArray class]]);
    XCTAssert(obj.nsMutableArray.count == 3);
    XCTAssert([obj.nsMutableArray.firstObject isKindOfClass:[NSNumber class]]);
    
    // NSArray With DemoContainerClass inside
    XCTAssert([obj.nsDemoClassArray isKindOfClass:[NSArray class]]);
    XCTAssert(obj.nsDemoClassArray.count == 3);
    XCTAssert([obj.nsDemoClassArray.firstObject isKindOfClass:[DemoContainerClass class]]);
    
    // NSDictionary
    XCTAssert([obj.nsDictionary isKindOfClass:[NSDictionary class]]);
    XCTAssert(obj.nsDictionary.count == 3);
    XCTAssert([obj.nsDictionary.allValues.firstObject isKindOfClass:[NSNumber class]]);
    
    // NSMutableDictionary
    XCTAssert([obj.nsMutableDictionary isKindOfClass:[NSMutableDictionary class]]);
    XCTAssert(obj.nsMutableDictionary.count == 3);
    XCTAssert([obj.nsMutableDictionary.allValues.firstObject isKindOfClass:[NSNumber class]]);
    
    // NSDictionary With DemoContainerClass inside
    XCTAssert([obj.nsDemoClassDictionary isKindOfClass:[NSDictionary class]]);
    XCTAssert(obj.nsDemoClassDictionary.count == 3);
    XCTAssert([obj.nsDemoClassDictionary.allValues.firstObject isKindOfClass:[DemoContainerClass class]]);
}

- (void)checkCustomClassWithDemoClassObject:(DemoClass *)obj
{
    XCTAssert([obj.customClass isKindOfClass:[DemoContainerClass class]]);
    XCTAssert([obj.customClass.name isEqualToString:@"name"]);
}

- (void)checkAutoMappingWithDemoClassObject:(DemoClass *)obj
{
    XCTAssert([obj.autoMappingString isEqualToString:@"string"]);
}

- (void)checkInherit
{
    id json = self.json;
    InheritClass *obj = [InheritClass zy_modelWithJson:json];
    [self checkCNumbersWithDemoClassObject:obj];
    [self checkNSClassWithDemoClassObject:obj];
    [self checkCustomClassWithDemoClassObject:obj];
    [self checkAutoMappingWithDemoClassObject:obj];
}

- (void)testJsonToModel
{
    id json = self.json;
    DemoClass *obj = [DemoClass zy_modelWithJson:json];
    [self checkCNumbersWithDemoClassObject:obj];
    [self checkNSClassWithDemoClassObject:obj];
    [self checkCustomClassWithDemoClassObject:obj];
    [self checkAutoMappingWithDemoClassObject:obj];
    [self checkInherit];
}

- (void)testModelToJson
{
    NSDictionary *json = self.json;
    DemoClass *obj = [DemoClass zy_modelWithJson:json];
    __unused NSDictionary *modelJson = [obj zy_modelJson];
    NSLog(@"%@", modelJson);
//    XCTAssert([json isEqualToDictionary:modelJson]);
}

@end
