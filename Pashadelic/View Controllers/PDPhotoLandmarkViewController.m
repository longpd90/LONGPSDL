//
//  PDPhotoLandmarkViewController.m
//  Pashadelic
//
//  Created by TungNT2 on 7/23/13.
//
//

#import "PDPhotoLandmarkViewController.h"
#import "PDLandmarkCell.h"
#import "UIImage+MTFilter.h"
#import "PDFilterViewController.h"
#import "PDLandmarkSelectMapViewController.h"
#import "PDServerPhotoUploader.h"

@interface PDPhotoLandmarkViewController () <PDUploadPhotoDelegate>
@property (strong, nonatomic) PDUploadPhotoViewController *uploadPhotoViewController;
@property (strong, nonatomic) PDNavigationController *uploadNavigationController;
- (void)search;
@end

@implementation PDPhotoLandmarkViewController
@synthesize landmarkSearchTextField;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Select or creat Landmark", nil);
    [self setLeftBarButtonToBackWithStyle:kPDLeftBarButtonStyleGrayAngle];
    [self setRightBarButtonToButton:[self redBarButtonWithTitle:NSLocalizedString(@"skip", nil)
                                                               action:@selector(finish:)]];
    
    landmarkSearchTextField.placeholder = NSLocalizedString(@"enter name to filter or add new", nil);
    landmarkSearchTextField.rightClearButton.hidden = YES;
    [landmarkSearchTextField.rightClearButton addTarget:self
                                                 action:@selector(cancel:)
                                       forControlEvents:UIControlEventTouchUpInside];
    [self.landmarkSearchTextField uploadPhotoStyle];
    _poisTableView.tableHeaderView = _topView;
    
    if (self.photo) {
        [self setPhoto:self.photo];
    }
    if (self.filteredImage) {
        [self setFilteredImage:_filteredImage];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(search)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:landmarkSearchTextField];
    [self refetchData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self search];
    if (![self.landmarkSearchTextField.text isEqualToString:@""]) {
        [self refetchData];
    }

}

- (void)viewDidUnload
{
    self.poisTableView = nil;
    self.landmarkSearchTextField = nil;
    self.filteredItems = nil;
    self.landmarkLoader = nil;
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
}

