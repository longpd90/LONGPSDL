//
//  PDTagSuggestionCell.h
//  Pashadelic
//
//  Created by LongPD on 8/13/13.
//
//

#import <UIKit/UIKit.h>

@interface PDTagSuggestionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *tagNameLabel;
@property (weak, nonatomic) IBOutlet UIView *backgroundViewCell;
- (void)setcontentForCell:(NSString *)tagName;

@end
