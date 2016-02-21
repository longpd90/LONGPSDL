//
//  PDHelpView.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 27.05.13.
//
//

#import <UIKit/UIKit.h>

@interface PDHelpView : UIView
{
	NSUInteger currentItemIndex;
}

@property (strong, nonatomic) UIImageView *foregroundImageView;
@property (strong, nonatomic) UIImageView *helpImageView;
@property (strong, nonatomic) UILabel *helpLabel;
@property (strong, nonatomic) UIButton *nextButton;
@property (strong, nonatomic) NSArray *items;

- (void)showHelp;
- (void)hideHelp;
- (void)showHelpForIndex:(NSUInteger)index;
- (void)showNextHelpItem;

@end
