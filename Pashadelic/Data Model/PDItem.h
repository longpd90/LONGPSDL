//
//  PDItem.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 20/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Globals.h"
#import "NSDictionary+Extra.h"


@class PDItem;

@protocol PDItemSelectDelegate <NSObject>
- (void)itemDidSelect:(PDItem *)item;
@end


@interface PDItem : NSObject

@property (assign, nonatomic) NSInteger identifier;
@property (assign, nonatomic) BOOL followStatus;
@property (assign, nonatomic) NSInteger followersCount;
@property (strong, nonatomic) NSURL *thumbnailURL;
@property (strong, nonatomic) NSURL *fullImageURL;
@property (weak, nonatomic) id <PDItemSelectDelegate> itemDelegate;

- (NSString *)followItemName;
- (void)itemWasSelected;
- (void)loadShortDataFromDictionary:(NSDictionary *)dictionary;
- (void)loadFullDataFromDictionary:(NSDictionary *)dictionary;
- (NSString *)textForShare;
- (NSString *)countValueInString:(NSInteger)value;
- (void)setValuesFromArray:(NSArray *)array;
- (UIImage *)cachedThumbnailImage;
- (UIImage *)cachedFullImage;
- (UIImage *)cachedImage;

@end
