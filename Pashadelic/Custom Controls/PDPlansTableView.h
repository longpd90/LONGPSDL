//
//  PDPlansTable.h
//  Pashadelic
//
//  Created by LongPD on 11/7/13.
//
//

#import "PDItemsTableView.h"
#import "PDPlansTableViewCell.h"

@interface PDPlansTableView : PDItemsTableView

@property (weak, nonatomic) id <PDPhotoViewDelegate> photoViewDelegate;
@property BOOL noPlan;

@end
