//
//  PDCategorySelectView.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 3/10/12.
//
//

#import <UIKit/UIKit.h>

@protocol PDCategorySelectViewDelegate <NSObject>
- (void)categoryDidSelect:(NSString *)category;
@end

@interface PDCategorySelectView : UITableView
<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) id <PDCategorySelectViewDelegate> categoryDelegate;
@property (strong, nonatomic) NSArray *categories;
@property (weak, nonatomic) NSString *selectedCategory;

@end
