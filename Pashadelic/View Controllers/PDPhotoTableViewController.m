//
//  PDPhotoTableViewController.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 19.02.13.
//
//

#import "PDPhotoTableViewController.h"
#import "UINavigationController+Extra.h"

@interface PDPhotoTableViewController ()
<PDPhotoSpotViewControllerDataSource>

@property (assign, readwrite, nonatomic) CGRect initialPhotoThumbnailViewFrame;
@property (assign, nonatomic) NSUInteger initialPhotoIndex;
@property (nonatomic) BOOL isNavigationBarHidden;
- (void)initPhotoViewController;
- (void)presentPhotoViewController;
- (void)refreshInitialPhotoThumbnailViewFrameForPhoto:(PDPhoto *)photo;
@end

@implementation PDPhotoTableViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	[self initPhotosTable];
	self.itemsTableView.tableHeaderView = self.toolbarView;
    _isNavigationBarHidden = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	self.navigationBarStyle = self.defaultNavigationBarStyle;
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self showToolbarAnimated:NO];
	self.tablePlaceholderView.height = self.tablePlaceholderView.height + self.tablePlaceholderView.y;
	self.tablePlaceholderView.y = 0;
	self.customNavigationBar.scrollView = self.itemsTableView;
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	self.customNavigationBar.scrollView = nil;
	[self.customNavigationBar resetToDefaultPosition:YES];
}

