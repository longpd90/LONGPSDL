//
//  PDGoogleAnalytics.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 31/10/12.
//
//

#import <Foundation/Foundation.h>
#import "GAI.h"

@interface PDGoogleAnalytics : NSObject

@property (strong, nonatomic) id <GAITracker> tracker;
+ (PDGoogleAnalytics *)sharedInstance;

- (void)trackPage:(NSString *)pageName;
- (void)trackAction:(NSString *)actionName atPage:(NSString *)pageName;

@end
