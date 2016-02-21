//
//  PDSlidesControl.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 03.02.13.
//
//

#import <UIKit/UIKit.h>

@interface PDSlidesControl : UIView
{
	BOOL isAnimating;
}

@property (strong, nonatomic) NSArray *items;
@property (strong, nonatomic) UIImageView *currentImage;
@property (strong, nonatomic) UIImageView *nextImage;
@property (strong, nonatomic) UIButton *leftButton;
@property (strong, nonatomic) UIButton *rightButton;
@property (strong, nonatomic) UILabel *noPhotosLabel;
@property (nonatomic) NSInteger currentIndex;

- (void)showPreviousSlide;
- (void)showNextSlide;
- (void)resetView;
- (void)loadCurrentImage;

@end
