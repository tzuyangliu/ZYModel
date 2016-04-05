//
//  ZYModelTests.m
//  ZYModelTests
//
//  Created by sheepliu on 16/3/29.
//  Copyright © 2016年 tzuyangliu. All rights reserved.
//

#import "User.h"
#import "ZYModel.h"
#import <XCTest/XCTest.h>

static const NSUInteger kTestRepeatTimes = 100000;

@interface ZYModelBasicTests : XCTestCase
@property (strong, nonatomic) NSDictionary* json;
@end

@implementation ZYModelBasicTests

- (void)setUp
{
    [super setUp];

    NSError* error = nil;
    NSString* filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"user"
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

- (void)testBaselineFunction
{
    NSDictionary* json = self.json;
    User* user = [[User alloc] init];
    user.uid = json[@"user_uid"];
    user.name = json[@"user_name"];
    user.gender = json[@"user_gender"];
    user.address = json[@"user_address"];
    
    XCTAssertNotNil(user.uid);
    XCTAssertNotNil(user.name);
    XCTAssertNotNil(user.gender);
    XCTAssertNotNil(user.address);
    
    XCTAssertEqual(user.uid, json[@"user_uid"]);
    XCTAssertEqual(user.name, json[@"user_name"]);
    XCTAssertEqual(user.gender, json[@"user_gender"]);
    XCTAssertEqual(user.address, json[@"user_address"]);
}

- (void)testZYModelFunction
{
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    NSDictionary* json = self.json;
    User* user = [User zy_modelWithJSON:json];
    XCTAssertNotNil(user.uid);
    XCTAssertNotNil(user.name);
    XCTAssertNotNil(user.gender);
    XCTAssertNotNil(user.address);
//    XCTAssertNotNil(user.father);

    XCTAssertEqual(user.uid, json[@"user_uid"]);
    XCTAssertEqual(user.name, json[@"user_name"]);
    XCTAssertEqual(user.gender, json[@"user_gender"]);
    XCTAssertEqual(user.address, json[@"user_address"]);
//    XCTAssertEqual(user.father.name, json[@"father"][@"user_name"]);
    // Test log
    NSLog(@"\n\n%@\n\n", user);
}

#pragma mark - Performance Test

- (void)testBaselinePerformace
{
    NSDictionary* json = self.json;
    [self measureBlock:^{
        for (NSUInteger i = 0; i < kTestRepeatTimes; i++) {
            User* user = [[User alloc] init];
            user.name = json[@"user_name"];
            user.uid = json[@"user_uid"];
            user.gender = json[@"user_gender"];
            user.address = json[@"user_address"];
        }
    }];
}

- (void)testZYModelPerformance
{
    NSDictionary* json = self.json;
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
//        for (NSUInteger i = 0; i < kTestRepeatTimes; i++) {
//            User __unused* user = [User zy_modelWithJSON:json];
//        }
    }];
}

@end
