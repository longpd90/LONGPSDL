//
//  PDFilterSearchViewController.m
//  Pashadelic
//
//  Created by LongPD on 2/21/14.
//
//

#import "PDFilterSearchViewController.h"

#define kPDMilesToKmUnit       1.609
#define kPDDefaultFilterRange  500

@interface PDFilterSearchViewController ()
- (void)initialize;
- (void)fetchData;
- (void)setupRangeViewIfNeeded;
- (NSString *)stringDateFromTo;
- (NSString *)stringTimeFromTo;
@end

@implementation PDFilterSearchViewController

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
    self.title = NSLocalizedString(@"filter results", nil);
    [self setRightBarButtonToButton:[self redBarButtonWithTitle:NSLocalizedString(@"go", nil) action:@selector(go:)]];
    PDGradientButton *cancelButton = [self grayBarButtonWithTitle:NSLocalizedString(@"cancel explore", nil) action:@selector(goBack:)];
    [self setLeftBarButtonToButton:cancelButton];
    cancelButton.theSideBarButton = kPDSideRightBarButton;

    [self initialize];
    [self fetchData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:_topbarArrow];
    self.dateLabel.text = [self stringDateFromTo];
    self.timeLabel.text = [self stringTimeFromTo];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_topbarArrow removeFromSuperview];
}

- (NSString *)pageName
{
	return @"Explore Filter";
}

- (void)setupRangeViewIfNeeded
{
    if (_locationSpecific && _locationSpecific.length > 0) {
        self.rangeView.hidden = NO;
        [self.locationSpecificLabel setText:_locationSpecific];
    } else {
        self.rangeView.hidden = YES;
    }
}

- (void)setLocationSpecific:(NSString *)locationSpecific
{
    _locationSpecific = locationSpecific;
    if ([self isViewLoaded]) {
        [self setupRangeViewIfNeeded];
    }
}

#pragma mark - private

- (void)initialize
{
    if (!_topbarArrow) {
        _topbarArrow = [[UIImageView alloc]initWithFrame:CGRectMake(149, 43, 22, 11)];
        _topbarArrow.image = [UIImage imageNamed:@"img-arrow-down.png"];
    }
    [self.navigationController.navigationBar addSubview:_topbarArrow];
    
	CGFloat fontSize = 15;
	NSDictionary *whiteColorAttribute = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
	NSDictionary *blackColorAttribute = @{NSForegroundColorAttributeName: [UIColor blackColor]};
  
	[self.iconAngleRightDate setFontAwesomeIconForImage:[FAKFontAwesome angleRightIconWithSize:fontSize] withAttributes:blackColorAttribute];
	[self.iconAngleRightTime setFontAwesomeIconForImage:[FAKFontAwesome angleRightIconWithSize:fontSize] withAttributes:blackColorAttribute];
	[self.iconCaretDown setFontAwesomeIconForImage:[FAKFontAwesome caretDownIconWithSize:fontSize] withAttributes:whiteColorAttribute];
   
    self.sortbyLabel.text = NSLocalizedString(@"sort by", nil);
    [_sortSegemented setTitle:NSLocalizedString(@"Date", nil) forSegmentAtIndex:0];
    [_sortSegemented setTitle:NSLocalizedString(@"Popularity", nil) forSegmentAtIndex:1];
    [_sortSegemented setTitle:NSLocalizedString(@"Distance", nil) forSegmentAtIndex:2];
    
    self.rangeLabel.text = NSLocalizedString(@"range", nil);
    self.radiusLabel.text = NSLocalizedString(@"photo within the radius of", nil);
    [_kmButton setTitle:NSLocalizedString(@"km", nil) forState:UIControlStateNormal];
    [_kmButton setTitle:[_kmButton titleForState:UIControlStateNormal] forState:UIControlStateSelected];
    [_milesButton setTitle:NSLocalizedString(@"miles", nil) forState:UIControlStateNormal];
    [_milesButton setTitle:[_milesButton titleForState:UIControlStateNormal] forState:UIControlStateSelected];
    [self.fromLabel setText:NSLocalizedString(@"from location", nil)];
    CGSize textSize = [self.fromLabel.text sizeWithFont:self.fromLabel.font];
    self.fromLabel.frame = CGRectWithWidth(self.fromLabel.frame, textSize.width);
    self.locationSpecificLabel.frame = CGRectWithX(self.locationSpecificLabel.frame, self.fromLabel.rightXPoint + 5);
    [self setupRangeViewIfNeeded];
}

- (void)fetchData
{
    _sortSegemented.selectedSegmentIndex = kPDFilterNearbySortType;
    float floatRange = kPDFilterNearbyRange;
    _distanceTextField.text = [NSString stringWithFormat:@"%zd", [self distanceRangeFromFloat:floatRange]];
}

- (void)finish
{
    [kPDUserDefaults setInteger:self.selectedSorting forKey:kPDFilterNearbySortTypeKey];
    float rangeSearch = [self floatFromUnit:[self.distanceTextField.text floatValue]];
    [kPDUserDefaults setFloat:rangeSearch forKey:kPDFilterNearbyRangeKey];
}

# pragma mark - fetch data

