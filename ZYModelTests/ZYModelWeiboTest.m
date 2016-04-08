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
    id json = self.json;
    YYWeiboStatus *weiboStatus = [YYWeiboStatus zy_modelWithJSON:json];
    
    XCTAssertNotNil(weiboStatus);
    // User
    XCTAssertNotNil(weiboStatus.user);
    // mid - NSMutableString
    XCTAssertNotNil(weiboStatus.mid);
    XCTAssert([weiboStatus.mid isKindOfClass:[NSMutableString class]]);
    // visible - NSMutableDictionary
    XCTAssertNotNil(weiboStatus.visible);
    XCTAssert([weiboStatus.visible isKindOfClass:[NSMutableDictionary class]]);
    // picIds - NSArray
    XCTAssertNotNil(weiboStatus.picIds);
    XCTAssert([weiboStatus.picIds isKindOfClass:[NSArray class]]);
    XCTAssert(weiboStatus.picIds.count > 0);
    // urlStruct - NSArray
//    XCTAssertNotNil(weiboStatus.urlStruct);
//    XCTAssert([weiboStatus.urlStruct isKindOfClass:[NSArray class]]);
//    XCTAssert(weiboStatus.urlStruct.count > 0);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