- (PDNavigationBarStyle)defaultNavigationBarStyle
{
    return PDNavigationBarStyleWhite;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)setFilteredImage:(UIImage *)newFilteredImage
{
    _filteredImage = newFilteredImage;
    if ([self isViewLoaded]) {
        UIImage *imageBlur = [UIImage imageWithBlur:newFilteredImage];
        [self.backgroundImageView setImage:imageBlur];
        [self.backgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
        [[PDServerPhotoUploader sharedInstance] uploadImageToCloudinary:newFilteredImage];
    }
}

- (NSString *)pageName
{
    return @"Select Landmark";
}

#pragma mark - private

- (void)setPhoto:(PDPhoto *)photo
{
    _photo = photo;
    if ([self isViewLoaded]) {
        UIImage *imageBlur = [UIImage imageWithBlur:photo.image];
        [self.backgroundImageView setImage:imageBlur];
        [self.backgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
    }
}

- (void)finish:(id)sender
{
    if ([[self previousViewController] isKindOfClass:[PDFilterViewController class]]) {
        PDUploadPhotoViewController *uploadPhotoViewController = [[PDUploadPhotoViewController alloc] initWithNibName:@"PDUploadPhotoViewController" bundle:nil];
        uploadPhotoViewController.delegate = self;
        self.photo.poiItem = _selectedPOIItem;
        uploadPhotoViewController.photo = self.photo;
        [self.navigationController pushViewController:uploadPhotoViewController animated:YES];
        [uploadPhotoViewController refetchData];
    } else if ([[self previousViewController] isKindOfClass:[PDUploadPhotoViewController class]]) {
        PDUploadPhotoViewController *backViewController = (PDUploadPhotoViewController *)[self previousViewController];
        backViewController.photo.poiItem = _selectedPOIItem;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)fetchData
{
    [super fetchData];
	if (!self.landmarkLoader) {
		self.landmarkLoader = [[PDServerLandmarkLoader alloc] initWithDelegate:self];
	}
    [self.landmarkLoader loadLandmarkWithLongitude:_photo.longitude
                                          latitude:_photo.latitude
                                             range:kPDMaxLandmarkRange page:1];
}

- (void)refreshView
{
    [super refreshView];
    if (landmarkSearchTextField.text.length == 0) {
        self.landmarkSearchTextField.rightView.hidden = YES;
		self.filteredItems = self.items;
	} else {
        self.landmarkSearchTextField.rightView.hidden = NO;
		self.filteredItems = [self.items filteredArrayUsingPredicate:
							  [NSPredicate predicateWithFormat:@"name contains[c] %@", landmarkSearchTextField.text]];
	}
    [self.poisTableView reloadData];
}

#pragma mark - action

- (IBAction)cancel:(id)sender
{
	[landmarkSearchTextField resignFirstResponder];
    landmarkSearchTextField.text = nil;
    _selectedPOIItem = nil;
	[self refreshView];
}

- (void)search
{
    if (self.landmarkSearchTextField.text.length > 0) {
        self.creatLandmarkButton.enabled = YES;
        self.creatLandmarkButton.alpha = 1.0;
    } else {
        self.creatLandmarkButton.enabled = NO;
        self.creatLandmarkButton.alpha = 0.5;
    }
	[self refreshView];
}

- (IBAction)creatLandmark:(id)sender {
    PDLandmarkSelectMapViewController *landmarkSelectViewController = [[PDLandmarkSelectMapViewController alloc] initWithNibName:@"PDLandmarkSelectMapViewController" bundle:nil];
    PDPOIItem *landmark = [[PDPOIItem alloc] init];
    landmark.name = self.landmarkSearchTextField.text;
    self.photo.poiItem = landmark;
    landmarkSelectViewController.photo = self.photo;
    [self.navigationController pushViewController:landmarkSelectViewController animated:YES];
}

- (void)changeTitleRightBarButton
{
    [self setRightBarButtonToButton:[self redBarButtonWithTitle:NSLocalizedString(@"done", nil)
                                                         action:@selector(goBack:)]];
    landmarkSearchTextField.returnKeyType = UIReturnKeyDone;
}

- (void)goBack:(id)sender
{
    _photo.poiItem = _selectedPOIItem;
    [[PDServerPhotoUploader sharedInstance] cancelUploadProcess];
	[self.navigationController popViewControllerRetro];
}

#pragma mark - PDUploadDelegate

- (void)editLandmarkWithPhoto:(PDPhoto *)photo
{
    self.photo = photo;
    landmarkSearchTextField.text = nil;
    self.filteredItems = nil;
    self.items = nil;
    [self refetchData];
}

#pragma mark - Text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self finish:nil];
    return YES;
}

#pragma mark - Table delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _filteredItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *landmarkCellIndentifier = @"PDLandmarkCell";
    PDLandmarkCell *landmarkCell = (PDLandmarkCell *)[tableView dequeueReusableCellWithIdentifier:landmarkCellIndentifier];
    if (!landmarkCell) {
        landmarkCell = [UIView loadFromNibNamed:landmarkCellIndentifier];
		landmarkCell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
		landmarkCell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    PDPOIItem *poiItem = [_filteredItems objectAtIndex:indexPath.row];
    [landmarkCell setPOI:poiItem];
    return landmarkCell;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedPOIItem = (PDPOIItem *)[_filteredItems objectAtIndex:indexPath.row];
    [landmarkSearchTextField resignFirstResponder];
    landmarkSearchTextField.text = _selectedPOIItem.name;
    [self search];
    [self finish:nil];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	if (self.isKeyboardShown) {
		[landmarkSearchTextField resignFirstResponder];
	}
}

#pragma mark - Server delegate

- (void)serverExchange:(PDServerExchange *)serverExchange didParseResult:(NSDictionary *)result
{
    [super serverExchange:serverExchange didParseResult:result];
    if ([serverExchange isKindOfClass:[PDServerLandmarkLoader class]]) {
        [super serverExchange:serverExchange didParseResult:result];
        self.items = [serverExchange loadLandmarkFromArray:result[@"pois"]];
        [self refreshView];
    }
}

@end