- (void)dealloc
{
	self.photosTableView = nil;
	self.photoViewController = nil;
	[self.fadeView removeFromSuperview];
	self.fadeView = nil;
	[self.photoThumbnailImageView removeFromSuperview];
	self.photoThumbnailImageView = nil;
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

- (NSString *)pageName
{
	return @"Photo table view";
}

- (void)setItemsTableView:(PDItemsTableView *)itemsTableView
{
	if ([self.itemsTableView isEqual:itemsTableView]) return;
	
	[self.itemsTableView beginUpdates];
	self.itemsTableView.tableHeaderView = nil;
	[self.toolbarView removeFromSuperview];
	[self.itemsTableView endUpdates];
	[super setItemsTableView:itemsTableView];
	self.customNavigationBar.scrollView = self.itemsTableView;
	self.customNavigationBar.tableName = self.pageName;
	self.itemsTableView.tableHeaderView = self.toolbarView;
	self.itemsTableView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
}

- (NSArray *)helpItems
{
	NSArray *array = [super helpItems];
	NSArray *helpItems;
	switch (self.itemsTableView.tableViewMode) {
		case PDItemsTableViewModeList:
			helpItems =	[kPDAppDelegate.helpItems objectForKey:@"List"];
			break;
			
		case PDItemsTableViewModeTile:
			helpItems = [kPDAppDelegate.helpItems objectForKey:@"Tile"];
			break;
      
		default:
			helpItems = nil;
			break;
	}
	
	if (helpItems) {
		array = [array arrayByAddingObjectsFromArray:helpItems];
	}
	
	return array;
}

- (void)applyOffsetToInitialThumbnailFrame
{
	if (!self.customNavigationBar.isShowed) {
		self.initialPhotoThumbnailViewFrame = CGRectWithY(self.initialPhotoThumbnailViewFrame, self.initialPhotoThumbnailViewFrame.origin.y + self.customNavigationBar.height);
	}
}

- (NSArray *)helpID
{
	return [[super helpID] arrayByAddingObject:@"PhotoTableView"];
}

- (void)addPhototoCollection:(PDPhoto *)photo
{
	PDCollectionsViewController *collectionsViewController = [[PDCollectionsViewController alloc] initForUniversalDevice];
	collectionsViewController.photo = photo;
	[kPDAppDelegate.viewDeckController addChildViewController:collectionsViewController];
	collectionsViewController.view.frame = kPDAppDelegate.viewDeckController.view.zeroPositionFrame;
	[kPDAppDelegate.viewDeckController.view addSubview:collectionsViewController.view];
	[collectionsViewController viewWillAppear:YES];
	collectionsViewController.view.y = collectionsViewController.view.height;
	[UIView animateWithDuration:0.2 animations:^{
    collectionsViewController.view.y = collectionsViewController.view.height - collectionsViewController.contentView.height;
	}];
}

- (void)showMainMenu
{
	[super showMainMenu];
	self.photoViewController = nil;
}

#pragma mark - Private

- (void)initPhotosTable
{
	self.photosTableView = [[PDPhotosTableView alloc] initWithFrame:self.tablePlaceholderView.zeroPositionFrame];
	self.photosTableView.itemsTableDelegate = self;
	self.photosTableView.photoViewDelegate = self;
	self.itemsTableView = _photosTableView;
	[self.tablePlaceholderView addSubview:_photosTableView];
}

- (void)initPhotoViewController
{
	self.photoViewController = [[PDPhotoSpotViewController alloc] initForUniversalDevice];
	self.photoViewController.photosDataSource = self;
	if (!self.fadeView) {
		self.fadeView = [[UIView alloc] initWithFrame:self.view.zeroPositionFrame];
		self.fadeView.backgroundColor = [UIColor whiteColor];
		self.fadeView.autoresizingMask = kFullAutoresizingMask;
		self.fadeView.hidden = YES;
		[self.view addSubview:self.fadeView];
	}
	if (!self.photoThumbnailImageView) {
		self.photoThumbnailImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
		self.photoThumbnailImageView.contentMode = UIViewContentModeScaleAspectFill;
		self.photoThumbnailImageView.clipsToBounds = YES;
		self.photoThumbnailImageView.hidden = YES;
		[self.view addSubview:self.photoThumbnailImageView];
	}
}

- (void)showPhoto:(PDPhoto *)photo
{
	if (!self.photoViewController) {
		[self initPhotoViewController];
	}
	if ([self.navigationController.topViewController isEqual:self.photoViewController]) {
		[self.navigationController popViewControllerAnimated:NO];
	}
	
	self.photoViewController.photo = photo;
	self.initialPhotoIndex = [self.items indexOfObject:photo];
	[self.navigationController pushViewController:_photoViewController animated:YES];
}

- (void)presentPhotoViewController
{
	if (!self.photoViewController) {
		[self initPhotoViewController];
	}
	[self.navigationController pushViewController:self.photoViewController animated:NO];
}

- (void)photo:(PDPhoto *)photo didSelectInView:(UIView *)view image:(UIImage *)image
{
	if (_photoViewController) {
		_photoViewController.photosDataSource = nil;
		_photoViewController = nil;
	}
	[self initPhotoViewController];
	
	self.photoViewController.photo = photo;
	self.initialPhotoIndex = [self.items indexOfObject:photo];
  
	self.fadeView.alpha = 0;
	[self.fadeView.superview bringSubviewToFront:self.fadeView];
	self.fadeView.hidden = NO;
	self.initialPhotoThumbnailViewFrame = [self.view convertRect:view.zeroPositionFrame fromView:view];
	
	[self.photoThumbnailImageView.superview bringSubviewToFront:self.photoThumbnailImageView];
	self.photoThumbnailImageView.frame = self.initialPhotoThumbnailViewFrame;
	
	[self applyOffsetToInitialThumbnailFrame];
	
  if (image) {
    self.photoThumbnailImageView.image = image;
  } else {
    self.photoThumbnailImageView.image = view.captureViewToUIImage;
  }
  if (self.customNavigationBar.y < 0)
        _isNavigationBarHidden = YES;
  else
         _isNavigationBarHidden = NO;
  self.photoThumbnailImageView.hidden = NO;
  CGFloat yOffset = 0;
  if (self.navigationController.isNavigationBarHidden) {
    yOffset = self.navigationController.navigationBar.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
  }
	
	[UIView animateWithDuration:0.3 animations:^{
		self.fadeView.alpha = 1;
		self.photoThumbnailImageView.frame =
		CGRectMakeWithSize(0, yOffset, [UIImageView sizeThatFitImageSize:CGSizeMake(photo.photoWidth, photo.photoHeight)
																												 maxViewSize:CGSizeMake(self.view.width, MAXFLOAT)]);
	} completion:^(BOOL finished) {
		if ([self.navigationController.topViewController isEqual:self.photoViewController]) {
			[self.navigationController popViewControllerAnimated:NO];
		}
		[self.navigationController pushViewController:self.photoViewController animated:NO];
		self.fadeView.hidden = YES;
		self.photoThumbnailImageView.hidden = YES;
	}];
}

- (void)refreshInitialPhotoThumbnailViewFrameForPhoto:(PDPhoto *)photo
{
	UIImageView *photoImageView = [(PDPhotosTableView *) self.itemsTableView photoImageViewForPhoto:photo];
	self.initialPhotoThumbnailViewFrame = [self.view convertRect:photoImageView.zeroPositionFrame fromView:photoImageView];
    if (_isNavigationBarHidden) {
        CGRect rect = self.initialPhotoThumbnailViewFrame;
        rect.origin.y = rect.origin.y + self.customNavigationBar.height;
        self.initialPhotoThumbnailViewFrame = rect;
    }
}

#pragma mark - scroll view delegae

- (void)itemsTableDidScrollToTop:(PDItemsTableView *)itemsTableView
{
	[self.customNavigationBar resetToDefaultPosition:YES];
}

- (void)itemsTableDidScroll:(PDItemsTableView *)itemsTableView
{
	if (itemsTableView.contentOffset.y <= itemsTableView.frame.size.height * 2) {
		[self.customNavigationBar hideTopButton];
	}
}

- (void)itemsTableViewDidEndDecelerating:(PDItemsTableView *)itemsTableView
{
	
}

- (void)itemsTableDidScrollToDown:(PDItemsTableView *)itemsTableView
{
	
}

#pragma mark - Photo view data source

- (NSUInteger)numberOfPhotosFor:(PDPhotoSpotViewController *)photoViewController
{
  return self.items.count;
}

- (NSUInteger)indexOfPhoto:(PDPhoto *)photo forPhotoViewController:(PDPhotoSpotViewController *)photoViewController
{
  return [self.items indexOfObject:photo];
}

- (PDPhoto *)photoAtIndex:(NSUInteger)index forPhotoViewController:(PDPhotoSpotViewController *)photoViewController
{
  if (!self.isLoading && self.items.count - index < 3) {
    [self itemsTableWillShowLastCells:self.itemsTableView];
  }
  
  if (index < self.items.count) {
    return self.items[index];
    
  } else {
    return nil;
  }
}

- (void)dismissPhotoViewController:(PDPhotoSpotViewController *)photoViewController withPhoto:(PDPhoto *)photo photoImage:(UIImage *)image photoImageSize:(CGSize)photoImageSize
{
  if ([self.items indexOfObject:photo] == NSNotFound) {
    [self.navigationController popViewControllerAnimated:YES];
    return;
  }
    [photoViewController.itemsTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];

  self.fadeView.hidden = NO;
  [self.fadeView.superview bringSubviewToFront:self.fadeView];
  [self.photoThumbnailImageView.superview bringSubviewToFront:self.photoThumbnailImageView];
  self.photoThumbnailImageView.frame = CGRectMakeWithSize(self.photoThumbnailImageView.x, self.photoThumbnailImageView.y, photoImageSize);
  self.photoThumbnailImageView.image = image;
  self.photoThumbnailImageView.hidden = NO;

  
  if (self.initialPhotoIndex != [self.items indexOfObject:photo]) {
    if ([self.itemsTableView isKindOfClass:[PDPhotosTableView class]]) {
      [(PDPhotosTableView *) self.itemsTableView scrollToPhoto:photo animated:NO];
      [self refreshInitialPhotoThumbnailViewFrameForPhoto:photo];
    }
  }
  [UIView animateWithDuration:0.2 animations:^{
    
  } completion:^(BOOL finished) {
    [self.navigationController popViewControllerAnimated:NO];
    
    [UIView animateWithDuration:0.3 animations:^{
      self.fadeView.alpha = 0;
      self.photoThumbnailImageView.frame = self.initialPhotoThumbnailViewFrame;
      
    } completion:^(BOOL finished) {
      self.fadeView.hidden = YES;
      self.photoThumbnailImageView.hidden = YES;
    }];
  }];
}

- (void)didDeletePhoto
{
	if (self.loading) return;
	[self refetchData];
}
@end
