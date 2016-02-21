//
//  PDCollectionCell.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 12.07.13.
//
//

#import <UIKit/UIKit.h>
#import "PDPhotoCollection.h"

@interface PDCollectionCell : UITableViewCell

@property (weak, nonatomic) PDPhotoCollection *collection;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@end
