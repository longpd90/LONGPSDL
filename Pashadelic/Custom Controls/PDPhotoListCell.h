//
//  PDPhotoListCell.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 11/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define kPDPhotoListCellDetailsHeight 30 + 16

@interface PDPhotoListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userAvatarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *pinButton;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) PDPhoto *photo;
@property (weak, nonatomic) PDUser *user;
@property (weak, nonatomic) IBOutlet UIView *overlayView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
- (void)setItem:(id)item;
- (IBAction)likePhoto:(id)sender;
- (IBAction)pinPhoto:(id)sender;
- (IBAction)userButtonTouch:(id)sender;
- (void)loadImages;

@end
