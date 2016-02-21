//
//  PDUsersView.h
//  Pashadelic
//
//  Created by LongPD on 8/18/14.
//
//

#import <UIKit/UIKit.h>

@protocol PDUsersViewDelegate <NSObject>

- (void)itemDidSelectedAtIndex:(NSInteger)index sender:(id)sender;

@end

@interface PDUsersView : UIView
<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, weak) id<PDUsersViewDelegate> delegate;

@end
