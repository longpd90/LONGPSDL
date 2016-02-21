//
//  PDPlanMapViewController.m
//  Pashadelic
//
//  Created by LongPD on 8/12/14.
//
//

#import "PDPlanMapViewController.h"
#import <Social/Social.h>

@interface PDPlanMapViewController ()

@end

@implementation PDPlanMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.photosMapView.changeMapModeButton.hidden = YES;
    [self setLeftBarButtonToBackWithStyle:kPDLeftBarButtonStyleGrayAngle];
    [self setRightBarButtonToButton:[self redBarButtonWithTitle:NSLocalizedString(@"route", nil)
                                                         action:@selector(routeToThePhoto)]];
    self.title = nil;
    
    CLLocation *planLocation = [[CLLocation alloc] initWithLatitude:self.plan.latitude longitude:self.plan.longitude];
    
    [self setPlanLocation:planLocation];
    [self updateNavigationBar];

}

- (NSString *)pageName
{
    return @"Plan Map View";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.customNavigationBar.titleButton.hidden = YES;
    self.shareButton.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.shareButton.hidden = YES;
}

#pragma mark - private

- (void)updateNavigationBar
{
    CGFloat fontSize = 22;
    [self.shareButton setFontAwesomeIconForImage:[FAKFontAwesome shareSquareIconWithSize:fontSize]
                                        forState:UIControlStateNormal
                                      attributes:@{NSForegroundColorAttributeName:kPDGlobalGrayColor}];
	[self.shareButton setFontAwesomeIconForImage:[FAKFontAwesome shareSquareIconWithSize:fontSize]
                                        forState:UIControlStateSelected
                                      attributes:@{NSForegroundColorAttributeName:kPDGlobalGreenColor}];
    self.shareButton.x = 40;
    self.shareButton.y = 5.5;
    [self.navigationController.navigationBar addSubview:self.shareButton];

}

- (IBAction)shareButton:(id)sender {
    [self shareAction];
}

#pragma mark - share plan

- (void)shareAction
{
      UIActionSheet *shareActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                        delegate:self
                                               cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:NSLocalizedString(@"Share on Facebook",nil), NSLocalizedString(@"Share on Twitter", nil), nil];
    [shareActionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)shareWithFacebook
{
	SLComposeViewController *facebookController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
	[facebookController setInitialText:NSLocalizedString(@"Share Plan", nil)];
	NSString *sharePlanURL = [kPDSharePlanURL stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)self.plan.identifier]];
	[facebookController addURL:[NSURL URLWithString:sharePlanURL]];
	[self presentViewController:facebookController animated:YES completion:nil];
    [self trackEvent:@"Share Facebook"];
}

- (void)shareWithTwitter
{
	NSString *sharePlanURL = [kPDSharePlanURL stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)self.plan.identifier]];
	SLComposeViewController *twitterController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
//	[twitterController addImage:self.photoPlanImageView.image];
	[twitterController setInitialText:sharePlanURL];
	[self presentViewController:twitterController animated:YES completion:nil];
    
    [self trackEvent:@"Share Twitter"];
}

- (void)initPhotoMapToolsView
{
}

- (void)routeToThePhoto
{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:NSLocalizedString(@"Do you want to open in map?", nil)
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"Yes", nil)
                                              otherButtonTitles:NSLocalizedString(@"No", nil), nil];
    [alertView show];
}

- (void)loadPlaceWithLatitude:(float)lat andLongitude:(float)lng
{
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(lat, lng);
    self.searchLocation = location;
}

