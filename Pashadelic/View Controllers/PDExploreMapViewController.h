//
//  PDExploreMapViewController.h
//  Pashadelic
//
//  Created by LongPD on 2/26/14.
//
//

#import "PDUserMapViewController.h"
#import "PDClusterMapViewController.h"
#import "PDSearchTextField.h"
#import "PDServerNearbyLoader.h"
#import "PDPlace.h"
#import "PDExploreSearchView.h"

@protocol PDExploreMapViewControllerDelegate <NSObject>
- (void)mapDidFinish:(NSString *)textSearch withPlace:(PDPlace *)place;
@end

@interface PDExploreMapViewController : PDClusterMapViewController <UISearchViewDelegate>


@property (weak, nonatomic) IBOutlet UIView *resultsSearchView;
@property (weak, nonatomic) IBOutlet UILabel *labelResultSearch;
@property (strong, nonatomic) PDSearchTextField *searchTextField;

@property (strong, nonatomic) PDServerNearbyLoader *serverNearbyLoader;

@property (weak, nonatomic) id <PDExploreMapViewControllerDelegate> delegate;

@property (strong, nonatomic) NSString *currentTextSearch;
@property (strong, nonatomic) PDPlace *selectedPlace;
@property (assign, nonatomic) BOOL isRedoSearch;

- (IBAction)refetchData:(id)sender;

@end
