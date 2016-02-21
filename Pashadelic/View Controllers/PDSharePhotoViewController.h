//
//  PDSharePhotoViewController.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 8/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDViewController.h"
#import "PDItem.h"

@interface PDSharePhotoViewController : PDViewController

@property (weak, nonatomic) PDPhoto *photo;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *photoTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *shareTextLabel;

- (IBAction)shareWithFacebook:(id)sender;
- (IBAction)shareWithTwitter:(id)sender;

@end
