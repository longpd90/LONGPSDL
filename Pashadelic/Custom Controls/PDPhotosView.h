//
//  UIHorizontalImageCarousel.h

#import <UIKit/UIKit.h>

@protocol PDPhotosViewDelegate <NSObject>

- (void)itemDidSelectedAtIndex:(NSInteger)index sender:(id)sender;

@end

@interface PDPhotosView: UIView
<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, weak) id<PDPhotosViewDelegate> delegate;

@end
