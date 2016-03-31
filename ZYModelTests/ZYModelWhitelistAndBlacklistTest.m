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

#pragma mark Whitelist Class

@interface UserWithWhitelist : User

@end

@implementation UserWithWhitelist

+ (NSArray *)whitelistProperties
{
    return @[@"name"];
}

@end

#pragma mark - Blacklist Class

@interface UserWithBlacklist : User

@end

@implementation UserWithBlacklist

+ (NSArray *)blacklistProperties
{
    return @[@"name", @"uid", @"gender"];
}

@end

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
    UserWithWhitelist *user = [UserWithWhitelist zy_modelWithJSON:self.json];
    XCTAssertNotNil(user.name);
    XCTAssertNil(user.uid);
    XCTAssertNil(user.gender);
    XCTAssertNil(user.address);
    
    XCTAssertEqual(user.name, self.json[@"user_name"]);
}

#pragma mark - Blacklist Test

- (void)testZYModelBlacklist
{
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    UserWithBlacklist *user = [UserWithBlacklist zy_modelWithJSON:self.json];
    XCTAssertNil(user.name);
    XCTAssertNil(user.uid);
    XCTAssertNil(user.gender);
    XCTAssertNotNil(user.address);
    
    XCTAssertEqual(user.address, self.json[@"user_address"]);
}

@end
