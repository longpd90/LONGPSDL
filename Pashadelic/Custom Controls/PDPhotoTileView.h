//
//  PDPhotoTileView.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 26/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "PDServerPhotoLoader.h"
#import "PDDynamicFontLabel.h"
@interface PDPhotoTileView : UIImageView

@property (strong, nonatomic) PDPhoto *photo;
@property (weak, nonatomic) id <PDPhotoViewDelegate> delegate;
@property (strong, nonatomic) UIView *overlayView;
@property (strong, nonatomic) PDDynamicFontLabel *inprocessLabel;

@end
