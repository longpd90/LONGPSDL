//
//  PDSearchBarController.m
//  Pashadelic
//
//  Created by TungNT2 on 4/23/14.
//
//

#import "PDSearchBarController.h"
#import "PDLocationHelper.h"

@interface PDSearchBarController ()
- (void)searchSuggestions;
- (void)searchPlaceWithTextSearch:(NSString *)textSearch;
- (void)clearSearch;
@end

@implementation PDSearchBarController

@synthesize active = _active;

- (id)init
{
    self = [super init];
    if (self) {
        self.searchBar = [PDSearchBar view];
        self.searchView = [PDSearchView view];
        self.searchBar.searchController = self;
        self.searchView.searchController = self;
        [self.searchBar.textField.rightClearButton addTarget:self
                                                      action:@selector(clearSearch)
                                            forControlEvents:UIControlEventTouchUpInside];
        if (self.searchBar.textField) {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(searchBarTextFieldDidChange:)
                                                         name:UITextFieldTextDidChangeNotification object:self.searchBar.textField];
				}
    }
    return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setSelectedPlace:(PDPlace *)selectedPlace
{
    _selectedPlace = selectedPlace;
    [self refreshView];
}

- (void)setActive:(NSInteger)active
{
    _active = active;
    [self.searchBar activateSearch:active];
    if (active) {
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        CGRect windFrame = [self.searchBar.superview convertRect:self.searchBar.frame toView:window];
        self.searchView.frame = CGRectMake(windFrame.origin.x,
                                           windFrame.origin.y + windFrame.size.height,
                                           windFrame.size.width,
                                           window.height - windFrame.origin.y - windFrame.size.height);
        self.searchView.alpha = 0;
        [window addSubview:self.searchView];
        [UIView animateWithDuration:0.3 animations:^{
            self.searchView.alpha = 1;
        }];
    } else {
        [self.searchBar.textField resignFirstResponder];
        [UIView animateWithDuration:0.3 animations:^{
            self.searchView.alpha = 0;
        } completion:^(BOOL finish){
            [self.searchView removeFromSuperview];
        }];
    }
}

- (void)setPlaces:(NSArray *)places
{
    NSMutableArray *newPlaces = [NSMutableArray arrayWithArray:places];
    PDPlace *currentPlace = [[PDPlace alloc] init];
    currentPlace.description = NSLocalizedString(@"current location", nil);
    currentPlace.latitude = [[PDLocationHelper sharedInstance] latitudes];
    currentPlace.longitude = [[PDLocationHelper sharedInstance] longitudes];
    [newPlaces addObject:currentPlace];
    _places = newPlaces;
}

- (void)searchSuggestions
{
	[self.googleAutocompleteServerSearch cancel];
	if (self.searchBar.textField.text.length > 0) {
		self.searchBar.textField.rightClearButton.hidden = NO;
	}
	else {
		self.searchBar.textField.rightClearButton.hidden = YES;
	}
	
	if (self.searchBar.textField.text.length <= 2) {
		self.searchView.suggestions = nil;
		[self.searchView refreshView];
	} else {
		if (!self.googleAutocompleteServerSearch) {
			self.googleAutocompleteServerSearch = [[PDGooglePlaceAutocomplete alloc] initWithDelegate:self];
		}
		[self.googleAutocompleteServerSearch searchPlaceAutocompleteWithSearchText:self.searchBar.textField.text];
	}
}

- (void)searchSuggestionDidSelect:(PDPlace *)selectedPlace
{
    [self.googlePlaceDetailsServerSearch cancel];
    for (PDPlace *place in self.places) {
        if ([place.description isEqualToString:NSLocalizedString(@"current location", nil)]) {
            self.selectedPlace = place;
            [self refreshView];
            if (self.delegate && [self.delegate respondsToSelector:@selector(searchBar:didSelectedPlace:)]) {
                [self.delegate searchBar:self didSelectedPlace:self.selectedPlace];
            }
            break;
        } else if ([place isEqual:selectedPlace]) {
            self.searchView.suggestions = nil;
            [self.searchView refreshView];
            self.selectedPlace = place;
					if (!self.googlePlaceDetailsServerSearch) {
            self.googlePlaceDetailsServerSearch = [[PDGooglePlaceDetails alloc] initWithDelegate:self];
					}
            [self.googlePlaceDetailsServerSearch getPlaceDetailWithReference:place.reference];
            break;
        }
    }
}

- (void)searchPlaceWithTextSearch:(NSString *)textSearch
{
	[self.googleGeocodingServerSearch cancel];
	if (!self.googleGeocodingServerSearch) {
    self.googleGeocodingServerSearch = [[PDGoogleGeocoding alloc] initWithDelegate:self];
	}
	[self.googleGeocodingServerSearch searchPlaceGeoCodeWithSearchText:textSearch];
}

- (void)refreshView
{
    self.searchBar.textField.text = self.selectedPlace.description;
    [self.searchBar.textField resignFirstResponder];
    self.active = NO;
}

- (void)clearSearch
{
    [self.searchBar clearSearch];
    self.searchView.suggestions = nil;
    [self.searchView refreshView];
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarDidCancel)]) {
        [self.delegate searchBarDidCancel];
    }
}

#pragma mark - UITextField delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.searchBar.textField.isSelected)
        return NO;
    
    if (!self.active)
        self.active = YES;
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text == nil)
        return YES;
    
    if (self.active)
        self.active = NO;
    
    [self searchPlaceWithTextSearch:textField.text];
    return YES;
}

#pragma mark - Notification

- (void)searchBarTextFieldDidChange:(NSNotification *)notification
{
    if ([notification.object isEqual:self.searchBar.textField])
        [self searchSuggestions];
}

#pragma mark - Server Exchange delegate

- (void)serverExchange:(id)serverExchange didParseResult:(id)result
{
    if ([serverExchange isKindOfClass:[PDGooglePlaceAutocomplete class]]) {
        self.places = [serverExchange loadPlacesFromResult];
        self.searchView.suggestions = self.places;
        [self.searchView refreshView];
    } else if ([serverExchange isKindOfClass:[PDGooglePlaceDetails class]]) {
        [self.selectedPlace loadFullDataFromDictionary:result];
        [self refreshView];
        if (self.delegate && [self.delegate respondsToSelector:@selector(searchBar:didSelectedPlace:)]) {
            [self.delegate searchBar:self didSelectedPlace:self.selectedPlace];
        }
    } else if ([serverExchange isKindOfClass:[PDGoogleGeocoding class]]) {
        self.places = [serverExchange loadGeoDataFromResult];
        if (self.places.count > 0) {
            self.selectedPlace = [self.places objectAtIndex:0];
            [self refreshView];
            if (self.delegate && [self.delegate respondsToSelector:@selector(searchBar:didSelectedPlace:)]) {
                [self.delegate searchBar:self didSelectedPlace:self.selectedPlace];
            }
        }
    }
}

- (void)serverExchange:(id)serverExchange didFailWithError:(NSString *)error
{
}

@end
