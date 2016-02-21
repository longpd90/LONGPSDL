//
//  PDExploreSearchTextField.m
//  Pashadelic
//
//  Created by TungNT2 on 2/24/14.
//
//

#import "PDExploreSearchTextField.h"

@implementation PDExploreSearchTextField

- (void)awakeFromNib
{
    [self initialize];
}

- (void)initialize
{
    [super initialize];
    self.backgroundColor = [UIColor whiteColor];
	self.clipsToBounds = NO;
	self.layer.shadowOffset = CGSizeMake(1, 1);
	self.layer.shadowOpacity = 0.5;
	self.layer.shadowRadius = 1;
	self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
	self.layer.borderColor = [UIColor lightGrayColor].CGColor;
	self.layer.borderWidth = 0;
	self.leftViewMode = UITextFieldViewModeAlways;
}

- (void)setIsSelectedPlace:(BOOL)isSelectedPlace
{
    _isSelectedPlace = isSelectedPlace;
    if (_isSelectedPlace) {
        self.textColor = [UIColor redColor];
    } else {
        self.textColor = [UIColor blackColor];
    }
}

@end
