//
//  PDWeatherEntity.h
//  Pashadelic
//
//  Created by LongPD on 9/4/13.
//
//

@interface PDWeather : NSObject
@property (nonatomic, strong) NSString *iconID;
@property (nonatomic, strong) UIImage *iconImage;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *country;
- (id)initWithDictionary:(NSDictionary *)dictionary;
@end
