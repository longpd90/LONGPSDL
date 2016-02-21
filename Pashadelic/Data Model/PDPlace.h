//
//  PDPlace.h
//  Pashadelic
//
//  Created by TungNT2 on 5/10/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface PDPlace : NSObject

@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, strong) NSString *reference;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, assign) double longitude;
@property (nonatomic, assign) double latitude;

- (void)loadDataFromDictionary:(NSDictionary *)dictionary;
- (void)loadGeoDataFromDictionary:(NSDictionary *)dictionary;
- (void)loadFullDataFromDictionary:(NSDictionary *)dictionary;
- (CLLocationCoordinate2D)coordinate;
@end
