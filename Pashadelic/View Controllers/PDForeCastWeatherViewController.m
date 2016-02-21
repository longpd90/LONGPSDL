//
//  PDNewHomeViewController.m
//  Pashadelic
//
//  Created by LongPD on 9/5/13.
//
//

#import "PDForeCastWeatherViewController.h"
#import "PDARViewController.h"

#define COLLAPSED_CELL_HEIGHT   54
#define EXPANDED_CELL_HEIGHT    250
#define NoCellExpand            -1
#define KPDBackgroundCell       [UIColor colorWithRed:30/255.0 green:30/255.0 blue:30/255.0 alpha:0.8]
#define kPDSecondInDay          60*60*24
#define kPDNumberOfCell         11

@interface PDForeCastWeatherViewController ()

@property (strong, nonatomic) PDARViewController *arViewController;

- (void)setBackgroundTodayPhotoImage;
- (void)setBackgroundTodayPhotoImageFromURL:(NSURL *)url;

@end

@implementation PDForeCastWeatherViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _forecastLabel.text = NSLocalizedString(@"Forecast", nil);
    self.weathers = [[NSArray alloc] init];
    _tableViewWeather.tableHeaderView = _topView;
    [_backButton setFontAwesomeIconForImage:[FAKFontAwesome angleLeftIconWithSize:30]
                              forState:UIControlStateNormal
                            attributes:@{NSForegroundColorAttributeName :[UIColor whiteColor]}];
    [_backButton setFontAwesomeIconForImage:[FAKFontAwesome angleLeftIconWithSize:30]
                              forState:UIControlStateSelected
                            attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self setBackgroundTodayPhotoImage];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    _expandedCellHeight = EXPANDED_CELL_HEIGHT;
    [self refreshView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSString *)pageName
{
	return @"Forecast weather";
}

#pragma mark - private

- (void)refreshView
{
    [super refreshView];
    _currentExpandedCell = 1;
    _currentNumberOfCell = kPDNumberOfCell;
    [_tableViewWeather reloadData];
}

- (void)setBackgroundTodayPhotoImage
{
    if (!kPDTodayPhotoURL) return;
    [self setBackgroundTodayPhotoImageFromURL:kPDTodayPhotoURL];
}

- (void)setBackgroundTodayPhotoImageFromURL:(NSURL *)url
{
    [self.todayImageView sd_setImageWithURL:url
                             placeholderImage:[UIImage imageNamed:@"placeholder_today_photo.png"]
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                   
                               }];
}

- (IBAction)didToucheBackButton:(id)sender
{
    [self.navigationController popViewControllerRetro];
}

#pragma mark - fetches data weather

- (void)fetchData
{
    if (self.weatherLoader) {
        self.weatherLoader.delegate = nil;
        self.weatherLoader = nil;
    }
    self.weatherLoader = [[PDWeatherLoader alloc] initWithDelegate:self];
    [self.weatherLoader loadForecastWeatherWithLatitude:self.userLocation.coordinate.latitude
                                              longitude:self.userLocation.coordinate.longitude];
}

#pragma mark - table view delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _currentNumberOfCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.row == _currentExpandedCell ? _expandedCellHeight : COLLAPSED_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *dayCellIdentifier = @"PDWeatherCell";
    static NSString *expandedCellIdentifier = @"PDMagicHourCell";
    
    // set up for content expand cell
    
    if (indexPath.row == _currentExpandedCell) {
        NSDate *date = [NSDate dateWithTimeInterval:(_currentExpandedCell - 1) * kPDSecondInDay sinceDate:_currentDate];
        PDMagicHourCell *expandCell = (PDMagicHourCell *)[tableView dequeueReusableCellWithIdentifier:expandedCellIdentifier];
        if (expandCell == nil) {
            expandCell = [[[NSBundle mainBundle] loadNibNamed:@"PDMagicHourCell" owner:self options:nil] objectAtIndex:0];
            expandCell.delegate = self;
        }
        [expandCell setContentCell:date andLocation:self.userLocation];
        expandCell.contentView.backgroundColor = KPDBackgroundCell;
        return expandCell;
    }
    
    // set up content for day cell
    
    else {
        PDWeatherCell *cell = (PDWeatherCell *) [tableView dequeueReusableCellWithIdentifier:dayCellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"PDWeatherCell" owner:self options:nil] objectAtIndex:0];
            cell.delegate = self;
        }
        
        if (_currentExpandedCell != NoCellExpand) {
            if (indexPath.row < _currentExpandedCell) {
                cell.tag = indexPath.row;
                cell.contentView.backgroundColor = KPDBackgroundCell;
                cell.btnShowDetail.selected = NO;
                if (indexPath.row == _currentExpandedCell - 1) {
                    cell.btnShowDetail.selected = YES;
                    cell.lineCellImageView.hidden = YES;
                }
            }else {
                cell.btnShowDetail.selected = NO;
                cell.tag = indexPath.row  - 1;
                float alpha = 1 - ( indexPath.row - 1 - _currentExpandedCell) * 0.1;
                UIColor *backgroundColor = [UIColor colorWithRed:30/255.0 green:30/255.0 blue:30/255.0 alpha:alpha];
                cell.contentView.backgroundColor = backgroundColor;
            }
        }
        else
        {
            cell.btnShowDetail.selected = NO;
            cell.tag = indexPath.row;
            cell.contentView.backgroundColor = KPDBackgroundCell;
        }
        NSDate *date = [NSDate dateWithTimeInterval:(cell.tag * kPDSecondInDay) sinceDate:_currentDate];
        [cell setContentCell:date andLocation:self.userLocation];
        
        // set icon weather
        
        if (self.weathers.count > 0) {
            if (cell.tag < self.weathers.count) {
                if (cell.tag == 0)
                    [cell setContentForWeather:_todayWeather];
                else{
                    PDWeather *weatherEntity = (PDWeather *)[self.weathers objectAtIndex:cell.tag];
                    [cell setContentForWeather:weatherEntity];
                }
            }
        }
        return cell;
    }
    return  nil;
}

