//
//  ZYModelWeiboTest.m
//  ZYModel
//
//  Created by sheepliu on 16/4/5.
//  Copyright © 2016年 tzuyangliu. All rights reserved.
//
/**
 支持的类型：
 
 NSObject 及其子类
 NSValue
 NSNumber
 NSString
 NSMutableString
 NSArray<T>
 NSMutableArray<T>
 NSDictionary<T,T>
 NSMutableDictionary<T,T>
 
 ---C系数值---
 bool
 int8_t __signed char
 uint8_t unsigned char
 int16_t short
 uint16_t unsigned short
 int32_t int
 uint32_t unsigned int
 int64_t long long
 uint64_t unsigned long long
 
 float
 double
 long double
 */

#import <XCTest/XCTest.h>
#import "ZYModel.h"
#import "YYWeiboModel.h"

@interface ZYModelWeiboTest : XCTestCase
@property (strong, nonatomic) NSDictionary* json;
@end

@implementation ZYModelWeiboTest

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
}

- (void)tearDown {
    [super tearDown];
}

- (void)testBasicFunction {
    id json = self.json;
    YYWeiboStatus *weiboStatus = [YYWeiboStatus zy_modelWithJson:json];
    
    XCTAssertNotNil(weiboStatus);
    // statusID
    XCTAssertEqual(weiboStatus.statusID, 3887674148022737);
    // idstr
    XCTAssertTrue([weiboStatus.idstr isKindOfClass:[NSString class]]);
    XCTAssertTrue([weiboStatus.idstr isEqual:@"3887674148022737"]);
    // favorited
    XCTAssertEqual(weiboStatus.favorited, YES);
    // repostsCount
    XCTAssertEqual(weiboStatus.repostsCount, 12662);
    // createdAt
//    XCTAssertNotNil(weiboStatus.createdAt);
//    XCTAssertTrue([weiboStatus.createdAt isKindOfClass:[NSDate class]]);
    // User
    XCTAssertNotNil(weiboStatus.user);
    // mid - NSMutableString
    XCTAssertNotNil(weiboStatus.mid);
    XCTAssertTrue([weiboStatus.mid isKindOfClass:[NSMutableString class]]);
    // visible - NSMutableDictionary
    XCTAssertNotNil(weiboStatus.visible);
    XCTAssertTrue([weiboStatus.visible isKindOfClass:[NSMutableDictionary class]]);
    // picIds - NSArray<NSString *> *
    XCTAssertNotNil(weiboStatus.picIds);
    XCTAssertTrue([weiboStatus.picIds isKindOfClass:[NSArray class]]);
    XCTAssertTrue(weiboStatus.picIds.count > 0);
    XCTAssertTrue([weiboStatus.picIds[0] isKindOfClass:[NSString class]]);
    // urlStruct - NSArray<YYWeiboURL *> *
    XCTAssertNotNil(weiboStatus.urlStruct);
    XCTAssertTrue([weiboStatus.urlStruct isKindOfClass:[NSArray class]]);
    XCTAssertTrue(weiboStatus.urlStruct.count > 0);
    XCTAssertTrue([weiboStatus.urlStruct[0] isKindOfClass:[YYWeiboURL class]]);
    // picInfos
    XCTAssertNotNil(weiboStatus.picInfos);
    XCTAssertTrue([weiboStatus.picInfos isKindOfClass:[NSDictionary class]]);
    YYWeiboPicture *picture = weiboStatus.picInfos[weiboStatus.picIds[0]];
    XCTAssertNotNil(picture);
    XCTAssertTrue([picture isKindOfClass:[YYWeiboPicture class]]);
    YYWeiboPictureMetadata *thumbnail = picture.thumbnail;
    XCTAssertNotNil(thumbnail);
    XCTAssertTrue([thumbnail isKindOfClass:[YYWeiboPictureMetadata class]]);
    XCTAssertNotNil(thumbnail.url);
    XCTAssertTrue([thumbnail.url isKindOfClass:[NSURL class]]);
}

- (void)testPerformanceExample {
    id json = self.json;
    [self measureBlock:^{
        for (NSInteger i = 0; i < 1000; i++){
            __unused YYWeiboStatus *weiboStatus = [YYWeiboStatus zy_modelWithJson:json];
        }
    }];
}

@end
