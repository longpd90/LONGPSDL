//
//  PDPlanParticipantsViewController.m
//  Pashadelic
//
//  Created by Nguyen Huu Anh on 8/22/14.
//
//

#import "PDPlanParticipantsViewController.h"
#import "PDServerPlanParticipantsLoader.h"

@interface PDPlanParticipantsViewController ()

@end

@implementation PDPlanParticipantsViewController

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
    self.title = NSLocalizedString(@"participant", nil);
}

- (NSString *)pageName
{
	return @"Participants";
}

- (void)fetchData
{
	[super fetchData];
	PDServerPlanParticipantsLoader *usersLoader = [[PDServerPlanParticipantsLoader alloc] initWithDelegate:self];
	self.serverExchange = usersLoader;
	[usersLoader loadPlanParticipants:self.plan andPage:self.currentPage];
}

- (void)refreshView
{
	[super refreshView];
    if (self.items.count > 1) {
        self.title = NSLocalizedString(@"participant", nil);
    } else {
        self.title = NSLocalizedString(@"participants", nil);
    }
}

@end
