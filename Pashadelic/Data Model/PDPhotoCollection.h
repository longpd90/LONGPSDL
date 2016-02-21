//
//  PDPhotoCollection.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 10.07.13.
//
//

#import <Foundation/Foundation.h>


@interface PDPhotoCollection : NSObject

@property (assign, nonatomic) NSUInteger identifier;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSString *thumbnailURL;
@property (assign, nonatomic) NSUInteger photosCount;

- (void)loadFromDictionary:(NSDictionary *)dictionary;

@end
