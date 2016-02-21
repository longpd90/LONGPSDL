//
//  PDTagCell.m
//  Pashadelic
//
//  Created by Linh on 2/18/13.
//
//

#import "PDPhotoTagCell.h"

@implementation PDPhotoTagCell

@synthesize tagCellActionButton, delegate;

- (IBAction)tagCellActionButtonTouch:(id)sender
{
	if (delegate) {
		[delegate tagCellAction:self];
	}
}

- (void)setContentForCell:(NSString *)tagName
{
    self.backgroundColor = [UIColor clearColor];
    self.tagNameLabel.text = tagName;
    [self.tagNameLabel setFont:[UIFont fontWithName:PDGlobalNormalFontName size:15]];
    
    CGSize sizeTagName = [tagName sizeWithFont:_tagNameLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, _tagNameLabel.height) lineBreakMode:NSLineBreakByCharWrapping];
    
    float widthCell = MIN(sizeTagName.width + 45, 310);
    self.contentCellView.width = widthCell + 5;
    self.tagNameLabel.width =  widthCell;
    self.tagCellActionButton.x = self.contentCellView.rightXPoint - self.tagCellActionButton.width;
}

@end
