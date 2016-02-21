//
//  PDListLandmarkViewController.m
//  Pashadelic
//
//  Created by LongPD on 6/16/14.
//
//

#import "PDListLandmarkViewController.h"
#import "PDServerListLandmarkLoader.h"
#import "PDLocationViewController.h"
#import "PDListLandmarkMapViewController.h"

@interface PDListLandmarkViewController ()

@end

@implementation PDListLandmarkViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setLeftBarButtonToBackWithStyle:kPDLeftBarButtonStyleGrayAngle];
    self.photosTableView.scrollsToTop = NO;
    self.title = NSLocalizedString(@"LANDMARKS", nil);
    [self initNotificationTableView];
    [self fetchData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (PDNavigationBarStyle)defaultNavigationBarStyle
{
    return PDNavigationBarStyleWhite;
}

- (void)setLocation:(PDLocation *)location
{
    _location = location;
}

#pragma mark - Public

- (NSString *)pageName
{
	return @"List Landmark";
}

- (void)initNotificationTableView
{
    self.landmarkTableView = [[PDPhotoLandmarkTalbeView alloc] initWithFrame:self.tablePlaceholderView.zeroPositionFrame];
	self.landmarkTableView.itemsTableDelegate = self;
	self.landmarkTableView.photoViewDelegate = self;
	self.itemsTableView = self.landmarkTableView;
	[self.tablePlaceholderView addSubview:_landmarkTableView];
}

- (void)fetchData
{
    [super fetchData];    
    self.listLandmarkLoader = [[PDServerListLandmarkLoader alloc] initWithDelegate:self];
    switch (self.location.locationType) {
        case PDLocationTypeCountry:
            [self.listLandmarkLoader loadLocationListLandmarkWithName:@"countries" locationID:self.location.identifier withPageIndex:self.currentPage];
            break;
        case PDLocationTypeState:
            [self.listLandmarkLoader loadLocationListLandmarkWithName:@"states" locationID:self.location.identifier withPageIndex:self.currentPage];
            break;
        case PDLocationTypeCity:
            [self.listLandmarkLoader loadLocationListLandmarkWithName:@"cities" locationID:self.location.identifier withPageIndex:self.currentPage];
            break;
        case PDLocationTypeLandmark:
            [self.listLandmarkLoader loadlandmarkWithId:self.location.identifier withPageIndex:self.currentPage];
        default:
            break;
    }
}

#pragma mark - Item Select delegate

- (void)itemDidSelect:(PDItem *)item
{
    if ([item isKindOfClass:[PDPhotoLandMarkItem class]]) {
        PDPhotoLandMarkItem *landmarkItem = (PDPhotoLandMarkItem *)item;
        PDLocationViewController *locationViewController = [[PDLocationViewController alloc] initWithNibName:@"PDLocationViewController" bundle:nil];
        PDLocation *locationLandmark = [[PDLocation alloc] init];
        locationLandmark.locationType = PDLocationTypeLandmark;
        locationLandmark.name = landmarkItem.name;
        locationLandmark.identifier = landmarkItem.identifier;
        locationViewController.location = locationLandmark;
        [self.navigationController pushViewController:locationViewController animated:YES];
    }
}

- (IBAction)goToMap:(id)sender {
    PDListLandmarkMapViewController *mapviewController = [[PDListLandmarkMapViewController alloc] initForUniversalDevice];
    mapviewController.sourceType = PDClusterMapViewSourceLankmarks;
    mapviewController.landmarks = self.items;
    [self.navigationController pushViewController:mapviewController animated:YES];
}

#pragma mark - Server delegate

- (void)serverExchange:(PDServerExchange *)serverExchange didParseResult:(NSDictionary *)result
{
	[super serverExchange:serverExchange didParseResult:result];
	self.items = [serverExchange loadLandmarkItemsFromArray:result[@"pois"]];
    self.totalPages = [result intForKey:@"total_page"];
	[self.items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		[obj setItemDelegate:self];
	}];
	[self refreshView];
}

@end
