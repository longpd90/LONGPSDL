//
//  PDEditPhotoViewController.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 3/10/12.
//
//

#import "PDEditPhotoViewController.h"

@interface PDEditPhotoViewController ()
@end

@implementation PDEditPhotoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = NSLocalizedString(@"Edit Photo", nil);
    self.shareView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setLeftBarButtonToBackWithStyle:kPDLeftBarButtonStyleGrayAngle];
    [self setRightBarButtonToButton:[self redBarButtonWithTitle:NSLocalizedString(@"done", nil)
                                                               action:@selector(finish:)]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
}

- (PDNavigationBarStyle)defaultNavigationBarStyle
{
    return PDNavigationBarStyleWhite;
}

#pragma mark - Public

- (void)goBack:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)validateData
{
	if (self.titleTextField.text.length == 0) {
		[UIAlertView showAlertWithTitle:nil message:NSLocalizedString(@"Please enter photo title", nil)];
		return NO;
	}
    if (!self.photo) {
        [UIAlertView showAlertWithTitle:nil message:NSLocalizedString(@"The photo data was nil", nil)];
    }
	return YES;
}

- (NSString *)pageName
{
	return @"Edit Photo";
}

- (void)refreshView
{
	[super refreshView];
	self.descriptionTextField.text = self.photo.details;
	self.titleTextField.text = self.photo.title;
}

- (void)finish:(id)sender
{
	if (![self validateData]) return;
	
	[self trackEvent:@"Edit photo"];
		
	[kPDAppDelegate showWaitingSpinner];
	if (!self.serverExchange) {
		self.serverExchange = [[PDServerEditPhoto alloc] initWithDelegate:self];
	}
	[self.serverExchange uploadPhotoData:self.photo
								   title:self.titleTextField.text
							 description:self.descriptionTextField.text
									tags:self.photo.tags];
}

#pragma mark - Server delegate

- (void)serverExchange:(PDServerExchange *)serverExchange didFailWithError:(NSString *)error
{
	[kPDAppDelegate hideWaitingSpinner];
	[self showErrorMessage:error];
}

- (void)serverExchange:(PDServerExchange *)serverExchange didParseResult:(NSDictionary *)result
{
	[kPDAppDelegate hideWaitingSpinner];
	self.photo.title = self.titleTextField.text;
	self.photo.details = self.descriptionTextField.text;
	
	NSDictionary *userInfo = @{
	@"object" : self.photo,
	@"values" : @[@{@"value" : self.photo.title, @"key" : @"title"},
	@{@"value" : self.photo.details, @"key" : @"details"},
	@{@"value" : (self.photo.tags.length > 0) ? self.photo.tags : @"", @"key" : @"tags"}]};
	[[NSNotificationCenter defaultCenter] postNotificationName:kPDItemWasChangedNotification
													object:self
												  userInfo:userInfo];
	[self.navigationController popViewControllerAnimated:YES];
}

@end
