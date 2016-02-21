//
//  PDTagSuggestionCell.m
//  Pashadelic
//
//  Created by LongPD on 8/13/13.
//
//

#import "PDTagSuggestionCell.h"

@implementation PDTagSuggestionCell

- (void)setcontentForCell:(NSString *)tagName
{
    self.backgroundColor = [UIColor clearColor];
    [self.tagNameLabel setFont:[UIFont fontWithName:PDGlobalNormalFontName size:15]];
    self.backgroundView.backgroundColor = [UIColor clearColor];
    self.tagNameLabel.text = [NSString stringWithFormat:@"%@",tagName];
    CGSize sizeTagName = [self.tagNameLabel.text sizeWithFont:self.tagNameLabel.font
                              constrainedToSize:CGSizeMake(10000, 33)
                                  lineBreakMode:NSLineBreakByCharWrapping];
    float widthCell = MIN(sizeTagName.width + 10, 310);
    self.backgroundViewCell.width = widthCell + 5;
    self.tagNameLabel.width =  widthCell;

}
@end
