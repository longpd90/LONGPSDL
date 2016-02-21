//
//  PDPhotospotsMapsViewController.h
//  Pashadelic
//
//  Created by LTT on 6/18/14.
//
//

#import "PDClusterMapViewController.h"
#import "PDUserMapViewController.h"
#import "PDLocation.h"
@interface PDLocationPhotosMapViewController : PDClusterMapViewController <MGServerExchangeDelegate, KPTreeControllerDelegate>

@property (strong, nonatomic) PDLocation *location;
@property (weak, nonatomic) IBOutlet MGLocalizedButton *photoButton;

- (IBAction)backToPhotos:(id)sender;

@end
