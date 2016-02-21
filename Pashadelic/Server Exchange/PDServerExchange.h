//
//  PDServerExchange.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Globals.h"
#import "NSDictionary+Extra.h"
#import "MGServerExchange.h"
#import "NSString+URLEncoding.h"

@interface PDServerExchange : MGServerExchange

- (BOOL)trackUploadDataProgress;
- (NSArray *)loadPhotosFromArray:(NSArray *)sourceArray;
- (NSArray *)loadUsersFromArray:(NSArray *)sourceArray;
- (NSArray *)loadCommentsFromArray:(NSArray *)sourceArray;
- (NSArray *)loadActivityItemsFromArray:(NSArray *)sourceArray;
- (NSArray *)loadNotificationItemsFromArray:(NSArray *)sourceArray;
- (NSArray *)loadPlansItemsFromArray:(NSArray *)sourceArray;
- (NSArray *)loadLandmarkFromArray:(NSArray *)sourceArray;
- (NSArray *)loadUsersFromResult:(NSDictionary *)result;
- (NSArray *)loadLandmarkItemsFromArray:(NSArray *)sourceArray;

@end
