//
//  PDPeople.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 25/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSArray+Extra.h"

@interface PDUser : PDItem

@property (assign, nonatomic) NSInteger pinsCount;
@property (assign, nonatomic) NSInteger followingsCount;
@property (assign, nonatomic) NSInteger followersCount;
@property (assign, nonatomic) NSInteger photosCount;
@property (assign, nonatomic) BOOL isFollowing;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *fullName;
@property (copy, nonatomic) NSString *location;
@property (copy, nonatomic) NSString *address;
@property (copy, nonatomic) NSString *interests;
@property (copy, nonatomic) NSString *details;
@property (copy, nonatomic) NSString *photoLevel;
@property (strong, nonatomic) NSURL *photoSpotButtonImageURL;
@property (strong, nonatomic) NSURL *pinsButtonImageURL;
@property (strong, nonatomic) NSURL *followersButtonImageURL;
@property (strong, nonatomic) NSURL *followingsButtonImageURL;
@property (strong, nonatomic) NSArray *photos;
@property (strong, nonatomic) NSArray *followers;
@property (strong, nonatomic) NSArray *slides;
@property (strong, nonatomic) NSArray *userPhotoThumbnails;

@end
