//
//  PDItemsTableRefreshView.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 17.12.12.
//
//

#import <UIKit/UIKit.h>
#import "LTTActivitiIndicatorView.h"
#import "LTTRadialProgressActivityIndicator.h"

enum PDItemsTableRefreshViewState {
	PDItemsTableRefreshViewStateNormal = 0,
	PDItemsTableRefreshViewStateRelease,
	PDItemsTableRefreshViewStateLoading
	};

#define kPDItemsTableRefreshViewDefaultHeight		60

@interface PDItemsTableRefreshView : UIView

@property (nonatomic) NSInteger state;
@property (strong, nonatomic) LTTActivitiIndicatorView *activityIndicatorView;
@property (strong, nonatomic) LTTRadialProgressActivityIndicator *radialProgressActivityIndicator;
- (void)resetView;
- (void)setState:(NSInteger)state animated:(BOOL)animated;
- (void)setProgress:(float)progress;
@end