#pragma mark - expand cell delegate

- (void)didTapARButton:(NSDate *)date
{
    [self trackEvent:@"View AR"];
    if (!self.arViewController) {
        self.arViewController = [[PDARViewController alloc] initWithNibName:@"PDARViewController" bundle:nil];
        self.arViewController.isWeather = YES;
    }
    self.arViewController.date = date;
    [self.navigationController pushViewController:self.arViewController animated:YES];
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - WeatherCell delegate

- (void)toggleCellWithIndex:(NSInteger)index{
    if (_currentExpandedCell == index+1) {
        _currentExpandedCell = NoCellExpand;
        NSArray *currentIndexPath = [[NSArray alloc]initWithObjects:[NSIndexPath indexPathForItem:index + 1 inSection:0], nil];
        [self collapseCellsAtIndexPaths:currentIndexPath];
        [self setBackgroundCellWhenCollapse:[currentIndexPath objectAtIndex:0]];
    } else {
        if (_currentExpandedCell == NoCellExpand) {
            _currentExpandedCell = index+1;
            [self expandCellsAtIndexPaths:[[NSArray alloc] initWithObjects:[NSIndexPath indexPathForItem:_currentExpandedCell inSection:0], nil]];
        } else {
            NSArray *currentIndexPath = [[NSArray alloc]initWithObjects:[NSIndexPath indexPathForItem:_currentExpandedCell inSection:0], nil];
            [self collapseCellsAtIndexPaths:currentIndexPath];
            [self setBackgroundCellWhenCollapse:[currentIndexPath objectAtIndex:0]];
            _currentExpandedCell = index + 1;
            [self expandCellsAtIndexPaths:[[NSArray alloc]initWithObjects:[NSIndexPath indexPathForItem:_currentExpandedCell inSection:0], nil]];
        }
    }
}

#pragma mark - toggle expand day

- (void)setBackgroundButtomCellWhenExpand:(NSIndexPath *)indexPath
{
    for (NSInteger j = indexPath.row + 1; j < 7; j ++) {
        float alpha = 1.0 - (j - indexPath.row - 1) * 0.1;
        UIColor *backgroundColor = [UIColor colorWithRed:30/255.0 green:30/255.0 blue:30/255.0 alpha:alpha];
        [_tableViewWeather cellForRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:0]].contentView.backgroundColor = backgroundColor;
    }
}

- (void)setBackgroundCellWhenCollapse:(NSIndexPath *)indexPath
{
    for (int j = indexPath.row ; j < kPDNumberOfCell; j ++) {
        [_tableViewWeather cellForRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:0]].contentView.backgroundColor = KPDBackgroundCell;
    }
}

- (void)setBackgroundTopCellWhenExpand:(NSIndexPath *)indexPath
{
    for (int j = 0; j < indexPath.row - 2; j ++) {
        [_tableViewWeather cellForRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:0]].contentView.backgroundColor = KPDBackgroundCell;
    }
}

- (void)expandCellsAtIndexPaths:(NSArray*)indexPaths{
    _currentNumberOfCell++;
    [_tableViewWeather insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    [self commitCellContents:[indexPaths objectAtIndex:0]];
    [self setBackgroundButtomCellWhenExpand:[indexPaths objectAtIndex:0]];
    [self setBackgroundTopCellWhenExpand:[indexPaths objectAtIndex:0]];
}

- (void)collapseCellsAtIndexPaths:(NSArray*)indexPaths {
    _currentNumberOfCell--;
    [_tableViewWeather deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    [self cleanCellContents:[indexPaths objectAtIndex:0]];
}

- (void)commitCellContents:(NSIndexPath*)indexPath {
    PDWeatherCell *dayCell = (PDWeatherCell *)[_tableViewWeather cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row-1 inSection:0]];
    [dayCell toggleImageButtonShowDetatilWeather];
    [_tableViewWeather cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:0]].contentView.backgroundColor = KPDBackgroundCell;
    [_tableViewWeather cellForRowAtIndexPath:indexPath].contentView.backgroundColor = KPDBackgroundCell;
}

- (void)cleanCellContents:(NSIndexPath*)indexPath {
    [_tableViewWeather cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:0]].contentView.backgroundColor = KPDBackgroundCell;
    PDWeatherCell *dayCell = (PDWeatherCell*)[_tableViewWeather cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:0]];
    [dayCell toggleImageButtonShowDetatilWeather];
}

#pragma mark - Server delegate

- (void)serverExchange:(PDServerExchange *)serverExchange didParseResult:(NSDictionary *)result
{
    if ([serverExchange isEqual:self.weatherLoader]) {
        self.weathers =  [self.weatherLoader loadForecastWeatherFromResult];
        _currentNumberOfCell = kPDNumberOfCell;
        [self.tableViewWeather reloadData];
    }
}

- (void)serverExchange:(PDServerExchange *)serverExchange didFailWithError:(NSString *)error
{
	[[PDSingleErrorAlertView instance] showErrorMessage:error];
}

@end
