//
//  PDLandmarkForecastViewController.m
//  Pashadelic
//
//  Created by LTT on 6/20/14.
//
//

#import "PDLandmarkForecastViewController.h"
#import "PDLandmarkMagicHourCell.h"

#define COLLAPSED_CELL_HEIGHT   54
#define EXPANDED_CELL_HEIGHT    280
#define NoCellExpand            -1
#define KPDBackgroundCell       [UIColor colorWithRed:30/255.0 green:30/255.0 blue:30/255.0 alpha:0.7]
#define kPDBackgroundExpandedCell [UIColor colorWithRed:30/255.0 green:30/255.0 blue:30/255.0 alpha:0.8]
#define kPDBackgroundNormalCell [UIColor colorWithRed:30/255.0 green:30/255.0 blue:30/255.0 alpha:0.0]

#define kPDSecondInDay          60*60*24
#define kPDNumberOfCell         11


@interface PDLandmarkForecastViewController ()

@end

@implementation PDLandmarkForecastViewController

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
    self.title = NSLocalizedString(@"Area Forecast", nil);
    [self setLeftBarButtonToBackWithStyle:kPDLeftBarButtonStyleGrayAngle];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.expandedCellHeight = EXPANDED_CELL_HEIGHT;
    self.tableViewWeather.backgroundColor = KPDBackgroundCell;
    [self refreshView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma Override super class

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *dayCellIdentifier = @"PDWeatherCell";
    static NSString *expandedCellIdentifier = @"PDLandmarkMagicHourCell";
    
    // set up for content expand cell
    
    if (indexPath.row == self.currentExpandedCell) {
        NSDate *date = [NSDate dateWithTimeInterval:(self.currentExpandedCell - 1) * kPDSecondInDay sinceDate:self.currentDate];
        PDLandmarkMagicHourCell *expandCell = (PDLandmarkMagicHourCell *)[tableView dequeueReusableCellWithIdentifier:expandedCellIdentifier];
        if (expandCell == nil) {
            expandCell = [[[NSBundle mainBundle] loadNibNamed:@"PDLandmarkMagicHourCell" owner:self options:nil] objectAtIndex:0];
        }
        [expandCell setContentCell:date andLocation:self.userLocation];
        expandCell.contentView.backgroundColor = kPDBackgroundExpandedCell;
        return expandCell;
    }    
    else {
        PDWeatherCell *cell = (PDWeatherCell *) [tableView dequeueReusableCellWithIdentifier:dayCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"PDWeatherCell" owner:self options:nil] objectAtIndex:0];
            cell.delegate = self;
        }

        if (self.currentExpandedCell != NoCellExpand) {
            if (indexPath.row < self.currentExpandedCell) {
                cell.tag = indexPath.row;
               
                cell.btnShowDetail.selected = NO;
                if (indexPath.row == self.currentExpandedCell - 1) {
                    cell.btnShowDetail.selected = YES;
                    cell.lineCellImageView.hidden = YES;
                    cell.contentView.backgroundColor = kPDBackgroundExpandedCell;
                } else
                    cell.contentView.backgroundColor = kPDBackgroundNormalCell;            
            } else {
                cell.contentView.backgroundColor = kPDBackgroundNormalCell;
                cell.btnShowDetail.selected = NO;
                cell.tag = indexPath.row  - 1;
            }
        }
        else {
            cell.btnShowDetail.selected = NO;
            cell.tag = indexPath.row;
            cell.contentView.backgroundColor = kPDBackgroundNormalCell;
        }
        
        NSDate *date = [NSDate dateWithTimeInterval:(cell.tag * kPDSecondInDay) sinceDate:self.currentDate];
        [cell setContentCell:date andLocation:self.userLocation];
        
        // set icon weather
        
        if (self.weathers.count > 0) {
            if (cell.tag < self.weathers.count) {
                PDWeather *weatherEntity = (PDWeather *)[self.weathers objectAtIndex:cell.tag];
                [cell setContentForWeather:weatherEntity];
            }
        }
        return cell;
    }
    return  nil;
}

- (void)setBackgroundButtomCellWhenExpand:(NSIndexPath *)indexPath
{
        [self.tableViewWeather cellForRowAtIndexPath:indexPath].contentView.backgroundColor = kPDBackgroundExpandedCell;
    float contentOffSetY = (indexPath.row - 2) * COLLAPSED_CELL_HEIGHT ;
    if (contentOffSetY <= 0) {
        contentOffSetY = 0;
    }
    [self.tableViewWeather setContentOffset:CGPointMake(0, contentOffSetY) animated:YES];
}

- (void)setBackgroundCellWhenCollapse:(NSIndexPath *)indexPath
{
    for (int j = 0 ; j < kPDNumberOfCell; j ++) {
        [self.tableViewWeather cellForRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:0]].contentView.backgroundColor = kPDBackgroundNormalCell;
            [self setTopCornerRounder:[self.tableViewWeather cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:0]].contentView withRadiusCorner:0.0];
    }
}

- (void)setBackgroundTopCellWhenExpand:(NSIndexPath *)indexPath
{
    [self setTopCornerRounder:[self.tableViewWeather cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:0]].contentView withRadiusCorner:8.0];
}

#pragma Private

- (void)setTopCornerRounder:(UIView *)view withRadiusCorner:(float)radius
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopRight|UIRectCornerTopLeft cornerRadii:CGSizeMake(radius, radius)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

#pragma Action

- (IBAction)didToucheBackButton:(id)sender {
    
    [self.navigationController popViewControllerRetro];
    
}
@end
