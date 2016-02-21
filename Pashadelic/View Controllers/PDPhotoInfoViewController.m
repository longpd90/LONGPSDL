//
//  PDPhotoInfoViewController.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 13.06.13.
//
//

#import "PDPhotoInfoViewController.h"
#import "PDPhotoSpotViewController.h"
#import "PDPhotoTipsView.h"

@interface PDPhotoInfoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *cameraLabel;
@property (weak, nonatomic) IBOutlet UILabel *focalLenghtLabel;
@property (weak, nonatomic) IBOutlet UILabel *shutterSpeedLabel;
@property (weak, nonatomic) IBOutlet UILabel *apertureLabel;
@property (weak, nonatomic) IBOutlet UILabel *isoLabel;
@property (weak, nonatomic) IBOutlet UILabel *altitudeLabel;
@property (weak, nonatomic) IBOutlet UIView *exifInfoView;

- (void)selectReportReason;

@end

@implementation PDPhotoInfoViewController

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
	self.sourceButton.titleLabel.numberOfLines = 0;
	self.sourceButton.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
	[self.reportButton setImage:[self.reportButton imageForState:UIControlStateSelected] forState:UIControlStateSelected | UIControlStateHighlighted];
    self.scrollBackgroundView.contentSize = self.view.frame.size;
    _tipsLabel.text = NSLocalizedString(@"Tips", nil);
	[(UILabel *) [self.exifInfoView viewWithTag:1] setText:NSLocalizedString(@"Date", nil)];
	[(UILabel *) [self.exifInfoView viewWithTag:2] setText:NSLocalizedString(@"Camera", nil)];
	[(UILabel *) [self.exifInfoView viewWithTag:3] setText:NSLocalizedString(@"Focal Length", nil)];
	[(UILabel *) [self.exifInfoView viewWithTag:4] setText:NSLocalizedString(@"Shutter", nil)];
	[(UILabel *) [self.exifInfoView viewWithTag:5] setText:NSLocalizedString(@"Aperture", nil)];
	[(UILabel *) [self.exifInfoView viewWithTag:6] setText:NSLocalizedString(@"ISO / Film", nil)];
	[(UILabel *) [self.exifInfoView viewWithTag:7] setText:NSLocalizedString(@"Altitude", nil)];
    self.view.backgroundColor = [UIColor darkGrayColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
	[self setDateLabel:nil];
	[self setCameraLabel:nil];
	[self setFocalLenghtLabel:nil];
	[self setShutterSpeedLabel:nil];
	[self setApertureLabel:nil];
	[self setIsoLabel:nil];
	[self setAltitudeLabel:nil];
	[self setExifInfoView:nil];
    [self setReportButton:nil];
	[super viewDidUnload];
}

- (NSString *)pageName
{
	return @"Photo EXIF Info";
}

