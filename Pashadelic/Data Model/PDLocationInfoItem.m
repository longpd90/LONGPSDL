//
//  PDLocationInfoItem.m
//  Pashadelic
//
//  Created by LongPD on 6/19/14.
//
//

#import "PDLocationInfoItem.h"

@implementation PDLocationInfoItem

- (void)loadCityDataFromDictionary:(NSDictionary *)dictionary
{
    _locationType = PDLocationTypeCity;
	self.name = [dictionary stringForKey:@"city_name"];
    self.photoCount = [dictionary intForKey:@"photos_count"];
    self.userCount = [dictionary intForKey:@"users_count"];
    self.landmardCount = [dictionary intForKey:@"landmarks_count"];
    self.avatarURL = [NSURL URLWithString:[dictionary stringForKey:@"avatar"]];
}

- (void)loadStateDataFromDictionary:(NSDictionary *)dictionary
{
    _locationType = PDLocationTypeState;
	self.name = [dictionary stringForKey:@"state_name"];
    self.photoCount = [dictionary intForKey:@"photos_count"];
    self.userCount = [dictionary intForKey:@"users_count"];
    self.landmardCount = [dictionary intForKey:@"landmarks_count"];
    self.avatarURL = [NSURL URLWithString:[dictionary stringForKey:@"avatar"]];
}

- (void)loadCountryDataFromDictionary:(NSDictionary *)dictionary
{
    _locationType = PDLocationTypeCountry;
	self.name = [dictionary stringForKey:@"country_name"];
    self.photoCount = [dictionary intForKey:@"photos_count"];
    self.userCount = [dictionary intForKey:@"users_count"];
    self.landmardCount = [dictionary intForKey:@"landmarks_count"];
    self.avatarURL = [NSURL URLWithString:[dictionary stringForKey:@"avatar"]];
}

@end
