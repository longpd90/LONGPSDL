//
//  PDPhotoListCell.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 11/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDPhotoListCell.h"
#import "PDViewController.h"
#import "PDPhotoTableViewController.h"
#import "UIImage+Extra.h"
#import "PDActivityItem.h"

@interface PDPhotoListCell (Private)
- (void)refreshPhotoStatus;
- (void)initCell;
@end

@implementation PDPhotoListCell

- (void)awakeFromNib
{
	[self initCell];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		[self initCell];
	}
	return self;
}

- (void)initCell
{
	self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[self.photoImage addSubview:self.activityIndicator];
	self.photoImage.backgroundColor = [UIColor lightGrayColor];
  
	CGFloat fontSize = 24;
	[self.likeButton setBackgroundImage:[[[UIImage alloc] init] imageWithColor:[UIColor colorWithWhite:0 alpha:0.5]] forState:UIControlStateNormal];
	[self.likeButton setBackgroundImage:[[[UIImage alloc] init] imageWithColor:[UIColor colorWithWhite:0 alpha:0.3]] forState:UIControlStateHighlighted];
	[self.likeButton setBackgroundImage:[[[UIImage alloc] init] imageWithColor:[UIColor colorWithWhite:0 alpha:0.7]] forState:UIControlStateSelected];
	[self.pinButton setBackgroundImage:[[[UIImage alloc] init] imageWithColor:[UIColor colorWithWhite:0 alpha:0.5]] forState:UIControlStateNormal];
	[self.pinButton setBackgroundImage:[[[UIImage alloc] init] imageWithColor:[UIColor colorWithWhite:0 alpha:0.3]] forState:UIControlStateHighlighted];
	[self.pinButton setBackgroundImage:[[[UIImage alloc] init] imageWithColor:[UIColor colorWithWhite:0 alpha:0.7]] forState:UIControlStateSelected];
	
	self.pinButton.layer.cornerRadius = self.likeButton.layer.cornerRadius = 5;
	
	[self.likeButton setFontAwesomeIconForImage:[FAKFontAwesome thumbsOUpIconWithSize:fontSize]
																		 forState:UIControlStateNormal
																	 attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
	[self.likeButton setFontAwesomeIconForImage:[FAKFontAwesome thumbsUpIconWithSize:fontSize]
																		 forState:UIControlStateSelected
																	 attributes:@{NSForegroundColorAttributeName: kPDGlobalGreenColor}];
	
	[self.pinButton setFontAwesomeIconForImage:[FAKFontAwesome folderOpenOIconWithSize:fontSize - 2]
																		forState:UIControlStateNormal
																	attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
	[self.pinButton setFontAwesomeIconForImage:[FAKFontAwesome folderIconWithSize:fontSize - 2]
																		forState:UIControlStateSelected
																	attributes:@{NSForegroundColorAttributeName: kPDGlobalGreenColor}];
    self.overlayView.hidden = YES;
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPhotoStatus) name:kPDPhotoStatusChangedNotification object:nil];
}

- (void)loadImages
{
	[self.photoImage sd_cancelCurrentImageLoad];
  UIImage *image = self.photo.cachedFullImage;
  if (image) {
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = YES;
    self.photoImage.image = image;
		[self.userAvatarImageView sd_setImageWithURL:self.user.thumbnailURL];
    return;
    
  } else {
    image = self.photo.cachedThumbnailImage;
  }
  
	[self.activityIndicator startAnimating];
	self.activityIndicator.hidden = NO;
	[self.photoImage sd_setImageWithURL:self.photo.fullImageURL placeholderImage:image completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
		[self.activityIndicator stopAnimating];
		self.activityIndicator.hidden = YES;
	}];
	
	[self.userAvatarImageView sd_setImageWithURL:self.user.thumbnailURL];
}

- (void)setItem:(id)item
{
    if ([item isKindOfClass:[PDActivityItem class]])
        self.user = [(PDActivityItem *)item userActivity];
    else
        self.user = [(PDPhoto *)item user];
    
    self.photo = (PDPhoto *)item;
    
}

- (void)setPhoto:(PDPhoto *)photo
{
	_photo = photo;
	if (!photo) return;
	self.photoImage.height = self.photo.photoListImageSize.height;
	self.pinButton.y = self.likeButton.y = self.photoImage.bottomYPoint - self.pinButton.height - 10;
	
	self.activityIndicator.center = self.photoImage.centerOfView;
	self.usernameLabel.text = self.user.name;
	self.usernameLabel.width = [self.usernameLabel sizeThatFits:CGSizeMake(MAXFLOAT, self.usernameLabel.height)].width;
	self.locationLabel.x = self.usernameLabel.rightXPoint + 6;
	self.locationLabel.width = self.width - self.locationLabel.x - 10;
	if ([photo isKindOfClass:[PDActivityItem class]]) {
		self.locationLabel.text = [(PDActivityItem *) self.photo actionTitle];
	} else {
		self.locationLabel.text = self.photo.location;
	}
	self.usernameLabel.width = self.width - self.usernameLabel.x;

	[self refreshPhotoStatus];
	[self loadImages];
    
}

- (void)refreshPhotoStatus
{
	if (self.photo.user.identifier == kPDUserID) {
		self.pinButton.enabled = self.likeButton.enabled = NO;
		self.pinButton.alpha = self.likeButton.alpha = 0.3;
		
	} else {
		self.pinButton.enabled = self.likeButton.enabled = YES;
		self.pinButton.alpha = self.likeButton.alpha = 1;
	}
	
	self.likeButton.selected = self.photo.likedStatus;
	self.pinButton.selected = self.photo.pinnedStatus;
}

- (IBAction)likePhoto:(id)sender
{
  if (!self.photo.likedStatus) {
    [(PDViewController *) self.firstViewController trackEvent:@"Like"];
	} else {
    [(PDViewController *) self.firstViewController trackEvent:@"Unlike"];
	}
	[self.photo likePhoto];
}

- (IBAction)pinPhoto:(id)sender
{
  if (!self.photo.pinnedStatus) {
    [(PDViewController *) self.firstViewController trackEvent:@"Collect"];
		if ([self.firstViewController respondsToSelector:@selector(addPhototoCollection:)]) {
			[self.firstViewController performSelector:@selector(addPhototoCollection:) withObject:self.photo];
		}
		
	} else {
    [(PDViewController *) self.firstViewController trackEvent:@"Uncollect"];
    [self.photo unPinPhoto];
	}
}

- (IBAction)userButtonTouch:(id)sender
{
	if (self.photo.itemDelegate) {
		[self.photo.itemDelegate itemDidSelect:self.user];
	}
}

@end
