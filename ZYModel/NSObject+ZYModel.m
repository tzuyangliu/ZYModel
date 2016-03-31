//
//  NSObject+ZYModel.m
//  ZYModel
//
//  Created by sheepliu on 16/3/29.
//  Copyright © 2016年 tzuyangliu. All rights reserved.
//

#import "NSObject+ZYModel.h"
#import <objc/objc-runtime.h>
#import "ZYClassInfo.h"

@implementation NSObject (ZYModel)

- (void)setValuesWithDictionary:(NSDictionary *)dictionary
{
    ZYClassInfo *clsInfo = [ZYClassInfo classInfoWithClass:[self class]];
    NSDictionary *propertyDictionary = clsInfo.properties;
    NSArray *mapperKeys = dictionary.allKeys;
    for (NSString *propertyName in propertyDictionary.allKeys)
    {
        if (![mapperKeys containsObject:propertyName])
        {
            continue;
        }
        ZYClassProperty *property = propertyDictionary[propertyName];
        id content = dictionary[propertyName];
        ((void (*)(id, SEL, id))(void *)objc_msgSend)((id)self, property.setter, content);
    }
}

- (void)setPropertyWithMapper:(NSDictionary<NSString *, NSString *> *)mapper data:(NSDictionary *)data
{
//    for (NSString *key in mapper){
//        NSString *value = mapper[key];
//        if (!value.length) continue;
//        id content = data[value];
//        if (!content) continue;
//        const char *property = key.UTF8String;
//        char *temp = strdup(property);
//        unsigned char *tptr = (unsigned char *)temp;
//        *tptr = toupper((unsigned char)*tptr);
//        char *buffer;
//        asprintf(&buffer, "set%s:", tptr);
//        SEL setterSEL = sel_registerName(buffer);
//        ((void (*)(id, SEL, id))(void *)objc_msgSend)((id)self, setterSEL, content);
//        free(temp);
//        free(buffer);
//    }
}

+ (instancetype)zy_modelWithJSON:(id)json
{
    NSObject *obj = [[self class] new];
    [obj setValuesWithDictionary:json];
//    [obj setPropertyWithMapper:[modelCls mappingDictionary] data:(NSDictionary *)json];
    return obj;
}

+ (instancetype)zy_modelWithDictionary:(NSDictionary *)dictionary
{
    return nil;
}

@end
