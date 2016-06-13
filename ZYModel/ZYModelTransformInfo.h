//
//  ZYModelTransfromInfo.h
//  ZYModel
//
//  Created by 刘子洋 on 16/3/31.
//  Copyright © 2016年 刘子洋. All rights reserved.
//
#import <Foundation/Foundation.h>
@interface ZYModelPropertyTransformInfo : NSObject {
@package
    NSString* _jsonKey;
    Class _cls;
    Class _containCls;
    SEL _setter;
    SEL _getter;
//    ZYEncodingType _type;
//    ZYEncodingNSType _nsType;
    ZYType _type;
    BOOL _isCNumber;
    BOOL _hasCustomContainCls;
}
- (instancetype)initWithClassPropertyInfo:(ZYClassPropertyInfo*)classProperty
                                  jsonKey:(NSString*)jsonKey;
@end
@interface ZYModelTransformInfo : NSObject {
@package
    NSDictionary<NSString*, NSString*>* _mapper;
    NSMutableArray<ZYModelPropertyTransformInfo*>* _propertyTransformInfos;
}
- (instancetype)initWithClass:(Class)cls;
+ (instancetype)modelTransformInfoWithClass:(Class)cls;
@end