//
//  PDSearchView.h
//  Pashadelic
//
//  Created by TungNT2 on 4/23/14.
//
//

#import <UIKit/UIKit.h>
#import "PDSearchBarController.h"

#define kPDSuggestionCellHeight 35

@class PDSearchBarController;

@interface PDSearchView : UIView <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) IBOutlet UITableView *searchTableView;
@property (strong, nonatomic) NSArray *suggestions;
@property (nonatomic, strong) PDSearchBarController *searchController;

+ (PDSearchView *)view;
- (void)refreshView;

@end