- (void)setPlanLocation:(CLLocation *)planLocation
{
    if (!planLocation)
        return;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    _planeDate = [dateFormatter dateFromString:self.plan.time];

    _planLocation = planLocation;
    [self loadPlaceWithLatitude:planLocation.coordinate.latitude    andLongitude:planLocation.coordinate.longitude];
    self.isHiddenSunMoon = NO;
    
    CGFloat fontSize = 20;
    NSDictionary *whiteColorAttribute = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
	[self.sunriseImageView setFontAwesomeIconForImage:[FAKFontAwesome longArrowUpIconWithSize:fontSize] withAttributes:whiteColorAttribute];
    
    [self.sunsetImageView setFontAwesomeIconForImage:[FAKFontAwesome longArrowDownIconWithSize:fontSize] withAttributes:whiteColorAttribute];
    
    float lat = planLocation.coordinate.latitude;
    float lng = planLocation.coordinate.longitude;
    
    if (!_sunMoonCalc) {
        self.sunMoonCalc = [[SunMoonCalcGobal alloc] init];
    }
    [self.sunMoonCalc computeMoonriseAndMoonSet:_planeDate withLatitude:lat withLongitude:lng];
    [self.sunMoonCalc computeSunriseAndSunSet:_planeDate withLatitude:lat withLongitude:lng];
    
    BOOL moonRiseBeforeMoonSet = (self.sunMoonCalc.timeRiseMoon.timeIntervalSince1970 < self.sunMoonCalc.timeSetMoon.timeIntervalSince1970);
    
	if (moonRiseBeforeMoonSet) {
		[self.moonriseImageView setFontAwesomeIconForImage:[FAKFontAwesome longArrowUpIconWithSize:fontSize] withAttributes:whiteColorAttribute];
		[self.moonsetImageView setFontAwesomeIconForImage:[FAKFontAwesome longArrowDownIconWithSize:fontSize] withAttributes:whiteColorAttribute];
		
	} else {
		[self.moonriseImageView setFontAwesomeIconForImage:[FAKFontAwesome longArrowDownIconWithSize:fontSize] withAttributes:whiteColorAttribute];
		[self.moonsetImageView setFontAwesomeIconForImage:[FAKFontAwesome longArrowUpIconWithSize:fontSize] withAttributes:whiteColorAttribute];
	}
    
    if (moonRiseBeforeMoonSet) {
        if (self.sunMoonCalc.MoonRise) {
            self.moonriseLabel.text = [NSString stringWithFormat:@"%@:%@",[self.sunMoonCalc.timeRiseMoon stringValueFormattedBy:@"HH"],[self.sunMoonCalc.timeRiseMoon stringValueFormattedBy:@"mm"]];
        }
        if (self.sunMoonCalc.MoonSet)
        {
            self.moonsetLabel.text = [NSString stringWithFormat:@"%@:%@",[self.sunMoonCalc.timeSetMoon stringValueFormattedBy:@"HH"],[self.sunMoonCalc.timeSetMoon stringValueFormattedBy:@"mm"]];
        }
    } else {
        if (self.sunMoonCalc.MoonSet == YES ) {
            self.moonriseLabel.text = [NSString stringWithFormat:@"%@:%@",[self.sunMoonCalc.timeSetMoon stringValueFormattedBy:@"HH"],[self.sunMoonCalc.timeSetMoon stringValueFormattedBy:@"mm"]];
        }
        if (self.sunMoonCalc.MoonRise == YES)
        {
            self.moonsetLabel.text = [NSString stringWithFormat:@"%@:%@",[self.sunMoonCalc.timeRiseMoon stringValueFormattedBy:@"HH"],[self.sunMoonCalc.timeRiseMoon stringValueFormattedBy:@"mm"]];
        }
    }
    
    if (_sunMoonCalc.todayHaveMoon == YES) {
        if (self.sunMoonCalc.MoonRise == YES )
            [self drawMoonPhaseWithLat:lat withDate:self.sunMoonCalc.timeRiseMoon];
        else if (self.sunMoonCalc.MoonSet == YES)
            [self drawMoonPhaseWithLat:lat withDate:self.sunMoonCalc.timeSetMoon];
        else
            [self drawMoonPhaseWithLat:lat withDate:_planeDate];
    }
    NSDictionary *sunTimes = [_sunMoonCalc getSunTimesWithDate:_planeDate andLatitude:lat andLogitude:lng];
    
    NSDate *sunriseTime = (NSDate *)[sunTimes objectForKey:@"sunrise"];
    NSDate *sunsetTime = (NSDate *)[sunTimes objectForKey:@"sunset"];
    _sunriseLabel.text = [NSString stringWithFormat:@"%@:%@",[sunriseTime stringValueFormattedBy:@"HH"],
                          [sunriseTime stringValueFormattedBy:@"mm"]];
    _sunsetLabel.text = [NSString stringWithFormat:@"%@:%@",[sunsetTime stringValueFormattedBy:@"HH"],
                         [sunsetTime stringValueFormattedBy:@"mm"]];

    self.latLonLabel.text = [NSString stringWithFormat:NSLocalizedString(@"latitude: %.2f / longitude: %.2f", nil),lat, lng];
}

- (void)drawMoonPhaseWithLat:(float)lat withDate:(NSDate *)dateC
{
    NSDate *dateC2 = [NSDate dateWithTimeInterval:1 sinceDate:dateC];
    
    double fraction = [_sunMoonCalc getMoonFraction:dateC];
    double fraction2 = [_sunMoonCalc getMoonFraction:dateC2];
    double moonFraction = fraction2 - fraction;
    
    float op = fraction;
    
    [self.draw drawMoon:25 andOption:op color:[UIColor whiteColor]];
    
    if (moonFraction > 0)
        _PDMoonPhase = FirstQuarter;
    else
        _PDMoonPhase = Lastquarter;
    
    if (((lat > 0 ) && (_PDMoonPhase == FirstQuarter)) || ((lat < 0) && (_PDMoonPhase == Lastquarter)))
        _draw.transform = CGAffineTransformMakeRotation(M_PI);
    else
        _draw.transform = CGAffineTransformMakeRotation(0);
}

#pragma mark -  ActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
 switch (buttonIndex)
        {
            case 0:
            {
                [self shareWithFacebook];
                break;
            }
            case 1:
            {
//                [self shareWithTwitter];
                break;
            }
            default:
                break;
        }
}

#pragma mark - Alert View delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == alertView.cancelButtonIndex) {
        [self trackEvent:@"Route to photo"];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.apple.com/maps?saddr=%f,%f&daddr=%f,%f",
                                           _planLocation.coordinate.latitude, _planLocation.coordinate.longitude,
                                           [[PDLocationHelper sharedInstance] latitudes],
                                           [[PDLocationHelper sharedInstance] longitudes]]];
        [[UIApplication sharedApplication] openURL:url];
	}
}

@end
