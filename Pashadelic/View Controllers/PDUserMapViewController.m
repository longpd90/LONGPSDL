//
//  PDUserMapViewController.m
//  Pashadelic
//
//  Created by LongPD on 12/20/13.
//
//

#import "PDUserMapViewController.h"
#import "PDServerUserPhotoMapLoader.h"

@interface PDUserMapViewController ()

@end

@implementation PDUserMapViewController

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
    [self setLeftBarButtonToBackWithStyle:kPDLeftBarButtonStyleGrayAngle];
    [self fetchData];
    [self setInfoUser:_user];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

- (PDNavigationBarStyle)defaultNavigationBarStyle
{
	return PDNavigationBarStyleWhite;
}

#pragma mark - private

- (void)fetchData
{
    [super fetchData];
    
    if (!self.serverExchange) {
        self.serverExchange = [[PDServerUserPhotoMapLoader alloc] initWithDelegate:self];
    }
    [self.serverExchange loadPhotoOfUser:_user];
}

#pragma mark - Public

- (NSString *)pageName
{
	return @"User's Photo Map";
}

- (void)setInfoUser:(PDUser *)theUser
{
    _user = theUser;
    if (!_user) return;
	if (_user.name.length ==  0) {
		self.title = NSLocalizedString(@"User", nil);
	} else {
		self.title = _user.name;
	}
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
    [self refreshMapViewAndChangeRegion:YES];
}

- (void)serverExchange:(id)serverExchange didFailWithError:(NSString *)error {
    [super serverExchange:serverExchange didFailWithError:error];
    [self showErrorMessage:error];
}

@end
