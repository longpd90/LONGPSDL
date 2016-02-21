//
//  PDPhotoLandMark.h
//  Pashadelic
//
//  Created by LongPD on 6/16/14.
//
//

#import "PDItem.h"

@interface PDPhotoLandMarkItem : PDItem

@property(strong, nonatomic) NSString *alias;
@property(strong, nonatomic) NSString *category;
@property(copy, nonatomic) NSString *name;
@property(copy, nonatomic) NSString *desc;
@property(copy, nonatomic) NSString *address;
@property double latitude;
@property double longitude;
@property(assign, nonatomic) NSInteger photoCount;
@property(assign, nonatomic) NSInteger userCount;
@property(strong, nonatomic) NSURL *avatarListURL;
@property(strong, nonatomic) NSURL *avatarTileURL;

- (void)loadDataFromDictionary:(NSDictionary *)dictionary;

@end
