//
//  PDListLandmarkMapViewController.h
//  Pashadelic
//
//  Created by LongPD on 6/27/14.
//
//

#import "PDClusterMapViewController.h"
#import "PDUserMapViewController.h"
#import "PDLocation.h"

@interface PDListLandmarkMapViewController : PDClusterMapViewController <MGServerExchangeDelegate, KPTreeControllerDelegate>

@property (weak, nonatomic) IBOutlet MGLocalizedButton *photoButton;
@property (strong, nonatomic) NSArray *landmarks;

- (IBAction)backToPhotos:(id)sender;

@end
