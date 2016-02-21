//
//  PDFeedItem.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 25.09.13.
//
//

#import "PDPhoto.h"
#import "UIImageView+Extra.h"

@interface PDActivityItem : PDPhoto

@property (strong, nonatomic) NSString *actionTitle;
@property (strong, nonatomic) NSArray *listOfID;
@property (strong, nonatomic) PDUser *userActivity;
@end
