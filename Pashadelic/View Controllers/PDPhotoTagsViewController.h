//
//  PDTagsViewController.h
//  Pashadelic
//
//  Created by Linh on 2/6/13.
//
//

#import <UIKit/UIKit.h>
#import "PDViewController.h"
#import "PDPhotoTagCell.h"
#import "PDPhoto.h"
#import "PDServerSearchSuggestions.h"
#import "PDSearchTextField.h"
#import "PDTagSuggestionView.h"

@interface PDPhotoTagsViewController : PDViewController <UITableViewDataSource, UITableViewDelegate,
PDTagCellDelegate, UITextFieldDelegate, PDTagSuggestionViewDelegate, MGServerExchangeDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *backgroudImageView;
@property (weak, nonatomic) IBOutlet UITableView *tagsTableView;
@property (weak, nonatomic) IBOutlet PDSearchTextField *tagsTextField;
@property (strong, nonatomic) PDTagSuggestionView *suggestionsTagsView;
@property (strong, nonatomic) PDServerSearchSuggestions *serverSearchSuggestionTags;
@property (strong, nonatomic) NSMutableArray *tags;
@property (weak, nonatomic) PDPhoto *photo;
@property (assign, nonatomic) BOOL isSearching;

- (void)finish:(id)sender;

@end
