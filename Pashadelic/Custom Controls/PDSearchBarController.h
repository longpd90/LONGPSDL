//
//  PDSearchBarController.h
//  Pashadelic
//
//  Created by TungNT2 on 4/23/14.
//
//

#import <Foundation/Foundation.h>
#import "PDSearchBar.h"
#import "PDSearchView.h"
#import "PDPlace.h"
#import "MGServerExchange.h"
#import "PDGooglePlaceAutocomplete.h"
#import "PDGooglePlaceDetails.h"
#import "PDGoogleGeocoding.h"


@class PDPlace;
@class PDSearchBar;
@class PDSearchView;
@class PDSearchBarController;

@protocol PDSearchBarControllerDelegate <NSObject>
@optional
- (void)searchBar:(PDSearchBarController *)searchBarController didSelectedPlace:(PDPlace *)place;
- (void)searchBarDidCancel;
@end
@interface PDSearchBarController : NSObject <UITextFieldDelegate, MGServerExchangeDelegate>

@property (nonatomic, strong) PDSearchBar *searchBar;
@property (nonatomic, strong) PDSearchView *searchView;
@property (nonatomic, strong) PDPlace *selectedPlace;
@property (strong, nonatomic) NSArray *places;
@property (nonatomic, weak) id <PDSearchBarControllerDelegate> delegate;
@property (nonatomic, strong) PDGoogleGeocoding *googleGeocodingServerSearch;
@property (nonatomic, strong) PDGooglePlaceDetails *googlePlaceDetailsServerSearch;
@property (nonatomic, strong) PDGooglePlaceAutocomplete *googleAutocompleteServerSearch;
@property (nonatomic, readwrite) NSInteger active;

- (void)searchSuggestionDidSelect:(PDPlace *)selectedPlace;
- (void)refreshView;

@end
