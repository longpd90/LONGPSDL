//
//  PDTagSuggestionView.h
//  Pashadelic
//
//  Created by LongPD on 8/13/13.
//
//

#import <UIKit/UIKit.h>
#import "PDTagSuggestionCell.h"
#define kPDTagSuggestionCellHeight 36

@class PDTagSuggestionView;
@protocol PDTagSuggestionViewDelegate <NSObject>
- (void)searchSuggestionDidSelect:(NSString *)suggestion;
- (void)didSrollTableView;
@end

@interface PDTagSuggestionView : UIView<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) id <PDTagSuggestionViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *suggestionsTable;
@property (strong, nonatomic) NSArray *suggestions;

- (id)init;
- (void)reloadData;
@end
