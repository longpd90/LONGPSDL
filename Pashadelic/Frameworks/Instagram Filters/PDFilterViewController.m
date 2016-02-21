//
//  ApplyFilter.m
//  Instagram_Filter
//
//  Created by Jin on 30/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDFilterViewController.h"
#import "FTImageView.h"
#import "PDPhotoLandmarkViewController.h"

@interface PDFilterViewController (Private)

- (void)actionOnButton:(id)sender;
- (void)finishEdit;
- (void)cancelEdit;

@end

@implementation PDFilterViewController
@synthesize filteredImageView;
@synthesize delegate;
@synthesize groupFilterButton;
@synthesize selectedFilterBorder;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
	}
	return self;
}

- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
	[self.filteredImageView clearFiltersBuffer];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
	[super viewDidLoad];
	[self.view setBackgroundColor:[UIColor blackColor]];
	[self setLeftBarButtonToBackWithStyle:kPDLeftBarButtonStyleGrayAngle];
	[self setRightBarButtonToButton:[self redBarButtonWithTitle:NSLocalizedString(@"next", nil)
																											 action:@selector(finishEdit)]];
	
	[self initTitleButtons];
	[self hideIndicator];
	self.rotateImage = 1;
	
	//    init ImageView
	CGRect applicationFrame =  [[UIScreen mainScreen] applicationFrame];
	self.filteredImageView = [[FTImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.origin.y, self.view.width, applicationFrame.size.height-44-90)];
	[self.filteredImageView setContentMode:UIViewContentModeScaleAspectFit];
	self.filteredImageView.isCanActive = YES;
	[self.view addSubview:self.filteredImageView];
	
	[self.filteredImageView addSubview:self.activityIndicator];
	
	if (self.photo) {
		[self setPhoto:self.photo];
	}
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	self.filteredImageView = nil;
	self.groupFilterButton = nil;
	self.selectedFilterBorder = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

- (PDNavigationBarStyle)defaultNavigationBarStyle
{
	return PDNavigationBarStyleWhite;
}

- (BOOL)prefersStatusBarHidden
{
	return NO;
}

- (void)dealloc
{
	self.photo = nil;
	self.filteredImageView = nil;
	self.scrollViewFilter = nil;
}

#pragma mark - private

- (void)initTitleButtons
{
	int titleButtonWidth = 90, titleViewHeight = 37;
	UIView *tlView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 180, 40)];// Here you can set View width and height as per your requirement for displaying titleImageView position in navigationbar
	NSDictionary *grayAttributes = @{NSForegroundColorAttributeName:kPDGlobalGrayColor};
	tlView.layer.cornerRadius = 4;
	[tlView setBackgroundColor:[UIColor clearColor]];
	
	UIView *titleButtonsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, titleButtonWidth * 2, titleViewHeight)];
	titleButtonsView.backgroundColor = [UIColor whiteColor];
	UIButton *rotateButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, titleButtonWidth, titleViewHeight)];
	[rotateButton addTarget:self action:@selector(btnRotateClicked) forControlEvents:UIControlEventTouchUpInside];
	[rotateButton setFontAwesomeIconForImage:[FAKFontAwesome repeatIconWithSize:20] forState:UIControlStateNormal attributes:grayAttributes];
	[titleButtonsView addSubview:rotateButton];
	
	self.groupFilterButton = [[UIButton alloc] initWithFrame:CGRectMake(titleButtonWidth, 0, titleButtonWidth, titleViewHeight)];
	[self.groupFilterButton setFontAwesomeIconForImage:[FAKFontAwesome adjustIconWithSize:20] forState:UIControlStateNormal attributes:grayAttributes];
	[groupFilterButton addTarget:self action:@selector(groupFilterButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[self setStateGroupFilterButtonForMode:PDImageFilterModeFinger];
	groupFilterButton.frame = CGRectMake(titleButtonWidth, 0, titleButtonWidth, titleViewHeight);
	[titleButtonsView addSubview:groupFilterButton];
	[tlView addSubview:titleButtonsView];
	self.navigationItem.titleView = tlView;
}

- (void)creatFilterBar
{
	self.scrollViewFilter = [[PDScrollViewFilter alloc] initWithFrame:CGRectMake(0, self.filteredImageView.frame.size.height, self.view.frame.size.width, 90)
																													withImage:self.photo.image];
	[self.view addSubview:self.scrollViewFilter];
	
	//    init selected filter border
	self.selectedFilterBorder = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selected_filter_border.png"]];
	self.selectedFilterBorder.frame = CGRectMake(0, 0, 60, 60);
	[self.selectedFilterBorder setUserInteractionEnabled:NO];
	
	int width = 5 ;
	for (int i=0; i < 16; i++) {
		UIButton *btnChoseFilter = [[UIButton alloc] initWithFrame:CGRectMake(width, 20, 60, 60)];
		btnChoseFilter.backgroundColor = [UIColor clearColor];
		[btnChoseFilter addTarget:self action:@selector(actionOnButton:) forControlEvents:UIControlEventTouchUpInside];
		btnChoseFilter.tag=i;
		[self.scrollViewFilter addSubview:btnChoseFilter];
		[self.scrollViewFilter bringSubviewToFront:btnChoseFilter];
		width += 80;
		if (i==0) {
			UIView *labelResetView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
			labelResetView.backgroundColor = [UIColor blackColor];
			labelResetView.alpha = 0.6;
			[btnChoseFilter addSubview:labelResetView];
			
			UILabel *labelReset = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 56, 20)];
			[labelReset setBackgroundColor:[UIColor clearColor]];
			labelReset.textColor = [UIColor whiteColor];
			labelReset.textAlignment = NSTextAlignmentCenter;
			labelReset.text = @"Reset";
			labelReset.font = [UIFont fontWithName:PDGlobalBoldFontName size:12];
			[btnChoseFilter addSubview:labelReset];
			[btnChoseFilter addSubview:self.selectedFilterBorder];
		}
	}
}

