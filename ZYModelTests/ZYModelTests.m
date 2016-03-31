//
//  ZYModelTests.m
//  ZYModelTests
//
//  Created by sheepliu on 16/3/29.
//  Copyright © 2016年 tzuyangliu. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ZYModel.h"
#import "User.h"

@interface ZYModelTests : XCTestCase
@property (strong, nonatomic) id json;
@end

@implementation ZYModelTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    NSError *error = nil;
    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"user"
                                                         ofType:@"json"];
    NSData *dataFromFile = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:dataFromFile
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
    id json = self.json;
    User *user = [User zy_modelWithJSON:json];
    
    NSLog(@"\n\n%@\n\n", user);
}


- (void)testPerformance {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        for (NSInteger i = 0; i < 100000; i++){
            id json = self.json;
            User *user = [User zy_modelWithJSON:json];
//            NSLog(@"%@", user.name);
        }
    }];
}

@end
