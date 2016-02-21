//
//  PDComment.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 25/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDItem.h"
@class PDUser;
@class PDPhoto;
@class PDPlan;
@interface PDComment : PDItem

@property (assign, nonatomic) NSInteger replyToID;
@property (strong, nonatomic) PDUser *user;
@property (copy, nonatomic) NSString *comment;
@property (copy, nonatomic) NSDate *date;
@property (weak, nonatomic) PDPhoto *photo;
@property (weak, nonatomic) PDPlan *plan;
- (void)loadFullDataFromDictionary:(NSDictionary *)dictionary;

@end
