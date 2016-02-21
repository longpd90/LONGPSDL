//
//  PDExploreMapViewController.m
//  Pashadelic
//
//  Created by LongPD on 2/26/14.
//
//

#import "PDExploreMapViewController.h"
#import "PDFilterSearchViewController.h"
#import "KPAnnotation.h"
#import "PDPhotoAnnotation.h"
#import "PDPhotoAnnotationView.h"
#import "PDPhotoClusterAnnotationView.h"

#define MaxSpan 110

@interface PDExploreMapViewController () <PDFilterSearchViewControllerDelegate>
- (void)showRedoSearchButton;
@end

@implementation PDExploreMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customNavigationBarInterface];
    [self setLeftButtonToMainMenu];
    [self setRightBarButtonToButton:[self redBarButtonWithTitle:NSLocalizedString(@"filter", nil)
                                                         action:@selector(showFilter:)]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:_searchTextField];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_searchTextField removeFromSuperview];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)customNavigationBarInterface
{
    self.searchTextField = [[PDSearchTextField alloc] initWithFrame:CGRectMake(45, 8, 205, 26)];
    self.searchTextField.layer.borderWidth = 0;
    self.searchTextField.layer.shadowOffset = CGSizeMake(0, 0);
	self.searchTextField.layer.shadowOpacity = 0;
	self.searchTextField.layer.shadowRadius = 0;
    self.searchTextField.layer.cornerRadius = 4;
    self.searchTextField.backgroundColor = [UIColor colorFromHexString:@"#EBEBEB"];
    self.searchTextField.rightView = nil;
    self.searchTextField.delegate = self;
    [self.searchTextField setFont:[UIFont systemFontOfSize:12]];
    self.searchTextField.placeholder = NSLocalizedString(@"search for city or landmark", nil);
    [self.navigationController.navigationBar addSubview:self.searchTextField];
}

#pragma mark - Public

- (NSString *)pageName
{
	return @"Explore Photo Map";
}

#pragma mark - Override

- (void)fetchData
{
    [super fetchData];
    
    self.searchTextField.text = _currentTextSearch;
    if (self.serverNearbyLoader) {
        [self.serverNearbyLoader cancel];
        self.serverNearbyLoader.delegate = nil;
        self.serverNearbyLoader = nil;
    }
    self.serverNearbyLoader = [[PDServerNearbyLoader alloc] initWithDelegate:self];
    [self.serverNearbyLoader loadNearbyPhotosForMap:self.currentTextSearch
                                         pageNumber:1
                                          longitude:_selectedPlace.longitude
                                           latitude:_selectedPlace.latitude ];
}

# pragma mark - Action

- (void)showExploreSearchView
{
    PDExploreSearchView *exploreSearchView = [[PDExploreSearchView alloc] init];
    exploreSearchView.selectedPlace = self.selectedPlace;
    if (self.currentTextSearch && self.currentTextSearch.length > 0) {
        exploreSearchView.searchedText = self.currentTextSearch;
    }
    exploreSearchView.delegate = self;
    [exploreSearchView showSearchInViewController:self];
}

- (void)showFilter:(id)sender
{
    PDFilterSearchViewController *filterSearchViewController = [[PDFilterSearchViewController alloc] initWithNibName:@"PDFilterSearchViewController"
                                                                                                              bundle:nil];
    filterSearchViewController.delegate = self;
    [filterSearchViewController setLocationSpecific:self.selectedPlace.description];
    [self.navigationController pushViewController:filterSearchViewController animated:YES];
}

- (IBAction)refetchData:(id)sender {
    self.resultsSearchView.hidden = YES;
    CLLocationCoordinate2D centerCoordinate = [self.photoClustersMapView centerCoordinate];
    if (self.serverNearbyLoader) {
        [self.serverNearbyLoader cancel];
        self.serverNearbyLoader.delegate = nil;
        self.serverNearbyLoader = nil;
    }
    self.loading = YES;
    self.isRedoSearch = YES;
    self.serverNearbyLoader = [[PDServerNearbyLoader alloc] initWithDelegate:self];
    
    [self.serverNearbyLoader loadNearbyPhotosForMap:self.currentTextSearch
                                         pageNumber:1
                                          longitude:centerCoordinate.longitude
                                           latitude:centerCoordinate.latitude ];
}

- (IBAction)photoButtonClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(mapDidFinish:withPlace:)]) {
        [self.delegate mapDidFinish:self.currentTextSearch withPlace:self.selectedPlace];
    }
    [self goBack:nil];
}

- (void)showRedoSearchButton
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.resultsSearchView.hidden = NO;
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - FilterSearchViewController delegate

- (void)filterDidFinish
{
    [self fetchData];
}


#pragma mark - UITextField delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self showExploreSearchView];
    return NO;
}

#pragma mark - UISearchView delegate

- (void)searchViewDidFinishWithTextSearch:(NSString *)textSearch place:(PDPlace *)place
{
    self.currentTextSearch = textSearch;
    self.searchTextField.text = textSearch;
    if (place)
        self.selectedPlace = place;
    else
        self.selectedPlace = nil;
    [self fetchData];
}

- (void)searchViewDidCancel:(id)searchView
{
}


- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    [super mapView:mapView regionDidChangeAnimated:animated];
    [self showRedoSearchButton];
}

#pragma mark - KPTreeController delegate

- (void)treeController:(KPTreeController *)tree configureAnnotationForDisplay:(KPAnnotation *)annotation
{
}

#pragma mark - Server exchange delegate

- (void)serverExchange:(PDServerExchange *)serverExchange didParseResult:(NSDictionary *)result
{
    [super serverExchange:serverExchange didParseResult:result];
    self.photos = [serverExchange loadPhotosFromArray:result[@"photos"]];
    if (self.isRedoSearch)
        [self refreshMapViewAndChangeRegion:NO];
    else
        [self refreshMapViewAndChangeRegion:YES];
    self.isRedoSearch = NO;
    self.resultsSearchView.hidden = YES;
}

- (void)serverExchange:(id)serverExchange didFailWithError:(NSString *)error {
    [super serverExchange:serverExchange didFailWithError:error];
    self.resultsSearchView.hidden = YES;
}

@end
