//
//  PDAppRater.h
//  Pashadelic
//
//  Created by TungNT2 on 4/4/14.
//
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@class PDAppRater;

@protocol PDAppRaterDelegate <NSObject>
@optional
-(void)appRaterDidDisplayAlert:(PDAppRater *)appRater;
-(void)appRaterDidDeclineToRate:(PDAppRater *)appRater;
-(void)appRaterDidOptToRate:(PDAppRater *)appRater;
-(void)appRaterDidOptToRemindLater:(PDAppRater *)appRater;
-(void)appRaterWillPresentModalView:(PDAppRater *)appRater animated:(BOOL)animated;
-(void)appRaterDidDismissModalView:(PDAppRater *)appRater animated:(BOOL)animated;
@end

extern NSString *const kPDAppRaterFirstUseDate;
extern NSString *const kPDAppRaterUseCount;
extern NSString *const kPDAppRaterSignificantEventCount;
extern NSString *const kPDAppRaterCurrentVersion;
extern NSString *const kPDAppRaterRatedCurrentVersion;
extern NSString *const kPDAppRaterRatedAnyVersion;
extern NSString *const kPDAppRaterDeclinedToRate;
extern NSString *const kPDAppRaterReminderRequestDate;

extern NSString *const kPDAppRaterMessageTitleKey;
extern NSString *const kPDAppRaterMessageKey;
extern NSString *const kPDAppRaterUpdateMessageKey;
extern NSString *const kPDAppRaterCancelButtonKey;
extern NSString *const kPDAppRaterRemindButtonKey;
extern NSString *const kPDAppRaterRateButtonKey;

@interface PDAppRater : NSObject <UIAlertViewDelegate, SKStoreProductViewControllerDelegate> {
    
	UIAlertView		*ratingAlert;
}

@property(nonatomic, strong) UIAlertView *ratingAlert;
@property(nonatomic) BOOL openInAppStore;
#if __has_feature(objc_arc_weak)
@property(nonatomic, weak) NSObject <PDAppRaterDelegate> *delegate;
#else
@property(nonatomic, unsafe_unretained) NSObject <PDAppDelegate> *delegate;
#endif

@property (nonatomic, strong) NSString *applicationName;
@property (nonatomic, strong) NSString *applicationVersion;

+ (void)appLaunched:(BOOL)canPromptForRating;
+ (void)appEnteredForeground:(BOOL)canPromptForRating;
+ (void)userDidSignificantEvent:(BOOL)canPromptForRating;
+ (void)tryToShowPrompt;
+ (void)forceShowPrompt:(BOOL)displayRateLaterButton;
+ (void)rateApp;
+ (void)closeModal;
@end

@interface PDAppRater (Configuration)

+ (void)setAppId:(NSString *)appId;
+ (void)setApplicationName:(NSString *)applicationName;
+ (void)setApplicationVersion:(NSString *)applicationVersion;
+ (void)setMessageTile:(NSString *)messageTile;
+ (void)setMessage:(NSString *)message;
+ (void)setUpdateMessage:(NSString *)updateMessage;
+ (void)setRateButtonLabel:(NSString *)rateButtonLabel;
+ (void)setRemindButtonLabel:(NSString *)remindButtonLabel;
+ (void)setCancelButtonLabel:(NSString *)cancelButtonLabel;
+ (void)setDaysUntilPrompt:(double)value;
+ (void)setUsesUntilPrompt:(NSInteger)value;
+ (void)setSignificantEventsUntilPrompt:(NSInteger)value;
+ (void)setTimeBeforeReminding:(double)value;
+ (void)setDebug:(BOOL)debug;
+ (void)setDelegate:(id<PDAppRaterDelegate>)delegate;
+ (void)setUsesAnimation:(BOOL)animation;
+ (void)setOpenInAppStore:(BOOL)openInAppStore;
@end