//
//  PDCollectionsViewController.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 12.07.13.
//
//

#import "PDCollectionsViewController.h"
#import "PDUserProfile.h"
#import "PDCollectionCell.h"
#import "PDServerCollectionsLoader.h"


@interface PDCollectionsViewController ()

@property (strong, nonatomic) PDServerCollectionsLoader *serverCollectionsLoader;

@end

@implementation PDCollectionsViewController

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
    self.view.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
	NSDictionary *imageAttributes = @{NSForegroundColorAttributeName:kPDGlobalGrayColor};
	[self.closeButton setFontAwesomeIconForImage:[FAKFontAwesome timesIconWithSize:25] forState:UIControlStateNormal attributes:imageAttributes];
	self.descriptionTextView.layer.cornerRadius = 5;
    [self.createButton setTitle:NSLocalizedString(@"+ create", nil) forState:UIControlStateNormal];
	self.createButton.layer.cornerRadius = 4;
	self.createButton.clipsToBounds = YES;
    self.createButton.enabled = NO;
    [self.createButton setBackgroundColor:[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1]];
	self.descriptionTextView.placeholder = NSLocalizedString(@"Leave a note so you know why you collected this photo", nil);
	self.folderNameTextField.placeholder = NSLocalizedString(@"Title of new folder", nil);
	if (self.photo) {
		self.photo = self.photo;
	}
    [self refetchData];
    [self setupFolderTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                          selector:@selector(searchFolderTableView)
                                          name:UITextFieldTextDidChangeNotification
                                          object:self.folderNameTextField];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.foldersTableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super viewDidUnload];

}

- (NSString *)pageName
{
    return @"Collections";
}

- (void)setupFolderTableView
{
    self.loadingMoreContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 46)];
	[self.loadingMoreContentView clearBackgroundColor];
	UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	activityView.color = [UIColor blackColor];
	activityView.center = self.loadingMoreContentView.centerOfView;
	[activityView startAnimating];
	[self.loadingMoreContentView addSubview:activityView];
	self.tableViewState = PDItemsTableViewStateNormal;
}

#pragma mark - folder table view

- (void)setTableViewState:(PDItemsTableViewViewState)tableViewState
{
	_tableViewState = tableViewState;
	switch (tableViewState) {
		case PDItemsTableViewStateNormal:
		{
			self.foldersTableView.tableFooterView = nil;
			break;
		}
		case PDItemsTableViewStateLoadingMoreContent:
		{
			self.foldersTableView.tableFooterView = self.loadingMoreContentView;
			break;
		}
		case PDItemsTableViewStateRefreshing:
		{
			self.foldersTableView.tableFooterView = nil;
			break;
		}
		case PDItemsTableViewStateReloading:
		{
			self.foldersTableView.tableFooterView = nil;
			break;
		}
		default:
			break;
	}
}


#pragma mark - fetch data

- (void)fetchData
{
	if ([kPDAuthToken length] == 0) return;
    [super fetchData];
	if (!self.serverCollectionsLoader) {
		self.serverCollectionsLoader = [[PDServerCollectionsLoader alloc] initWithDelegate:self];
	}
	[self.serverCollectionsLoader loadCollectionsPage:self.currentPage];
}

#pragma mark - Actions

- (IBAction)createNewCollection:(id)sender
{
	if (self.folderNameTextField.text.length == 0) {
		[UIAlertView showAlertWithTitle:nil message:NSLocalizedString(@"Please enter folder title", nil)];
		return;
	}
	self.serverCreateCollection = [[PDServerCreateCollection alloc] initWithDelegate:self];
	PDPhotoCollection *collection = [PDPhotoCollection new];
	collection.title = self.folderNameTextField.text;
	[self.serverCreateCollection createCollection:collection photo:self.photo];
    [self.photo pinPhoto];
    [self goBack:nil];
}

- (void)addPhotoToCollection:(PDPhotoCollection *)photoCollection
{
    self.serverAddPhotoToCollection = [[PDServerAddPhotoToCollection alloc] initWithDelegate:self];
    [self.serverAddPhotoToCollection addPhoto:self.photo toCollection:photoCollection];
    [self.photo pinPhoto];
    [self goBack:nil];
}

- (IBAction)goBack:(id)sender
{
	[self.view endEditing:YES];
	[UIView animateWithDuration:0.2 animations:^{
		self.contentView.y = self.view.height;
	} completion:^(BOOL finished) {
		[self removeFromParentViewController];
		[self.view removeFromSuperview];
	}];
}

- (void)setPhoto:(PDPhoto *)photo
{
	_photo = photo;
	self.folderNameTextField.text = @"";
	self.descriptionTextView.text = @"";
	[self.photoImageView sd_setImageWithURL:self.photo.thumbnailURL];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
	[super keyboardWillShow:notification];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
	[super keyboardWillHide:notification];
}

