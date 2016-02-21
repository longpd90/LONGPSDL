//
//  PDServerErrorAlertView.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 12.01.14.
//
//

#import <UIKit/UIKit.h>

@interface MGSingleErrorAlertView : NSObject

+ (instancetype)instance;

- (void)showErrorMessage:(NSString *)error;

@end
