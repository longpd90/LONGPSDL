//
//  PDLoginTextField.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 10.02.13.
//
//

#import "PDTextField.h"

#define kPDLoginTextFieldAccessoryViewMaxSide		20

@implementation PDTextField

- (void)awakeFromNib
{
	[self initialize];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
	self.backgroundColor = [UIColor whiteColor];
	self.clipsToBounds = NO;
	self.layer.shadowOffset = CGSizeMake(1, 1);
	self.layer.shadowOpacity = 0.25;
	self.layer.shadowRadius = 1;
	self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
	self.layer.borderColor = [UIColor lightGrayColor].CGColor;
	self.layer.borderWidth = 1;
	self.leftViewMode = UITextFieldViewModeAlways;
}

- (void)uploadPhotoStyle
{
	self.layer.shadowOffset = CGSizeZero;
	self.layer.shadowOpacity = 0.0;
	self.layer.shadowRadius = 0.0;
	self.layer.shadowColor = [UIColor clearColor].CGColor;
	self.layer.borderColor = [UIColor clearColor].CGColor;
	self.layer.borderWidth = 0.0;
    self.layer.cornerRadius = 4;
	self.leftViewMode = UITextFieldViewModeAlways;
}

- (CGRect)rightViewRectForBounds:(CGRect)bounds
{
	if (!self.rightView) return CGRectZero;
	
	double height = bounds.size.height;
	double side = MIN(height, kPDLoginTextFieldAccessoryViewMaxSide);
	return CGRectMake(bounds.size.width - 5 - side, (height - side) / 2, side, side);
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
	if (!self.leftView) return CGRectZero;
	
	double height = bounds.size.height;
	double side = MIN(height, kPDLoginTextFieldAccessoryViewMaxSide);
	return CGRectMake(5, (height - side) / 2, side, side);
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
	float leftViewWidth = CGRectGetMaxX([self leftViewRectForBounds:bounds]);
	float rightViewWidth = [self rightViewRectForBounds:bounds].size.width + 5;
	return CGRectMake(leftViewWidth + 5, 0, bounds.size.width - leftViewWidth - 10 - rightViewWidth, bounds.size.height);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
	return [self textRectForBounds:bounds];
}

@end
