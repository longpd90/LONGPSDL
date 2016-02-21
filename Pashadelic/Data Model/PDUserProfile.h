//
//  PDUserProfile.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 6/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDUser.h"

@interface PDUserProfile : PDUser

@property (assign, nonatomic) NSInteger sex;
@property (assign, nonatomic) NSInteger countryID;
@property (assign, nonatomic) NSInteger stateID;
@property (assign, nonatomic) NSInteger level;
@property (copy, nonatomic) NSString *firstName;
@property (copy, nonatomic) NSString *lastName;
@property (copy, nonatomic) NSString *email;
@property (copy, nonatomic) NSString *phone;
@property (copy, nonatomic) NSString *desc;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSMutableArray *pins;
@property (strong, nonatomic) NSMutableArray *nearbyPins;
@property (nonatomic, assign) NSUInteger unreadItemsCount;
@property (nonatomic, assign) NSUInteger plansUpcomingCount;
@property (strong, nonatomic) NSArray *photoCollections;

- (void)loadEditInfoFromDictionary:(NSDictionary *)dictionary;

@end
