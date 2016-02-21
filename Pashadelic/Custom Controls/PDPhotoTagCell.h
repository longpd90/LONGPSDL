//
//  PDTagCell.h
//  Pashadelic
//
//  Created by Linh on 2/18/13.
//
//

#import "PDTextField.h"

@class PDPhotoTagCell;

@protocol PDTagCellDelegate <NSObject>
- (void)tagCellAction:(PDPhotoTagCell *)cell;
@end

@interface PDPhotoTagCell : UITableViewCell
<UITextFieldDelegate>

@property (weak, nonatomic) id <PDTagCellDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIButton *tagCellActionButton;
@property (weak, nonatomic) IBOutlet UIView *contentCellView;
@property (weak, nonatomic) IBOutlet UILabel *tagNameLabel;

- (IBAction)tagCellActionButtonTouch:(id)sender;
- (void)setContentForCell:(NSString *)tagName;

@end
