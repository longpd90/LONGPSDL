//
//  PDGeoTagInfoViewController.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 28.05.13.
//
//

#import <UIKit/UIKit.h>
#import "PDPOIItem.h"
#import "PDViewController.h"

@interface PDPOIInfoViewController : PDViewController

@property (weak, nonatomic) PDPOIItem *poiItem;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (weak, nonatomic) IBOutlet UITextView *infoTextView;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;

- (IBAction)closeView:(id)sender;
- (IBAction)call:(id)sender;

@end
