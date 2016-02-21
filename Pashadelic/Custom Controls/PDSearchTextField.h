//
//  PDSearchTextField.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 13.04.13.
//
//

#import "PDTextField.h"

@interface PDSearchTextField : PDTextField

@property (strong, nonatomic) UIButton *rightClearButton;
- (void)setIConLocationSearchForLeftView;
- (BOOL)validateTextSearch;
@end
