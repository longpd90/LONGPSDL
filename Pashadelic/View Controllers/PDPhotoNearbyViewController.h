//
//  PDSpotNearbyViewController.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 11/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDNearbyViewController.h"

@interface PDPhotoNearbyViewController : PDNearbyViewController

@property (weak, nonatomic) PDPhoto *photo;
@property (weak, nonatomic) IBOutlet UIImageView *sourcePhotoImageView;
@property (weak, nonatomic) IBOutlet UIButton *captionButton;
@property (weak, nonatomic) IBOutlet UIView *buttonsView;
@property (weak, nonatomic) IBOutlet UIView *buttonsShadowView;

@end