- (void)setPhoto:(PDPhoto *)photo
{
	_photo = photo;
	self.dateLabel.text = photo.date;
	self.cameraLabel.text = photo.cameraInfo;
	self.focalLenghtLabel.text = photo.focalLength;
	self.shutterSpeedLabel.text = photo.shutterSpeed;
	self.apertureLabel.text = photo.aperture;
	self.isoLabel.text = photo.isoFilm;
	self.altitudeLabel.text = [NSString stringWithFormat:@"%.0f", photo.altitude];
    if (photo.tripod != kPDNoTip) {
        if (photo.tripod == 1) {
            [self addTipWithImageName:@"icon-tripod.png" withTitle:NSLocalizedString(@"A tripod can be used here.", nil)];
        } else {
            [self addTipWithImageName:@"icon-no-tripod.png" withTitle:NSLocalizedString(@"A tripod can't be used here.", nil)];
        }
    }
    
    if (photo.is_crowded != kPDNoTip) {
        if (photo.is_crowded == 1)
            [self addTipWithImageName:@"icon-crowded.png" withTitle:NSLocalizedString(@"This place was crowded.", nil)];
        else
            [self addTipWithImageName:@"icon-no-cowded.png" withTitle:NSLocalizedString(@"This place wasn't crowded.", nil)];
    }
    
    if (photo.is_parking != kPDNoTip) {
        if (photo.is_parking == 1)
            [self addTipWithImageName:@"icon-parking.png" withTitle:NSLocalizedString(@"There is parking nearby.", nil)];
        else
            [self addTipWithImageName:@"icon-no-parking.png" withTitle:NSLocalizedString(@"There isn't parking nearby.", nil)];
    }
    
    if (photo.is_dangerous != kPDNoTip) {
        if (photo.is_dangerous == 1)
            [self addTipWithImageName:@"icon-caution.png" withTitle:NSLocalizedString(@"This place requires caution.", nil)];
        else
            [self addTipWithImageName:@"icon-no-caution.png" withTitle:NSLocalizedString(@"This place is safe.", nil)];
    }
    
    if (photo.indoor != kPDNoTip) {
        if (photo.indoor == 1)
            [self addTipWithImageName:@"icon-indoor.png" withTitle:NSLocalizedString(@"This place is indoor.", nil)];
        else
            [self addTipWithImageName:@"icon-outdoor.png" withTitle:NSLocalizedString(@"This place is outdoor.", nil)];
    }
    
    if (photo.is_permission != kPDNoTip) {
        if (photo.is_permission == 1)
            [self addTipWithImageName:@"icon-permission.png" withTitle:NSLocalizedString(@"Permission is required to access.", nil)];
        else
            [self addTipWithImageName:@"icon-no-permission.png" withTitle:NSLocalizedString(@"Permission isn't required to access.", nil)];
    }
    
    if (photo.is_paid != kPDNoTip) {
        if (photo.is_paid == YES)
            [self addTipWithImageName:@"icon-no-free.png" withTitle:NSLocalizedString(@"There is no fee to enter the spot.", nil)];
        else
            [self addTipWithImageName:@"icon-free.png" withTitle:NSLocalizedString(@"There is a fee to enter the spot.", nil)];
    }

    if (photo.difficulty_access != 0) {
        if (photo.difficulty_access == 1)
            [self addTipWithImageName:@"icon-hard.png" withTitle:NSLocalizedString(@"Difficulty to photograph this spot: hard", nil)];
        else if (photo.difficulty_access == 2)
            [self addTipWithImageName:@"icon-medium.png" withTitle:NSLocalizedString(@"Difficulty to photograph this spot: medium", nil)];
        else if (photo.difficulty_access == 3)
            [self addTipWithImageName:@"icon-easy.png" withTitle:NSLocalizedString(@"Difficulty to photograph this spot: easy", nil)];
    }
    
    self.reportButton.y = self.tipsView.bottomYPoint + 30;
 
	if (photo.source.length > 0) {
		[self.sourceButton setTitle:[NSString stringWithFormat:@"Source : %@", photo.source] forState:UIControlStateNormal];
        self.sourceButton.y = self.tipsView.bottomYPoint + 30;
		self.sourceButton.height = [self.sourceButton.title
                                    sizeWithFont:self.sourceButton.titleLabel.font
                                    constrainedToSize:CGSizeMake(self.sourceButton.width, MAXFLOAT)
                                    lineBreakMode:NSLineBreakByCharWrapping].height;
		self.reportButton.y = self.sourceButton.bottomYPoint + 30;
		self.sourceButton.hidden = NO;
	}
	self.reportButton.selected = (self.photo.user.identifier == kPDUserID);
    [self setShawdowStyle:self.viewForDeleteButton];
    [self setShawdowStyle:self.viewForReportButton];
    [self refreshViewForReportAndDeleteButton];
}

