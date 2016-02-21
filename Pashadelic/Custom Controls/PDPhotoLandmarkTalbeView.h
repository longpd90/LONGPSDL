//
//  PDPhotoLandmarkTalbeView.h
//  Pashadelic
//
//  Created by LongPD on 6/16/14.
//
//

#import "PDItemsTableView.h"
#import "PDPhotoLandmarkCell.h"

@interface PDPhotoLandmarkTalbeView : PDItemsTableView
@property (weak, nonatomic) id <PDPhotoViewDelegate> photoViewDelegate;

@end
