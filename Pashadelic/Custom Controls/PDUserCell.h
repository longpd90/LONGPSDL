//
//  PDReviewCell.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 11/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PDFollowItemButton.h"
#import "MGGradientView.h"

@interface PDUserCell : UITableViewCell

@property (weak, nonatomic) PDUser *user;
@property (weak, nonatomic) IBOutlet UIImageView *userAvatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet PDFollowItemButton *followButton;
@property (strong, nonatomic) NSArray *userImages;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

- (void)refreshCell;
- (void)loadUserPhotos;

@end