- (void)setShawdowStyle:(UIView *)view
{
    view.layer.cornerRadius = 3;
	view.layer.shadowOffset = CGSizeMake(1, 1);
	view.layer.shadowOpacity = 0.5;
	view.layer.shadowRadius = 1;
	view.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    view.layer.borderColor = [UIColor whiteColor].CGColor;
	view.layer.borderWidth = 0.5;
}

- (void)refreshViewForReportAndDeleteButton
{
    _viewForDeleteButton.frame = _reportButton.frame;
    _viewForReportButton.frame = _reportButton.frame;
    if (self.reportButton.selected) {
        _viewForDeleteButton.hidden = NO;
        _viewForReportButton.hidden = YES;

    }
    else {
        _viewForReportButton.hidden = NO;
        _viewForDeleteButton.hidden = YES;
    }
}

- (PDNavigationBarStyle)defaultNavigationBarStyle
{
	return PDNavigationBarStyleBlack;
}

- (IBAction)closeView:(id)sender
{
	[self.viewDeckController toggleRightViewAnimated:YES];
}

- (IBAction)sourceButtonTouch:(id)sender
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.photo.source]];
}

- (IBAction)report:(id)sender
{
	if (self.reportButton.isSelected) {
		[kPDAppDelegate showWaitingSpinner];
		self.serverExchange  = [[PDServerDeletePhoto alloc] initWithDelegate:self];
		[self.serverExchange deletePhoto:self.photo];
		
	} else {
		[self selectReportReason];
	}
}

- (void)selectReportReason
{
	UIAlertView *alertView =
	[[UIAlertView alloc] initWithTitle:nil
							   message:NSLocalizedString(@"Tell us why the photo is inappropriate", nil)
							  delegate:self
					 cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
					 otherButtonTitles:
	 NSLocalizedString(@"Offensive (nude, obscene, violence)", nil),
	 NSLocalizedString(@"Spam (ads, self-promotion)", nil),
	 NSLocalizedString(@"Irrelevant Content (3D, graphics)", nil),
	 NSLocalizedString(@"Wrong location", nil), nil];
	[alertView show];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesEnded:touches withEvent:event];
	[self closeView:nil];
}

- (void)addTipWithImageName:(NSString *)iconName withTitle:(NSString *)tile
{
    _tipsView.hidden = NO;
    PDPhotoTipsView *photoTipsView = [[PDPhotoTipsView alloc] init];
    photoTipsView.y = _tipsView.height + 20;
    photoTipsView.x = 10;
    UIImage *image = [UIImage imageNamed:iconName];
    [photoTipsView setcontentImage:image withTitle:tile];
    [_tipsView addSubview:photoTipsView];
    _tipsCount ++;
    _tipsView.height = _tipsView.height + photoTipsView.height;
}

#pragma mark - Alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == alertView.cancelButtonIndex) return;
	
	[kPDAppDelegate showWaitingSpinner];
	self.serverExchange = [[PDServerPhotoReport alloc] initWithDelegate:self];
	[self.serverExchange reportAboutPhoto:self.photo reason:buttonIndex];
}

#pragma mark - Server exchange delegate

- (void)serverExchange:(PDServerExchange *)serverExchange didParseResult:(NSDictionary *)result
{
	[kPDAppDelegate hideWaitingSpinner];
	
	if ([serverExchange isKindOfClass:[PDServerPhotoReport class]]) {
		[UIAlertView showAlertWithTitle:nil message:NSLocalizedString(@"You reported about photo", nil)];
		
	} else {
		[UIAlertView showAlertWithTitle:nil message:NSLocalizedString(@"You deleted photo", nil)];
		[self closeView:nil];
		if ([self.ownerViewController isKindOfClass:[PDPhotoSpotViewController class]]) {
			[self.ownerViewController goBack:nil];
		}
	}
}

- (void)serverExchange:(PDServerExchange *)serverExchange didFailWithError:(NSString *)error
{
	[kPDAppDelegate hideWaitingSpinner];
	[self showErrorMessage:error];
}

@end
