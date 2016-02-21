//
//  PDSecondViewController.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 25/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDServerNearbyLoader.h"
#import "PDPhotoTableViewController.h"

@interface PDNearbyViewController : PDPhotoTableViewController
<PDItemSelectDelegate, MGServerExchangeDelegate, UIMenuViewDelegate, UIAlertViewDelegate>

@property (nonatomic) int sorting;
@property (weak, nonatomic) IBOutlet PDToolbarButton *sortByDateButton;
@property (weak, nonatomic) IBOutlet PDToolbarButton *sortByRankingButton;

- (IBAction)sortTypeChanged:(id)sender;

@end
