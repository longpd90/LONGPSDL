//
//  PDReview.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 07.07.13.
//
//

#import <Foundation/Foundation.h>


@interface PDReview : PDItem

@property (assign, nonatomic) BOOL showFullDescription;
@property (assign, nonatomic) NSInteger userID;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSDate *date;
@property (assign, nonatomic) NSUInteger rating;

- (void)loadFromDictionary:(NSDictionary *)dictionary;

@end
