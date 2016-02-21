//
//  PDExploreViewController.m
//  Pashadelic
//
//  Created by LongPD on 2/20/14.
//
//

#import "PDExploreViewController.h"
#import "PDFilterSearchViewController.h"
#import "PDGooglePlaceAutocomplete.h"
#import "PDExploreSearchView.h"

@interface PDExploreViewController ()<PDFilterSearchViewControllerDelegate>
@property (nonatomic, strong) PDExploreMapViewController *exploreMapViewController;
- (void)initInterface;
- (PDPlace *)defaultPlace;
- (void)showExploreSearchView;
@end

@implementation PDExploreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setLeftButtonToMainMenu];
    [self setRightBarButtonToButton:[self redBarButtonWithTitle:NSLocalizedString(@"filter", nil)
                                                         action:@selector(showFilter:)]];
    self.photosTableView.tableViewMode = PDItemsTableViewModeList;
    [self initialize];
    [self initInterface];
    [self initLocationService];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _labelTopView.text = [NSString stringWithFormat:NSLocalizedString(@"see what's new within %0.0fkm", nil), [kPDUserDefaults floatForKey:kPDFilterNearbyRangeKey]];
    _searchTextField.text = self.searchedText;
    [self.navigationController.navigationBar addSubview:_searchTextField];
    self.customNavigationBar.titleButton.hidden = YES;

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

#pragma mark - Override

- (NSString *)pageName
{
	return @"Explore";
}

- (void)refreshView
{
    [super refreshView];
}

#pragma mark - Private

- (void)initialize
{
    self.toolbarView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    [self.showMapButton setTitle:NSLocalizedString(@"map", nil) forState:UIControlStateNormal];
}

- (void)initInterface
{
    self.customNavigationBar.titleButton.hidden = YES;
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

- (PDPlace *)defaultPlace
{
    double latitude = [[PDLocationHelper sharedInstance] latitudes];
    double longitude = [[PDLocationHelper sharedInstance] longitudes];
    if (latitude != 0 && longitude != 0) {
        PDPlace *currentPlace = [[PDPlace alloc] init];
        [self showTableHeaderView];
        currentPlace.description = NSLocalizedString(@"current location", nil);
        currentPlace.latitude = latitude;
        currentPlace.longitude = longitude;
        return currentPlace;
    } else {
        [self hiddenTableHeaderView];
        return nil;
    }
}

- (void)fetchData
{
    [super fetchData];
    if (self.serverNearbyLoader) {
        [self.serverNearbyLoader cancel];
        self.serverNearbyLoader.delegate = nil;
        self.serverNearbyLoader = nil;
    }
    self.serverNearbyLoader = [[PDServerNearbyLoader alloc] initWithDelegate:self];
    [self.serverNearbyLoader loadNearbyPhotos:self.searchedText
                                   pageNumber:self.currentPage
                                    longitude:self.selectedPlace.longitude
                                     latitude:self.selectedPlace.latitude];
}

# pragma mark - action

- (void)showTableHeaderView
{
	[self.photosTableView beginUpdates];
    self.photosTableView.tableHeaderView = self.toolbarView;
	[self.photosTableView endUpdates];
}

- (void)hiddenTableHeaderView
{
	[self.photosTableView beginUpdates];
	self.photosTableView.tableHeaderView = nil;
	[self.toolbarView removeFromSuperview];
	[self.photosTableView endUpdates];
    
}

- (void)showFilter:(id)sender
{
    PDFilterSearchViewController *filterSearchViewController = [[PDFilterSearchViewController alloc] initWithNibName:@"PDFilterSearchViewController" bundle:nil];
    filterSearchViewController.delegate = self;
    filterSearchViewController.locationSpecific = self.selectedPlace.description;
    [self.navigationController pushViewController:filterSearchViewController animated:YES];
}

- (void)showMainMenu
{
	[super showMainMenu];
	if (self.exploreMapViewController && ![self.navigationController.viewControllers containsObject:self.exploreMapViewController]) {
		self.exploreMapViewController = nil;
	}
}

- (void)showExploreSearchView
{
    PDExploreSearchView *exploreSearchView = [[PDExploreSearchView alloc] init];
    exploreSearchView.selectedPlace = self.selectedPlace;
    if (self.searchedText && self.searchedText.length > 0)
        exploreSearchView.searchedText = self.searchedText;
    exploreSearchView.delegate = self;
    [exploreSearchView showSearchInViewController:self];
}

- (IBAction)showPhotosInMap:(id)sender {
    if (!_exploreMapViewController) {
        _exploreMapViewController = [[PDExploreMapViewController alloc]initWithNibName:@"PDExploreMapViewController" bundle:nil];
        _exploreMapViewController.delegate = self;
    }
    _exploreMapViewController.currentTextSearch = _searchedText;
    _exploreMapViewController.selectedPlace = _selectedPlace;
    [self.navigationController pushViewController:_exploreMapViewController animated:YES];
    [_exploreMapViewController fetchData];
}

#pragma mark - ExplorerMapViewController delegate

- (void)mapDidFinish:(NSString *)textSearch withPlace:(PDPlace *)place
{
    _searchTextField.text = textSearch;
    _searchedText = textSearch;
    _selectedPlace = place;
    self.currentPage = 1;
    [self fetchData];
    if (self.searchedText.length > 0 || ![self.selectedPlace.description isEqualToString:NSLocalizedString(@"current location", nil)]) {
        [self hiddenTableHeaderView];
    } else {
        [self showTableHeaderView];
    }
}

#pragma mark - FilterSearchViewController delegate

- (void)filterDidFinish
{
    self.currentPage = 1;
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
    self.searchTextField.text = self.searchedText = textSearch;
    self.selectedPlace = place;
    if (self.searchedText.length > 0 || ![self.selectedPlace.description isEqualToString:NSLocalizedString(@"current location", nil)]) {
        [self hiddenTableHeaderView];
    } else {
        [self showTableHeaderView];
    }
    self.currentPage = 1;
    [self fetchData];
}

- (void)searchViewDidCancel:(id)searchView
{
}

#pragma mark - Override

- (void)initLocationService
{
    [super initLocationService];
    if (!isLocationReceived) return;
    self.selectedPlace = [self defaultPlace];
    [self fetchData];
}

- (void)updateLocation
{
    [super updateLocation];
    [kPDAppDelegate showWaitingSpinner];
    [[PDLocationHelper sharedInstance] updateLocation:^(NSError *error, CLLocation *location){
        if (error) {
            [self updateLocationDidFailWithError:error];
            [kPDAppDelegate hideWaitingSpinner];
            return;
        }
        isLocationReceived = YES;
        self.selectedPlace = [self defaultPlace];
        self.currentPage = 1;
        [self fetchData];
    }];
}

- (void)locationChanged:(NSNotification *)notification
{
    [super locationChanged:notification];
    self.selectedPlace = [self defaultPlace];
    self.currentPage = 1;
    [self fetchData];
}

#pragma mark - ServerExchange delegate

- (void)serverExchange:(id)serverExchange didParseResult:(id)result
{
    [super serverExchange:serverExchange didParseResult:result];
    if (serverExchange == self.serverNearbyLoader) {
        self.currentPage = [result intForKey:@"page"];
        self.totalPages = [result intForKey:@"total_pages"];
        self.items = [serverExchange loadPhotosFromArray:result[@"photos"]];
        [self refreshView];
    }
}

- (void)serverExchange:(id)serverExchange didFailWithError:(NSString *)error
{
    [super serverExchange:serverExchange didFailWithError:error];
    if (serverExchange == self.serverNearbyLoader) {
        [self refreshView];
    }
}

@end
