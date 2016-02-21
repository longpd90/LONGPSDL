//
//  PDLandmarkSelectMapViewController.h
//  Pashadelic
//
//  Created by Nguyen Huu Anh on 8/7/14.
//
//

#import "PDLocationSelectViewController.h"
#import "PDUploadPhotoViewController.h"
#import "PDSearchBar.h"
#import "PDSearchBarController.h"
#import "PDPOIItem.h"


@interface PDLandmarkSelectMapViewController : PDLocationSelectViewController<MGServerExchangeDelegate>
@property (strong, nonatomic) IBOutlet PDSearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UILabel *nameLandmark;
@property (strong, nonatomic) PDSearchBarController *searchBarController;
@property (strong, nonatomic) PDPOIItem *landmark;
@property (strong, nonatomic) PDPhoto *photo;

@end
