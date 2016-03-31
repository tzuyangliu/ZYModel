//
//  ZYModelWhitelistAndBlacklistTest.m
//  ZYModel
//
//  Created by sheepliu on 16/3/31.
//  Copyright © 2016年 tzuyangliu. All rights reserved.
//

#import "User.h"
#import "ZYModel.h"
#import <XCTest/XCTest.h>

@interface ZYModelWhitelistAndBlacklistTest : XCTestCase
@property (strong, nonatomic) NSDictionary* json;
@end

@implementation ZYModelWhitelistAndBlacklistTest

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

#pragma mark - Whitelist Test

- (void)testZYModelWhitelist
{
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

#pragma mark - Blacklist Test

- (void)testZYModelBlacklist
{
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

@end
