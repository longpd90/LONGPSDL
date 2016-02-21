//
//  PDTipsViewViewController.m
//  Pashadelic
//
//  Created by LongPD on 3/5/14.
//
//

#import "PDPhotoTipsViewController.h"
#import "UIImage+Extra.h"

@interface PDPhotoTipsViewController ()
@property (strong, nonatomic) NSMutableArray *buttonTips;
@end

@implementation PDPhotoTipsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"provide tips", nil);
    [self setLeftBarButtonToBackWithStyle:kPDLeftBarButtonStyleGrayAngle];
    [self setRightBarButtonToButton:[self redBarButtonWithTitle:NSLocalizedString(@"done", nil)
                                                         action:@selector(finish:)]];
    
    [self initContentInterFace];
    if (self.photo)
        [self setPhoto:self.photo];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self refreshView];
}

#pragma mark - overide

- (NSString *)pageName
{
    return @"Select Tips";
}

- (PDNavigationBarStyle)defaultNavigationBarStyle
{
	return PDNavigationBarStyleWhite;
}

- (void)setPhoto:(PDPhoto *)photo
{
    _photo = photo;
    if (self.isViewLoaded) {
        [_backgroundImageView setImage:photo.image];
    }
}

- (void)goBack:(id)sender
{
    [self.navigationController popViewControllerRetro];
}

- (void)finish:(id)sender
{
    [self.navigationController popViewControllerRetro];
    if (!_tripodYesButton.selected && !_tripodNoButton.selected)
        _photo.tripod = kPDNoTip;
    else
        _photo.tripod = _tripodYesButton.selected;

    if (!_crowededYesButton.selected && !_crowededNoButton.selected)
        _photo.is_crowded = kPDNoTip;
    else
        _photo.is_crowded = _crowededYesButton.selected;
    
    if (!_dangerousYesButton.selected && !_dangerousNoButton.selected)
        _photo.is_dangerous = kPDNoTip;
    else
        _photo.is_dangerous = _dangerousYesButton.selected;
    
    if (!_indoorYesButton.selected && !_indoorNoButton.selected)
        _photo.indoor = kPDNoTip;
    else
        _photo.indoor = _indoorYesButton.selected;
    
    if (!_permissionYesButton.selected && !_permissionNoButton.selected)
        _photo.is_permission = kPDNoTip;
    else
        _photo.is_permission = _permissionYesButton.selected;
    
    if (!_payYesButton.selected && !_payNoButton.selected)
        _photo.is_paid = kPDNoTip;
    else
        _photo.is_paid = _payYesButton.selected;
    
    if (!_nearbyYesButton.selected && !_nearbyNoButton.selected)
        _photo.is_parking = kPDNoTip;
    else
        _photo.is_parking = _nearbyYesButton.selected;

    _photo.difficulty_access = (3 - _difficultySegment.selectedSegmentIndex);
}

#pragma mark - private

- (void)initContentInterFace
{
    self.scrollBackgroundView.contentSize = self.contentView.frame.size;
    [self.scrollBackgroundView addSubview:self.contentView];

    _tipTitleLabel.text = NSLocalizedString(@"Help your fellow photographers by providing information about the location where you photographed!", nil);
    _tripodLabel.text = NSLocalizedString(@"Could you use tripod?", nil);
    _crowededLabel.text = NSLocalizedString(@"Was the place crowded?", nil);
    _nearbyLabel.text = NSLocalizedString(@"Any parking lot nearby?", nil);
    _dangerousLabel.text = NSLocalizedString(@"Was it dangerous?", nil);
    _indoorLabel.text = NSLocalizedString(@"Is this spot indoor?", nil);
    _permissionLabel.text = NSLocalizedString(@"Do you need a permission?", nil);
    _payLabel.text = NSLocalizedString(@"Do you have to pay?", nil);
    _difficultyLabel.text = NSLocalizedString(@"Difficulty to access?", nil);
    
    [self.difficultySegment setTitle:NSLocalizedString(@"Easy", nil) forSegmentAtIndex:0];
    [self.difficultySegment setTitle:NSLocalizedString(@"Normal", nil) forSegmentAtIndex:1];
    [self.difficultySegment setTitle:NSLocalizedString(@"Hard", nil) forSegmentAtIndex:2];

    _buttonTips = [[NSMutableArray alloc] initWithObjects:_tripodYesButton,_tripodNoButton,_crowededYesButton,_crowededNoButton,_nearbyYesButton,_nearbyNoButton,_dangerousYesButton,_dangerousNoButton,_indoorYesButton,_indoorNoButton,_permissionYesButton,_permissionNoButton,_payYesButton,_payNoButton, nil];
    
    UIImage *backgroundButtonTipsNormal = [[[UIImage alloc] init] imageWithColor:[UIColor whiteColor]];
    UIImage *backgroundButtonTipsSelected = [[[UIImage alloc] init] imageWithColor:kPDGlobalRedColor];
    for (int i = 0; i < _buttonTips.count; i ++) {
        UIButton *buttonTip = [_buttonTips objectAtIndex:i];
        [buttonTip setBackgroundImage:backgroundButtonTipsNormal forState:UIControlStateNormal];
        [buttonTip setBackgroundImage:backgroundButtonTipsSelected forState:UIControlStateSelected];
        [buttonTip setTitleColor:kPDGlobalGrayColor forState:UIControlStateNormal];
        [buttonTip setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        buttonTip.layer.borderColor = kPDGlobalGrayColor.CGColor;
        buttonTip.layer.borderWidth = 0.5;
    }
}

- (void)refreshView
{
    _tripodYesButton.selected = (_photo.tripod == 1);
    _tripodNoButton.selected = (_photo.tripod == 0);
    
    _crowededYesButton.selected = (_photo.is_crowded == 1);
    _crowededNoButton.selected = (_photo.is_crowded == 0);
    
    _nearbyYesButton.selected = (_photo.is_parking == 1);
    _nearbyNoButton.selected = (_photo.is_parking == 0);
    
    _dangerousYesButton.selected = (_photo.is_dangerous == 1);
    _dangerousNoButton.selected = (_photo.is_dangerous == 0);
    
    _indoorYesButton.selected  = (_photo.indoor == 1);
    _indoorNoButton.selected  = (_photo.indoor == 0);
    
    _permissionYesButton.selected  = (_photo.is_permission == 1);
    _permissionNoButton.selected = (_photo.is_permission == 0);
    
    _payYesButton.selected = (_photo.is_paid == 1);
    _payNoButton.selected = (_photo.is_paid == 0);
    if (_photo.difficulty_access > 0)
        _difficultySegment.selectedSegmentIndex = 3 - _photo.difficulty_access;
    else
        _difficultySegment.selectedSegmentIndex = -1;
}

#pragma mark - action

- (IBAction)selectedTips:(UIButton *)sender {
    if (!sender.selected) {
        [sender setSelected:!sender.selected];
        if (sender.tag%2 == 0) {
            UIButton *button = [_buttonTips objectAtIndex:(sender.tag + 1)];
            [button setSelected:!sender.selected];
        } else {
            UIButton *button = [_buttonTips objectAtIndex:(sender.tag - 1)];
            [button setSelected:!sender.selected];
        }
    }
}

@end
