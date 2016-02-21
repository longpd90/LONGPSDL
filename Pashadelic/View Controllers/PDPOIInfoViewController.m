//
//  PDGeoTagInfoViewController.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 28.05.13.
//
//

#import "PDPOIInfoViewController.h"

@interface PDPOIInfoViewController ()

@end

@implementation PDPOIInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
	}
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	if (self.poiItem) {
		self.poiItem = self.poiItem;
	}
	self.view.backgroundColor = [UIColor darkGrayColor];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (NSString *)pageName
{
	return @"POI Info View";
}

- (void)setPoiItem:(PDPOIItem *)poiItem
{
	_poiItem = poiItem;
	if (!poiItem) return;
	self.titleLabel.text = poiItem.name;
	[self.locationButton setTitle:poiItem.location forState:UIControlStateNormal];
	self.infoTextView.text = poiItem.info;
	[self.phoneButton setTitle:poiItem.phone forState:UIControlStateNormal];
}

- (IBAction)closeView:(id)sender
{
	[self.viewDeckController toggleRightViewAnimated:YES];
}

- (IBAction)call:(id)sender
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", self.poiItem.phone]]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesEnded:touches withEvent:event];
	[self closeView:nil];
}

@end
