//
//  PDPan.h
//  Pashadelic
//
//  Created by LongPD on 11/14/13.
//
//

#import "PDItem.h"
#import "PDPhoto.h"
#import "PDUser.h"
#import "PDComment.h"

@interface PDPlan : PDItem
@property(nonatomic, assign) NSInteger planID;
@property(copy, nonatomic) NSString *name;
@property(copy, nonatomic) NSString *desc;
@property (copy, nonatomic) NSString *time;
@property (strong, nonatomic) PDUser *user;
@property(nonatomic, assign) NSInteger userID;
@property(copy, nonatomic) NSString *address;
@property(copy, nonatomic) NSString *address_jp;
@property double latitude;
@property double longitude;
@property(strong, nonatomic) PDPhoto *photo;
@property (strong, nonatomic) NSString *mapImageURLString;
@property (strong, nonatomic) NSArray *listMember;
@property (strong, nonatomic) NSArray *comments;
@property (assign, nonatomic) NSInteger commentsCount;
@property (assign, nonatomic) NSInteger capacity;
@property (assign, nonatomic) NSInteger participantsCount;
@property (strong, nonatomic) NSArray *paticipants;
@property (assign, nonatomic) BOOL joinStatus;
- (void)loadDataFromDictionary:(NSDictionary *)dictionary;

@end
