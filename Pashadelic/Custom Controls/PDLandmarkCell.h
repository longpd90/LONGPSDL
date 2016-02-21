//
//  PDLandmarkCell.h
//  Pashadelic
//
//  Created by TungNT2 on 7/23/13.
//
//

#import <UIKit/UIKit.h>
#import "PDPOIItem.h"
#import "PDGlobalFontLabel.h"
#define offsetLeft 57

@interface PDLandmarkCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *photoUnitLabel;
@property (weak, nonatomic) IBOutlet UIView *backgroundLabelView;
@property (weak, nonatomic) IBOutlet UILabel *unitDistanceLabel;
@property (strong, nonatomic) IBOutlet PDGlobalFontLabel *landmarkNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *photoCountsLabel;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewItem;
@property (weak, nonatomic) IBOutlet UIImageView *compassImageView;

- (void)setPOI:(PDPOIItem *)poiItem;


@end
