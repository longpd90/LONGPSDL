//
//  PDPhotoFullScreenView.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 21/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDPhotoActionButton.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+Extra.h"

@protocol PDPhotoImageViewDelegate <NSObject>

- (void)didTouchedImageView;

@end

@interface PDPhotoImageView : UIImageView
{
	NSTimer *hidingTimer;
}
@property (weak, nonatomic)id<PDPhotoImageViewDelegate>delegate;
@property (weak, nonatomic) PDPhoto *photo;
@end
