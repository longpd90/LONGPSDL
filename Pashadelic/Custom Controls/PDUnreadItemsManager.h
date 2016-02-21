//
//  PDUnreadItemsManager.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 14.01.13.
//
//

#import <Foundation/Foundation.h>

#define MaxOneDigitNumber     9
#define MaxTwoDigitsNumber    99
#define MaxThreeDigitsNumber  999

@interface PDUnreadItemsManager : NSObject

@property (nonatomic, assign) NSInteger unreadItemsCount;
@property (nonatomic, assign) NSInteger upcomingPlanCount;



+ (PDUnreadItemsManager *)instance;
- (void)fetchData;
- (void)initialize;
- (void)refreshAppBadgeCount;
- (void)reset;

@end
