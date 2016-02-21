//
//  PDTipDescription.h
//  Pashadelic
//
//  Created by LongPD on 6/10/14.
//
//

#import <UIKit/UIKit.h>

@interface PDTipDescription : UIView
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UILabel *tipTileLabel;

- (void)setTipDescription:(NSString *)tipTile;

@end
