//
//  PDDiscoverViewController.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 22.04.13.
//
//

#import "PDPhotoTableViewController.h"
#import "PDServerTrendingsLoader.h"
#import "PDServerFeaturedLoader.h"
#import "PDServerUpcomingLoader.h"

@interface PDDiscoverViewController : PDPhotoTableViewController

@property (nonatomic,assign) NSUInteger sourceType;

@property (weak, nonatomic) IBOutlet PDToolbarButton *featuredSourceButton;
@property (weak, nonatomic) IBOutlet PDToolbarButton *upcomingSourceButton;
@property (weak, nonatomic) IBOutlet PDToolbarButton *photosSourceButton;

- (IBAction)sourceChanged:(id)sender;

@end
