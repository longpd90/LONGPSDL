//
//  PDLandmarkPhotospotsViewController.m
//  Pashadelic
//
//  Created by LTT on 6/19/14.
//
//

#import "PDLandmarkPhotospotsViewController.h"
#import "PDServerPhotospotsLoader.h"
#import "PDLocationPhotosMapViewController.h"

#define kPDHeightOfChangeSortView 150;

enum PDPhotospotsSort {
    PDPhotospotsSortByPopular = 0,
	PDPhotospotsSortByNewest,
	PDPhotospotsSortByNextDays
};
@interface PDLandmarkPhotospotsViewController ()
@property (nonatomic) NSInteger photospotsSort;
@property (strong, nonatomic) NSArray *photos;
@end

@implementation PDLandmarkPhotospotsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil location:(PDLocation *)location
{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self) {
        self.location = location;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Photospots", nil);
    self.photospotsSort = PDPhotospotsSortByPopular;
    [self setLeftBarButtonToBackWithStyle:kPDLeftBarButtonStyleGrayAngle];
    [self initInteface];
	[self refetchData];
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

#pragma mark - Public

- (NSString *)pageName
{
    return @"Photospots";
}

- (void)fetchData
{
	[super fetchData];
    self.serverExchange = [[PDServerPhotospotsLoader alloc] initWithDelegate:self];
    [self.serverExchange getPhotospotsInLocation:self.location sortType:self.photospotsSort page:self.currentPage];
    if (self.currentPage == 1) {
        self.photos = [[NSArray alloc] init];
    }
}

#pragma - Private

- (void)initInteface
{
    NSDictionary *grayColorAttribute = @{NSForegroundColorAttributeName: kPDGlobalGrayColor};
    self.navigationItem.titleView = self.navigationbarView;
    [_changeSortButton setFontAwesomeIconForImage:[FAKFontAwesome sortIconWithSize:14.0]
                                         forState:UIControlStateNormal
                                       attributes:grayColorAttribute];
    [self setTitleForChangeSortButton:NSLocalizedString(@"popular", nil)];
    _changeSortView.frame = CGRectMake(0, -150, 320, 150);
    [self.view addSubview:_changeSortView];
    _changeSortView.hidden = YES;
    
}

- (void)setTitleForChangeSortButton:(NSString *)title
{
    [_changeSortButton setTitle:title forState:UIControlStateNormal];
    [_changeSortButton setTitle:[_changeSortButton titleForState:UIControlStateNormal] forState:UIControlStateHighlighted];
    [_changeSortButton setTitle:[_changeSortButton titleForState:UIControlStateNormal] forState:UIControlStateSelected];
}

- (void)showChangeSortView
{
    self.changeSortView.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        _changeSortView.frame = CGRectMake(0, 0, 320, 150);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideChangeSortView
{
    _changeSortButton.selected = NO;
    [UIView animateWithDuration:0.5 animations:^{
        _changeSortView.frame = CGRectMake(0, -150, 320, 150);
    } completion:^(BOOL finished) {
        self.changeSortView.hidden = YES;
    }];
}

#pragma mark - Server delegate

- (void)serverExchange:(PDServerExchange *)serverExchange didParseResult:(NSDictionary *)result
{
	if (![serverExchange isEqual:self.serverExchange]) return;
	[super serverExchange:serverExchange didParseResult:result];
	self.totalPages = [result intForKey:@"total_pages"];
	self.items = [serverExchange loadPhotosFromArray:result[@"photos"]];
    if (self.photos.count == 0) {
        _photos = [serverExchange loadPhotosFromArray:result[@"photos"]];
    }
    else {
        NSArray *morePhotos = [serverExchange loadPhotosFromArray:result[@"photos"]];
        _photos = [_photos arrayByAddingObjectsFromArray:morePhotos];
    }
    
	[self refreshView];
}

#pragma - IBAction

- (IBAction)clickButtonMap:(id)sender {
    PDLocationPhotosMapViewController *mapviewController = [[PDLocationPhotosMapViewController alloc] initForUniversalDevice];
    mapviewController.photos = self.photos;
    if (self.location.locationType == PDLocationTypeLandmark) {
        mapviewController.location = self.location;
    }
    [self.navigationController pushViewController:mapviewController animated:YES];
}

- (IBAction)clickChangeSortButton:(id)sender {
    if (!_changeSortButton.selected) {
        _changeSortButton.selected = YES;
        [self showChangeSortView];
    } else {
        [self hideChangeSortView];
    }
}

- (IBAction)clickPopularButton:(id)sender {
    self.photospotsSort = PDPhotospotsSortByPopular;
    [self setTitleForChangeSortButton:NSLocalizedString(@"popular", nil)];
    self.popularButton.selected = YES;
    self.newestButton.selected = NO;
    self.nextDaysButton.selected = NO;
    [self hideChangeSortView];
    [self refetchData];
}

- (IBAction)clickNewestButton:(id)sender {
    self.photospotsSort = PDPhotospotsSortByNewest;
    [self setTitleForChangeSortButton:NSLocalizedString(@"newest", nil)];
    self.popularButton.selected = NO;
    self.newestButton.selected = YES;
    self.nextDaysButton.selected = NO;
    [self hideChangeSortView];
    [self refetchData];
}

- (IBAction)clickNextDaysButton:(id)sender {
    self.photospotsSort = PDPhotospotsSortByNextDays;
    [self setTitleForChangeSortButton:NSLocalizedString(@"30 days", nil)];
    self.popularButton.selected = NO;
    self.newestButton.selected = NO;
    self.nextDaysButton.selected = YES;
    [self hideChangeSortView];
    [self refetchData];
}

@end
