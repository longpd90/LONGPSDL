//
//  PDSearchBarTextField.h
//  Pashadelic
//
//  Created by TungNT2 on 4/25/14.
//
//

#import <UIKit/UIKit.h>
#import "PDTextField.h"

@interface PDSearchBarTextField : PDTextField

@property (strong, nonatomic) UIButton *rightClearButton;
@property (nonatomic, assign) BOOL isSelected;
- (void)initialize;
- (void)setLeftViewWithImage:(UIImage *)image;
- (void)setRightViewWithImage:(UIImage *)image;
@end
