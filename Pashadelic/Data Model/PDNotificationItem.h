//
//  PDFeedItem.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 12.11.12.
//
//

#import "PDItem.h"
#import "PDPlan.h"


enum PDFeedTargetType {
	PDFeedTargetTypePhoto = 0,
	PDFeedTargetTypeUser
	};

enum PDEventType {
	PDEventTypeLike = 0,
	PDEventTypePin,
	PDEventTypeComment,
	PDEventTypeReply,
	PDEventTypePopular,
    PDEventTypeFeature,
	PDEventTypeFBPosted,
	PDEventTypeFollow,
	PDEventTypeFBUserJoin,
	PDEventTypeGoogleUserJoin,
	PDEventTypeBadgeGained,
	PDEventTypePOI,
    PDEventTypePlan
};

@protocol PDPlanDelegate <NSObject>

- (void)showPlan:(PDPlan *)plan;

@end
@interface PDNotificationItem : PDItem

@property (nonatomic, assign) BOOL checked;
@property (strong, nonatomic) NSDate *created;
@property (strong, nonatomic) NSString *text;
@property (nonatomic, assign) NSUInteger targetType;
@property (nonatomic, assign) NSUInteger feedType;
@property (nonatomic, assign) NSUInteger targetID;
@property (nonatomic, assign) NSUInteger sourceID;
@property (strong, nonatomic) NSString *targetImageURL;
@property (strong, nonatomic) NSString *targetIconURL;
@property (strong, nonatomic) NSString *sourceImageURL;
@property (strong, nonatomic) PDPhoto *photoItem;
@property (strong, nonatomic) PDPlan *planItem;
@end
