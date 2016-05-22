//
//  WBModel.m
//  ModelBenchmark
//
//  Created by ibireme on 15/9/18.
//  Copyright (c) 2015 ibireme. All rights reserved.
//

#import "YYWeiboModel.h"
#import "MJExtension.h"

@implementation YYWeiboPictureMetadata
+ (NSDictionary *)zy_propertyToJsonKeyMapper
{
    return [self mapper];
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return [self mapper];
}
+ (NSDictionary *)modelCustomPropertyMapper {
    return [self mapper];
}

+ (NSDictionary *)mapper {
    return @{@"cutType" : @"cut_type"};
}

@end

@implementation YYWeiboPicture
+ (NSDictionary *)zy_propertyToJsonKeyMapper
{
    return [self mapper];
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return [self mapper];
}
+ (NSDictionary *)modelCustomPropertyMapper {
    return [self mapper];
}
+ (NSDictionary *)mapper {
    return @{@"picID" : @"pic_id",
             @"keepSize" : @"keep_size",
             @"photoTag" : @"photo_tag",
             @"objectID" : @"object_id",
             @"middlePlus" : @"middleplus"};
}

@end

@implementation YYWeiboURL
+ (NSDictionary *)zy_propertyToJsonKeyMapper
{
    return [self mapper];
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return [self mapper];
}
+ (NSDictionary *)modelCustomPropertyMapper {
    return [self mapper];
}
+ (NSDictionary *)mapper {
    return @{@"oriURL" : @"ori_url",
             @"urlTitle" : @"url_title",
             @"urlTypePic" : @"url_type_pic",
             @"urlType" : @"url_type",
             @"shortURL" : @"short_url",
             @"actionLog" : @"actionlog",
             @"pageID" : @"page_id",
             @"storageType" : @"storage_type"};
}

@end

@implementation YYWeiboUser

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if (property.type.typeClass == [NSDate class]) {
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"EE MMM dd HH:mm:ss ZZZ yyyy";
        return [fmt dateFromString:oldValue];
    }
    return oldValue;
}

+ (NSDictionary *)zy_propertyToJsonKeyMapper
{
    return [self mapper];
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return [self mapper];
}
+ (NSDictionary *)modelCustomPropertyMapper {
    return [self mapper];
}

+ (NSDictionary *)mapper {
    return @{@"userID" : @"id",
             @"idString" : @"idstr",
             @"genderString" : @"gender",
             @"biFollowersCount" : @"bi_followers_count",
             @"profileImageURL" : @"profile_image_url",
             @"uclass" : @"class",
             @"verifiedContactEmail" : @"verified_contact_email",
             @"statusesCount" : @"statuses_count",
             @"geoEnabled" : @"geo_enabled",
             @"followMe" : @"follow_me",
             @"coverImagePhone" : @"cover_image_phone",
             @"desc" : @"description",
             @"followersCount" : @"followers_count",
             @"verifiedContactMobile" : @"verified_contact_mobile",
             @"avatarLarge" : @"avatar_large",
             @"verifiedTrade" : @"verified_trade",
             @"profileURL" : @"profile_url",
             @"coverImage" : @"cover_image",
             @"onlineStatus"  : @"online_status",
             @"badgeTop" : @"badge_top",
             @"verifiedContactName" : @"verified_contact_name",
             @"screenName" : @"screen_name",
             @"verifiedSourceURL" : @"verified_source_url",
             @"pagefriendsCount" : @"pagefriends_count",
             @"verifiedReason" : @"verified_reason",
             @"friendsCount" : @"friends_count",
             @"blockApp" : @"block_app",
             @"hasAbilityTag" : @"has_ability_tag",
             @"avatarHD" : @"avatar_hd",
             @"creditScore" : @"credit_score",
             @"createdAt" : @"created_at",
             @"blockWord" : @"block_word",
             @"allowAllActMsg" : @"allow_all_act_msg",
             @"verifiedState" : @"verified_state",
             @"verifiedReasonModified" : @"verified_reason_modified",
             @"allowAllComment" : @"allow_all_comment",
             @"verifiedLevel" : @"verified_level",
             @"verifiedReasonURL" : @"verified_reason_url",
             @"favouritesCount" : @"favourites_count",
             @"verifiedType" : @"verified_type",
             @"verifiedSource" : @"verified_source",
             @"userAbility" : @"user_ability"};
}

@end

@implementation YYWeiboStatus

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if (property.type.typeClass == [NSDate class]) {
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"EE MMM dd HH:mm:ss ZZZ yyyy";
        return [fmt dateFromString:oldValue];
    }
    return oldValue;
}

+ (NSDictionary *)zy_propertyToJsonKeyMapper
{
    return [self mapper];
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return [self mapper];
}
+ (NSDictionary *)modelCustomPropertyMapper {
    return [self mapper];
}
+ (NSDictionary *)mapper {
    return @{@"statusID" : @"id",
             @"createdAt" : @"created_at",
             @"attitudesStatus" : @"attitudes_status",
             @"inReplyToScreenName" : @"in_reply_to_screen_name",
             @"sourceType" : @"source_type",
             @"commentsCount" : @"comments_count",
             @"recomState" : @"recom_state",
             @"urlStruct" : @"url_struct",
             @"sourceAllowClick" : @"source_allowclick",
             @"bizFeature" : @"biz_feature",
             @"mblogTypeName" : @"mblogtypename",
             @"mblogType" : @"mblogtype",
             @"inReplyToStatusId" : @"in_reply_to_status_id",
             @"picIds" : @"pic_ids",
             @"repostsCount" : @"reposts_count",
             @"attitudesCount" : @"attitudes_count",
             @"darwinTags" : @"darwin_tags",
             @"userType" : @"userType",
             @"picInfos" : @"pic_infos",
             @"inReplyToUserId" : @"in_reply_to_user_id"};
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"picIds" : [NSString class],
             @"picInfos" : [YYWeiboPicture class],
             @"urlStruct" : [YYWeiboURL class]};
}

+ (NSDictionary *)zy_containerPropertyGenericClass
{
    return @{@"picIds" : [NSString class],
             @"picInfos" : [YYWeiboPicture class],
             @"urlStruct" : [YYWeiboURL class]};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"picIds" : [NSString class],
             @"picInfos" : [YYWeiboPicture class],
             @"urlStruct" : [YYWeiboURL class]};
}
@end