- (NSString *)stringDateFromTo
{
    if (kPDFilterNearbyDateFrom == 0 || kPDFilterNearbyDateTo == 0) {
        return NSLocalizedString(@"when photo was photographed", nil);
    } else {
        NSArray *months = [NSArray arrayWithObjects:@"January", @"February", @"March", @"April", @"May", @"June",
                           @"July", @"August", @"September", @"October", @"November", @"December", nil];
        float dateFrom = kPDFilterNearbyDateFrom;
        float dateTo = kPDFilterNearbyDateTo;
        NSInteger monthFrom = [self convertNumberToMonth:dateFrom];
        NSInteger dayFrom = [self convertNumberToDay:dateFrom];
        NSInteger monthTo = [self convertNumberToMonth:dateTo];
        NSInteger dayTo = [self convertNumberToDay:dateTo];
        return ([NSString stringWithFormat:@"%@/%ld - %@/%ld ", months[monthFrom - 1],(long)dayFrom, months[monthTo - 1],(long)dayTo]);
    }
}

- (NSString *)stringTimeFromTo
{
    if (kPDFilterNearbyTimeFrom == 0 || kPDFilterNearbyTimeTo == 0) {
        return NSLocalizedString(@"time photo was photographed", nil);
    } else {
        
        float timeFrom = kPDFilterNearbyTimeFrom;
        float timeTo = kPDFilterNearbyTimeTo;
        NSInteger hourFrom = [self hourFromNumber:timeFrom];
        NSString *aMOrPmFrom = @"AM";
        if (hourFrom > 12) {
            hourFrom = hourFrom % 12;
            aMOrPmFrom = @"PM";
        }
        NSInteger minuteFrom = [self minuteFromNumber:timeFrom];
        NSInteger hourTo = [self hourFromNumber:timeTo];
        NSString *aMOrPmTo = @"AM";
        if (hourTo > 12) {
            hourTo = hourTo % 12;
            aMOrPmTo = @"PM";
        }
        NSInteger minuteTo = [self minuteFromNumber:timeTo];
        return ([NSString stringWithFormat:@"%ld:%zd %@ - %zd:%ld %@",(long)hourFrom,minuteFrom,aMOrPmFrom,hourTo,(long)minuteTo,aMOrPmTo]);
    }
}

- (NSInteger)distanceRangeFromFloat:(float)floatRange
{
    if (floatRange > 0) {
        if (fmod(floatRange, 1.0) == 0) {
            [self unitDidSelect:_kmButton];
            return ((NSInteger)floatRange);
        } else {
            [self unitDidSelect:_milesButton];
            return  ([[NSNumber numberWithFloat:(floatRange/kPDMilesToKmUnit)] intValue]);
        }
    } else {
        [self unitDidSelect:_kmButton];
        return kPDDefaultFilterRange;
    }
}

# pragma mark - Actions

- (IBAction)selectDatePhotographed:(id)sender {
    if (_datePickerViewController) {
        _datePickerViewController = nil;
    }
    _datePickerViewController = [[PDDatePickerViewController alloc] initWithNibName:@"PDDatePickerViewController"
                                                                     datePickerMode:UIDatePickerModeDate] ;
    [self.navigationController pushViewController:_datePickerViewController animated:YES];
    
}

- (IBAction)selectTimePhotographed:(id)sender {
    if (_datePickerViewController) {
        _datePickerViewController = nil;
    }
    _datePickerViewController = [[PDDatePickerViewController alloc] initWithNibName:@"PDDatePickerViewController"
                                                                     datePickerMode:UIDatePickerModeTime] ;
    [self.navigationController pushViewController:_datePickerViewController animated:YES];
    
}

- (IBAction)sortSegmented:(id)sender {
    self.selectedSorting = _sortSegemented.selectedSegmentIndex;
}

- (void)go:(id)sender
{
    [self finish];
    if (self.delegate && [self.delegate respondsToSelector:@selector(filterDidFinish)]) {
        [self.delegate filterDidFinish];
    }
    [self goBack:sender];
}

- (IBAction)showDistanceUnit:(id)sender {
    if (!_showingUnitTable) {
        _showingUnitTable = YES;
        [UIView animateWithDuration:0.2 animations:^{
            self.distanceUnitView.height = 60;
        } completion:^(BOOL finished) {
            
        }];
    } else {
        [self unitDidSelect:sender];
    }
}

- (void)unitDidSelect:(id)sender
{
    _showingUnitTable = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.distanceUnitView.height = 30;
    } completion:^(BOOL finished) {
    }];
    if ([sender isEqual:_kmButton]) {
        if (_kmButton.selected)
            return;
        else {
            _kmButton.selected = !_kmButton.selected;
            _milesButton.selected = NO;
            _kmButton.frame = CGRectWithY(_kmButton.frame, 0);
            _milesButton.frame = CGRectWithY(_milesButton.frame, 30);
        }
    } else {
        if (_milesButton.selected)
            return;
        else {
            _milesButton.selected = !_milesButton.selected;
            _kmButton.selected = NO;
            _milesButton.frame = CGRectWithY(_milesButton.frame, 0);
            _kmButton.frame = CGRectWithY(_kmButton.frame, 30);
        }
    }
}

#pragma mark - Conversion utilities

- (NSInteger)convertNumberToDay:(NSInteger)number
{
    return (number % kPDUnitConverDateToNumber);
}

- (NSInteger)convertNumberToMonth:(NSInteger)number
{
    return (NSInteger)(number / kPDUnitConverDateToNumber);
}

- (NSInteger)hourFromNumber:(NSInteger)number
{
    return (NSInteger)(number / 60);
}

- (NSInteger)minuteFromNumber:(NSInteger)number
{
    return (number % 60);
}

- (float)floatFromUnit:(float)distance
{
    if (_kmButton.selected) {
        return distance;
    } else {
        return distance * kPDMilesToKmUnit;
    }
}

#pragma mark - Touch delegate

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_distanceTextField resignFirstResponder];
}

@end