- (void)searchFolderTableView
{
    if (self.folderNameTextField.text.length == 0) {
        [self.createButton setBackgroundColor:[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1]];
        self.createButton.enabled = NO;
        self.photoCollections = kPDUserProfile.photoCollections;
	} else {
        [self.createButton setBackgroundColor:kPDGlobalRedColor];
        self.createButton.enabled = YES;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title contains[c] %@", self.folderNameTextField.text];
        self.photoCollections = [kPDUserProfile.photoCollections filteredArrayUsingPredicate:predicate];
	}
    [self.foldersTableView reloadData];
}

- (void)willShowLastCells
{
    if (self.tableViewState != PDItemsTableViewStateNormal) return;
	
	if (self.currentPage < self.totalPages) {
		self.currentPage++;
		[self fetchData];
		self.tableViewState = PDItemsTableViewStateLoadingMoreContent;
	}
}

#pragma mark - setCollections

- (void)setCollections:(NSArray *)photoCollections
{
	if (self.tableViewState == PDItemsTableViewStateLoadingMoreContent) {
		[self appendPhotoCollections:photoCollections];
	} else {
		self.photoCollections = photoCollections;
		[self.foldersTableView reloadData];
	}
	self.tableViewState = PDItemsTableViewStateNormal;
}

- (void)appendPhotoCollections:(NSArray *)photoCollections
{
	if (!_photoCollections) {
		_photoCollections = photoCollections;
	} else {
		_photoCollections = [_photoCollections arrayByAddingObjectsFromArray:photoCollections];
	}
	[self.foldersTableView reloadData];
}

#pragma mark - view delegate

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.folderNameTextField resignFirstResponder];
    [self.descriptionTextView resignFirstResponder];
}

#pragma mark - Table delegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.photoCollections.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier	= @"PDCollectionCell";
	
	PDCollectionCell *cell = (PDCollectionCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [PDCollectionCell loadFromNibNamed:CellIdentifier];
	}
	
	cell.collection = self.photoCollections[indexPath.row];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	self.serverAddPhotoToCollection = [[PDServerAddPhotoToCollection alloc] initWithDelegate:self];
    PDPhotoCollection *photoCollection = (PDPhotoCollection *)self.photoCollections[indexPath.row];
    [self addPhotoToCollection:photoCollection];
    [self.photo pinPhoto];
	[self goBack:nil];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [self.foldersTableView.dataSource tableView:self.foldersTableView numberOfRowsInSection:indexPath.section] - 3) {
        [self willShowLastCells];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.folderNameTextField resignFirstResponder];
    [self.descriptionTextView resignFirstResponder];
}

#pragma mark - Server exchange delegate

- (void)serverExchange:(PDServerExchange *)serverExchange didFailWithError:(NSString *)error
{
	[kPDAppDelegate hideWaitingSpinner];
	[[PDSingleErrorAlertView instance] showErrorMessage:error];
    if ([serverExchange isKindOfClass:[PDServerCollectionsLoader class]]) {
        self.loading = NO;
    }
}

- (void)serverExchange:(PDServerExchange *)serverExchange didParseResult:(NSDictionary *)result
{
	[kPDAppDelegate hideWaitingSpinner];
	if ([serverExchange isKindOfClass:[PDServerAddPhotoToCollection class]]) {
		PDServerAddPhotoToCollection *serverAddPhoto = (PDServerAddPhotoToCollection *)serverExchange;
		[PDPopupView showPopupWithImage:serverAddPhoto.photo.cachedImage
								   text:[NSString stringWithFormat:NSLocalizedString(@"added to %@", nil), serverAddPhoto.photoCollection.title] position:PDPopupPositionBottom];
		
	} else if ([serverExchange isKindOfClass:[PDServerCreateCollection class]]) {
		PDServerCreateCollection *serverCreateCollection = (PDServerCreateCollection *)serverExchange;
        [PDPopupView showPopupWithImage:serverCreateCollection.photo.cachedImage
								   text:[NSString stringWithFormat:NSLocalizedString(@"added to %@", nil),serverCreateCollection.collection.title] position:PDPopupPositionBottom];

	} else if ([serverExchange isKindOfClass:[PDServerCollectionsLoader class]]) {
        self.loading = NO;
        self.currentPage = [result intForKey:@"page"];
        self.totalPages = [result intForKey:@"total_pages"];
        NSDictionary *photoCollections = result[@"others"];
		NSMutableArray *collections = [NSMutableArray array];
		for (NSDictionary *collectionInfo in photoCollections) {
			PDPhotoCollection *collection = [PDPhotoCollection new];
			[collection loadFromDictionary:collectionInfo];
			[collections addObject:collection];
		}
        [self setCollections:collections];
		kPDAppDelegate.userProfile.photoCollections = self.photoCollections;
	}
}

@end
