//
//  PDImageView.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 16.01.13.
//
//

#import "PDImageView.h"

@implementation PDImageView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self.superview touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self.superview touchesEnded:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self.superview touchesMoved:touches withEvent:event];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitView = [super hitTest:point withEvent:event];
	
    if (hitView == self) {
        return self.superview;
    }
    return hitView;
}

@end
