//
//  PDSuggestionCell.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 29.03.13.
//
//

#import "PDSuggestionCell.h"

@implementation PDSuggestionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		self.backgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.backgroundColor = [UIColor clearColor];
        self.textLabel.font = [UIFont fontWithName:PDGlobalNormalFontName size:13];
		self.textLabel.textColor = [UIColor whiteColor];
		self.textLabel.backgroundColor = [UIColor clearColor];
    }
    return self;
}

@end
