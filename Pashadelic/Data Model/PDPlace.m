//
//  PDPlace.m
//  Pashadelic
//
//  Created by TungNT2 on 5/10/13.
//
//

#import "PDPlace.h"

@implementation PDPlace
@synthesize description = _description;
- (void)loadDataFromDictionary:(NSDictionary *)dictionary
{
    _description = [dictionary stringForKey:@"description"];
    _identifier = [dictionary intForKey:@"id"];
    _reference = [dictionary stringForKey:@"reference"];
}

- (void)loadGeoDataFromDictionary:(NSDictionary *)dictionary
{
    _description = [dictionary stringForKey:@"formatted_address"];
    [self loadFullDataFromDictionary:dictionary];
}

- (void)loadFullDataFromDictionary:(NSDictionary *)dictionary
{
    NSDictionary *dictGeometry = [dictionary objectForKey:@"geometry"];
    NSDictionary *dictLocation = [dictGeometry objectForKey:@"location"];
    _longitude = [dictLocation floatForKey:@"lng"];
    _latitude = [dictLocation floatForKey:@"lat"];
}

- (CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake(_latitude, _longitude);
}

@end
