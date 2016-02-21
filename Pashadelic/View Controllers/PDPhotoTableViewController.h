//
//  PDPhotoTableViewController.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 19.02.13.
//
//

#import "PDTableViewController.h"
#import "PDPhotosTableView.h"
#import "PDCollectionsViewController.h"
#import "PDPhotoSpotViewController.h"
#import "PDNavigationController.h"

@interface PDPhotoTableViewController : PDTableViewController <PDPhotoViewDelegate>
{
	BOOL isAnimationDone;
}

@property (strong, nonatomic) PDPhotosTableView *photosTableView;
@property (strong, nonatomic) PDPhotoSpotViewController *photoViewController;
@property (strong, nonatomic) UIView *fadeView;
@property (strong, nonatomic) UIImageView *photoThumbnailImageView;

- (void)initPhotosTable;
- (void)addPhototoCollection:(PDPhoto *)photo;
- (void)applyOffsetToInitialThumbnailFrame;
@end