- (void)setPhoto:(PDPhoto *)photo
{
	_photo = photo;
	if (!photo) return;
	if ([self isViewLoaded]) {
		[self.filteredImageView setImageInput:photo.image];
		[self performSelector:@selector(creatFilterBar) withObject:nil];
	}
}

- (void)showIndicator
{
	[self.view setUserInteractionEnabled:NO];
	[self.activityIndicator setHidden:NO];
	[self.activityIndicator startAnimating];
}

- (void)hideIndicator
{
	[self.view setUserInteractionEnabled:YES];
	[self.activityIndicator setHidden:YES];
	[self.activityIndicator stopAnimating];
}

- (void)btnRotateClicked
{
	for (int i = 0; i < [self.scrollViewFilter.arrayImageFilter count]; i ++ ) {
		UIImageView *awesomeView = (UIImageView *)[self.scrollViewFilter.arrayImageFilter objectAtIndex:i];
		awesomeView.transform = CGAffineTransformMakeRotation(M_PI_2 * (self.rotateImage % 4));
		[self.scrollViewFilter sendSubviewToBack:awesomeView];
	}
	if (filteredImageView.isCanActive) {
		filteredImageView.isCanActive = NO;
		[self.filteredImageView rotateImage];
	}
	self.rotateImage ++;
}

#pragma mark - Group Filter

- (void)groupFilterButtonClicked
{
	if (self.filteredImageView.isCanActive) {
		self.filteredImageView.isCanActive = NO;
		switch (self.filteredImageView.filterMode) {
			case PDImageFilterModeFinger:
				[self.filteredImageView changeFilterMode:PDImageFilterModeTiltShiftCircle];
				break;
			case PDImageFilterModeTiltShiftCircle:
				[self.filteredImageView changeFilterMode:PDImageFilterModeTiltShiftSquare];
				break;
			case PDImageFilterModeTiltShiftSquare:
				[self.filteredImageView changeFilterMode:PDImageFilterModeFinger];
			default:
				break;
		}
		[self setStateGroupFilterButtonForMode:self.filteredImageView.filterMode];
	}
}

- (void)setStateGroupFilterButtonForMode:(PDImageFilterMode)filterMode
{
	NSDictionary *grayAttributes = @{NSForegroundColorAttributeName:kPDGlobalGrayColor};
	switch (filterMode) {
		case PDImageFilterModeFinger:
			[self.groupFilterButton setFontAwesomeIconForImage:[FAKFontAwesome adjustIconWithSize:20] forState:UIControlStateNormal attributes:grayAttributes];
			break;
		case PDImageFilterModeTiltShiftSquare:
			[self.groupFilterButton setFontAwesomeIconForImage:[FAKFontAwesome minusCircleIconWithSize:20] forState:UIControlStateNormal attributes:grayAttributes];
			break;
		case PDImageFilterModeTiltShiftCircle:
			[self.groupFilterButton setFontAwesomeIconForImage:[FAKFontAwesome dotCircleOIconWithSize:20] forState:UIControlStateNormal attributes:grayAttributes];
			break;
		default:
			break;
	}
}

#pragma mark - Filter

- (void)actionOnButton:(id)sender
{
	if (filteredImageView.isCanActive) {
		filteredImageView.isCanActive = NO;
		UIButton *btn = (UIButton *)sender;
		NSInteger tag = btn.tag;
		if ([self.selectedFilterBorder superview]) {
			[self.selectedFilterBorder removeFromSuperview];
		}
		if (tag == 0) {
			// reset filter mode to Finger when click reset
			[self.filteredImageView changeFilterMode:PDImageFilterModeFinger];
			[self setStateGroupFilterButtonForMode:PDImageFilterModeFinger];
		}
		[sender addSubview:self.selectedFilterBorder];
		[self.scrollViewFilter bringSubviewToFront:sender];
		[self.filteredImageView filteredImageAtIndex:tag];
	}
}

- (void)cancelEdit
{
	if (delegate) {
		[delegate filterDidCancel];
	}
}

- (void)finishEdit
{
	PDPhotoLandmarkViewController *photoLandMarkViewController = [[PDPhotoLandmarkViewController alloc] initForUniversalDevice];
	self.photo.image = self.filteredImageView.image;
	photoLandMarkViewController.photo = self.photo;
    photoLandMarkViewController.filteredImage = self.filteredImageView.image;
	[self.navigationController pushViewController:photoLandMarkViewController animated:YES];
}

#pragma mark - Touch Delegate

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self.scrollViewFilter setUserInteractionEnabled:NO];
	[self.filteredImageView touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self.filteredImageView touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self.filteredImageView touchesEnded:touches withEvent:event];
	[self.scrollViewFilter setUserInteractionEnabled:YES];
}

- (NSString *)pageName
{
	return @"Photo Filter";
}

@end
