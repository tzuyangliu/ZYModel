//
//  ZYModelWeiboTest.m
//  ZYModel
//
//  Created by sheepliu on 16/4/5.
//  Copyright © 2016年 tzuyangliu. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ZYModel.h"
#import "YYWeiboModel.h"

@interface ZYModelWeiboTest : XCTestCase
@property (strong, nonatomic) NSDictionary* json;
@end

@implementation ZYModelWeiboTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
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
    id json = self.json;
    YYWeiboStatus *weiboStatus = [YYWeiboStatus zy_modelWithJSON:json];
    
    NSLog(@"%@", weiboStatus);
    XCTAssertNotNil(weiboStatus.user);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
