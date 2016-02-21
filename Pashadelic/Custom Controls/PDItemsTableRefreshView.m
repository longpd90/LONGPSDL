//
//  PDItemsTableRefreshView.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 17.12.12.
//
//

#import "PDItemsTableRefreshView.h"

@implementation PDItemsTableRefreshView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[self resetView];

    }
    return self;
}

- (void)awakeFromNib
{
	[super awakeFromNib];
    _activityIndicatorView = [[LTTActivitiIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    [self addSubview:_activityIndicatorView];
    _radialProgressActivityIndicator = [[LTTRadialProgressActivityIndicator alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [self addSubview:_radialProgressActivityIndicator];
	[self resetView];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
    _activityIndicatorView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    _activityIndicatorView.hidden = !(_state == PDItemsTableRefreshViewStateLoading);

}

- (void)resetView
{
	self.state = -1;
	[self setState:PDItemsTableRefreshViewStateNormal animated:NO];
}

- (void)setState:(NSInteger)state
{
	[self setState:state animated:NO];
}
- (void)setProgress:(float)progress
{
    _radialProgressActivityIndicator.progress = progress;
    CGPoint center = CGPointMake(self.frame.size.width / 2, self.frame.size.height * progress / 2);
    _radialProgressActivityIndicator.center = center;
}

- (void)setState:(NSInteger)state animated:(BOOL)animated
{
	if (state == _state) return;
	
	switch (state) {
		case PDItemsTableRefreshViewStateNormal: {
			_activityIndicatorView.hidden = YES;
            _radialProgressActivityIndicator.hidden = NO;
			break;
		}
			
		case PDItemsTableRefreshViewStateRelease: {
			_activityIndicatorView.hidden = YES;
            _radialProgressActivityIndicator.hidden = NO;
            _radialProgressActivityIndicator.progress = 1.0;
			break;
		}
			
		case PDItemsTableRefreshViewStateLoading:
			_activityIndicatorView.hidden = NO;
            _radialProgressActivityIndicator.progress = 0;
            _radialProgressActivityIndicator.hidden = YES;
			break;
			
			
		default:
			break;
	}
	_state = state;
}

@end
