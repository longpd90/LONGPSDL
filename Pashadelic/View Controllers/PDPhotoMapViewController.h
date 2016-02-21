//
//  PDPhotoMapViewController.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 16/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDViewController.h"
#import "PDPhotosMapView.h"


@interface PDPhotoMapViewController : PDViewController <UIAlertViewDelegate>

@property (strong, nonatomic) PDPhotosMapView *mapView;
@property (strong, nonatomic) PDPhoto *photo;

- (void)routeToThePhoto;

@end
