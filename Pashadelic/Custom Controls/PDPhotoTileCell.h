//
//  PDPhotoTileCell.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 26/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDPhotoTileView.h"

#define kPDPhotoTileCellHeight		107
#define kPDPhotoTileViewWidth     106
#define kPDPhotoTileViewHeight		106

@interface PDPhotoTileCell : UITableViewCell

@property (strong, nonatomic) NSArray *photoViews;
@property (strong, nonatomic) NSArray *photoViewsArray;
@property (strong, nonatomic) NSArray *photos;
@property (weak, nonatomic) id <PDPhotoViewDelegate> photoViewDelegate;

- (void)initCell;
@end
