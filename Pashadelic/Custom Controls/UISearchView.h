//
//  UISearchView.h
//  Pashadelic
//
//  Created by TungNT2 on 2/25/14.
//
//

#import <UIKit/UIKit.h>

@class UISearchView;
@class PDPlace;

@protocol UISearchViewDelegate <NSObject>
@optional
- (void)searchViewDidFinishWithTextSearch:(NSString *)textSearch place:(PDPlace *)place;
- (void)searchViewDidCancel:(id)searchView;
@end

@interface UISearchView : UIView <UIGestureRecognizerDelegate>
@property (strong, nonatomic) UIView *backgroundSearchView;
@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (weak, nonatomic) id <UISearchViewDelegate> delegate;

- (void)initialize;
- (void)showSearchInViewController:(UIViewController *)viewController;
- (void)hideSearch;
- (IBAction)search:(id)sender;
- (IBAction)cancel:(id)sender;

@end
