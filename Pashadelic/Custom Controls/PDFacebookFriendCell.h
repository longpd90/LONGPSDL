//
//  PDFacebookFriendCell.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDUserCell.h"
#import "PDFacebookFriend.h"

@interface PDFacebookFriendCell : UITableViewCell

@property (weak, nonatomic) PDFacebookFriend *facebookFriend;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userAvatarImageView;
@property (weak, nonatomic) IBOutlet UIButton *inviteButton;

- (IBAction)inviteUser:(id)sender;

@end
