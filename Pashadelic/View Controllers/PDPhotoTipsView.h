//
//  PDPhotoTipsView.h
//  Pashadelic
//
//  Created by LongPD on 3/10/14.
//
//

#import <UIKit/UIKit.h>
@class PDPhotoTipsView;
@protocol PDPhotoTipsViewDelegate <NSObject>

- (void)showTitleTip:(PDPhotoTipsView *)tipView;
@end

@interface PDPhotoTipsView : UIView
@property (weak, nonatomic)id<PDPhotoTipsViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIButton *showTileButton;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (strong, nonatomic) NSString *titleTip;
- (IBAction)showTile:(UIButton *)sender;
- (void)setcontentImage:(UIImage *)image withTitle:(NSString *)tile;
@end
