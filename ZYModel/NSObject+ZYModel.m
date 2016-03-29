//
//  NSObject+ZYModel.m
//  ZYModel
//
//  Created by sheepliu on 16/3/29.
//  Copyright © 2016年 tzuyangliu. All rights reserved.
//

#import "NSObject+ZYModel.h"
#import <objc/objc-runtime.h>

@implementation NSObject (ZYModel)

+ (id<ZYModel>)modelCls
{
    return (id<ZYModel>)[self class];
}

- (void)setPropertyWithMapper:(NSDictionary<NSString *, NSString *> *)mapper data:(NSDictionary *)data
{
    for (NSString *key in mapper){
        NSString *value = mapper[key];
        if (!value.length) continue;
        id content = data[value];
        if (!content) continue;
        const char *property = key.UTF8String;
        char *temp = strdup(property); // make a copy
        unsigned char *tptr = (unsigned char *)temp;
        *tptr = toupper((unsigned char)*tptr);
        char *buffer;
        asprintf(&buffer, "set%s:", tptr);
        SEL setterSEL = sel_registerName(buffer);
        ((void (*)(id, SEL, id))(void *)objc_msgSend)((id)self, setterSEL, content);
        free(temp);
        free(buffer);
    }
}

+ (instancetype)zy_modelWithJSON:(id)json
{
    id<ZYModel> modelCls = [self modelCls];
    NSObject *obj = [[self class] new];
    [obj setPropertyWithMapper:[modelCls mappingDictionary] data:(NSDictionary *)json];
    return obj;
}

+ (instancetype)zy_modelWithDictionary:(NSDictionary *)dictionary
{
    return nil;
}

@end
