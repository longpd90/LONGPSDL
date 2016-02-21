//
//  PDCollectionsViewController.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 12.07.13.
//
//
#import "PDViewController.h"
#import <UIKit/UIKit.h>
#import "PDTextField.h"
#import "SSTextView.h"
#import "MGLocalizedLabel.h"
#import "MGLocalizedButton.h"
#import "PDServerCreateCollection.h"
#import "PDServerAddPhotoToCollection.h"
#import "MGViewController.h"
#import "PDPopupView.h"
#import "PDTableViewController.h"

@interface PDCollectionsViewController : PDTableViewController
<MGServerExchangeDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) PDPhoto *photo;
@property (assign, nonatomic) PDItemsTableViewViewState tableViewState;
@property (strong, nonatomic) IBOutlet UIView *createFolderView;
@property (weak, nonatomic) IBOutlet MGLocalizedButton *createButton;
@property (weak, nonatomic) IBOutlet UITextField *folderNameTextField;
@property (strong, nonatomic) PDServerAddPhotoToCollection *serverAddPhotoToCollection;
@property (strong, nonatomic) PDServerCreateCollection *serverCreateCollection;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet SSTextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UITableView *foldersTableView;
@property (strong, nonatomic) NSArray *photoCollections;
@property (strong, nonatomic) UIView *loadingMoreContentView;
- (IBAction)createNewCollection:(id)sender;

@end
