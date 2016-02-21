//
//  PDListLandmarkViewController.h
//  Pashadelic
//
//  Created by LongPD on 6/16/14.
//
//

#import "PDPhotoTableViewController.h"
#import "PDPhotoLandmarkTalbeView.h"
#import "PDServerListLandmarkLoader.h"

@interface PDListLandmarkViewController : PDPhotoTableViewController


@property (strong, nonatomic) PDLocation *location;
@property (strong, nonatomic) PDPhotoLandmarkTalbeView *landmarkTableView;
@property (weak, nonatomic) IBOutlet UIView *tablePlaceholderView;
@property (strong, nonatomic) PDServerListLandmarkLoader *listLandmarkLoader;

@property (weak, nonatomic) IBOutlet PDGlobalFontButton *showMap;
- (IBAction)goToMap:(id)sender;

@end
