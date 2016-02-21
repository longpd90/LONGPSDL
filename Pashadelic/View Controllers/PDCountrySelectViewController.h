//
//  PDCountrySelectViewController.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 25.12.12.
//
//

#import "PDViewController.h"
#import "PDServerCountriesLoader.h"
#import "PDSearchTextField.h"

@class PDCountrySelectViewController;
@protocol PDCountrySelectDelegate <NSObject>
- (void)countryDidSelect:(NSDictionary *)country viewController:(PDCountrySelectViewController *)viewController;
@end

@interface PDCountrySelectViewController : PDViewController
<UITableViewDataSource, UITableViewDelegate, MGServerExchangeDelegate>

@property (nonatomic) NSInteger countryID;
@property (strong, nonatomic) NSArray *items;
@property (strong, nonatomic) NSArray *filteredItems;
@property (weak, nonatomic) IBOutlet UITableView *itemsTableView;
@property (weak, nonatomic) IBOutlet PDSearchTextField *searchTextField;
@property (weak, nonatomic) id <PDCountrySelectDelegate> delegate;

- (IBAction)cancel:(id)sender;
- (IBAction)search:(id)sender;

@end
