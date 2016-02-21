//
//  PDPhotoLandmarkViewController.h
//  Pashadelic
//
//  Created by TungNT2 on 7/23/13.
//
//

#import "PDViewController.h"
#import "PDSearchTextField.h"
#import "PDServerLandmarkLoader.h"
#import "PDTableViewController.h"
#import "PDSearchTextField.h"
#import "PDPOIItem.h"
#import "PDUploadPhotoViewController.h"

#define kPDMaxLandmarkRange     100

@interface PDPhotoLandmarkViewController : PDTableViewController
<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, MGServerExchangeDelegate>

@property (nonatomic, strong) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet PDSearchTextField *landmarkSearchTextField;
@property (strong, nonatomic) IBOutlet UITableView *poisTableView;
@property (weak, nonatomic) IBOutlet PDGlobalFontButton *creatLandmarkButton;
@property (strong, nonatomic) NSArray *filteredItems;
@property (strong, nonatomic) PDPhoto *photo;
@property (weak, nonatomic) PDPOIItem *selectedPOIItem;
@property (strong, nonatomic) PDServerLandmarkLoader *landmarkLoader;
@property (strong, nonatomic) UIImage *filteredImage;

- (IBAction)creatLandmark:(id)sender;
- (void)changeTitleRightBarButton;

@end
